# test the GRN subsystem module -
include("../Include.jl")

# set the organism -
organism = :LINE_MCF7

# load the dd with the appropriate organism symbol -
dd = GRNModule.GRNDataDictionary(organism)

# estimate the steady state array -
(ss_mRNA_ss) = GRNModule.calculate_steady_state_mRNA(dd)
