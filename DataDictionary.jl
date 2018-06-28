function maximize_cellmass_data_dictionary_dipp_experimental(organismid,exchange_flux_array)

end

function maximize_cellmass_data_dictionary_dipp(organismid)

    # load the default data dictionary -
    data_dictionary = MetabolismDataDictionary(organismid)

    # get the exchange rates for this organism -
    exchange_flux_array = data_dictionary["exchange_flux_array"]

    # modify the data dictionary -
    objective_coefficient_array = data_dictionary["objective_coefficient_array"]
    objective_coefficient_array[end] = -1.0

    # we need to set the glucose uptake rate -
    species_bounds_array = data_dictionary["species_bounds_array"]
    default_flux_bounds_array = data_dictionary["default_flux_bounds_array"]
    list_of_species = data_dictionary["cobra_dictionary"]["mets"]
    list_of_reaction_tags = data_dictionary["cobra_dictionary"]["rxns"]
    list_of_reversible_reactions = data_dictionary["cobra_dictionary"]["rev"]

    # add cell mass reaction -
    list_of_reversible_reactions = [list_of_reversible_reactions ; 0]

    # how many total fluxes do we have?
    (total_number_of_fluxes,nc) = size(default_flux_bounds_array)

    # update the flux bounds -
    (number_of_exchange_fluxes,cols) = size(exchange_flux_array)
    for exchange_flux_index = 1:number_of_exchange_fluxes

        # get reaction tag and value -
        reaction_tag = exchange_flux_array[exchange_flux_index,1]
        constraint_value = exchange_flux_array[exchange_flux_index,2]
        constraint_uncertainty = exchange_flux_array[exchange_flux_index,3]

        # find reaction index -
        reaction_tag_index = find_index_of_reaction(list_of_reaction_tags,reaction_tag)

        # bound value -
        tmp_value_1 = constraint_value*(1/constraint_uncertainty)
        tmp_value_2 = constraint_value*(constraint_uncertainty)

        # update the bound -
        default_flux_bounds_array[reaction_tag_index,1] = min(tmp_value_1,tmp_value_2)
        default_flux_bounds_array[reaction_tag_index,2] = max(tmp_value_1,tmp_value_2)
    end

    # load the XSS and vmax values -
    path_to_steady_state_expression_data = "$(pwd())/grn_model/XSS.dat.1"
    path_to_vmax_data_file = "$(pwd())/config/VMAX-CCM-Palsson-SciReports-2017.dat"
    path_to_rules_map = "$(pwd())/Network.rules"

    # get the rules -
    rules_map = readdlm(path_to_rules_map,',')

    # get the VMAX -
    vmax_array = readdlm(path_to_vmax_data_file)

    # get the steady-state expression state, and compute the rules -
    state_array = readdlm(path_to_steady_state_expression_data)
    number_of_mRNA = 1760
    default_enzyme_concentation = 0.04732687179487179 # mumol/gDW
    protein_array = state_array[(number_of_mRNA+1):end]
    scaled_protein_array = (1/default_enzyme_concentation)*protein_array
    v_array = gene_association_rules(scaled_protein_array,data_dictionary)

    # ok, map these rules (and the VMAXs to the specific reactions)
    for flux_index = 1:total_number_of_fluxes

        if (flux_index>number_of_exchange_fluxes)

            # get the VMAX value -
            vmax = vmax_array[flux_index]
            rule_value = v_array[flux_index]

            if (list_of_reversible_reactions[flux_index] == 0)
                # update the upper bounds -
                default_flux_bounds_array[flux_index,2] = vmax*rule_value
            else

                # reversible - update the back reaction as well -
                default_flux_bounds_array[flux_index,1] = -1*vmax*rule_value
                default_flux_bounds_array[flux_index,2] = vmax*rule_value
            end
        end
    end

    # repack -
    data_dictionary["default_flux_bounds_array"] = default_flux_bounds_array
    data_dictionary["species_bounds_array"] = species_bounds_array
    data_dictionary["objective_coefficient_array"] = objective_coefficient_array

    # return the modified data dictionary -
    return data_dictionary
end

function MetabolismDataDictionary(organismid::Symbol)

    # setup paths -
    path_to_cobra_mat_file = "$(pwd())/cobra_code/modelCore.mat"
    path_to_cellmass_file = build_cellmass_file_path(organismid)
    path_to_exchange_array = build_exchange_array_file_path(organismid)

    # load the *.mat code from the cobra code folder -
    file = matopen(path_to_cobra_mat_file)
    cobra_dictionary = read(file,"modelCore")
    close(file)

    # ok, the cobra dictionary contains all the stuff that we need.
    # get the stoichometric matrix -
    stoichiometric_matrix = full(cobra_dictionary["S"])
    (number_of_species,number_of_reactions) = size(stoichiometric_matrix)

    # we need to add the biomass equation for HL-60 -
    biomass_eqn_data = readdlm(path_to_cellmass_file,',')
    biomass_eqn = zeros(number_of_species)

    # how many biomass components do we have?
    number_of_biomass_species = length(biomass_eqn_data[:,1])
    for biomass_component_index = 1:number_of_biomass_species

        # get the component symbol and stcoeff -
        component_symbol = biomass_eqn_data[biomass_component_index,1]
        component_stoichiometric_coeff = biomass_eqn_data[biomass_component_index,2]

        # ok, so now we need to find the index of this component -
        index_of_species = find_index_of_species(cobra_dictionary["mets"],component_symbol)

        # update the entry in the biomass_eqn -
        biomass_eqn[index_of_species] = component_stoichiometric_coeff
    end

    # add the new *column* to the stoichometric array -
    stoichiometric_matrix = [stoichiometric_matrix biomass_eqn]

    # what is the *final* size of the system?
    (number_of_species,number_of_reactions) = size(stoichiometric_matrix)

    # objective coefficient array -
    objective_coefficient_array = cobra_dictionary["c"]
    objective_coefficient_array = [objective_coefficient_array ; 0.0] # add entry for growth -

    # Add growh to rev list (0 = not reversible, 1 = reversible)
    reversible_reactions = cobra_dictionary["rev"]
    reversible_reactions = [reversible_reactions ; 0.0]

    # default flux bounds array -
    default_flux_bounds_array = zeros(number_of_reactions,2)
    lb = cobra_dictionary["lb"] # lower bound -
    ub = cobra_dictionary["ub"] # upper bound -
    for reaction_index = 1:number_of_reactions - 1
        default_flux_bounds_array[reaction_index,1] = lb[reaction_index]
        default_flux_bounds_array[reaction_index,2] = 20.0
    end

    # add default growth rate constraint?
    default_flux_bounds_array[end,1] = 0.0
    default_flux_bounds_array[end,2] = 1.0

    # species bounds array - default, everything is bounded 0,0
    # species in the [e] (extracellular) compartment are unbounded
    # by default -1,1
    species_bounds_array = zeros(number_of_species,2)
    index_array_extracellular_species = find_species_in_compartment(cobra_dictionary["mets"],"[e]")
    for unbounded_species_index in index_array_extracellular_species
        species_bounds_array[unbounded_species_index,1] = 0.0
        species_bounds_array[unbounded_species_index,2] = 0.0
    end

    # create list of reaction strings -
    list_of_reaction_strings = cobra_dictionary["rxnNames"]

    # add growth reaction name -
    list_of_reaction_strings = [list_of_reaction_strings ; "growth"]

    # add growth to reaction list -
    list_of_reaction_tags = cobra_dictionary["rxns"]
    list_of_reaction_tags = [list_of_reaction_tags ; "growth"]

    # create a list of metabolite strings -
    list_of_metabolite_symbols = cobra_dictionary["mets"]

    # What sense do we do? (by default we min)
    is_minimum_flag = true

    # lastly, load organism specific exchange bounds -
    exchange_flux_array = readdlm(path_to_exchange_array,',')

    # =============================== DO NOT EDIT BELOW THIS LINE ============================== #
	data_dictionary = Dict{AbstractString,Any}()
	data_dictionary["stoichiometric_matrix"] = stoichiometric_matrix
	data_dictionary["objective_coefficient_array"] = objective_coefficient_array
	data_dictionary["default_flux_bounds_array"] = default_flux_bounds_array
    data_dictionary["reversible_reactions"] = reversible_reactions
	data_dictionary["species_bounds_array"] = species_bounds_array
	data_dictionary["list_of_reaction_strings"] = list_of_reaction_strings
    data_dictionary["list_of_reaction_tags"] = list_of_reaction_tags
	data_dictionary["list_of_metabolite_symbols"] = list_of_metabolite_symbols
	data_dictionary["is_minimum_flag"] = is_minimum_flag
	data_dictionary["number_of_species"] = number_of_species
	data_dictionary["number_of_reactions"] = number_of_reactions
    data_dictionary["exchange_flux_array"] = exchange_flux_array

    # in case we need something later -
    data_dictionary["cobra_dictionary"] = cobra_dictionary
    # =============================== DO NOT EDIT ABOVE THIS LINE ============================== #
	return data_dictionary
end

# Helper functions -
function build_exchange_array_file_path(organismid::Symbol)

    # we need to figure out which cellmass file to load -
    # load the mapping file -
    path_to_map_file = "$(pwd())/cobra_code/metabolites/Map.json"

    # parse this file, and return the mapping dictionary -
    mapping_dictionary = JSON.parsefile(path_to_map_file)

    # convert organismid to key -
    key_value = string(organismid)
    if (haskey(mapping_dictionary,key_value) == true)

        # ok, we have this key, grab the associated dictionary and load the filename -
        file_name = mapping_dictionary[key_value]["constraints_file_name"]

        # build the path -
        file_path = "$(pwd())/cobra_code/metabolites/$(file_name)"

        # return -
        return file_path
    end
end

function build_cellmass_file_path(organismid::Symbol)

    # we need to figure out which cellmass file to load -
    # load the mapping file -
    path_to_cellmass_map = "$(pwd())/cobra_code/cellmass/Map.json"

    # parse this file, and return the mapping dictionary -
    cellmass_mapping_dictionary = JSON.parsefile(path_to_cellmass_map)

    # convert organismid to key -
    key_value = string(organismid)
    if (haskey(cellmass_mapping_dictionary,key_value) == true)

        # ok, we have this key, grab the associated dictionary and load the filename -
        cellmass_file_name = cellmass_mapping_dictionary[key_value]["cellmass_file_name"]

        # build the path -
        cellmass_file_path = "$(pwd())/cobra_code/cellmass/$(cellmass_file_name)"

        # return -
        return cellmass_file_path
    end

    # default -
    path_to_default_cellmass_file = "$(pwd())/cobra_code/cellmass/Default-Biomass.csv"
end
