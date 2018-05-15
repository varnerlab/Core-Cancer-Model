# my includes -
top_level_path = pwd()
include("$(top_level_path)/grn_model/Constants.jl")
include("$(top_level_path)/grn_model/Kinetics.jl")
include("$(top_level_path)/grn_model/DataDictionary.jl")
include("$(top_level_path)/grn_model/Discrete.jl")
include("$(top_level_path)/grn_model/Control.jl")
include("$(top_level_path)/grn_model/Cluster.jl")
include("$(top_level_path)/grn_model/EvalGRNSystem.jl")

# system includes -
using MAT
using JSON
using Clustering
