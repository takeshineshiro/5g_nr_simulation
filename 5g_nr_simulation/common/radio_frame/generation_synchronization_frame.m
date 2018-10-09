%% in 5G nr system, there are many case for ssb allocation during frames. such case a, case b, case c ...
%  glo_ssb.param.ssb_case is used to decided which ssb sequence case

function ssb_grid = generation_synchronization_frame()
disp("fun: generation_synchronization_frame");

global glo_ssb;

% glo_ssb.param.ssb_case refer to 38.213, case A to case E
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

%%
function ssb_grid_list = ssb_burst_sequence_case_a()
disp("fun: ssb_burst_sequence_case_a");

% output: ssb_grid_list,  a sequence of ssb,  three dimesion data, one subscript for symbol, one subscript for frequency and one subscript for ssb index

global glo_cell;
global glo_ssb;
global FFT_SIZE;

v_issb_index =0;
v_ssb_slot =0;

v_frequencyoffset = glo_ssb.param.kssb;
v_issb_start_symbol_pos =0;
a_ssb_grid =zeros(FFT_SIZE, 1);

% glo_cell.param.subframe.length define the simulation subframe number
% glo_cell.param.subframe.symobls define the symobles in one subframe

% caution:  in global_parameter(),  calculating the slots in one subframe and
% symbols in one slot. hence, there subframe.sybols means the number symobles in one subframe
v_max_symbols =  min(5, glo_cell.param.subframe.length) * glo_cell.param.subframe.symobls;

% v_ssb_max_num indicate the n if the formulation  {2,8} + 14 n
% in thise case, one v_ssb_max_num value indicates has two ssb blocks.
v_ssb_num =0;
v_ssb_max_num = v_max_symbols/14;

global glo_base_ssb_index_case_a;
global glo_base_ssb_index_case_a_max_len;

for  v_ssb_num =0:1:v_ssb_max_num
    v_base_ssb_index_pos =0;
    
    for k=0:1:glo_base_ssb_index_case_a_max_len-1
        
        v_tmp_ssb_indx =glo_base_ssb_index_case_a(v_base_ssb_index_pos+1);
        v_issb_start_symbol_pos = v_tmp_ssb_indx+14*v_ssb_num;
        
        % every ssb block has its own ssb index, so the v_issb_index as virutal parameter for generation_ssb() function
        % every ssb block has same SFN defined in global_parameters()
        % generation_ssb() function create only one ssb block
        a_ssb = generation_ssb(v_issb_index) ;
        v_issb_index = v_issb_index +1;
        
        v_base_ssb_index_pos = v_base_ssb_index_pos +1;
        
        % append one ssb block yo ssb block list (a_ssb_grid, this is a ssb list variable)
        a_ssb_grid(:,v_issb_start_symbol_pos+1:v_issb_start_symbol_pos+4) = a_ssb(:,1:4);
        
    end
    
end

ssb_grid_list = a_ssb_grid;
glo_ssb.grid.data = a_ssb_grid;
glo_ssb.grid.antenna_logical_port = 4000;

end

%%
function ssb_grid = ssb_burst_sequence_case_b()

end


