function [pss_time_peak, pss_frequency_peak] = synchronization_pss_detection(radio_channel_wave_signal)
disp("synchronization_pss_detection");

    global glo_ssb;
    global FFT_SIZE;

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
    
    [v_pss_peak_value, v_pss_peak_pos] = max(abs(a_pss_time_peak));   
    v_time_tc_pos = v_pss_peak_pos -1;
    v_tmp_one_symbol_data = radio_channel_wave_signal(1+v_time_tc_pos*v_time_step_size:1+v_time_tc_pos*v_time_step_size+FFT_SIZE-1);
    
    v_tmp_one_symbol_data = fft(v_tmp_one_symbol_data, FFT_SIZE);   
    v_pss_freq_peak = abs(xcorr(v_tmp_one_symbol_data, fliplr(glo_ssb.data.pss))); 
          
    pss_time_peak =a_pss_time_peak; 
    pss_frequency_peak = v_pss_freq_peak;
end
