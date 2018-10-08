function decoded_ssb_list =decoding_ssb(ssb_grid_list)
disp("fun: decoding_ssb");

% decoding ssb block list (many ssb blocks)
% decoding ssb block into pss, sss, pbch and pbch dmrs

% decoded.ssb.pss
% decode.ssb.sss
% decode.ssb.pbch
% decode.ssb.pbch_dmrs

    global glo_ssb;
    global glo_cell;
    v_pss_pos=0;
    v_sss_pos=0;
    v_pbch_pos=0;
    v_pbch_dmrs_pos =0;
    
    v_n_cellid = glo_cell.param.physical_cell_identity.nid;  

    v= mod(v_n_cellid,4);
 
    a_decoded_ssb_list =0;
    
    [v_fft_size, v_ssb_symbol_len, v_ssb_max_num] =size(ssb_grid_list);    
    
     for v_ssb_num =0:1:v_ssb_max_num-1
       
         v_pbch_dmrs_pos =0;
         v_pbch_pos =0;
         v_pss_pos =0;
         v_sss_pos =0;
        
        v_tmp_symbol =0;
       for k=56:1:182
           ssb_list(v_ssb_num+1).pss(v_pss_pos+1) = ssb_grid_list(k+1 , v_tmp_symbol+1, v_ssb_num+1);
           v_pss_pos = v_pss_pos +1;
       end 

       v_tmp_symbol =1;
       for k=0:1:239
           if mod (k,4) == v
               ssb_list(v_ssb_num+1).pbch_dmrs(v_pbch_dmrs_pos+1) = ssb_grid_list(k+1 , v_tmp_symbol+1, v_ssb_num+1);
               v_pbch_dmrs_pos = v_pbch_dmrs_pos +1;
           else
               ssb_list(v_ssb_num+1).pbch(v_pbch_pos+1) = ssb_grid_list(k+1 , v_tmp_symbol+1, v_ssb_num+1);
               v_pbch_pos = v_pbch_pos +1;
           end       
       end

       v_tmp_symbol =2;
       for k=0:1:47
           if mod (k,4) == v
               ssb_list(v_ssb_num+1).pbch_dmrs(v_pbch_dmrs_pos+1) = ssb_grid_list(k+1 , v_tmp_symbol+1, v_ssb_num+1);
               v_pbch_dmrs_pos = v_pbch_dmrs_pos +1;
           else
               ssb_list(v_ssb_num+1).pbch(v_pbch_pos+1) = ssb_grid_list(k+1 , v_tmp_symbol+1, v_ssb_num+1);
               v_pbch_pos = v_pbch_pos +1;
           end       
       end

       for k=56:1:182
           ssb_list(v_ssb_num+1).sss(v_sss_pos+1) = ssb_grid_list(k+1 , v_tmp_symbol+1, v_ssb_num+1);
           v_sss_pos = v_sss_pos +1;    
       end   

        for k=192:1:239
           if mod (k,4) == v
               ssb_list(v_ssb_num+1).pbch_dmrs(v_pbch_dmrs_pos+1) = ssb_grid_list(k+1 , v_tmp_symbol+1, v_ssb_num+1);
               v_pbch_dmrs_pos = v_pbch_dmrs_pos +1;
           else
               ssb_list(v_ssb_num+1).pbch(v_pbch_pos+1) = ssb_grid_list(k+1 , v_tmp_symbol+1, v_ssb_num+1);
               v_pbch_pos = v_pbch_pos +1;
           end       
        end

       v_tmp_symbol =3;
       for k=0:1:239
           if mod (k,4) == v
               ssb_list(v_ssb_num+1).pbch_dmrs(v_pbch_dmrs_pos+1) = ssb_grid_list(k+1 , v_tmp_symbol+1, v_ssb_num+1);
               v_pbch_dmrs_pos = v_pbch_dmrs_pos +1;
           else
               ssb_list(v_ssb_num+1).pbch(v_pbch_pos+1) = ssb_grid_list(k+1 , v_tmp_symbol+1, v_ssb_num+1);
               v_pbch_pos = v_pbch_pos +1;
           end       
       end      
     
     end     
   
  	decoded_ssb_list = ssb_list; 
    
end



