%% Parameters for radio channel 
function channel_parameter
disp("fun: channel_parameter");

    global glo_channel;
    glo_channel.param.channel_type ="AWGN_CHANNEL";
    glo_channel.data.snr = 0;  

end



