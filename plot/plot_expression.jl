# Script to plot the predicted versus measured expression values -



# Include -
include("../Include.jl")

# ============================================================================= #
# Phase 1: run the GRN module, and cluster the results (kmeans, 3 clusters)
# set the organism -
organism = :LINE_MCF7

# load the dd with the appropriate organism symbol -
dd = GRNModule.GRNDataDictionary(organism)

# estimate the steady state array -
(ss_mRNA) = GRNModule.calculate_steady_state_mRNA(dd)

# cluster the simulated values -
simulated_cluster_dictionary = GRNModule.cluster_mRNA_simulation(ss_mRNA,3)
# ============================================================================= #

# ============================================================================= #
# Phase 2: get the clustering results for the experimental system -
measured_cluster_dictionary = dd["mRNA_cluster_data_dictionary"]
# ============================================================================= #

# ============================================================================= #
# Phase 3: mean center the simulated data -
mean_ss_mRNA = mean(ss_mRNA)
min_ss_mRNA = minimum(ss_mRNA)
max_ss_mRNA = maximum(ss_mRNA)
scaled_ss_mRNA_s = (ss_mRNA - mean_ss_mRNA)/(max_ss_mRNA - min_ss_mRNA)
# ============================================================================= #

# ============================================================================= #
# Phase 4: mean center the measured data -

# what is our idnex vector -
list_of_genes = dd["list_of_genes"]
ss_mRNA_m = mean(measured_cluster_dictionary["raw_data_array"][list_of_genes[:,1],2:end],2)

# ss_mRNA_m = mean(raw_data_array,2)
mean_ss_mRNA = mean(ss_mRNA_m)
min_ss_mRNA = minimum(ss_mRNA_m)
max_ss_mRNA = maximum(ss_mRNA_m)
scaled_ss_mRNA_m = (ss_mRNA_m - mean_ss_mRNA)/(max_ss_mRNA - min_ss_mRNA)
# ============================================================================= #
