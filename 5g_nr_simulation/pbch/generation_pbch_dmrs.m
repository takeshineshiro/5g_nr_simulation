 function pbch_data =  generation_pbch_dmrs()
 disp("fun: generation_pbch_dmrs");

    global glo_ssb;
    global glo_cell;
    
    v_issb = glo_ssb.param.issb;
    v_n_cellId = glo_cell.param.physical_cell_identity.nid;
  
    v_cinit = pow2(11)*(v_issb + 1)*(floor(v_n_cellId/4)+1) + pow2(6)*(v_issb + 1) + mod(v_n_cellId, 4);
    
    %  pbch_dmrs_len = 144
    v_pbch_dmrs_len= (240+240+48+48)/4  ;
    v_pn_sequece_len = 2*(v_pbch_dmrs_len+1);     
    
   pn_sequece = pseudo_random_sequence(v_pn_sequece_len, v_cinit);
    
    for m=0:1:(v_pbch_dmrs_len-1)
        pbch_dmrs(m+1) = (1/sqrt(2)) * (1 - 2*pn_sequece(2*m+1)) + j*(1/sqrt(2) )*(1-2*pn_sequece(2*m+1+1));
    end    
   
    physical_broadcast_channel_demodulate_reference_signal = pbch_dmrs;
   glo_ssb.data.pbch_dmrs = pbch_dmrs;
 
 end