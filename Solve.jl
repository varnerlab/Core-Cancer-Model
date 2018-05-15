# include -
include("Include.jl")

# load the data dictionary -
data_dictionary = maximize_cellmass_data_dictionary(0,0,0)

# calculate the optimal flux distribution -
(objective_value, calculated_flux_array, dual_value_array, uptake_array, exit_flag, status_flag) = calculate_optimal_flux_distribution(data_dictionary)
