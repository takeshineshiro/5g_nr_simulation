function ssb=generation_ssb(issb_index)
disp("fun: generation_ssb");

   global glo_ssb;
   global glo_cell;
   global FFT_SIZE;
   
    glo_ssb.param.issb = issb_index ;    
    generation_pss();
    generation_sss();
    generation_pbch();
    generation_pbch_dmrs();
   
    a_pss = glo_ssb.data.pss;
    a_sss = glo_ssb.data.sss;
    a_pbch = glo_ssb.data.pbch.qpsk;
    a_pbch_dmrs = glo_ssb.data.pbch_dmrs;    
    v_n_cellid = glo_cell.param.physical_cell_identity.nid;     
    
    a_ssb =zeros(FFT_SIZE, 1);      
    v_pss_pos =0;
    v_sss_pos =0;
    v_pbch_pos=0;
    v_pbch_dmrs_pos =0;
    
   
    v_tmp_symbol = 0;
    for k=56:1:182
        a_ssb(k+1,1+v_tmp_symbol) = a_pss(v_pss_pos+1);     
        v_pss_pos = v_pss_pos +1;
    end
    
     v = mod(v_n_cellid, 4);
     v_tmp_symbol = 1;
    
    for k=0:1:239
        if mod(k,4) == v
            a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch_dmrs(v_pbch_dmrs_pos+1);
            v_pbch_dmrs_pos = v_pbch_dmrs_pos +1;
        else
            a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch(v_pbch_pos+1);
            v_pbch_pos = v_pbch_pos+1;
        end               
    end   
    
    v_tmp_symbol =2; 
    
    for k=0:1:47
        if mod(k,4) == v
            a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch_dmrs(v_pbch_dmrs_pos+1);
            v_pbch_dmrs_pos = v_pbch_dmrs_pos +1;
        else
            a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch(v_pbch_pos+1);
            v_pbch_pos = v_pbch_pos+1;
        end               
    end
    
    for k=56:1:182
        a_ssb(k+1,1+v_tmp_symbol) = a_sss(v_sss_pos+1);        
        v_sss_pos = v_sss_pos +1;
    end    
    
    for k=192:1:239
        if mod(k,4) == v
            a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch_dmrs(v_pbch_dmrs_pos+1);
            v_pbch_dmrs_pos = v_pbch_dmrs_pos +1;
        else
            a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch(v_pbch_pos+1);
            v_pbch_pos = v_pbch_pos+1;
        end  
    end   
    
    v_tmp_symbol =3; 
    
    for k=0:1:239
        if mod(k,4) == v
            a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch_dmrs(v_pbch_dmrs_pos+1);
            v_pbch_dmrs_pos = v_pbch_dmrs_pos +1;
        else
            a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch(v_pbch_pos+1);
            v_pbch_pos = v_pbch_pos+1;
        end  
    end   
    
    ssb = a_ssb;  
    glo_ssb.data.ssb = a_ssb;
    synchornization_signal_block = a_ssb;

end



