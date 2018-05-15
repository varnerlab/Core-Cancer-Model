function show_flux_profile(flux_array::Array{Float64,2},data_dictionary::Dict{AbstractString,Any})

    # what is the size of the flux array?
    (number_of_fluxes,number_of_cols) = size(flux_array)

    # what is the list of reaction strings?
    list_of_reaction_strings = readdlm("$(pwd())/Reactions.net",',')

    # initialize tmp_array -
    tmp_array = zeros(number_of_cols)

    # create a list of reactions?
    list_of_flux_records = String[]
    for flux_index = 1:number_of_fluxes

        # key,value -
        rxn_name = list_of_reaction_strings[flux_index,2]
        reaction_eqn_lhs = list_of_reaction_strings[flux_index,3]
        reaction_eqn_rhs = list_of_reaction_strings[flux_index,4]

        # create local flux array -
        for col_index = 1:number_of_cols
            tmp_array[col_index] = flux_array[flux_index,col_index]
        end

        # add flux values to my record -
        record = "$(flux_index),$(rxn_name),$(reaction_eqn_lhs) = $(reaction_eqn_rhs)"
        for col_index = 1:number_of_cols
            record *= ",$(tmp_array[col_index])"
        end

        # add records to list -
        push!(list_of_flux_records,record)
  end

  return list_of_flux_records
end
