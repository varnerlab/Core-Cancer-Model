function build_default_mRNA_concentration_array(biophysical_data_dictionary,list_of_genes)

    # how many transcripts do we have?
    (number_of_transcripts,ncol) = size(list_of_genes)
    return zeros(number_of_transcripts)
end

function build_default_protein_concentration_array(biophysical_data_dictionary,list_of_transcripts)

    # how many transcripts do we have?
    (number_of_transcripts,ncol) = size(list_of_transcripts)
    return zeros(number_of_transcripts)
end

function build_default_gene_concentration_array(biophysical_data_dictionary,list_of_genes)

    # initalize -
    gene_concentration_array = Float64[]

    # grab copy number -
    average_gene_number = parse(Float64,biophysical_data_dictionary["average_gene_number"]["value"])
    mass_of_single_cell = parse(Float64,biophysical_data_dictionary["mass_of_single_cell"]["value"])

    # Calculate the rnapII_concentration -
    gene_concentration = average_gene_number*(1/av_number)*(1/mass_of_single_cell)*1e9       # nmol/gdw

    # build the array of transcription rate -
    (number_of_genes,ncol) = size(list_of_genes)
    for gene_index = 1:number_of_genes
        push!(gene_concentration_array,gene_concentration)
    end

    # return -
    return gene_concentration_array
end

function build_protein_length_dictionary(cobra_dictionary)

    # path to sequence files -
    path_to_seq_files = "$(pwd())/grn_model/sequence/protein_sequences"

    # process list of transcripts -
    list_of_genes = cobra_dictionary["genes"]
    (number_of_genes,ncol) = size(list_of_genes)
    protein_length_dictionary = Dict{String,Int}()
    total_sequence_length = 0
    for gene_index = 1:number_of_genes

        # Get tag name -
        full_gene_tag = list_of_genes[gene_index]

        # build the file name -
        protein_name = replace(full_gene_tag,'.','-')
        filename = "P_$(protein_name).seq"

        # check to see if the file is empty -
        local_sequence_length = 0
        if (filesize("$(path_to_seq_files)/$(filename)")!=0)

            # load the file -
            protein_sequence_array = readdlm("$(path_to_seq_files)/$(filename)",'\n')
            number_of_lines = length(protein_sequence_array)
            for line_index = 1:number_of_lines
                local_sequence_length = local_sequence_length + length(protein_sequence_array[line_index])
            end
        end

        # update the total sequence length -
        total_sequence_length = total_sequence_length + local_sequence_length

        # cache -
        protein_length_dictionary[full_gene_tag] = local_sequence_length
    end

    # what is the average length (rounded) -
    average_protein_length = round(total_sequence_length/number_of_genes)

    # return -
    return (protein_length_dictionary,average_protein_length)
end

function build_gene_length_dictionary(cobra_dictionary)

    # path to sequence files -
    path_to_seq_files = "$(pwd())/grn_model/sequence/gene_sequences"

    # process list of genes -
    list_of_genes = cobra_dictionary["genes"]
    (number_of_genes,ncol) = size(list_of_genes)
    gene_length_dictionary = Dict{String,Int}()
    total_sequence_length = 0
    for gene_index = 1:number_of_genes

        # Get tag name -
        full_gene_tag = list_of_genes[gene_index]

        # cutoff the splice varient -
        gene_tag = full_gene_tag[1:end-2]

        # create the filename -
        filename = "G_$(gene_tag).seq"

        # check to see if the file is empty -
        local_sequence_length = 0
        if (filesize("$(path_to_seq_files)/$(filename)")!=0)

            # load the file -
            gene_sequence_array = readdlm("$(path_to_seq_files)/$(filename)",'\n')
            number_of_lines = length(gene_sequence_array)
            for line_index = 1:number_of_lines
                local_sequence_length = local_sequence_length + length(gene_sequence_array[line_index])
            end
        end

        # update the total sequence length -
        total_sequence_length = total_sequence_length + local_sequence_length

        # cache -
        gene_length_dictionary[gene_tag] = local_sequence_length
    end

    # what is the average length (rounded) -
    average_gene_length = round(total_sequence_length/number_of_genes)

    # return -
    return (gene_length_dictionary,average_gene_length)
end

function load_biophysical_data_dictionary(organismid::Symbol)

    # initialize -
    biophysical_data_dictionary = Dict{String,String}()
    raw_database_dict = Dict{Any,Any}()

    # where are all my cell files stored?
    path_to_organism_directory = "$(pwd())/grn_model/organism"

    # load the mapping file -
    path_to_biophysics_map = "$(pwd())/grn_model/organism/Map.json"

    # parse this file, and return the mapping dictionary -
    biophysics_mapping_dictionary = JSON.parsefile(path_to_biophysics_map)

    # what is the default file path?
    path_to_model_file = "$(path_to_organism_directory)/Default.json"

    # convert organismid to key, and update the model path -
    key_value = string(organismid)
    if (haskey(biophysics_mapping_dictionary,key_value) == true)

        # ok, we have this key, grab the associated dictionary and load the filename -
        biophysics_file_name = biophysics_mapping_dictionary[key_value]["biophysics_file_name"]

        # where can we find the biophysical properties?
        path_to_model_file = "$(path_to_organism_directory)/$(biophysics_file_name)"
    end

    # ok, we have a path (perhaps organism specific), load it up -
    # load the biophysics dictionary -
    raw_database_dict = JSON.parsefile(path_to_model_file)

    # remove the top level dictionary -
    biophysical_data_dictionary = raw_database_dict["biophysical_properties"]

    # Need to add one more item --
    fraction_nucleus = parse(Float64,biophysical_data_dictionary["nuclear_fraction"]["value"])
    cell_diameter = parse(Float64,biophysical_data_dictionary["cell_diameter"]["value"])

    # Calculate the volume (convert to L)
    VC = ((1-fraction_nucleus)*(1/6)*(3.14159)*(cell_diameter)^3)*(1e-15)
    VN = ((fraction_nucleus)*(1/6)*(3.14159)*(cell_diameter)^3)*(1e-15)
    VT = VC+VN

    # add --
    biophysical_data_dictionary["volume_of_single_cell_cytosol"]["value"] = string(VC)
    biophysical_data_dictionary["volume_of_single_cell_nuclear"]["value"] = string(VN)
    biophysical_data_dictionary["volume_of_single_cell_total"]["value"] = string(VT)

    # return -
    return biophysical_data_dictionary
end

function load_transcription_factor_data_dictionary(organismid::Symbol)

    # initialize -
    transcription_factor_dictionary = Dict{String,String}()
    raw_database_dict = Dict{Any,Any}()

    # Where is the cell biophysics data stored?
    path_to_organism_directory = "$(pwd())/grn_model/organism"

    # load the mapping file -
    path_to_biophysics_map = "$(pwd())/grn_model/organism/Map.json"

    # parse the mapping file, and return the mapping dictionary -
    biophysics_mapping_dictionary = JSON.parsefile(path_to_biophysics_map)

    # what is the default file path?
    path_to_model_file = "$(path_to_organism_directory)/Default.json"

    # convert organismid to key, and update the model path -
    key_value = string(organismid)
    if (haskey(biophysics_mapping_dictionary,key_value) == true)

        # ok, we have this key, grab the associated dictionary and load the filename -
        biophysics_file_name = biophysics_mapping_dictionary[key_value]["biophysics_file_name"]

        # where can we find the biophysical properties?
        path_to_model_file = "$(path_to_organism_directory)/$(biophysics_file_name)"
    end

    # Load -
    raw_database_dict = JSON.parsefile(path_to_model_file)

    # remove the top level dictionary -
    transcription_factor_dictionary = raw_database_dict["basal_transcription_factor_abundance"]

    # return -
    return transcription_factor_dictionary
end

function find_cluster_index_of_gene(match_gene_id,mRNA_cluster_data_dictionary)

    # initalize -
    flag = -1

    # Get the gene_id array from the cluster -
    cluster_gene_id_array = mRNA_cluster_data_dictionary["gene_id_array"]
    assignments_array = mRNA_cluster_data_dictionary["assignment_array"]

    # search for the id -
    number_of_cluster_gene_id = length(cluster_gene_id_array)
    for cluster_gene_id_index = 1:number_of_cluster_gene_id

        # get the test gene id -
        test_gene_id = cluster_gene_id_array[cluster_gene_id_index]
        if (test_gene_id == match_gene_id)
            flag = assignments_array[cluster_gene_id_index]
        end
    end

    # return -
    return flag
end

function find_data_index_of_gene(match_gene_id,mRNA_cluster_data_dictionary)

    # Get the gene id array -
    gida = mRNA_cluster_data_dictionary["gene_id_array"]
    idx_data = find(gida .== match_gene_id)
    return idx_data
end

function build_expression_file_path(organismid::Symbol)

    # we need to figure out which cellmass file to load -
    # load the mapping file -
    path_to_expression_map = "$(pwd())/cobra_code/expression/Map.json"

    # parse this file, and return the mapping dictionary -
    expression_mapping_dictionary = JSON.parsefile(path_to_expression_map)

    # convert organismid to key -
    key_value = string(organismid)
    if (haskey(expression_mapping_dictionary,key_value) == true)

        # ok, we have this key, grab the associated dictionary and load the filename -
        expression_file_name = expression_mapping_dictionary[key_value]["expression_file_name"]

        # build the path -
        expression_file_path = "$(pwd())/cobra_code/expression/$(expression_file_name)"

        # return -
        return expression_file_path
    end

    # default -
    path_to_default_expression_file = "$(pwd())/cobra_code/expression/Default-Expression.csv"
end

function GRNDataDictionary(organism::Symbol)

    # load the *.mat code from the cobra code folder -
    path_to_cobra_file = "$(pwd())/cobra_code/modelCore.mat"
    file = matopen(path_to_cobra_file)
    cobra_dictionary = read(file,"modelCore")
    close(file)

    # Load the list of genes -
    path_to_genes_file = "$(pwd())/grn_model/Genes.net"
    list_of_genes = readdlm(path_to_genes_file,',')

    # load the list of transcripts -
    path_to_transcripts_file = "$(pwd())/grn_model/Transcripts.net"
    list_of_transcripts = readdlm(path_to_transcripts_file,',')

    # ok, lets load the physical properties up for this organism -
    biophysical_data_dictionary = load_biophysical_data_dictionary(organism)
    transcription_factor_dictionary = load_transcription_factor_data_dictionary(organism)

    # ----------------------------------------------------------------------------------------------------- #
    # Compute the list of gene lengths, and average length -
    (gene_length_dictionary,average_gene_length) = build_gene_length_dictionary(cobra_dictionary)
    # ----------------------------------------------------------------------------------------------------- #
    #
    # ----------------------------------------------------------------------------------------------------- #
    # Compute the protein length dictionary, and the average length -
    (protein_length_dictionary,average_protein_length) = build_protein_length_dictionary(cobra_dictionary)
    # ----------------------------------------------------------------------------------------------------- #
    #
    # ----------------------------------------------------------------------------------------------------- #
    # Compute the default gene concentration array -
    gene_concentration_array = build_default_gene_concentration_array(biophysical_data_dictionary,list_of_genes)
    # ----------------------------------------------------------------------------------------------------- #
    #
    # ----------------------------------------------------------------------------------------------------- #
    # Compute the default mRNA concentration array -
    mRNA_concentration_array = build_default_mRNA_concentration_array(biophysical_data_dictionary,list_of_genes)
    # ----------------------------------------------------------------------------------------------------- #
    #
    # ----------------------------------------------------------------------------------------------------- #
    # Compute the default mRNA concentration array -
    protein_concentration_array = build_default_protein_concentration_array(biophysical_data_dictionary,list_of_transcripts)
    # ----------------------------------------------------------------------------------------------------- #
    #
    # ----------------------------------------------------------------------------------------------------- #
    # Compute the system arrays -

    # NOTE: if yoy already have a system dictionary saved, then load the saved version ->
    # the computation of the AHAT and BHAT is slow for large arrays -
    path_to_system_cache = "$(pwd())/grn_model/system/system.mat"
    system_dictionary = Dict{Any,Any}()
    if (filesize(path_to_system_cache)==0)

        # ok, we don't have the system.mat saved, so we need to dump build the system arrays and dump to disk -
        time_step_size = 0.5 # hr
        (number_of_genes,ncol) = size(list_of_genes)
        (number_of_transcripts,ncol) = size(list_of_transcripts)
        (AHAT,BHAT,CHAT) = generate_discrete_grn_system(biophysical_data_dictionary,number_of_genes,number_of_transcripts,time_step_size)
        system_dictionary["time_step_size"] = time_step_size
        system_dictionary["number_of_genes"] = number_of_genes
        system_dictionary["number_of_transcripts"] = number_of_transcripts
        system_dictionary["A"] = AHAT
        system_dictionary["B"] = BHAT
        system_dictionary["C"] = CHAT

        # dump system array to disk -
        matwrite(path_to_system_cache,system_dictionary)
    else
        file = matopen(path_to_system_cache)
        system_dictionary = read(file)
        close(file)
    end
    # ----------------------------------------------------------------------------------------------------- #
    #
    # ----------------------------------------------------------------------------------------------------- #

    # load the clustering results -
    path_to_mRNA_cluster_file = "$(pwd())/grn_model/system/mRNA_cluster_data_dictionary.mat"
    path_to_experimental_expression_file = build_expression_file_path(organism)
    mRNA_cluster_data_dictionary = Dict{String,Any}()
    if (filesize(path_to_mRNA_cluster_file) == 0)

        # cluster the data -
        mRNA_cluster_data_dictionary = cluster_mRNA_data(path_to_experimental_expression_file,3)

        # dump to disk for next time -
        matwrite(path_to_mRNA_cluster_file,mRNA_cluster_data_dictionary)
    else

        # msg = "Loading the cached cluster data ... "
        # println(msg)

        # load the cached copy of the clustering data -
        file = matopen(path_to_mRNA_cluster_file)
        mRNA_cluster_data_dictionary = read(file)
        close(file)
    end

    # process the clustering results, to compute the default basal weight array -
    # the cluster come back from the clustering routine: 1-> low, 2=>medium, 3->high
    cluster_range_array = mRNA_cluster_data_dictionary["cluster_range_array"]
    raw_data_array = mRNA_cluster_data_dictionary["raw_data_array"]
    number_of_genes = system_dictionary["number_of_genes"]
    W = zeros(number_of_genes)
    beta = 0.66
    for gene_index = 1:number_of_genes

        # get the test gene tag -
        gene_tag = list_of_genes[gene_index,2]
        gene_data_index = find_data_index_of_gene(gene_tag,mRNA_cluster_data_dictionary)

        # find the cluster index -
        cluster_index = find_cluster_index_of_gene(gene_tag,mRNA_cluster_data_dictionary)
        if (cluster_index != -1)


            if (cluster_index == LOW)

                # what range are we?
                cluster_range = cluster_range_array[:,cluster_index]
                raw_value = mean(raw_data_array[gene_data_index,2:end],2)[1]

                # compute the alpha score -
                alpha = (raw_value - cluster_range[1])/(cluster_range[2] - cluster_range[1])

                W2 = 0.4
                W1 = (1-beta)*(2*W2)
                W3 = 2*beta*W2

                #  low cluster -
                W[gene_index] = W1*(1-alpha)+W3*alpha


                # msg = "Gene $(gene_tag) cluster: $(LOW) with W = $(W[gene_index])"
                # println(msg)

            elseif (cluster_index == MEDIUM)

                # what range are we?
                cluster_range = cluster_range_array[:,cluster_index]
                raw_value = mean(raw_data_array[gene_data_index,2:end],2)[1]

                #@show cluster_range

                # compute the alpha score -
                alpha = (raw_value - cluster_range[1])/(cluster_range[2] - cluster_range[1])

                W2 = 4.0
                W1 = (1-beta)*(2*W2)
                W3 = 2*beta*W2

                # high cluster -
                W[gene_index] = W1*(1-alpha)+W3*alpha

                # msg = "Gene $(gene_tag) cluster: $(MEDIUM) with W = $(W[gene_index])"
                # println(msg)

            elseif (cluster_index == HIGH)

                # what range are we?
                cluster_range = cluster_range_array[:,cluster_index]
                raw_value = mean(raw_data_array[gene_data_index,2:end],2)[1]

                # compute the alpha score -
                alpha = (raw_value - cluster_range[1])/(cluster_range[2] - cluster_range[1])

                W2 = 40.0
                W1 = (1-beta)*(2*W2)
                W3 = 2*beta*W2

                # high cluster -
                W[gene_index] = W1*(1-alpha)+W3*alpha

                # msg = "Gene $(gene_tag) cluster: $(HIGH) with W = $(W[gene_index])"
                # println(msg)
            end
        else

            # What cluster?
            W[gene_index] = 0.4
            # msg = "Gene $(gene_tag) is type UNDEFINED with W = $(W[gene_index])"
            # println(msg)
        end
    end

    # Set the KD -
    KD_array = 91*ones(number_of_genes) # average basal TF is 20000 per/cell

    # ----------------------------------------------------------------------------------------------------- #
    #
    # =============================== DO NOT EDIT BELOW THIS LINE ========================================= #
	data_dictionary = Dict{AbstractString,Any}()
    data_dictionary["list_of_genes"] = list_of_genes
    data_dictionary["average_gene_length"] = average_gene_length
    data_dictionary["list_of_transcripts"] = list_of_transcripts
    data_dictionary["average_protein_length"] = average_protein_length
    data_dictionary["gene_length_dictionary"] = gene_length_dictionary
    data_dictionary["protein_length_dictionary"] = protein_length_dictionary

    data_dictionary["gene_concentration_array"] = gene_concentration_array
    data_dictionary["mRNA_concentration_array"] = mRNA_concentration_array
    data_dictionary["protein_concentration_array"] = protein_concentration_array

    data_dictionary["basal_transcription_weight_array"] = W
    data_dictionary["default_basal_transcription_KD_array"] = KD_array

    data_dictionary["cobra_dictionary"] = cobra_dictionary
    data_dictionary["biophysical_data_dictionary"] = biophysical_data_dictionary
    data_dictionary["basal_transcription_factor_dictionary"] = transcription_factor_dictionary
    data_dictionary["system_dictionary"] = system_dictionary
    data_dictionary["mRNA_cluster_data_dictionary"] = mRNA_cluster_data_dictionary
    data_dictionary["path_to_experimental_expression_file"] = path_to_experimental_expression_file
    # =============================== DO NOT EDIT ABOVE THIS LINE ========================================= #
	return data_dictionary
end
