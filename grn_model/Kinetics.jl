function calculate_specific_rate_of_translation(t,transcript_concentration_array,data_dictionary)

    # get stuff from the biophysical_data_dictionary -
    list_of_transcripts = data_dictionary["list_of_transcripts"]
    average_protein_length = data_dictionary["average_protein_length"]
    protein_length_dictionary = data_dictionary["protein_length_dictionary"]

    # biophysics -
    biophysical_data_dictionary = data_dictionary["biophysical_data_dictionary"]
    mass_of_single_cell = parse(Float64,biophysical_data_dictionary["mass_of_single_cell"]["value"])
    doubling_time_cell = parse(Float64,biophysical_data_dictionary["cell_doubling_time"]["value"])
    max_translation_rate = parse(Float64,biophysical_data_dictionary["max_translation_rate"]["value"])
    saturation_constant_translation = parse(Float64,biophysical_data_dictionary["saturation_constant_translation"]["value"])
    number_of_ribosomes = parse(Float64,biophysical_data_dictionary["number_of_ribosomes"]["value"])

    # initialize empty array -
    translation_rate_array = Float64[]

    # Maximum specific growth rate -
    maximum_specific_growth_rate = (1/doubling_time_cell)*log(e,2)                               # hr^-1

    # Calculate the ribosome_concentration -
    ribosome_concentration = number_of_ribosomes*(1/av_number)*(1/mass_of_single_cell)*1e6       # mumol/gdw

    # Calculate the RNAP elongation rate -
    kcat_translation_elongation = max_translation_rate*(3600/average_protein_length)             # hr^-1

    # saturation constant -
    KSAT = saturation_constant_translation*(1/av_number)*(1/mass_of_single_cell)*1e9             # nmol/gdw

    # build the array of translation rates -
    (number_of_translation_rates,ncol) = size(list_of_transcripts)
    for transcript_index = 1:number_of_translation_rates

        # get the transcript tag -
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

        # get the current -
        mRNA = transcript_concentration_array[transcript_index]

        # calculate the rate -
        translation_rate = kcat*(ribosome_concentration)*((mRNA)/(KSAT+mRNA))

        # cache -
        push!(translation_rate_array,translation_rate)
    end

    # return -
    return translation_rate_array
end

function calculate_specific_rate_of_transcription(t,state_array,data_dictionary)

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

    # initalize empty array -
    transcription_rate_array = Float64[]

    # Maximum specific growth rate -
    maximum_specific_growth_rate = (1/doubling_time_cell)*log(e,2)                          # hr^-1

    # Calculate the rnapII_concentration -
    rnapII_concentration = number_of_rnapII*(1/av_number)*(1/mass_of_single_cell)*1e6       # mumol/gdw

    # Calculate the RNAP elongation rate -
    kcat_transcription_elongation = max_transcription_rate*(3600/average_gene_length)       # hr^-1
    kcat_transcription_initiation = ((1/3600)*transcription_initiation_time_contstant)^-1   # hr^-1

    # saturation constant -
    KSAT = saturation_constant_transcription*(1/av_number)*(1/mass_of_single_cell)*1e9      # nmol/gdw

    # build the array of transcription rate -
    (number_of_genes,ncol) = size(list_of_genes)
    for gene_index = 1:number_of_genes

        # get the gene tag -
        gene_tag = list_of_genes[gene_index,2][3:end]

        # get the length factor for this gene -
        gene_length = gene_length_dictionary[gene_tag]

        length_factor = 1.0
        if (gene_length != 0)

            # compute the length factor -
            length_factor = (average_gene_length/gene_length)

        end

        # overall kcat -
        kcat = (kcat_transcription_elongation*length_factor*kcat_transcription_initiation)/(kcat_transcription_elongation*length_factor+maximum_specific_growth_rate)

        # get the gene concentration -
        gene = gene_concentration_array[gene_index]

        # compute the rate -
        transcription_rate = kcat*(rnapII_concentration)*((gene)/(KSAT+gene))

        # cache -
        push!(transcription_rate_array,transcription_rate)
    end

    # return -
    return transcription_rate_array
end
