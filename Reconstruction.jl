# helper methods to setup the cobra model in Julia -
function write_effective_vmax_file(path_to_genes_file,path_to_gene_ec_map_file,path_to_ec_database,path_to_vmax_file,data_dictionary)

    # load the genes file -
    list_of_genes = readdlm(path_to_genes_file,',')

    # load the ec file -
    gene_ec_map = readdlm(path_to_gene_ec_map_file,'\t')

    # get the cobra dictionary from the dd -
    cobra_dictionary = data_dictionary["cobra_dictionary"]

    # setup some defaults -
    default_kcat = 13.7*(3600)  # hr^-1
    default_enzyme_concentation = 0.047*(1/1000)    # mmol/gDW

    # get the rxnGeneMat from cobra -
    GM = cobra_dictionary["rxnGeneMat"]
    FGM = full(GM)

    # initialize the vmax array -
    effective_vmax_array = Float64[]

    # what is the size of FGM?
    (number_of_reactions,number_of_genes) = size(FGM)
    for reaction_index = 1:number_of_reactions

        # what are the genes associated with this reaction?
        idx_genes = find(FGM[reaction_index,:] .!= 0)

        # ok, so if we have no genes, then generate a default vmax -
        if (isempty(idx_genes))

            vmax = default_kcat*default_enzyme_concentation
            push!(effective_vmax_array,vmax)
        else

            # initialize local ec array -
            local_ec_array = String[]

            # ok, so we have some genes!
            while (!isempty(idx_genes))

                # pop a gene index from the list -
                local_gene_index = pop!(idx_genes)

                # what is the gene location?
                gene_location = list_of_genes[local_gene_index,2]

                # chop off the leading G_ and replace w/hsa: -
                full_gene_name = "hsa:$(gene_location[6:(end-2)])"

                # find this name in the gene_ec_map -
                (number_of_matches,nc) = size(gene_ec_map)
                for index = 1: number_of_matches
                    test_symbol = gene_ec_map[index,1]
                    if (full_gene_name == test_symbol)
                        push!(local_ec_array,gene_ec_map[index,2])
                    end
                end
            end

            @show (reaction_index,local_ec_array)

            # ok, so when I get here I have a collection of ec numbers associated w/this reaction
            # estimate an aggregate kcat (somehow ...)

            # load the ec database -
            tmp_kcat_array = Float64[]
            ec_dictionary = JSON.parsefile(path_to_ec_database)

            # if we have NO ec number, then add the default -
            if (isempty(local_ec_array))
                push!(tmp_kcat_array,default_kcat)
            end

            # if have an ec number, then check the dictionary -
            while (!isempty(local_ec_array))

                # pop -
                ec_number_key = pop!(local_ec_array)

                # is this ec in the database?
                if (haskey(ec_dictionary,ec_number_key) == true)

                    # get the array for dictionarys for this ec number -
                    array_of_dictionaries = ec_dictionary[ec_number_key]
                    while (!isempty(array_of_dictionaries))

                        # get the dictionary -
                        local_dictionary = pop!(array_of_dictionaries)
                        kcat = parse(Float64,local_dictionary["turnoverNumber"])

                        if (kcat != -999) # bad data ...
                            push!(tmp_kcat_array,kcat)
                        else
                            push!(tmp_kcat_array,default_kcat)
                        end
                    end
                else

                    # oops - we have an ec number that we don't have any data for, use the default kcat -
                    push!(tmp_kcat_array,default_kcat)
                end
            end # end-while

            #@show (reaction_index,tmp_kcat_array)

            # ok, so when I get here, I should have a bunch of potential kcats
            # compute the average, and vmax -
            average_kcat = mean(tmp_kcat_array)
            vmax = (average_kcat*default_enzyme_concentation)*(3600)    # mmol/gDW-hr
            push!(effective_vmax_array,vmax)

        end # end else
    end # end - reaction`

    # write to disk -
    open(path_to_vmax_file,"w") do f

        for statement in effective_vmax_array
            write(f,"$(statement)\n")
        end
    end
end

function print_boundary_metabolites(path_to_model_file,data_name)

    # initialize -
    species_list = String[]

    # load the file -
    file = matopen(path_to_model_file)
    cobra_dictionary = read(file,data_name)
    close(file)

    # get the list of metabolites -
    list_of_metabolite_symbols = cobra_dictionary["mets"]
    for symbol in list_of_metabolite_symbols

        if (contains(symbol,"[e]") == true)
            push!(species_list,symbol)
        end
    end

    return species_list
end

function write_dictionary_to_cobra_mat_file(output_path_to_cobra_file,data_dictionary)

    # ok, lets write out the update dictionary in the form a of cobra dictionary -
    cobra_dictionary = Dict()

    # fill in the cobra data -
    cobra_dictionary["S"] = data_dictionary["stoichiometric_matrix"]
    cobra_dictionary["lb"] = data_dictionary["default_flux_bounds_array"][:,1]
    cobra_dictionary["ub"] = data_dictionary["default_flux_bounds_array"][:,2]
    cobra_dictionary["c"] = data_dictionary["objective_coefficient_array"]
    cobra_dictionary["rxnNames"] = data_dictionary["list_of_reaction_strings"]
    cobra_dictionary["mets"] = data_dictionary["list_of_metabolite_symbols"]
    cobra_dictionary["rxns"] = data_dictionary["list_of_reaction_tags"]
    cobra_dictionary["b"] = data_dictionary["uptake_array"]
    cobra_dictionary["rev"] = data_dictionary["reversible_reactions"]
    cobra_dictionary["rxnGeneMat"] = data_dictionary["cobra_dictionary"]["rxnGeneMat"]
    cobra_dictionary["grRules"] = data_dictionary["cobra_dictionary"]["grRules"]

    # write out -
    matwrite(output_path_to_cobra_file,cobra_dictionary)
end

function reconstruct_rule_strings(path_to_model_file,data_name)

    # initialize -
    rule_string_buffer = String[]

    # load up the cobra dictionary -
    file = matopen(path_to_model_file)
    cobra_dictionary = read(file,data_name)
    close(file)

    # get stuff from the Cobra dictionary -
    list_of_rules = cobra_dictionary["grRules"]
    list_of_reaction_tags = cobra_dictionary["rxns"]

    # how many rules?
    number_of_rules = length(list_of_rules)
    for rule_index = 1:number_of_rules

        # initialize clean buffer -
        local_buffer = ""

        # get the rule -
        rule_string = list_of_rules[rule_index]
        if (length(rule_string)!=0)

            # get the reaction tag -
            reaction_tag = list_of_reaction_tags[rule_index]

            # fill the local buffer -
            local_buffer *= "$(rule_index),$(reaction_tag),$(rule_string);"

            # add this to the rule buffer -
            push!(rule_string_buffer,local_buffer)
        end
    end
    return rule_string_buffer
end

function reconstruct_mRNA_string_list(path_to_model_file,data_name)

    # initialize -
    mRNA_symbol_list = String[]

    # load up the cobra dictionary -
    file = matopen(path_to_model_file)
    cobra_dictionary = read(file,data_name)
    close(file)

    # get stuff from cobra dictionary -
    list_of_species = cobra_dictionary["genes"]

    # main loop -
    number_of_species = length(list_of_species)
    for species_index = 1:number_of_species

        # initialize clean buffer -
        local_buffer = ""

        # Get the structure -
        mRNA_tag = list_of_species[species_index]

        # populate local buffer -
        local_buffer *= "$(species_index),mRNA_$(mRNA_tag)"

        # add -
        push!(mRNA_symbol_list,local_buffer)
    end

    # return -
    return mRNA_symbol_list
end

function reconstruct_gene_string_list(path_to_model_file,data_name)

    # initialize -
    gene_symbol_list = String[]
    local_gene_set = Set{String}()

    # load up the cobra dictionary -
    file = matopen(path_to_model_file)
    cobra_dictionary = read(file,data_name)
    close(file)

    # get stuff from cobra dictionary -
    list_of_species = cobra_dictionary["genes"]

    # main loop -
    number_of_species = length(list_of_species)
    for species_index = 1:number_of_species

        # initialize clean buffer -
        local_buffer = ""

        # Get the structure -
        gene_tag = list_of_species[species_index]

        # cuttoff the splice varient -
        gene_tag = gene_tag[1:end-2]

        # model gene symbol -
        model_gene_symbol = "G_$(gene_tag)"
        if (in(gene_tag,local_gene_set) == false)

            # populate local buffer -
            local_buffer *= "$(species_index),G_$(gene_tag)"

            # add -
            push!(gene_symbol_list,local_buffer)

            # add to set -
            push!(local_gene_set,gene_tag)
        end
    end

    # return -
    return gene_symbol_list
end

function reconstruct_species_string_list(path_to_model_file,data_name)

    # initialize -
    species_string_buffer = String[]


    # load up the cobra dictionary -
    file = matopen(path_to_model_file)
    cobra_dictionary = read(file,data_name)
    close(file)

    # get stuff from the cobra dictionary -
    list_of_species = cobra_dictionary["mets"]
    list_of_structures = cobra_dictionary["metFormulas"]
    list_of_species_names = cobra_dictionary["metNames"]

    # main loop -
    number_of_species = length(list_of_species)
    for species_index = 1:number_of_species

        # initialize clean buffer -
        local_buffer = ""

        # Get the structure -
        tag = list_of_species[species_index]
        structure = list_of_structures[species_index]
        name = list_of_species_names[species_index]

        # populate local buffer -
        local_buffer *= "$(species_index),$(tag),$(name),$(structure)"

        # add -
        push!(species_string_buffer,local_buffer)
    end

    # return -
    return species_string_buffer
end

function reconstruct_reaction_string_list(path_to_model_file,data_name)

    # initialize -
    reaction_string_buffer = String[]

    # load the file -
    file = matopen(path_to_model_file)
    cobra_dictionary = read(file,data_name)
    close(file)

    # get the stoichiometric array -
    stoichiometric_matrix = full(cobra_dictionary["S"])
    list_of_reaction_tags = cobra_dictionary["rxns"]
    list_of_species = cobra_dictionary["mets"]
    list_of_reversible_reactions = cobra_dictionary["rev"]

    # what is the size?
    (number_of_species,number_of_reactions) = size(stoichiometric_matrix)
    for reaction_index = 1:number_of_reactions

        # initialize empty buffer -
        buffer = ""

        # get the reaction tag -
        reaction_tag_string = list_of_reaction_tags[reaction_index]

        # add the tag to the buffer -
        buffer *= "$(reaction_index),$(reaction_tag_string),"

        # find the reactants -
        idx_reactants = find(stoichiometric_matrix[:,reaction_index].<0.0)
        if (isempty(idx_reactants) == true)
            buffer *= "[],"
        else

            # how many species do we have?
            number_of_species = length(idx_reactants)
            counter = 1
            for index in idx_reactants

                # get the metabolite -
                metabolite_string = list_of_species[index]
                stcoeff = stoichiometric_matrix[index,reaction_index]

                if (stcoeff != -1.0)
                    # add data to the buffer -
                    buffer *= "$(abs(stcoeff))*$(metabolite_string)"
                else
                    # add data to the buffer -
                    buffer *= "$(metabolite_string)"
                end



                # do we have more?
                if (counter < number_of_species)
                    buffer *= "+"
                else
                    buffer *= ","
                end

                counter = counter + 1
            end
        end

        # find the products -
        idx_products = find(stoichiometric_matrix[:,reaction_index].>0.0)
        if (isempty(idx_products) == true)
            buffer *= "[],"
        else

            # how many species do we have?
            number_of_species = length(idx_products)
            counter = 1
            for index in idx_products

                # get the metabolite -
                metabolite_string = list_of_species[index]
                stcoeff = stoichiometric_matrix[index,reaction_index]

                if (stcoeff != 1.0)
                    # add data to the buffer -
                    buffer *= "$(stcoeff)*$(metabolite_string)"
                else
                    # add data to the buffer -
                    buffer *= "$(metabolite_string)"
                end

                # do we have more?
                if (counter < number_of_species)
                    buffer *= "+"
                else
                    buffer *= ","
                end

                counter = counter + 1
            end
        end

        # is this reaction reversible?
        rev_value = list_of_reversible_reactions[reaction_index]
        if (rev_value == 1.0)
            buffer *= "-inf,inf"
        else
            buffer *= "0,inf"
        end

        # add buffer to list of strings -
        push!(reaction_string_buffer,buffer)
    end

    # return reaction_string_buffer
    return reaction_string_buffer
end


function find_index_of_reaction(list_of_reaction_tags,reaction_tag)
    return find_index_of_species(list_of_reaction_tags,reaction_tag)
end

function find_index_of_species(list_of_species,species_symbol)

    # how many items do we have?
    number_of_items = length(list_of_species)

    location = -1
    counter = 1
    is_ok_to_stop = false
    while (is_ok_to_stop == false)

        # get symbol =
        test_symbol = list_of_species[counter]
        if (test_symbol == species_symbol)
            is_ok_to_stop = true
            location = counter
        else

            if (counter>=number_of_items)
                is_ok_to_stop = true
            end

            counter = counter + 1
        end
    end

    return location
end

function find_species_in_compartment(list_of_species,compartment_string)

    # initialize -
    index_array = Int64[]

    # main -
    counter = 1
    for species_symbol in list_of_species

        if (contains(species_symbol,compartment_string) == true)
            push!(index_array,counter)
        end

        # update the counter -
        counter = counter + 1
    end

    # return -
    return index_array
end
