# Include -
include("../Include.jl")

# ============================================================================= #
# Phase 1: run the GRN module, and cluster the results (kmeans, 3 clusters)
# set the organism -
organism = :LINE_HL_60_TB

# load the dd with the appropriate organism symbol -
dd = GRNModule.GRNDataDictionary(organism)

# estimate the steady state array -
(ss_P) = GRNModule.calculate_steady_state_protein(dd)
# ============================================================================= #
