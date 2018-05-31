# what is my top level path -
top_level_path = pwd()

# inlcude statements -
include("$(pwd())/DataDictionary.jl")
include("$(pwd())/Flux.jl")
include("$(pwd())/Reconstruction.jl")
include("$(pwd())/Rules.jl")

# path to my subsystem modules -
path_to_grn_module = "$(top_level_path)/grn_model"
push!(LOAD_PATH, path_to_grn_module)
import GRNModule

# using -
using GLPK
using MAT
using PyPlot
