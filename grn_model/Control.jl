function calculate_transcriptional_control(t,system_state,data_dictionary)

    # how many transcription rates do we have?
    list_of_genes = data_dictionary["list_of_genes"]
    (number_of_genes,ncol) = size(list_of_genes)
    u_array = zeros(number_of_genes)

    # For now: we don't have any regulatory logic, only basal information
    # grab the list/abundabnce of basal TFs from the transcription_factor_dictionary -
    transcription_factor_dictionary = data_dictionary["basal_transcription_factor_dictionary"]
    W = data_dictionary["basal_transcription_weight_array"]
    kd_array = data_dictionary["default_basal_transcription_KD_array"]
    biophysical_data_dictionary = data_dictionary["biophysical_data_dictionary"]
    mass_of_single_cell = parse(Float64,biophysical_data_dictionary["mass_of_single_cell"]["value"])

    # convert the TF dictionary into an array, in nmol/gdw -
    basal_tf_array = Float64[]
    number_of_basal_transcription_factors = length(transcription_factor_dictionary)
    for key in keys(transcription_factor_dictionary)

        # get the local dictionary -
        local_dictionary = transcription_factor_dictionary[key]

        # get the value -
        value = parse(Float64,local_dictionary["value"])

        # convert to nmol/gdw -
        value_converted = value*(1/av_number)*(1/mass_of_single_cell)*1e9   # nmol/gdw

        # cache -
        push!(basal_tf_array,value_converted)
    end

    # ok - lets assume the worst, and use the MIN of the basal transcription factors -
    basal_tf_abundance = minimum(basal_tf_array)

    # convert the kd_array -
    kd_array = ((1/av_number)*(1/mass_of_single_cell)*1e9)*kd_array

    # build -
    for gene_index = 1:number_of_genes

        numerator = W[gene_index]*(basal_tf_abundance/(basal_tf_abundance+kd_array[gene_index]))
        denominator = 1+numerator
        u_array[gene_index] = numerator/denominator
    end

    # return -
    return u_array
end
