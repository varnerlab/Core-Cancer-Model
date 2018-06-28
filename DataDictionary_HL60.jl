function maximize_cellmass_data_dictionary_dipp_experimental_atra(organismid)

    # calculate the DIPP data_dictionary -
    data_dictionary = maximize_cellmass_data_dictionary_dipp(organismid)

    # Update the bounds, using our values -
    exchange_flux_array = [

        "DM_atp_c_"      1.07             1.0   ;
        "EX_ala_L(e)"	 0.005            10.0 ;
        "EX_arg_L(e)"	-0.01             1.0 ;
        "EX_asn_L(e)"	-0.01651081       10.0 ;
        "EX_asp_L(e)"	-0.004154395      10.0 ;
        "EX_chol(e)"	-0.000851349      10.0  ;
        "EX_cit(e)"	    -0.001048267      10.0   ;
        "EX_cl(e)"	     0                1.0    ;
        "EX_co2(e)"	     2.558242542      10.0   ;
        "EX_glc(e)"	    -0.216906385      1.0   ;
        "EX_gln_L(e)"	-0.02             20.0 ;
        "EX_glu_L(e)"	 0.0031           10.0 ;
        "EX_gly(e)"	     -0.0018          10.0   ;
        "EX_h(e)"	     8.858968875      10.0 ;
        "EX_h2o(e)"	    -1.971666594      10.0   ;
        "EX_ile_L(e)"	-0.012471146      10.0 ;
        "EX_k(e)"	     0                1.0 ;
        "EX_lac_L(e)"	 1.03175303       1.0 ;
        "EX_leu_L(e)"	-0.004940638      10.0 ;
        "EX_lys_L(e)"	-0.003548132      10.0 ;
        "EX_na1(e)"	     0                10.0   ;
        "EX_nh4(e)"	     0.377364932      10.0   ;
        "EX_o2(e)"	    -0.468052822      10.0    ;
        "EX_orn(e)"	     0.013272831      10.0   ;
        "EX_phe_L(e)"	-0.008165546      10.0 ;
        "EX_pi(e)"	    -0.016314853      100.0    ;
        "EX_pro_L(e)"	-0.001551575      10.0 ;
        "EX_ser_L(e)"	-0.0079990443     10.0 ;
        "EX_thr_L(e)"	-0.0043192918     10.0 ;
        "EX_trp_L(e)"	-0.001773787      10.0 ;
        "EX_tyr_L(e)"	-0.01016693       10.0 ;
        "EX_urea(e)"	 0.028072828      100.0  ;
        "EX_val_L(e)"	-0.0035015249     10.0 ;
    ]

    list_of_reaction_tags = data_dictionary["cobra_dictionary"]["rxns"]
    default_flux_bounds_array = data_dictionary["default_flux_bounds_array"]

    # update the flux bounds -
    (number_of_exchange_fluxes,cols) = size(exchange_flux_array)
    for exchange_flux_index = 1:number_of_exchange_fluxes

        # get reaction tag and value -
        reaction_tag = exchange_flux_array[exchange_flux_index,1]
        constraint_value = exchange_flux_array[exchange_flux_index,2]
        constraint_uncertainty = exchange_flux_array[exchange_flux_index,3]

        # find reaction index -
        reaction_tag_index = find_index_of_reaction(list_of_reaction_tags,reaction_tag)

        if (constraint_value<0)

            # update the bound -
            default_flux_bounds_array[reaction_tag_index,1] = constraint_value*constraint_uncertainty
            default_flux_bounds_array[reaction_tag_index,2] = constraint_value*(1/constraint_uncertainty)

        else
            # update the bound -
            default_flux_bounds_array[reaction_tag_index,1] = constraint_value*(1/constraint_uncertainty)
            default_flux_bounds_array[reaction_tag_index,2] = constraint_value*(constraint_uncertainty)
        end
    end

    # repack -
    data_dictionary["default_flux_bounds_array"] = default_flux_bounds_array

    # return the modified data dictionary -
    return data_dictionary
end

function maximize_cellmass_data_dictionary_dipp_experimental(organismid)

    # calculate the DIPP data_dictionary -
    data_dictionary = maximize_cellmass_data_dictionary_dipp(organismid)

    # Update the bounds, using our values -
    exchange_flux_array = [

        "DM_atp_c_"      1.07             1.0   ;
        "EX_ala_L(e)"	 0.019221305      10.0 ;
        "EX_arg_L(e)"	-0.048            1.0 ;
        "EX_asn_L(e)"	-0.01651081       10.0 ;
        "EX_asp_L(e)"	-0.004154395      10.0 ;
        "EX_chol(e)"	-0.000851349      10.0  ;
        "EX_cit(e)"	    -0.001048267      10.0   ;
        "EX_cl(e)"	     0                1.0    ;
        "EX_co2(e)"	     2.558242542      10.0   ;
        "EX_glc(e)"	    -0.256906385      1.0   ;
        "EX_gln_L(e)"	-0.048            20.0 ;
        "EX_glu_L(e)"	 0.0031           10.0 ;
        "EX_gly(e)"	     -0.0018          10.0   ;
        "EX_h(e)"	     8.858968875      10.0 ;
        "EX_h2o(e)"	    -1.971666594      10.0   ;
        "EX_ile_L(e)"	-0.012471146      10.0 ;
        "EX_k(e)"	     0                1.0 ;
        "EX_lac_L(e)"	 1.16175303       1.0 ;
        "EX_leu_L(e)"	-0.004940638      10.0 ;
        "EX_lys_L(e)"	-0.003548132      10.0 ;
        "EX_na1(e)"	     0                10.0   ;
        "EX_nh4(e)"	     0.377364932      10.0   ;
        "EX_o2(e)"	    -0.468052822      10.0    ;
        "EX_orn(e)"	     0.013272831      10.0   ;
        "EX_phe_L(e)"	-0.008165546      10.0 ;
        "EX_pi(e)"	    -0.016314853      100.0    ;
        "EX_pro_L(e)"	-0.001551575      10.0 ;
        "EX_ser_L(e)"	-0.0079990443     10.0 ;
        "EX_thr_L(e)"	-0.0043192918     10.0 ;
        "EX_trp_L(e)"	-0.001773787      10.0 ;
        "EX_tyr_L(e)"	-0.01016693       10.0 ;
        "EX_urea(e)"	 0.028072828      100.0  ;
        "EX_val_L(e)"	-0.0035015249     10.0 ;
    ]

    list_of_reaction_tags = data_dictionary["cobra_dictionary"]["rxns"]
    default_flux_bounds_array = data_dictionary["default_flux_bounds_array"]

    # update the flux bounds -
    (number_of_exchange_fluxes,cols) = size(exchange_flux_array)
    for exchange_flux_index = 1:number_of_exchange_fluxes

        # get reaction tag and value -
        reaction_tag = exchange_flux_array[exchange_flux_index,1]
        constraint_value = exchange_flux_array[exchange_flux_index,2]
        constraint_uncertainty = exchange_flux_array[exchange_flux_index,3]

        # find reaction index -
        reaction_tag_index = find_index_of_reaction(list_of_reaction_tags,reaction_tag)

        if (constraint_value<0)

            # update the bound -
            default_flux_bounds_array[reaction_tag_index,1] = constraint_value*constraint_uncertainty
            default_flux_bounds_array[reaction_tag_index,2] = constraint_value*(1/constraint_uncertainty)

        else
            # update the bound -
            default_flux_bounds_array[reaction_tag_index,1] = constraint_value*(1/constraint_uncertainty)
            default_flux_bounds_array[reaction_tag_index,2] = constraint_value*(constraint_uncertainty)
        end
    end

    # repack -
    data_dictionary["default_flux_bounds_array"] = default_flux_bounds_array

    # return the modified data dictionary -
    return data_dictionary
end
