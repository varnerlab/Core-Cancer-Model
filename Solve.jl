# include -
include("Include.jl")

# what organism are we going to use?
organismid = :LINE_T_47D

# load the data dictionary -
#data_dictionary = maximize_cellmass_data_dictionary_dipp_experimental(organismid)
#data_dictionary = maximize_cellmass_data_dictionary_dipp_experimental_atra(organismid)
data_dictionary = maximize_cellmass_data_dictionary_dipp(organismid)

# calculate the optimal flux distribution -
(objective_value, calculated_flux_array, dual_value_array, uptake_array, exit_flag, status_flag) = calculate_optimal_flux_distribution(data_dictionary)


# 1,DM_atp_c_,atp[c]+h2o[c],adp[c]+h[c]+pi[c],0,inf
# 2,EX_ala_L(e),ala_L[e],[],0,inf
# 3,EX_arg_L(e),arg_L[e],[],0,inf
# 4,EX_asn_L(e),asn_L[e],[],0,inf
# 5,EX_asp_L(e),asp_L[e],[],0,inf
# 6,EX_chol(e),chol[e],[],-inf,inf
# 7,EX_cit(e),cit[e],[],0,inf
# 8,EX_cl(e),cl[e],[],-inf,inf
# 9,EX_co2(e),co2[e],[],0,inf
# 10,EX_glc(e),glc_D[e],[],0,inf
# 11,EX_gln_L(e),gln_L[e],[],0,inf
# 12,EX_glu_L(e),glu_L[e],[],0,inf
# 13,EX_gly(e),gly[e],[],0,inf
# 14,EX_h(e),h[e],[],-inf,inf
# 15,EX_h2o(e),h2o[e],[],-inf,inf
# 16,EX_ile_L(e),ile_L[e],[],0,inf
# 17,EX_k(e),k[e],[],-inf,inf
# 18,EX_lac_L(e),lac_L[e],[],0,inf
# 19,EX_leu_L(e),leu_L[e],[],0,inf
# 20,EX_lys_L(e),lys_L[e],[],0,inf
# 21,EX_na1(e),na1[e],[],-inf,inf
# 22,EX_nh4(e),nh4[e],[],-inf,inf
# 23,EX_o2(e),o2[e],[],-inf,inf
# 24,EX_orn(e),orn[e],[],0,inf
# 25,EX_phe_L(e),phe_L[e],[],0,inf
# 26,EX_pi(e),pi[e],[],-inf,inf
# 27,EX_pro_L(e),pro_L[e],[],0,inf
# 28,EX_ser_L(e),ser_L[e],[],0,inf
# 29,EX_thr_L(e),thr_L[e],[],0,inf
# 30,EX_trp_L(e),trp_L[e],[],0,inf
# 31,EX_tyr_L(e),tyr_L[e],[],0,inf
# 32,EX_urea(e),urea[e],[],0,inf
# 33,EX_val_L(e),val_L[e],[],0,inf

# lets look at some specific flux values -
idx_data = [1, 2, 3, 10, 11, 18]

# what are my measured values?
measured_flux_array = calculated_flux_array[idx_data]
