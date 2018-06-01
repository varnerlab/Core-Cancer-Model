# test the GRN subsystem module -
include("../Include.jl")

# set the organism -
organism = :LINE_HL_60_TB

# load the dd with the appropriate organism symbol -
dd = GRNModule.GRNDataDictionary(organism)

# estimate the steady state mRNA array -
(ss_mRNA_ss, control_array) = GRNModule.calculate_steady_state_mRNA(dd)

# Calculate the steady state P array -
(ss_P_ss) = GRNModule.calculate_steady_state_protein(dd)

# Save to disk to use in DIPP simulations -
data_array = [ss_mRNA_ss ; ss_P_ss]

# dump -
writedlm("./grn_model/XSS.dat.1",data_array)
