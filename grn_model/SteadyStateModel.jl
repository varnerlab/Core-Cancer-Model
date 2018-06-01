function find_transcript_index(transcript_tag,list_of_genes)
    return find(list_of_genes[:,2] .== transcript_tag)
end

function estimate_control_input(gain_array,data_dictionary)

    # initalize an empty control_array -
    control_array = Float64[]

    # get the path to the experimental expression_file_path -
    path_to_expression_file = data_dictionary["path_to_experimental_expression_file"]

    # load the experimental data -
    raw_data_array = readdlm(path_to_expression_file,',')

    # remove the gene id's
    expression_data_array = mean(raw_data_array[:,2:end],2)

    # ok, so lets get the genes in the model -
    list_of_genes = data_dictionary["list_of_genes"]

    # mean center the data_array
    mean_value = mean(expression_data_array)
    max_value = maximum(expression_data_array)
    min_value = minimum(expression_data_array)
    scaled_data_array = (expression_data_array - mean_value)/(max_value - min_value)

    # what is the min and max gain -
    min_gain_value = minimum(gain_array)
    max_gain_value = maximum(gain_array)
    mean_gain_value = mean(gain_array)

    # get the gene_id array -
    mRNA_cluster_dictionary = data_dictionary["mRNA_cluster_data_dictionary"]
    gene_id_array = mRNA_cluster_dictionary["gene_id_array"]

    # compute the u-variable -
    gene_index = 1
    number_of_genes = length(list_of_genes[:,1])
    for gene_index = 1:number_of_genes

        # what is the model scale?
        model_scale = max_gain_value*0.99 - min_gain_value*0.01

        # what is the mean gain value?
        mean_scale = mean_gain_value*(0.35)

        # what is the current gene tag?
        gene_tag = list_of_genes[gene_index,2]

        # where is this gene index in the *data*
        gene_index_in_data = GRNModule.find_data_index_of_gene(gene_tag,mRNA_cluster_dictionary)
        if (isempty(gene_index_in_data))

            # compute the control value -
            control_value = 0.0
        else
            control_value = mean_scale + model_scale*scaled_data_array[gene_index_in_data[1]]
        end

        # compute the control value -
        # control_value = mean_scale + model_scale*scaled_data_array[gene_index]

        # cache -
        push!(control_array, control_value)

    end

    # return -
    return control_array
end

function calculate_steady_state_protein(data_dictionary)

    # estimate the mRNA -
    (transcript_concentration_array, control_array) = calculate_steady_state_mRNA(data_dictionary)

    # initalize empty array -
    steady_state_array = Float64[]

    # get stuff from the biophysical_data_dictionary -
    list_of_transcripts = data_dictionary["list_of_transcripts"]
    list_of_genes = data_dictionary["list_of_genes"]
    average_protein_length = data_dictionary["average_protein_length"]
    protein_length_dictionary = data_dictionary["protein_length_dictionary"]

    # biophysics -
    biophysical_data_dictionary = data_dictionary["biophysical_data_dictionary"]
    mass_of_single_cell = parse(Float64,biophysical_data_dictionary["mass_of_single_cell"]["value"])
    doubling_time_cell = parse(Float64,biophysical_data_dictionary["cell_doubling_time"]["value"])
    max_translation_rate = parse(Float64,biophysical_data_dictionary["max_translation_rate"]["value"])
    saturation_constant_translation = parse(Float64,biophysical_data_dictionary["saturation_constant_translation"]["value"])
    number_of_ribosomes = parse(Float64,biophysical_data_dictionary["number_of_ribosomes"]["value"])
    protein_half_life = parse(Float64,biophysical_data_dictionary["protein_half_life"]["value"])

    # Calculate the ribosome_concentration -
    ribosome_concentration = number_of_ribosomes*(1/av_number)*(1/mass_of_single_cell)*1e6      # mumol/gdw

    # Calculate the RNAP elongation rate -
    kcat_translation_elongation = max_translation_rate*(3600/average_protein_length)            # hr^-1

    # saturation constant -
    KSAT = saturation_constant_translation*(1/av_number)*(1/mass_of_single_cell)*1e9            # nmol/gdw

    # What is the degradation constant for protein?
    kdX = -(1/protein_half_life)*log(e,2)

    # Maximum specific growth rate -
    mugmax = (1/doubling_time_cell)*log(e,2)                                                    # hr^-1

    # build the array of translation rates -
    (number_of_translation_rates,ncol) = size(list_of_transcripts)
    for transcript_index = 1:number_of_translation_rates

        # get the transcript tag - (cuttoff the trailing splice variant information)
        transcript_tag = list_of_transcripts[transcript_index,2][6:end]

        # lookup the protein length -
        protein_length = protein_length_dictionary[transcript_tag]

        # compute the length factor -
        length_factor = 1.0
        if (protein_length != 0)
            length_factor = (average_protein_length/protein_length)
        end

        # compute the kcat -
        kcat = kcat_translation_elongation*length_factor

        # what is the mRNA index?
        gene_tag = "G_$(transcript_tag[1:end-2])"
        mRNA_index = find_transcript_index(gene_tag,list_of_genes)
        P = 0.04732687179487179 # default is the average
        if (isempty(mRNA_index) == false)

            # get the current -
            mRNA_value = transcript_concentration_array[mRNA_index[1]]
            if mRNA_value == 0.0
                P = 0.04732687179487179 # mistake hack - should lookup, and then discount?
            else
                # calculate the protein level -
                mhat = (mRNA_value)/(KSAT+mRNA_value)
                P = ((kcat*mhat*ribosome_concentration)/(mugmax+kdX))
            end
        end

        # cache -
        push!(steady_state_array,P)
    end

    # return -
    return steady_state_array
end

function calculate_steady_state_mRNA(data_dictionary)

    # initalize empty array -
    steady_state_array = Float64[]

    # get stuff from the biophysical_data_dictionary -
    list_of_genes = data_dictionary["list_of_genes"]
    average_gene_length = data_dictionary["average_gene_length"]
    gene_length_dictionary = data_dictionary["gene_length_dictionary"]
    gene_concentration_array = data_dictionary["gene_concentration_array"]

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

    # initialize the gain array -
    gain_array = Float64[]

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
        push!(gain_array,GAIN_T)
    end

    # call the control function with the gain array -
    control_array = estimate_control_input(gain_array,data_dictionary)

    # compute the steady-state -
    steady_state_array = gain_array.*control_array

    # return -
    return (steady_state_array, control_array)
end
