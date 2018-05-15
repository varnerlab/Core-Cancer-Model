function gene_association_rules(state_array,data_dictionary)

	 # initialize the v array
	 v = ones(381)

	 # 34 -> 89874.1;
	 v[34] =  state_array[1922]

	 # 35 -> (((1738.1 and 8050.1) and 1743.1 and 4967.1) or ((1738.1 and 8050.1) and 1743.1 and 4967.2));
	 v[35] =  maximum([ minimum([ state_array[347]  state_array[1047]  minimum([ state_array[346]  state_array[1764] ])]) minimum([ state_array[347]  state_array[1048]  minimum([ state_array[346]  state_array[1764] ])])])

	 # 36 -> 89874.1;
	 v[36] =  state_array[1922]

	 # 37 -> 3242.1;
	 v[37] =  state_array[814]

	 # 38 -> 2531.1;
	 v[38] =  state_array[552]

	 # 39 -> 23498.1;
	 v[39] =  state_array[511]

	 # 44 -> 65985.1;
	 v[44] =  state_array[1597]

	 # 46 -> (51166.1 or 51166.2);
	 v[46] =  maximum([ state_array[1096]  state_array[1097] ])

	 # 47 -> 39.1;
	 v[47] =  state_array[886]

	 # 48 -> 38.1;
	 v[48] =  state_array[881]

	 # 49 -> ((3030.1 and 3032.1) or 38.1);
	 v[49] =  maximum([ minimum([ state_array[769]  state_array[770] ]) state_array[881] ])

	 # 50 -> 6566.1;
	 v[50] =  state_array[1578]

	 # 51 -> (31.2 or 31.4 or 31.1 or 31.3 or 31.5 or (31.2 and 32.1) or (31.3 and 32.1) or (31.4 and 32.1) or (31.5 and 32.1) or (31.1 and 32.1));
	 v[51] =  maximum([ state_array[791]  state_array[793]  state_array[790]  state_array[792]  state_array[794]  minimum([ state_array[791]  state_array[813] ]) minimum([ state_array[792]  state_array[813] ]) minimum([ state_array[793]  state_array[813] ]) minimum([ state_array[794]  state_array[813] ]) minimum([ state_array[790]  state_array[813] ])])

	 # 52 -> (47.1 or 47.2);
	 v[52] =  maximum([ state_array[976]  state_array[977] ])

	 # 53 -> (36.1 or 34.1);
	 v[53] =  maximum([ state_array[849]  state_array[828] ])

	 # 54 -> 3712.1;
	 v[54] =  state_array[870]

	 # 55 -> (34.1 or 27034.1);
	 v[55] =  maximum([ state_array[828]  state_array[641] ])

	 # 56 -> 50.1;
	 v[56] =  state_array[1049]

	 # 57 -> 788.1;
	 v[57] =  state_array[1710]

	 # 58 -> (203.1 or 26289.2 or 26289.1 or 122481.1);
	 v[58] =  maximum([ state_array[411]  state_array[608]  state_array[607]  state_array[177] ])

	 # 59 -> (26289.1 or 26289.2);
	 v[59] =  maximum([ state_array[607]  state_array[608] ])

	 # 61 -> (158.1 or 158.2);
	 v[61] =  maximum([ state_array[286]  state_array[287] ])

	 # 62 -> (158.1 or 158.2);
	 v[62] =  maximum([ state_array[286]  state_array[287] ])

	 # 63 -> (159.1 or 122622.2 or 122622.1);
	 v[63] =  maximum([ state_array[298]  state_array[179]  state_array[178] ])

	 # 64 -> (56895.1 or 55326.1 or 56894.2 or 137964.1 or 10554.1 or 10555.1 or 56894.1);
	 v[64] =  maximum([ state_array[1377]  state_array[1334]  state_array[1376]  state_array[245]  state_array[48]  state_array[49]  state_array[1375] ])

	 # 65 -> 471.1;
	 v[65] =  state_array[987]

	 # 66 -> 10606.1;
	 v[66] =  state_array[59]

	 # 67 -> (((1738.1 and 8050.1) and 1743.1 and 4967.1) or ((1738.1 and 8050.1) and 1743.1 and 4967.2));
	 v[67] =  maximum([ minimum([ state_array[347]  state_array[1047]  minimum([ state_array[346]  state_array[1764] ])]) minimum([ state_array[347]  state_array[1048]  minimum([ state_array[346]  state_array[1764] ])])])

	 # 68 -> 8402.1;
	 v[68] =  state_array[1801]

	 # 69 -> (2875.1 or 84706.1);
	 v[69] =  maximum([ state_array[711]  state_array[1819] ])

	 # 70 -> 206358.1;
	 v[70] =  state_array[422]

	 # 73 -> 384.1;
	 v[73] =  state_array[883]

	 # 74 -> 435.1;
	 v[74] =  state_array[938]

	 # 75 -> (445.1 or 445.2);
	 v[75] =  maximum([ state_array[948]  state_array[949] ])

	 # 76 -> 11254.1;
	 v[76] =  state_array[128]

	 # 77 -> (83884.1 or 10166.1);
	 v[77] =  maximum([ state_array[1792]  state_array[16] ])

	 # 83 -> 80150.1;
	 v[83] =  state_array[1752]

	 # 84 -> (440.1 or 440.2 or 440.3);
	 v[84] =  maximum([ state_array[944]  state_array[945]  state_array[946] ])

	 # 85 -> (11254.1 or 55089.1 or 54407.1 or 81539.1);
	 v[85] =  maximum([ state_array[128]  state_array[1321]  state_array[1290]  state_array[1773] ])

	 # 87 -> 790.1;
	 v[87] =  state_array[1711]

	 # 88 -> (8604.1 or 10165.1);
	 v[88] =  maximum([ state_array[1851]  state_array[15] ])

	 # 89 -> 2805.1;
	 v[89] =  state_array[693]

	 # 90 -> 2806.1;
	 v[90] =  state_array[694]

	 # 91 -> (6505.1 or 6506.1 or 6507.1 or 6511.1 or 6512.1);
	 v[91] =  maximum([ state_array[1517]  state_array[1518]  state_array[1519]  state_array[1524]  state_array[1525] ])

	 # 92 -> (291.1 or 292.1 or 293.1);
	 v[92] =  maximum([ state_array[724]  state_array[726]  state_array[727] ])

	 # 94 -> 7108.1;
	 v[94] =  state_array[1647]

	 # 95 -> 50814.1;
	 v[95] =  state_array[1073]

	 # 96 -> 3295.1;
	 v[96] =  state_array[824]

	 # 97 -> 6307.1;
	 v[97] =  state_array[1454]

	 # 98 -> 50814.1;
	 v[98] =  state_array[1073]

	 # 99 -> 790.1;
	 v[99] =  state_array[1711]

	 # 100 -> (1373.1 or 1373.2);
	 v[100] =  maximum([ state_array[236]  state_array[237] ])

	 # 101 -> (10423.2 or 10423.1);
	 v[101] =  maximum([ state_array[45]  state_array[44] ])

	 # 102 -> 1040.1;
	 v[102] =  state_array[39]

	 # 103 -> (10390.1 or 56994.1);
	 v[103] =  maximum([ state_array[37]  state_array[1383] ])

	 # 104 -> (5130.1 or 9468.1);
	 v[104] =  maximum([ state_array[1109]  state_array[1981] ])

	 # 105 -> (1119.1 or 1119.2 or 1120.1 or 1120.2);
	 v[105] =  maximum([ state_array[116]  state_array[117]  state_array[120]  state_array[121] ])

	 # 106 -> 60482.1;
	 v[106] =  state_array[1440]

	 # 107 -> 9058.1;
	 v[107] =  state_array[1933]

	 # 108 -> 6576.1;
	 v[108] =  state_array[1588]

	 # 109 -> (65010.1 or 65010.2 or 65010.3);
	 v[109] =  maximum([ state_array[1514]  state_array[1515]  state_array[1516] ])

	 # 110 -> 54675.1;
	 v[110] =  state_array[1305]

	 # 117 -> 788.1;
	 v[117] =  state_array[1710]

	 # 119 -> 1384.1;
	 v[119] =  state_array[246]

	 # 120 -> (1431.1 or 1431.2);
	 v[120] =  maximum([ state_array[251]  state_array[252] ])

	 # 121 -> (56474.1 or 56474.2);
	 v[121] =  maximum([ state_array[1367]  state_array[1368] ])

	 # 122 -> 51727.1;
	 v[122] =  state_array[1182]

	 # 123 -> 6319.1;
	 v[123] =  state_array[1456]

	 # 124 -> 6319.1;
	 v[124] =  state_array[1456]

	 # 125 -> 1718.1;
	 v[125] =  state_array[341]

	 # 126 -> 1717.1;
	 v[126] =  state_array[340]

	 # 127 -> (8560.1 or 8560.2);
	 v[127] =  maximum([ state_array[1846]  state_array[1847] ])

	 # 128 -> 1719.1;
	 v[128] =  state_array[342]

	 # 129 -> 1723.1;
	 v[129] =  state_array[343]

	 # 130 -> 790.1;
	 v[130] =  state_array[1711]

	 # 131 -> 5860.1;
	 v[131] =  state_array[1429]

	 # 132 -> 2224.1;
	 v[132] =  state_array[458]

	 # 133 -> 4597.1;
	 v[133] =  state_array[966]

	 # 135 -> 1841.1;
	 v[135] =  state_array[382]

	 # 136 -> 10682.1;
	 v[136] =  state_array[65]

	 # 137 -> (1892.1 or (3030.1 and 3032.1));
	 v[137] =  maximum([ state_array[387]  minimum([ state_array[769]  state_array[770] ])])

	 # 138 -> (549.1 or 1892.1 or (3030.1 and 3032.1));
	 v[138] =  maximum([ state_array[1313]  state_array[387]  minimum([ state_array[769]  state_array[770] ])])

	 # 139 -> (1892.1 or (3030.1 and 3032.1));
	 v[139] =  maximum([ state_array[387]  minimum([ state_array[769]  state_array[770] ])])

	 # 140 -> (2027.1 or 2027.2 or 26237.1 or 2023.1 or 2026.1);
	 v[140] =  maximum([ state_array[409]  state_array[410]  state_array[601]  state_array[407]  state_array[408] ])

	 # 141 -> ((2108.1 and 2109.2) or (2108.1 and 2109.1));
	 v[141] =  maximum([ minimum([ state_array[426]  state_array[428] ]) minimum([ state_array[426]  state_array[427] ])])

	 # 142 -> 2110.1;
	 v[142] =  state_array[431]

	 # 143 -> (51703.1 or 2180.1 or 22305.1 or 22305.2 or 2181.1 or 2181.2);
	 v[143] =  maximum([ state_array[1179]  state_array[444]  state_array[461]  state_array[462]  state_array[445]  state_array[446] ])

	 # 144 -> 2180.1;
	 v[144] =  state_array[444]

	 # 147 -> 2194.1;
	 v[147] =  state_array[450]

	 # 148 -> (226.1 or 230.1 or 226.3 or 226.2 or 229.1);
	 v[148] =  maximum([ state_array[467]  state_array[477]  state_array[469]  state_array[468]  state_array[472] ])

	 # 149 -> 10840.1;
	 v[149] =  state_array[75]

	 # 153 -> 10840.1;
	 v[153] =  state_array[75]

	 # 154 -> 2184.1;
	 v[154] =  state_array[448]

	 # 155 -> 2271.1;
	 v[155] =  state_array[470]

	 # 156 -> 1468.1;
	 v[156] =  state_array[255]

	 # 157 -> 2819.1;
	 v[157] =  state_array[695]

	 # 159 -> 5832.1;
	 v[159] =  state_array[1419]

	 # 160 -> 2539.1;
	 v[160] =  state_array[555]

	 # 161 -> (7360.1 or 7360.2 or 7359.1);
	 v[161] =  maximum([ state_array[1676]  state_array[1677]  state_array[1675] ])

	 # 162 -> (2597.1 or 26330.1);
	 v[162] =  maximum([ state_array[588]  state_array[617] ])

	 # 163 -> (2618.1 or 2618.2);
	 v[163] =  maximum([ state_array[596]  state_array[597] ])

	 # 164 -> (275.1 and 1738.1 and 2653.1 and 2731.1);
	 v[164] =  minimum([ state_array[681]  state_array[346]  state_array[627]  state_array[671] ])

	 # 165 -> (275.1 and 1738.1 and 2653.1 and 2731.1);
	 v[165] =  minimum([ state_array[681]  state_array[346]  state_array[627]  state_array[671] ])

	 # 166 -> (275.1 and 1738.1 and 2653.1 and 2731.1);
	 v[166] =  minimum([ state_array[681]  state_array[346]  state_array[627]  state_array[671] ])

	 # 167 -> ((2992.1 and 2998.1) or (8908.1 and 2997.1) or (2992.1 and 2997.1) or (8908.1 and 2998.1));
	 v[167] =  maximum([ minimum([ state_array[748]  state_array[762] ]) minimum([ state_array[1916]  state_array[761] ]) minimum([ state_array[748]  state_array[761] ]) minimum([ state_array[1916]  state_array[762] ])])

	 # 168 -> (6470.1 or 6470.2);
	 v[168] =  maximum([ state_array[1477]  state_array[1478] ])

	 # 169 -> 2987.1;
	 v[169] =  state_array[744]

	 # 170 -> 2632.1;
	 v[170] =  state_array[616]

	 # 171 -> (155184.1 or 29988.1 or 56606.1 or 56606.2 or 81031.1 or 66035.1 or 154091.1 or 6514.1 or 6513.1 or 6515.1 or 6517.1 or 11182.1 or 144195.1);
	 v[171] =  maximum([ state_array[269]  state_array[763]  state_array[1371]  state_array[1372]  state_array[1769]  state_array[1599]  state_array[262]  state_array[1527]  state_array[1526]  state_array[1528]  state_array[1529]  state_array[114]  state_array[253] ])

	 # 172 -> ((2992.1 and 2998.1) or (8908.1 and 2998.1) or (2992.1 and 2997.1) or (8908.1 and 2997.1));
	 v[172] =  maximum([ minimum([ state_array[748]  state_array[762] ]) minimum([ state_array[1916]  state_array[762] ]) minimum([ state_array[748]  state_array[761] ]) minimum([ state_array[1916]  state_array[761] ])])

	 # 173 -> (11254.1 or 55089.1 or 54407.1 or 81539.1);
	 v[173] =  maximum([ state_array[128]  state_array[1321]  state_array[1290]  state_array[1773] ])

	 # 175 -> 5832.1;
	 v[175] =  state_array[1419]

	 # 176 -> (2747.1 or 2746.1);
	 v[176] =  maximum([ state_array[680]  state_array[679] ])

	 # 177 -> (2747.1 or 2746.1);
	 v[177] =  maximum([ state_array[680]  state_array[679] ])

	 # 178 -> (2744.1 or 27165.1 or 27165.2);
	 v[178] =  maximum([ state_array[677]  state_array[661]  state_array[662] ])

	 # 179 -> 5471.1;
	 v[179] =  state_array[1308]

	 # 180 -> (2639.1 or 2639.2);
	 v[180] =  maximum([ state_array[618]  state_array[619] ])

	 # 181 -> (57084.1 or 57030.1 or 246213.1);
	 v[181] =  maximum([ state_array[1387]  state_array[1386]  state_array[535] ])

	 # 182 -> (8604.1 or 10165.1 or 79751.1 or 83733.1);
	 v[182] =  maximum([ state_array[1851]  state_array[15]  state_array[1731]  state_array[1790] ])

	 # 183 -> (6505.1 or 6506.1 or 6507.1 or 6511.1 or 6512.1);
	 v[183] =  maximum([ state_array[1517]  state_array[1518]  state_array[1519]  state_array[1524]  state_array[1525] ])

	 # 184 -> 2628.1;
	 v[184] =  state_array[606]

	 # 185 -> 23464.1;
	 v[185] =  state_array[501]

	 # 186 -> 206358.1;
	 v[186] =  state_array[422]

	 # 187 -> (11254.1 or 55089.1 or 54407.1 or 81539.1);
	 v[187] =  maximum([ state_array[128]  state_array[1321]  state_array[1290]  state_array[1773] ])

	 # 189 -> 8833.1;
	 v[189] =  state_array[1897]

	 # 190 -> 57678.1;
	 v[190] =  state_array[1406]

	 # 191 -> 2224.1;
	 v[191] =  state_array[458]

	 # 192 -> (761.1) or (771.1) or (377677.1) or (762.1) or (766.2) or (23632.1) or (766.1) or (771.2) or (759.1) or (768.1) or (760.1);
	 v[192] =  maximum([ state_array[1699]  state_array[1707]  state_array[877]  state_array[1700]  state_array[1704]  state_array[525]  state_array[1703]  state_array[1708]  state_array[1697]  state_array[1706]  state_array[1698] ])

	 # 194 -> 6523.1;
	 v[194] =  state_array[1536]

	 # 196 -> 343.1;
	 v[196] =  state_array[842]

	 # 198 -> (3028.1 or (3030.1 and 3032.1) or 3033.1);
	 v[198] =  maximum([ state_array[767]  minimum([ state_array[769]  state_array[770] ]) state_array[771] ])

	 # 199 -> 3028.1;
	 v[199] =  state_array[767]

	 # 201 -> 9497.1;
	 v[201] =  state_array[1987]

	 # 202 -> (2645.1 or 2645.2 or 2645.3 or 3098.1 or 3098.2 or 3098.3 or 3098.4 or 3098.5 or 3099.1 or 3101.1 or 80201.1);
	 v[202] =  maximum([ state_array[621]  state_array[622]  state_array[623]  state_array[784]  state_array[785]  state_array[786]  state_array[787]  state_array[788]  state_array[789]  state_array[795]  state_array[1755] ])

	 # 203 -> 3081.1;
	 v[203] =  state_array[780]

	 # 204 -> 11112.1;
	 v[204] =  state_array[109]

	 # 205 -> 8942.1;
	 v[205] =  state_array[1917]

	 # 206 -> 3156.1;
	 v[206] =  state_array[801]

	 # 207 -> (3157.2 or 3157.1);
	 v[207] =  maximum([ state_array[803]  state_array[802] ])

	 # 209 -> (3155.1 or 54511.1);
	 v[209] =  maximum([ state_array[800]  state_array[1293] ])

	 # 210 -> (7352.1 or 7350.1 or 7351.1 or 7352.2 or 9481.1 or 9016.1 or 9016.2);
	 v[210] =  maximum([ state_array[1670]  state_array[1668]  state_array[1669]  state_array[1671]  state_array[1983]  state_array[1924]  state_array[1925] ])

	 # 213 -> ((3419.1 and 3420.1 and 3421.1) or (3419.1 and 3420.2 and 3421.1) or (3419.1 and 3420.3 and 3421.1) or (3419.1 and 3420.1 and 3421.1) or (3419.1 and 3420.2 and 3421.2) or (3419.1 and 3420.3 and 3421.2));
	 v[213] =  maximum([ minimum([ state_array[831]  state_array[833]  state_array[836] ]) minimum([ state_array[831]  state_array[834]  state_array[836] ]) minimum([ state_array[831]  state_array[835]  state_array[836] ]) minimum([ state_array[831]  state_array[833]  state_array[836] ]) minimum([ state_array[831]  state_array[834]  state_array[837] ]) minimum([ state_array[831]  state_array[835]  state_array[837] ])])

	 # 214 -> 3418.1;
	 v[214] =  state_array[830]

	 # 215 -> 586.1;
	 v[215] =  state_array[1428]

	 # 216 -> 11254.1;
	 v[216] =  state_array[128]

	 # 217 -> 471.1;
	 v[217] =  state_array[987]

	 # 218 -> (3614.1 or 3614.2 or 3615.1);
	 v[218] =  maximum([ state_array[852]  state_array[853]  state_array[854] ])

	 # 219 -> (3422.1 or 91734.1);
	 v[219] =  maximum([ state_array[838]  state_array[1948] ])

	 # 220 -> 2194.1;
	 v[220] =  state_array[450]

	 # 221 -> (57468.1 or 6560.1 or 9990.1 or 10723.1);
	 v[221] =  maximum([ state_array[1403]  state_array[1573]  state_array[2033]  state_array[69] ])

	 # 222 -> 8564.1;
	 v[222] =  state_array[1848]

	 # 223 -> (6566.1 or 9194.1 or 23539.1 or 9123.1);
	 v[223] =  maximum([ state_array[1578]  state_array[1950]  state_array[516]  state_array[1939] ])

	 # 224 -> (3939.1 or 3945.1 or 3948.1 or 3948.2 or 92483.1 or 160287.1 or 55293.1 or (3939.1 and 3945.1));
	 v[224] =  maximum([ state_array[890]  state_array[891]  state_array[892]  state_array[893]  state_array[1955]  state_array[305]  state_array[1330]  minimum([ state_array[890]  state_array[891] ])])

	 # 225 -> 586.1;
	 v[225] =  state_array[1428]

	 # 226 -> (11254.1 or 6520.1 or 55089.1 or 81539.1 or 6541.1 or 6542.1 or 84889.1);
	 v[226] =  maximum([ state_array[128]  state_array[1532]  state_array[1321]  state_array[1773]  state_array[1554]  state_array[1555]  state_array[1825] ])

	 # 227 -> 1595.1;
	 v[227] =  state_array[303]

	 # 228 -> 4047.1;
	 v[228] =  state_array[901]

	 # 229 -> 4023.1;
	 v[229] =  state_array[899]

	 # 230 -> 6309.1;
	 v[230] =  state_array[1455]

	 # 231 -> (11254.1 or 6584.1);
	 v[231] =  maximum([ state_array[128]  state_array[1596] ])

	 # 232 -> (83884.1 or 10166.1);
	 v[232] =  maximum([ state_array[1792]  state_array[16] ])

	 # 233 -> (2954.1 or 2954.2 or 2954.3);
	 v[233] =  maximum([ state_array[732]  state_array[733]  state_array[734] ])

	 # 234 -> (56922.1 and 64087.1);
	 v[234] =  minimum([ state_array[1380]  state_array[1464] ])

	 # 235 -> (130752.1 or 4190.1);
	 v[235] =  maximum([ state_array[210]  state_array[922] ])

	 # 236 -> 4191.1;
	 v[236] =  state_array[923]

	 # 237 -> 4199.1;
	 v[237] =  state_array[924]

	 # 238 -> (4200.1 or 10873.1);
	 v[238] =  maximum([ state_array[925]  state_array[84] ])

	 # 239 -> 4598.1;
	 v[239] =  state_array[967]

	 # 240 -> 549.1;
	 v[240] =  state_array[1313]

	 # 241 -> (3612.1 or 3613.1);
	 v[241] =  maximum([ state_array[850]  state_array[851] ])

	 # 242 -> 51477.1;
	 v[242] =  state_array[1134]

	 # 243 -> 84693.1;
	 v[243] =  state_array[1816]

	 # 244 -> 4594.1;
	 v[244] =  state_array[965]

	 # 246 -> (4522.1 or 80068.1 or 285216.1);
	 v[246] =  maximum([ state_array[955]  state_array[1746]  state_array[707] ])

	 # 247 -> (25902.1 or 10797.1);
	 v[247] =  maximum([ state_array[579]  state_array[73] ])

	 # 248 -> 4522.1;
	 v[248] =  state_array[955]

	 # 249 -> 10797.1;
	 v[249] =  state_array[73]

	 # 254 -> (6526.1 or 6528.1 or 6523.1);
	 v[254] =  maximum([ state_array[1538]  state_array[1540]  state_array[1536] ])

	 # 255 -> (6549.1 or 6550.1 or 389015.1 or 6553.1 or 6548.1);
	 v[255] =  maximum([ state_array[1565]  state_array[1566]  state_array[885]  state_array[1567]  state_array[1564] ])

	 # 256 -> 1841.1;
	 v[256] =  state_array[382]

	 # 257 -> ((4830.1 and 4831.1) or (4830.2 and 4831.1) or 4832.1 or 29922.2 or 10201.1 or 29922.1);
	 v[257] =  maximum([ minimum([ state_array[1019]  state_array[1021] ]) minimum([ state_array[1020]  state_array[1021] ]) state_array[1022]  state_array[751]  state_array[21]  state_array[750] ])

	 # 258 -> 4833.1;
	 v[258] =  state_array[1023]

	 # 259 -> ((4830.1 and 4831.1) or (4830.2 and 4831.1) or 4832.1 or 10201.1 or 29922.1 or 29922.2);
	 v[259] =  maximum([ minimum([ state_array[1019]  state_array[1021] ]) minimum([ state_array[1020]  state_array[1021] ]) state_array[1022]  state_array[21]  state_array[750]  state_array[751] ])

	 # 260 -> ((4830.1 and 4831.1) or (4830.2 and 4831.1) or 4832.1 or 10201.1 or 29922.1 or 29922.2);
	 v[260] =  maximum([ minimum([ state_array[1019]  state_array[1021] ]) minimum([ state_array[1020]  state_array[1021] ]) state_array[1022]  state_array[21]  state_array[750]  state_array[751] ])

	 # 261 -> ((4830.1 and 4831.1) or (4830.2 and 4831.1) or 4832.1 or 10201.1 or 29922.1 or 29922.2);
	 v[261] =  maximum([ minimum([ state_array[1019]  state_array[1021] ]) minimum([ state_array[1020]  state_array[1021] ]) state_array[1022]  state_array[21]  state_array[750]  state_array[751] ])

	 # 262 -> ((4830.2 and 4831.1) or (4830.1 and 4831.1) or 4832.1 or 10201.1 or 29922.1 or 29922.2);
	 v[262] =  maximum([ minimum([ state_array[1020]  state_array[1021] ]) minimum([ state_array[1019]  state_array[1021] ]) state_array[1022]  state_array[21]  state_array[750]  state_array[751] ])

	 # 263 -> ((4830.1 and 4831.1) or (4830.2 and 4831.1) or 4832.1 or 10201.1 or 29922.1 or 29922.2);
	 v[263] =  maximum([ minimum([ state_array[1019]  state_array[1021] ]) minimum([ state_array[1020]  state_array[1021] ]) state_array[1022]  state_array[21]  state_array[750]  state_array[751] ])

	 # 264 -> ((4830.1 and 4831.1) or (4830.2 and 4831.1) or 4832.1 or 10201.1 or 29922.1 or 29922.2);
	 v[264] =  maximum([ minimum([ state_array[1019]  state_array[1021] ]) minimum([ state_array[1020]  state_array[1021] ]) state_array[1022]  state_array[21]  state_array[750]  state_array[751] ])

	 # 265 -> (6557.1 or 6558.1);
	 v[265] =  maximum([ state_array[1570]  state_array[1571] ])

	 # 266 -> (6557.1 or 6558.1);
	 v[266] =  maximum([ state_array[1570]  state_array[1571] ])

	 # 267 -> ((481.1 and 478.1) or (477.1 and 23439.1) or (483.1 and 476.1) or (481.1 and 480.1) or (482.1 and 478.1) or (482.1 and 476.1) or (482.1 and 477.1) or (481.1 and 476.1) or (23439.1 and 476.1) or (480.1 and 23439.1) or (481.1 and 477.1));
	 v[267] =  maximum([ minimum([ state_array[1016]  state_array[1013] ]) minimum([ state_array[1012]  state_array[499] ]) minimum([ state_array[1018]  state_array[1011] ]) minimum([ state_array[1016]  state_array[1015] ]) minimum([ state_array[1017]  state_array[1013] ]) minimum([ state_array[1017]  state_array[1011] ]) minimum([ state_array[1017]  state_array[1012] ]) minimum([ state_array[1016]  state_array[1011] ]) minimum([ state_array[499]  state_array[1011] ]) minimum([ state_array[1015]  state_array[499] ]) minimum([ state_array[1016]  state_array[1012] ])])

	 # 272 -> 5009.1;
	 v[272] =  state_array[1050]

	 # 273 -> (((593.1 and 594.1) and 1629.1 and 1738.1) or ((593.1 and 594.2) and 1629.1 and 1738.1));
	 v[273] =  maximum([ minimum([ state_array[320]  state_array[346]  minimum([ state_array[1432]  state_array[1433] ])]) minimum([ state_array[320]  state_array[346]  minimum([ state_array[1432]  state_array[1434] ])])])

	 # 274 -> (((593.1 and 594.1) and 1629.1 and 1738.1) or ((593.1 and 594.2) and 1629.1 and 1738.1));
	 v[274] =  maximum([ minimum([ minimum([ state_array[1432]  state_array[1433] ]) state_array[320]  state_array[346] ]) minimum([ minimum([ state_array[1432]  state_array[1434] ]) state_array[320]  state_array[346] ])])

	 # 275 -> (((593.1 and 594.1) and 1629.1 and 1738.1) or ((593.1 and 594.2) and 1629.1 and 1738.1));
	 v[275] =  maximum([ minimum([ minimum([ state_array[1432]  state_array[1433] ]) state_array[320]  state_array[346] ]) minimum([ minimum([ state_array[1432]  state_array[1434] ]) state_array[320]  state_array[346] ])])

	 # 276 -> 7372.1;
	 v[276] =  state_array[1685]

	 # 277 -> 4942.1;
	 v[277] =  state_array[1041]

	 # 278 -> (83884.1 or 10166.1);
	 v[278] =  maximum([ state_array[1792]  state_array[16] ])

	 # 279 -> (10166.1 or 83884.1);
	 v[279] =  maximum([ state_array[16]  state_array[1792] ])

	 # 280 -> (6541.1 or 6542.1 or 84889.1);
	 v[280] =  maximum([ state_array[1554]  state_array[1555]  state_array[1825] ])

	 # 281 -> 7372.1;
	 v[281] =  state_array[1685]

	 # 282 -> (8659.1 or 8659.2);
	 v[282] =  maximum([ state_array[1863]  state_array[1864] ])

	 # 283 -> (5831.1 or 5831.2);
	 v[283] =  maximum([ state_array[1417]  state_array[1418] ])

	 # 284 -> 130013.1;
	 v[284] =  state_array[208]

	 # 285 -> (5091.1 or 5091.2);
	 v[285] =  maximum([ state_array[1074]  state_array[1075] ])

	 # 286 -> ((1737.1 and (1738.1 and 8050.1) and (5161.1 and 5162.1)) or (1737.1 and (1738.1 and 8050.1) and (5160.1 and 5162.1)));
	 v[286] =  maximum([ minimum([ state_array[345]  minimum([ state_array[346]  state_array[1764] ]) minimum([ state_array[1174]  state_array[1175] ])]) minimum([ state_array[345]  minimum([ state_array[346]  state_array[1764] ]) minimum([ state_array[1169]  state_array[1175] ])])])

	 # 288 -> (5211.1 or 5213.1 or 5211.2 or (5211.1 and 5213.1) or (5211.2 and 5213.1) or 5214.1 or (5211.1 and 5214.1) or (5211.2 and 5214.1) or (5213.1 and 5214.1));
	 v[288] =  maximum([ state_array[1195]  state_array[1197]  state_array[1196]  minimum([ state_array[1195]  state_array[1197] ]) minimum([ state_array[1196]  state_array[1197] ]) state_array[1198]  minimum([ state_array[1195]  state_array[1198] ]) minimum([ state_array[1196]  state_array[1198] ]) minimum([ state_array[1197]  state_array[1198] ])])

	 # 289 -> 26227.1;
	 v[289] =  state_array[599]

	 # 290 -> 2821.1;
	 v[290] =  state_array[697]

	 # 291 -> (5230.1 or 5232.1 or 348477.1);
	 v[291] =  maximum([ state_array[1204]  state_array[1205]  state_array[844] ])

	 # 292 -> 25796.1;
	 v[292] =  state_array[566]

	 # 293 -> (5223.1 or 5224.1 or 5224.2 or 669.1 or 669.2);
	 v[293] =  maximum([ state_array[1199]  state_array[1200]  state_array[1201]  state_array[1607]  state_array[1608] ])

	 # 294 -> (5236.1 or 55276.1);
	 v[294] =  maximum([ state_array[1206]  state_array[1329] ])

	 # 295 -> 9489.1;
	 v[295] =  state_array[1986]

	 # 297 -> 5053.1;
	 v[297] =  state_array[1066]

	 # 298 -> (11254.1 or 55089.1 or 54407.1 or 81539.1 or 6541.1 or 6542.1 or 84889.1);
	 v[298] =  maximum([ state_array[128]  state_array[1321]  state_array[1290]  state_array[1773]  state_array[1554]  state_array[1555]  state_array[1825] ])

	 # 300 -> (6574.1 or 6575.1);
	 v[300] =  maximum([ state_array[1586]  state_array[1587] ])

	 # 302 -> (8398.1 or 8398.2 or 5320.1);
	 v[302] =  maximum([ state_array[1797]  state_array[1798]  state_array[1247] ])

	 # 303 -> 10654.1;
	 v[303] =  state_array[62]

	 # 304 -> 5464.1;
	 v[304] =  state_array[1301]

	 # 305 -> (8611.1 or 8611.2 or 8613.1 or 8612.1);
	 v[305] =  maximum([ state_array[1853]  state_array[1854]  state_array[1856]  state_array[1855] ])

	 # 306 -> (5095.1 and 5096.1);
	 v[306] =  minimum([ state_array[1079]  state_array[1080] ])

	 # 309 -> (2618.1 or 2618.2);
	 v[309] =  maximum([ state_array[596]  state_array[597] ])

	 # 310 -> (2618.1 or 2618.2);
	 v[310] =  maximum([ state_array[596]  state_array[597] ])

	 # 311 -> 10606.1;
	 v[311] =  state_array[59]

	 # 312 -> 5198.1;
	 v[312] =  state_array[1187]

	 # 313 -> 206358.1;
	 v[313] =  state_array[422]

	 # 314 -> (55089.1 or 54407.1 or 81539.1);
	 v[314] =  maximum([ state_array[1321]  state_array[1290]  state_array[1773] ])

	 # 316 -> (5631.1 or 5634.1 or 221823.1 or 221823.2);
	 v[316] =  maximum([ state_array[1365]  state_array[1366]  state_array[454]  state_array[455] ])

	 # 317 -> 23761.1;
	 v[317] =  state_array[528]

	 # 318 -> (29968.1) or (29968.2);
	 v[318] =  maximum([ state_array[759]  state_array[760] ])

	 # 319 -> (10396.1 or 57194.1);
	 v[319] =  maximum([ state_array[38]  state_array[1392] ])

	 # 320 -> (8781.1) or (5723.1);
	 v[320] =  maximum([ state_array[1885]  state_array[1393] ])

	 # 321 -> 9791.1;
	 v[321] =  state_array[2012]

	 # 322 -> (5313.1 or 5313.2 or 5315.1 or 5315.2 or 5315.3 or 113452.1);
	 v[322] =  maximum([ state_array[1241]  state_array[1242]  state_array[1243]  state_array[1244]  state_array[1245]  state_array[145] ])

	 # 323 -> 6566.1;
	 v[323] =  state_array[1578]

	 # 324 -> (6240.1 and 6241.1);
	 v[324] =  minimum([ state_array[1451]  state_array[1452] ])

	 # 325 -> (6240.1 and 6241.1);
	 v[325] =  minimum([ state_array[1451]  state_array[1452] ])

	 # 326 -> (6240.1 and 6241.1);
	 v[326] =  minimum([ state_array[1451]  state_array[1452] ])

	 # 327 -> (6240.1 and 6241.1);
	 v[327] =  minimum([ state_array[1451]  state_array[1452] ])

	 # 328 -> (6120.1 or 6120.2);
	 v[328] =  maximum([ state_array[1443]  state_array[1444] ])

	 # 329 -> 22934.1;
	 v[329] =  state_array[475]

	 # 330 -> 10157.1;
	 v[330] =  state_array[13]

	 # 331 -> 10157.1;
	 v[331] =  state_array[13]

	 # 332 -> (10558.1 and 9517.1);
	 v[332] =  minimum([ state_array[50]  state_array[1991] ])

	 # 333 -> (11254.1 or 55089.1 or 54407.1 or 81539.1);
	 v[333] =  maximum([ state_array[128]  state_array[1321]  state_array[1290]  state_array[1773] ])

	 # 334 -> 259230.1;
	 v[334] =  state_array[584]

	 # 335 -> 6646.1;
	 v[335] =  state_array[1601]

	 # 336 -> 6713.1;
	 v[336] =  state_array[1610]

	 # 337 -> 2222.1;
	 v[337] =  state_array[457]

	 # 338 -> (8801.1 and 8802.1);
	 v[338] =  minimum([ state_array[1888]  state_array[1889] ])

	 # 339 -> 6888.1;
	 v[339] =  state_array[1633]

	 # 340 -> (5092.1 or 5092.2);
	 v[340] =  maximum([ state_array[1076]  state_array[1077] ])

	 # 341 -> (11254.1 or 54407.1 or 81539.1);
	 v[341] =  maximum([ state_array[128]  state_array[1290]  state_array[1773] ])

	 # 342 -> (7086.1 or 8277.1 or 84076.1);
	 v[342] =  maximum([ state_array[1646]  state_array[1780]  state_array[1802] ])

	 # 343 -> (7086.1 or 8277.1 or 84076.1);
	 v[343] =  maximum([ state_array[1646]  state_array[1780]  state_array[1802] ])

	 # 344 -> 7298.1;
	 v[344] =  state_array[1665]

	 # 345 -> (7167.1 or 286016.1);
	 v[345] =  maximum([ state_array[1649]  state_array[709] ])

	 # 346 -> (7296.1 or 7296.2 or 7296.4 or 7296.3);
	 v[346] =  maximum([ state_array[1661]  state_array[1662]  state_array[1664]  state_array[1663] ])

	 # 347 -> 6999.1;
	 v[347] =  state_array[1637]

	 # 348 -> 11254.1;
	 v[348] =  state_array[128]

	 # 349 -> 2805.1;
	 v[349] =  state_array[693]

	 # 350 -> 11254.1;
	 v[350] =  state_array[128]

	 # 351 -> 51727.1;
	 v[351] =  state_array[1182]

	 # 352 -> (6563.1 or 8170.1 or 6528.1 or 6523.1);
	 v[352] =  maximum([ state_array[1575]  state_array[1776]  state_array[1540]  state_array[1536] ])

	 # 353 -> 366.1;
	 v[353] =  state_array[864]

	 # 354 -> 586.1;
	 v[354] =  state_array[1428]

	 # 355 -> 11254.1;
	 v[355] =  state_array[128]

	 # 356 -> (26275.1);
	 v[356] =  state_array[603]

	 # 357 -> (641372.1) or (641371.1) or (570.1);
	 v[357] =  maximum([ state_array[1468]  state_array[1467]  state_array[1384] ])

	 # 361 -> (5226.1);
	 v[361] =  state_array[1202]

	 # 366 -> ((55967.1 and 51079.1 and 4535.1 and 4536.1 and 4537.1 and 4538.1 and 4539.1 and 4540.1 and 4541.1 and 4694.1 and 4705.1 and 126328.1 and 4695.1 and 4696.1 and 4697.1 and 4698.1 and 4700.1 and 4701.1 and 4702.1 and 4704.1 and 4706.1 and 4707.1 and 4716.1 and 4708.1 and 4709.1 and 4710.1 and 4711.1 and 4712.2 and 4713.1 and 4714.1 and 4715.1 and 4717.1 and 4718.1 and 4719.1 and 4720.1 and 4722.1 and 4724.1 and 4725.1 and 4726.1 and 374291.1 and 4728.1 and 4723.1 and 4729.1 and 4731.1 and 7991.1) or (55967.1 and 51079.1 and 4535.1 and 4536.1 and 4537.1 and 4538.1 and 4539.1 and 4540.1 and 4541.1 and 4694.1 and 4705.1 and 126328.1 and 4695.1 and 4696.1 and 4697.1 and 4698.1 and 4700.1 and 4701.1 and 4702.1 and 4704.1 and 4706.1 and 4707.1 and 4716.1 and 4708.1 and 4709.1 and 4710.1 and 4711.1 and 4712.2 and 4713.1 and 4714.1 and 4715.1 and 4717.1 and 4718.1 and 4719.1 and 4720.1 and 4722.1 and 4724.1 and 4725.1 and 4726.1 and 374291.1 and 4728.1 and 4723.1 and 4729.1 and 4731.2 and 7991.2) or (55967.1 and 51079.1 and 4535.1 and 4536.1 and 4537.1 and 4538.1 and 4539.1 and 4540.1 and 4541.1 and 4694.1 and 4705.1 and 126328.1 and 4695.1 and 4696.1 and 4697.1 and 4698.1 and 4700.1 and 4701.1 and 4702.1 and 4704.1 and 4706.1 and 4707.1 and 4716.1 and 4708.1 and 4709.1 and 4710.1 and 4711.1 and 4712.1 and 4713.1 and 4714.1 and 4715.1 and 4717.1 and 4718.1 and 4719.1 and 4720.1 and 4722.1 and 4724.1 and 4725.1 and 4726.1 and 374291.1 and 4728.1 and 4723.1 and 4729.1 and 4731.1 and 7991.1) or (55967.1 and 51079.1 and 4535.1 and 4536.1 and 4537.1 and 4538.1 and 4539.1 and 4540.1 and 4541.1 and 4694.1 and 4705.1 and 126328.1 and 4695.1 and 4696.1 and 4697.1 and 4698.1 and 4700.1 and 4701.1 and 4702.1 and 4704.1 and 4706.1 and 4707.1 and 4716.1 and 4708.1 and 4709.1 and 4710.1 and 4711.1 and 4712.1 and 4713.1 and 4714.1 and 4715.1 and 4717.1 and 4718.1 and 4719.1 and 4720.1 and 4722.1 and 4724.1 and 4725.1 and 4726.1 and 374291.1 and 4728.1 and 4723.1 and 4729.1 and 4731.2 and 7991.1) or (55967.1 and 51079.1 and 4535.1 and 4536.1 and 4537.1 and 4538.1 and 4539.1 and 4540.1 and 4541.1 and 4694.1 and 4705.1 and 126328.1 and 4695.1 and 4696.1 and 4697.1 and 4698.1 and 4700.1 and 4701.1 and 4702.1 and 4704.1 and 4706.1 and 4707.1 and 4716.1 and 4708.1 and 4709.1 and 4710.1 and 4711.1 and 4712.1 and 4713.1 and 4714.1 and 4715.1 and 4717.1 and 4718.1 and 4719.1 and 4720.1 and 4722.1 and 4724.1 and 4725.1 and 4726.1 and 374291.1 and 4728.1 and 4723.1 and 4729.1 and 4731.1 and 7991.2) or (55967.1 and 51079.1 and 4535.1 and 4536.1 and 4537.1 and 4538.1 and 4539.1 and 4540.1 and 4541.1 and 4694.1 and 4705.1 and 126328.1 and 4695.1 and 4696.1 and 4697.1 and 4698.1 and 4700.1 and 4701.1 and 4702.1 and 4704.1 and 4706.1 and 4707.1 and 4716.1 and 4708.1 and 4709.1 and 4710.1 and 4711.1 and 4712.2 and 4713.1 and 4714.1 and 4715.1 and 4717.1 and 4718.1 and 4719.1 and 4720.1 and 4722.1 and 4724.1 and 4725.1 and 4726.1 and 374291.1 and 4728.1 and 4723.1 and 4729.1 and 4731.2 and 7991.1) or (55967.1 and 51079.1 and 4535.1 and 4536.1 and 4537.1 and 4538.1 and 4539.1 and 4540.1 and 4541.1 and 4694.1 and 4705.1 and 126328.1 and 4695.1 and 4696.1 and 4697.1 and 4698.1 and 4700.1 and 4701.1 and 4702.1 and 4704.1 and 4706.1 and 4707.1 and 4716.1 and 4708.1 and 4709.1 and 4710.1 and 4711.1 and 4712.1 and 4713.1 and 4714.1 and 4715.1 and 4717.1 and 4718.1 and 4719.1 and 4720.1 and 4722.1 and 4724.1 and 4725.1 and 4726.1 and 374291.1 and 4728.1 and 4723.1 and 4729.1 and 4731.2 and 7991.2) or (55967.1 and 51079.1 and 4535.1 and 4536.1 and 4537.1 and 4538.1 and 4539.1 and 4540.1 and 4541.1 and 4694.1 and 4705.1 and 126328.1 and 4695.1 and 4696.1 and 4697.1 and 4698.1 and 4700.1 and 4701.1 and 4702.1 and 4704.1 and 4706.1 and 4707.1 and 4716.1 and 4708.1 and 4709.1 and 4710.1 and 4711.1 and 4712.2 and 4713.1 and 4714.1 and 4715.1 and 4717.1 and 4718.1 and 4719.1 and 4720.1 and 4722.1 and 4724.1 and 4725.1 and 4726.1 and 374291.1 and 4728.1 and 4723.1 and 4729.1 and 4731.1 and 7991.2));
	 v[366] =  maximum([ minimum([ state_array[1361]  state_array[1091]  state_array[957]  state_array[958]  state_array[959]  state_array[960]  state_array[961]  state_array[962]  state_array[963]  state_array[971]  state_array[982]  state_array[195]  state_array[972]  state_array[973]  state_array[974]  state_array[975]  state_array[978]  state_array[979]  state_array[980]  state_array[981]  state_array[983]  state_array[984]  state_array[995]  state_array[985]  state_array[986]  state_array[988]  state_array[989]  state_array[991]  state_array[992]  state_array[993]  state_array[994]  state_array[996]  state_array[997]  state_array[998]  state_array[999]  state_array[1000]  state_array[1002]  state_array[1003]  state_array[1004]  state_array[872]  state_array[1005]  state_array[1001]  state_array[1006]  state_array[1007]  state_array[1737] ]) minimum([ state_array[1361]  state_array[1091]  state_array[957]  state_array[958]  state_array[959]  state_array[960]  state_array[961]  state_array[962]  state_array[963]  state_array[971]  state_array[982]  state_array[195]  state_array[972]  state_array[973]  state_array[974]  state_array[975]  state_array[978]  state_array[979]  state_array[980]  state_array[981]  state_array[983]  state_array[984]  state_array[995]  state_array[985]  state_array[986]  state_array[988]  state_array[989]  state_array[991]  state_array[992]  state_array[993]  state_array[994]  state_array[996]  state_array[997]  state_array[998]  state_array[999]  state_array[1000]  state_array[1002]  state_array[1003]  state_array[1004]  state_array[872]  state_array[1005]  state_array[1001]  state_array[1006]  state_array[1008]  state_array[1738] ]) minimum([ state_array[1361]  state_array[1091]  state_array[957]  state_array[958]  state_array[959]  state_array[960]  state_array[961]  state_array[962]  state_array[963]  state_array[971]  state_array[982]  state_array[195]  state_array[972]  state_array[973]  state_array[974]  state_array[975]  state_array[978]  state_array[979]  state_array[980]  state_array[981]  state_array[983]  state_array[984]  state_array[995]  state_array[985]  state_array[986]  state_array[988]  state_array[989]  state_array[990]  state_array[992]  state_array[993]  state_array[994]  state_array[996]  state_array[997]  state_array[998]  state_array[999]  state_array[1000]  state_array[1002]  state_array[1003]  state_array[1004]  state_array[872]  state_array[1005]  state_array[1001]  state_array[1006]  state_array[1007]  state_array[1737] ]) minimum([ state_array[1361]  state_array[1091]  state_array[957]  state_array[958]  state_array[959]  state_array[960]  state_array[961]  state_array[962]  state_array[963]  state_array[971]  state_array[982]  state_array[195]  state_array[972]  state_array[973]  state_array[974]  state_array[975]  state_array[978]  state_array[979]  state_array[980]  state_array[981]  state_array[983]  state_array[984]  state_array[995]  state_array[985]  state_array[986]  state_array[988]  state_array[989]  state_array[990]  state_array[992]  state_array[993]  state_array[994]  state_array[996]  state_array[997]  state_array[998]  state_array[999]  state_array[1000]  state_array[1002]  state_array[1003]  state_array[1004]  state_array[872]  state_array[1005]  state_array[1001]  state_array[1006]  state_array[1008]  state_array[1737] ]) minimum([ state_array[1361]  state_array[1091]  state_array[957]  state_array[958]  state_array[959]  state_array[960]  state_array[961]  state_array[962]  state_array[963]  state_array[971]  state_array[982]  state_array[195]  state_array[972]  state_array[973]  state_array[974]  state_array[975]  state_array[978]  state_array[979]  state_array[980]  state_array[981]  state_array[983]  state_array[984]  state_array[995]  state_array[985]  state_array[986]  state_array[988]  state_array[989]  state_array[990]  state_array[992]  state_array[993]  state_array[994]  state_array[996]  state_array[997]  state_array[998]  state_array[999]  state_array[1000]  state_array[1002]  state_array[1003]  state_array[1004]  state_array[872]  state_array[1005]  state_array[1001]  state_array[1006]  state_array[1007]  state_array[1738] ]) minimum([ state_array[1361]  state_array[1091]  state_array[957]  state_array[958]  state_array[959]  state_array[960]  state_array[961]  state_array[962]  state_array[963]  state_array[971]  state_array[982]  state_array[195]  state_array[972]  state_array[973]  state_array[974]  state_array[975]  state_array[978]  state_array[979]  state_array[980]  state_array[981]  state_array[983]  state_array[984]  state_array[995]  state_array[985]  state_array[986]  state_array[988]  state_array[989]  state_array[991]  state_array[992]  state_array[993]  state_array[994]  state_array[996]  state_array[997]  state_array[998]  state_array[999]  state_array[1000]  state_array[1002]  state_array[1003]  state_array[1004]  state_array[872]  state_array[1005]  state_array[1001]  state_array[1006]  state_array[1008]  state_array[1737] ]) minimum([ state_array[1361]  state_array[1091]  state_array[957]  state_array[958]  state_array[959]  state_array[960]  state_array[961]  state_array[962]  state_array[963]  state_array[971]  state_array[982]  state_array[195]  state_array[972]  state_array[973]  state_array[974]  state_array[975]  state_array[978]  state_array[979]  state_array[980]  state_array[981]  state_array[983]  state_array[984]  state_array[995]  state_array[985]  state_array[986]  state_array[988]  state_array[989]  state_array[990]  state_array[992]  state_array[993]  state_array[994]  state_array[996]  state_array[997]  state_array[998]  state_array[999]  state_array[1000]  state_array[1002]  state_array[1003]  state_array[1004]  state_array[872]  state_array[1005]  state_array[1001]  state_array[1006]  state_array[1008]  state_array[1738] ]) minimum([ state_array[1361]  state_array[1091]  state_array[957]  state_array[958]  state_array[959]  state_array[960]  state_array[961]  state_array[962]  state_array[963]  state_array[971]  state_array[982]  state_array[195]  state_array[972]  state_array[973]  state_array[974]  state_array[975]  state_array[978]  state_array[979]  state_array[980]  state_array[981]  state_array[983]  state_array[984]  state_array[995]  state_array[985]  state_array[986]  state_array[988]  state_array[989]  state_array[991]  state_array[992]  state_array[993]  state_array[994]  state_array[996]  state_array[997]  state_array[998]  state_array[999]  state_array[1000]  state_array[1002]  state_array[1003]  state_array[1004]  state_array[872]  state_array[1005]  state_array[1001]  state_array[1006]  state_array[1007]  state_array[1738] ])])

	 # 367 -> ((1537.1 and 4519.1 and 29796.2 and 27089.1 and 10975.1 and 7381.1 and 7384.1 and 7385.1 and 7386.1 and 7388.1) or (1537.1 and 4519.1 and 29796.1 and 27089.1 and 10975.1 and 7381.1 and 7384.1 and 7385.1 and 7386.1 and 7388.1));
	 v[367] =  maximum([ minimum([ state_array[261]  state_array[954]  state_array[739]  state_array[648]  state_array[94]  state_array[1688]  state_array[1689]  state_array[1690]  state_array[1691]  state_array[1692] ]) minimum([ state_array[261]  state_array[954]  state_array[738]  state_array[648]  state_array[94]  state_array[1688]  state_array[1689]  state_array[1690]  state_array[1691]  state_array[1692] ])])

	 # 368 -> ((7384.1 and 7388.1 and 4519.1 and 10975.1 and 29796.2 and 7385.1 and 1537.1 and 7386.1 and 27089.1 and 7381.1) or (7384.1 and 7388.1 and 29796.1 and 10975.1 and 4519.1 and 7385.1 and 7386.1 and 1537.1 and 27089.1 and 7381.1));
	 v[368] =  maximum([ minimum([ state_array[1689]  state_array[1692]  state_array[954]  state_array[94]  state_array[739]  state_array[1690]  state_array[261]  state_array[1691]  state_array[648]  state_array[1688] ]) minimum([ state_array[1689]  state_array[1692]  state_array[738]  state_array[94]  state_array[954]  state_array[1690]  state_array[1691]  state_array[261]  state_array[648]  state_array[1688] ])])

	 # 370 -> (6476.1 or 8972.1);
	 v[370] =  maximum([ state_array[1481]  state_array[1918] ])


	 # return the varray to the caller -
	 return v
end
