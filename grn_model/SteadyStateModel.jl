function estimate_control_input(data_dictionary)

    # initalize an empty control_array -
    control_array = Float64[]

    # get the path to the experimental expression_file_path -
    path_to_expression_file = data_dictionary["path_to_experimental_expression_file"]

    # load the experimental data -
    raw_data_array = readdlm(path_to_expression_file,',')

    # remove the gene id's
    total_data_array = mean(raw_data_array[:,2:end],2)

    # ok, so lets get the genes in the model -
    list_of_genes = data_dictionary["list_of_genes"]
    expression_data_array = total_data_array[list_of_genes[:,1]]

    # mean center the data_array
    mean_value = mean(expression_data_array)
    max_value = maximum(expression_data_array)
    min_value = minimum(expression_data_array)
    scaled_data_array = (expression_data_array - mean_value)/(max_value - min_value)

    # compute the control array -
    control_array = 0.475+0.95*scaled_data_array

    # return -
    return control_array
end

function calculate_steady_state_mRNA(data_dictionary)

    # initalize empty array -
    steady_state_array = Float64[]

    # get stuff from the biophysical_data_dictionary -
    list_of_genes = data_dictionary["list_of_genes"]
    average_gene_length = data_dictionary["average_gene_length"]
    gene_length_dictionary = data_dictionary["gene_length_dictionary"]
    gene_concentration_array = data_dictionary["gene_concentration_array"]

    # What is the control_array?
    control_array = estimate_control_input(data_dictionary)

    # biophysics -
    biophysical_data_dictionary = data_dictionary["biophysical_data_dictionary"]
    number_of_rnapII = parse(Float64,biophysical_data_dictionary["number_of_rnapII"]["value"])
    mass_of_single_cell = parse(Float64,biophysical_data_dictionary["mass_of_single_cell"]["value"])
    doubling_time_cell = parse(Float64,biophysical_data_dictionary["cell_doubling_time"]["value"])
    max_transcription_rate = parse(Float64,biophysical_data_dictionary["max_transcription_rate"]["value"])
    saturation_constant_transcription = parse(Float64,biophysical_data_dictionary["saturation_constant_transcription"]["value"])
    transcription_initiation_time_contstant = parse(Float64,biophysical_data_dictionary["transcription_initiation_time_contstant"]["value"])
    mRNA_half_life_TF = parse(Float64,biophysical_data_dictionary["mRNA_half_life_TF"]["value"])

    # Maximum specific growth rate -
    mugmax = (1/doubling_time_cell)*log(e,2)                          # hr^-1

    # Calculate the rnapII_concentration -
    rnapII_concentration = number_of_rnapII*(1/av_number)*(1/mass_of_single_cell)*1e9       # nmol/gdw

    # Calculate the RNAP elongation rate -
    kcat_transcription_elongation = max_transcription_rate*(3600/average_gene_length)       # hr^-1
    kcat_transcription_initiation = ((1/3600)*transcription_initiation_time_contstant)^-1   # hr^-1
    kcat_transcription = min(kcat_transcription_elongation,kcat_transcription_initiation)

    # Calculate the degradation constant -
    kdT = -(1/mRNA_half_life_TF)*log(e,0.5)

    # saturation constant -
    KSAT = saturation_constant_transcription*(1/av_number)*(1/mass_of_single_cell)*1e9      # nmol/gdw

    # build the array of steady state concentrations -
    (number_of_genes,ncol) = size(list_of_genes)
    for gene_index = 1:number_of_genes

        # get the gene tag -
        gene_tag = list_of_genes[gene_index,2][3:end]

        # get the gene concentration -
        avg_gene_concentration = gene_concentration_array[gene_index]

        # get the length factor for this gene -
        gene_length = gene_length_dictionary[gene_tag]
        length_factor = 1.0
        if (gene_length != 0)

            # compute the length factor -
            length_factor = (average_gene_length/gene_length)
        end

        # setup the ksat for this gene -
        kcat = (kcat_transcription_elongation*length_factor*kcat_transcription_initiation)/((kcat_transcription_elongation*length_factor+mugmax)*(mugmax+kdT))

        # setup the GAIN for this gene -
        GAIN_T = kcat*(rnapII_concentration)*((avg_gene_concentration)/(KSAT+avg_gene_concentration))

        # calc the steady state value -
        tmp_value = (GAIN_T)*control_array[gene_index]
        push!(steady_state_array,tmp_value)
    end

    # return -
    return steady_state_array
end
