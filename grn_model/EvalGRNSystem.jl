

# -------------------------------------------------------------------------
# Script to evaluate the GRN subsystem, and save steady-state expression
# state to disk
#--------------------------------------------------------------------------
function evaluate_steady_state_grn_subsystem(organism::Symbol)

    # Where are we going to save the XSS file?
    path_to_cached_file = "$(pwd())/grn_model/XSS.dat.1"

    # load the dd with the appropriate organism symbol -
    dd = GRNDataDictionary(organism)

    # Test the steady-state estimation routine -
    t = 0.0

    # Get the initial state array -
    state_array = 0
    if (filesize(path_to_cached_file) == 0)
        mRNA_concentration_array = dd["mRNA_concentration_array"]
        protein_concentration_array = dd["protein_concentration_array"]
        state_array = [mRNA_concentration_array ; protein_concentration_array]
    else
        state_array = readdlm(path_to_cached_file)
    end

    # get the system arrays -
    AM = dd["system_dictionary"]["A"]
    BM = dd["system_dictionary"]["B"]
    CM = dd["system_dictionary"]["C"]

    # Run the solver -
    XSS = estimate_discrete_grn_system_steady_state(t,state_array,AM,BM,dd)

    # dump -
    writedlm(path_to_cached_file,XSS)

    # we need to split the expression into mRNA and protein -
    number_of_genes = dd["system_dictionary"]["number_of_genes"]
    number_of_transcripts = dd["system_dictionary"]["number_of_transcripts"]

    # partition -
    ss_mRNA_concentration_array = XSS[1:number_of_genes]
    ss_protein_concentration_array = XSS[(number_of_genes+1):end]

    # return -
    return (ss_mRNA_concentration_array,ss_protein_concentration_array)
end
