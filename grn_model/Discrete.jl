function evaluate_discrete_grn_system(t,state_array,AM,BM,data_dictionary)

    # ok, evaluate the kinetics at this state -
    rT = calculate_specific_rate_of_transcription(t,state_array,data_dictionary)
    rX = calculate_specific_rate_of_translation(t,state_array,data_dictionary)

    # Call my control function -
    control_array = calculate_transcriptional_control(t,state_array,data_dictionary)

    # build the overall rate vector -
    rV = [rT.*control_array ; rX]

    # @show size(rV),size(AM),size(BM),size(state_array)

    # calculate the new state -
    xnew = AM*state_array+BM*rV

    # compute the error -
    error = norm((xnew - state_array))

    # return -
    return (xnew,error)
end

function estimate_discrete_grn_system_steady_state(t,state_array,AM,BM,data_dictionary)

    # initialize -
    tolerance = 1e-10
    is_ok_to_stop = 0

    # what is the old state?
    old_state_array = state_array
    steady_state_array = state_array

    # main loop -
    while (is_ok_to_stop == 0)

        # calculate -
        (new_state_array, error) = evaluate_discrete_grn_system(t,old_state_array,AM,BM,data_dictionary)

        @show error

        if (error<=tolerance)
            is_ok_to_stop = 1
            steady_state_array = new_state_array
        else
            old_state_array = new_state_array
        end
    end

    # return -
    return steady_state_array
end

function generate_discrete_grn_system(biophysical_data_dictionary,number_of_genes,number_of_transcripts,time_step_size)

    # compute degradation rate constants -
    mRNA_half_life_TF = parse(Float64,biophysical_data_dictionary["mRNA_half_life_TF"]["value"])
    protein_half_life = parse(Float64,biophysical_data_dictionary["protein_half_life"]["value"])
    doubling_time_cell = parse(Float64,biophysical_data_dictionary["cell_doubling_time"]["value"])

    kDM = -(1/mRNA_half_life_TF)*log(e,0.5)                        # hr^-1
    kDP = -(1/protein_half_life)*log(e,0.5)                        # hr^-1
    mugmax = (1/doubling_time_cell)*log(e,2)                       # hr^-1

    # compute the S matrix -
    number_of_cols = number_of_genes+number_of_transcripts
    SM = eye(number_of_cols,number_of_cols)

    # -- Compute AHAT ----------------------------------------------------------- %
    # Dilution and degrdation terms (we need for A matrix)
    mRNA_delta = (kDM+mugmax)
    P_delta = (kDP+mugmax)
    AM = -1*eye(number_of_cols,number_of_cols)

    # mRNA -
    for index = 1:number_of_genes
        AM[index,index] = mRNA_delta*AM[index,index]
    end

    # protein -
    for index = (number_of_genes+1):(number_of_cols)
        AM[index,index] = P_delta*AM[index,index]
    end

    # Compute AHAT -
    AHAT = expm(AM*time_step_size)
    # --------------------------------------------------------------------------- %

    # -- Compute BHAT ----------------------------------------------------------- %
    IM = eye(number_of_cols,number_of_cols)
    BHAT = (AHAT - IM)*inv(AM)*SM
    # --------------------------------------------------------------------------- %

    # -- Compute DHAT ----------------------------------------------------------- %
    CHAT = inv((IM - AHAT))
    # --------------------------------------------------------------------------- %

    return (AHAT,BHAT,CHAT)
end
