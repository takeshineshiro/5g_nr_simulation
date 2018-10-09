clear all

disp(" ***** start pbch signal link simulation *****")

str = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z');
disp(str);

%% define all global variable for simulation
% global parameter() defines all gobal vairables, mainly abot cell parameter
% synchronization_parameter() defines all the variables for pss, sss, and pbch.
% channel_parameter() defines all the variables for radio channel (caution: not about the channel code parameter)

global_parameter();
synchronization_parameter();
channel_parameter();

global glo_ssb;

global  glo_channel;
glo_channel.data.snr = 0;

%%

generation_synchronization_frame();

baseband_ssb_signal = glo_ssb.grid.data;
radio_channel_wave_signal = radio_channel(baseband_ssb_signal);

decoded_ssb_list = decoding_synchronization_frame(radio_channel_wave_signal);

% decoded_ssb_list,  include pss, sss, pbch and pbch dmrs
% decoded_ssb_list, include many ssb block content

v_ssb_max_num = length(decoded_ssb_list);

for v_ssb_num =0:1: v_ssb_max_num-1
    decoded_pbch_content(v_ssb_num+1) =  decode_pbch(decoded_ssb_list(v_ssb_num+1).pbch);
    
end

    decoded_pbch_content(1)

disp(" *****  pbch signal link simulation end *****")

