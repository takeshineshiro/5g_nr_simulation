function ssb_grid = generation_synchronization_frame()
disp("fun: generation_synchronization_frame");

    global glo_ssb;      
    
    v_ssb_case = glo_ssb.param.ssb_case; 
    
    switch v_ssb_case
        case "CASE_A"
            ssb_grid = ssb_burst_sequence_case_a();
            
        case "CASE_B"
            ssb_grid = ssb_burst_sequence_case_b();
            
        otherwise
            error("ssb case error");
    end   
             
end

function ssb_grid = ssb_burst_sequence_case_a()
disp("fun: ssb_burst_sequence_case_a");

    global glo_cell;
    global glo_ssb;
    global FFT_SIZE;
    
    v_issb_index =0; 
    v_ssb_slot =0;
    
    v_frequencyoffset = glo_ssb.param.kssb;
    v_issb_start_symbol_pos =0;
    a_ssb_grid =zeros(FFT_SIZE, 1); 
     
    v_max_symbols =  min(5, glo_cell.param.subframe.length) * glo_cell.param.subframe.symobls;
    
    v_ssb_num =0;
    v_ssb_max_num = v_max_symbols/14;   % {2,8} + 14 n          
    
     global glo_base_ssb_index_case_a;
     global glo_base_ssb_index_case_a_max_len;   
    
    for  v_ssb_num =0:1:v_ssb_max_num            
        v_base_ssb_index_pos =0;
               
        for k=0:1:glo_base_ssb_index_case_a_max_len-1
            
            v_tmp_ssb_indx =glo_base_ssb_index_case_a(v_base_ssb_index_pos+1);
            v_issb_start_symbol_pos = v_tmp_ssb_indx+14*v_ssb_num;
            
             a_ssb = generation_ssb(v_issb_index);
             v_issb_index = v_issb_index +1;
             
            v_base_ssb_index_pos = v_base_ssb_index_pos +1;               
           a_ssb_grid(:,v_issb_start_symbol_pos+1:v_issb_start_symbol_pos+4) = a_ssb(:,1:4);         
             
        end  
        
    end      
    
    ssb_grid = a_ssb_grid;
    glo_ssb.grid.data = a_ssb_grid;
    glo_ssb.grid.antenna_logical_port = 4000; 
    
end

function ssb_grid = ssb_burst_sequence_case_b()

end


