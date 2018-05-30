# include -
include("Include.jl")

# what organism are we going to use?
organismid = :LINE_HL_60_TB

# load the data dictionary -
data_dictionary = maximize_cellmass_data_dictionary_dipp(organismid)

# calculate the optimal flux distribution -
(objective_value, calculated_flux_array, dual_value_array, uptake_array, exit_flag, status_flag) = calculate_optimal_flux_distribution(data_dictionary)
