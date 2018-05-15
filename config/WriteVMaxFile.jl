# ------------------------------------------------------------------------------- #
# NOTE: we execute everything from the root, so all paths are relative to root
# ------------------------------------------------------------------------------- #

# script to write the vmax file -
using MAT
using JSON
include("$(pwd())/Reconstruction.jl")
include("$(pwd())/DataDictionary.jl")

# load dd -
mdd = MetabolismDataDictionary(0,0,0)

# setup paths -
path_to_genes_file = "$(pwd())/grn_model/Transcripts.net"
path_to_gene_ec_map_file = "$(pwd())/config/ec_numbers.dat"
path_to_ec_database = "$(pwd())/config/ECNDatabase-CCM-Palsson-SciReports-2017.json"
path_to_vmax_file = "$(pwd())/config/VMAX-CCM-Palsson-SciReports-2017.dat"

# write the file -
write_effective_vmax_file(path_to_genes_file,path_to_gene_ec_map_file,path_to_ec_database,path_to_vmax_file,mdd)
