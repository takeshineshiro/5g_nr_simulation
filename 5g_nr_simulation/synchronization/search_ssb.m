function ssb = search_ssb(radio_channel_wave_signal)

% radio_channel_wave_signal , frame sequence , one dimension
% searching and decoding the strongest SSB block in frame

global glo_ssb;
global FFT_SIZE;

% constant variable ,  ssb block symobls 
v_ssb_symbol_num =4;

v_radio_channel_wave_signal_len = length(radio_channel_wave_signal);

v_time_step_size =4096;
v_time_step_max_num = floor(v_radio_channel_wave_signal_len/v_time_step_size);
v_time_tc_pos =0;

for v_step_num =0:1:v_time_step_max_num
    
    if  v_time_tc_pos + FFT_SIZE +1    >  v_radio_channel_wave_signal_len
        break;
    end
    
    v_time_one_symobl_data =  radio_channel_wave_signal(v_time_tc_pos+1:v_time_tc_pos+1+FFT_SIZE);
    v_time_tc_pos = v_time_tc_pos + v_time_step_size;
    
    v_tmp_one_symbol_data = fft(v_time_one_symobl_data, FFT_SIZE);    
    a_pss_time_peak(v_step_num+1) = max(abs(xcorr(v_tmp_one_symbol_data, fliplr(glo_ssb.data.pss))));
    
end

% the best pss xcorrelation value (ssb block)
[v_pss_peak_value, v_pss_peak_pos] = max(abs(a_pss_time_peak));
v_time_tc_pos = v_pss_peak_pos -1;

% extract the best SSB block
v_tmp_ssb_symob_data = radio_channel_wave_signal((1+v_time_tc_pos*v_time_step_size):(1+v_time_tc_pos*v_time_step_size+FFT_SIZE*v_ssb_symbol_num-1));

v_tmp_ssb_symob_data = reshape(v_tmp_ssb_symob_data, FFT_SIZE, v_ssb_symbol_num);

v_tmp_ssb_symob_data = fft(v_tmp_ssb_symob_data, FFT_SIZE, 1);

% v_tmp_ssb_symob_data, temporary ssb block data, 4 symbols and FFT_SIZE (frequency domain)
ssb = decoding_ssb(v_tmp_ssb_symob_data);

end





