%% Parameters for radio channel 
function  radio_channel_wave_signal = radio_channel(baseband_data)
disp("fun: radio_channel");
    
    global glo_channel;
    global FFT_SIZE;
    
    v_channel_type  = glo_channel.param.channel_type;
    v_snr =    glo_channel.data.snr;
    
    [v_fft_size, v_symbo_num] = size(baseband_data);
    
    baseband_data = ifft(baseband_data, FFT_SIZE, 1);
    
    v_baseband_signal = reshape(baseband_data, 1, v_fft_size*v_symbo_num);
    
    switch   v_channel_type
        case "AWGN_CHANNEL"
            v_radio_channel_wave_signal = awgn(v_baseband_signal, v_snr,'measured');
        otherwise
            error("channel type error");
    end
   
    radio_channel_wave_signal = v_radio_channel_wave_signal;
 
end



