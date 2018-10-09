%%
function decoded_ssb_list = decoding_synchronization_frame(radio_channel_wave_signal)
disp("fun: decoding_synchronization_frame");

% radio_channel_wave_signal,  input time sequence, one dimension data array

global FFT_SIZE;
global glo_ssb;

v_radio_channel_wave_tc_num = length(radio_channel_wave_signal);
radio_channel_symbol_signal = reshape(radio_channel_wave_signal, FFT_SIZE, floor(v_radio_channel_wave_tc_num/FFT_SIZE));

radio_channel_symbols_signal = fft(radio_channel_symbol_signal, FFT_SIZE, 1);

v_ssb_case = glo_ssb.param.ssb_case;

switch v_ssb_case
    case "CASE_A"
        ssb_grid_list = ssb_demapping_case_a(radio_channel_symbols_signal);
        
    case "CASE_B"
        ssb_grid_list = ssb_demapping_case_b(radio_channel_symbols_signal);
        
    otherwise
        error("ssb case error");
end

a_decoded_ssb_list = decoding_ssb(ssb_grid_list);
decoded_ssb_list =a_decoded_ssb_list;

end

%%

function ssb_grid_list = ssb_demapping_case_a(radio_channel_symbol_signal)
disp("fun: ssb_demapping_case_a");

%   input: radio_channel_symbol_signal, receive all the symbols
%   output: ssb_grid_list , three dimension,  [FFT_DATA(4096), symbol(ssb length), SSB block num]
%   function: extract the ssb block from radio wave signal, and ssb_grid_list express as grid, the grid is already processed as FFT.

% local variables
v_tmp_symbol =0;
v_tmp_ssb_start_symbol=0;

% v_ssb_symol_num, constant variable for ssb block symbols
v_ssb_symol_num =4;

% v_ssb_num is used to record the ssb sequence (maybe there are some ssb blocks in simulation time)
v_ssb_num =0;

global glo_base_ssb_index_case_a;
global glo_base_ssb_index_case_a_max_len;

[v_fft_size, v_max_symbol_num] = size(radio_channel_symbol_signal);

v_ssb_base_loop_num =0;

while  v_max_symbol_num >  v_tmp_ssb_start_symbol + v_ssb_symol_num
    
    for n_ssb_base_indx =0:1:glo_base_ssb_index_case_a_max_len-1
        
        v_tmp_ssb_start_symbol = glo_base_ssb_index_case_a(n_ssb_base_indx+1) + 14*v_ssb_base_loop_num;
        
        if   v_tmp_ssb_start_symbol + v_ssb_symol_num > v_max_symbol_num
            break;
        end
        
        a_ssb_grid(:, :,  v_ssb_num+1) =  radio_channel_symbol_signal(:, v_tmp_ssb_start_symbol+1: v_tmp_ssb_start_symbol+v_ssb_symol_num);
        v_ssb_num = v_ssb_num +1;
        
    end
    
    v_ssb_base_loop_num = v_ssb_base_loop_num +1;
    
end

ssb_grid_list = a_ssb_grid;

end

%%
function ssb_grid_list = ssb_demapping_case_b(radio_channel_symbol_signal)
disp("fun: ssb_demapping_case_b");

ssb_grid_list =0;

end








