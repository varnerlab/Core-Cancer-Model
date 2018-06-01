# Script to plot the predicted versus measured expression values -

# Include -
include("../Include.jl")

# ============================================================================= #
# Phase 1: run the GRN module, and cluster the results (kmeans, 3 clusters)
# set the organism -
organism = :LINE_HL_60_TB

# load the dd with the appropriate organism symbol -
dd = GRNModule.GRNDataDictionary(organism)

# estimate the steady state array -
(ss_mRNA,control_array) = GRNModule.calculate_steady_state_mRNA(dd)

# cluster the simulated values -
simulated_cluster_dictionary = GRNModule.cluster_mRNA_simulation(dd,ss_mRNA,3)
# ============================================================================= #

# ============================================================================= #
# Phase 2: get the clustering results for the experimental system -
measured_cluster_dictionary = dd["mRNA_cluster_data_dictionary"]
# ============================================================================= #

# ============================================================================= #
# Phase 3: mean center the simulated data -
# ============================================================================= #

# ============================================================================= #
# Phase 4: mean center the measured data -

# what is our idnex vector -
list_of_genes = dd["list_of_genes"]
number_of_genes = length(list_of_genes[:,1])
ss_mRNA_m = zeros(number_of_genes)
for gene_index = 1:number_of_genes

    # what is the current gene tag?
    gene_tag = list_of_genes[gene_index,2]

    # where is this gene index in the *data*
    gene_index_in_data = GRNModule.find_data_index_of_gene(gene_tag,measured_cluster_dictionary)
    if (isempty(gene_index_in_data))

        @show gene_tag
        ss_mRNA_m[gene_index] = -1.0

    else
        tmp_array = measured_cluster_dictionary["raw_data_array"][gene_index_in_data[1],2:end]
        ss_mRNA_m[gene_index] = mean(tmp_array)
    end
end

# which index are NOT -1?
idx_non_negative = find(ss_mRNA_m .!= -1)
nnz = length(idx_non_negative)

MA = Float64[]
SA = Float64[]
for nnz_index in idx_non_negative

    mv = ss_mRNA_m[nnz_index]
    sv = ss_mRNA[nnz_index]

    push!(MA,mv)
    push!(SA,sv)

end

# measured -
ss_mRNA_m = MA
mean_ss_mRNA = mean(ss_mRNA_m)
min_ss_mRNA = minimum(ss_mRNA_m)
max_ss_mRNA = maximum(ss_mRNA_m)
scaled_ss_mRNA_m = (ss_mRNA_m - mean_ss_mRNA)/(max_ss_mRNA - min_ss_mRNA)

# simulated -
ss_mRNA = SA
mean_ss_mRNA = mean(ss_mRNA)
min_ss_mRNA = minimum(ss_mRNA)
max_ss_mRNA = maximum(ss_mRNA)
scaled_ss_mRNA_s = (ss_mRNA - mean_ss_mRNA)/(max_ss_mRNA - min_ss_mRNA)

# ============================================================================= #
