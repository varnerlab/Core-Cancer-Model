# test the GRN subsystem module -
include("Include.jl")

# set the organism -
organism = :LINE_MCF7

# load the dd with the appropriate organism symbol -
dd = GRNModule.GRNDataDictionary(organism)

# estimate the steady state array -
(ss_mRNA,ss_P) = GRNModule.evaluate_steady_state_grn_subsystem(organism)
