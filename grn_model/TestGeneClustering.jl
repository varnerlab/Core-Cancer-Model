# include -
include("Include.jl")

# cluster the HL-60 data into 3 clusters -
mRNA_cluster_data_dictionary = cluster_mRNA_data("../cobra_code/Expression-HL60.csv",3)
