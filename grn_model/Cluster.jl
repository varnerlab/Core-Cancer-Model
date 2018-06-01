# script to cluster gene expression data -
function cluster_mRNA_data(path_to_expression_file,number_of_clusters)

    # load the data -
    raw_data_array = readdlm(path_to_expression_file,',')

    # remove the gene id's
    data_array = transpose(raw_data_array[:,2:end])

    # cluster -
    kmeans_result = kmeans(data_array,number_of_clusters)

    # convert the raw data to the gene tag -
    gene_id_array = String[]
    (number_of_genes,number_of_cols) = size(raw_data_array)
    for gene_index = 1:number_of_genes

        # grab the raw value -
        raw_value = trunc(Int64,raw_data_array[gene_index,1])

        # build the tag -
        gene_tag = "G_$(raw_value)"

        # cache -
        push!(gene_id_array,gene_tag)
    end

    # NOTE: The clustering algorithm returns the clusters in a random order
    # Reorder the clusters 1 = low, 2 = medium, 3 = high
    center_array = kmeans_result.centers
    index_sort = sortperm(vec(center_array[1,:]),rev=false)

    # remap the assignents -
    assignment_array = Int64[]
    for assignent_index = 1:number_of_genes

        # what is the current assigment?
        current_index = kmeans_result.assignments[assignent_index]

        # determine the new assigment -
        new_assignment = find(index_sort .== current_index)

        # cache -
        push!(assignment_array,new_assignment[1])
    end

    # remap the centers -
    center_array = kmeans_result.centers[:,index_sort]

    # determine the range of each cluster (min->max)
    cluster_range_array = zeros(2,number_of_clusters)
    for cluster_index = 1:number_of_clusters

        idx_cluster = find(assignment_array .== cluster_index)
        raw_value_array = mean(raw_data_array[idx_cluster,2:end],2)
        cluster_range_array[1,cluster_index] = minimum(raw_value_array)
        cluster_range_array[2,cluster_index] = maximum(raw_value_array)
    end

    # ok -
    mRNA_cluster_data_dictionary = Dict{String,Any}()
    mRNA_cluster_data_dictionary["gene_id_array"] = gene_id_array
    mRNA_cluster_data_dictionary["center_array"] = center_array
    mRNA_cluster_data_dictionary["cluster_range_array"] = cluster_range_array
    mRNA_cluster_data_dictionary["assignment_array"] = assignment_array
    mRNA_cluster_data_dictionary["counts"] = kmeans_result.counts
    mRNA_cluster_data_dictionary["totalcost"] = kmeans_result.totalcost
    mRNA_cluster_data_dictionary["converged"] = kmeans_result.converged
    mRNA_cluster_data_dictionary["raw_data_array"] = raw_data_array

    # return -
    return mRNA_cluster_data_dictionary
end

function cluster_mRNA_simulation(data_dictionary,mRNA_data_array,number_of_clusters)

    # get list of genes -
    list_of_genes = data_dictionary["list_of_genes"]

    # build tmp array -
    raw_data_array = [mRNA_data_array mRNA_data_array]

    # reshape -
    data_array = transpose(raw_data_array)

    # cluster -
    kmeans_result = kmeans(data_array,number_of_clusters)

    # convert the raw data to the gene tag -
    gene_id_array = String[]
    (number_of_genes,number_of_cols) = size(raw_data_array)
    for gene_index = 1:number_of_genes

        # build the tag -
        gene_tag = list_of_genes[gene_index,2]

        # cache -
        push!(gene_id_array,gene_tag)
    end

    # NOTE: The clustering algorithm returns the clusters in a random order
    # Reorder the clusters 1 = low, 2 = medium, 3 = high
    center_array = kmeans_result.centers
    index_sort = sortperm(vec(center_array[1,:]),rev=false)

    # remap the assignents -
    assignment_array = Int64[]
    for assignent_index = 1:number_of_genes

        # what is the current assigment?
        current_index = kmeans_result.assignments[assignent_index]

        # determine the new assigment -
        new_assignment = find(index_sort .== current_index)

        # cache -
        push!(assignment_array,new_assignment[1])
    end

    # remap the centers -
    center_array = kmeans_result.centers[:,index_sort]

    # determine the range of each cluster (min->max)
    cluster_range_array = zeros(2,number_of_clusters)
    for cluster_index = 1:number_of_clusters

        idx_cluster = find(assignment_array .== cluster_index)
        raw_value_array = mean(raw_data_array[idx_cluster,2:end],2)
        cluster_range_array[1,cluster_index] = minimum(raw_value_array)
        cluster_range_array[2,cluster_index] = maximum(raw_value_array)
    end

    # ok -
    mRNA_cluster_data_dictionary = Dict{String,Any}()
    mRNA_cluster_data_dictionary["gene_id_array"] = gene_id_array
    mRNA_cluster_data_dictionary["center_array"] = center_array
    mRNA_cluster_data_dictionary["cluster_range_array"] = cluster_range_array
    mRNA_cluster_data_dictionary["assignment_array"] = assignment_array
    mRNA_cluster_data_dictionary["counts"] = kmeans_result.counts
    mRNA_cluster_data_dictionary["totalcost"] = kmeans_result.totalcost
    mRNA_cluster_data_dictionary["converged"] = kmeans_result.converged
    mRNA_cluster_data_dictionary["raw_data_array"] = raw_data_array

    # return -
    return mRNA_cluster_data_dictionary
end
