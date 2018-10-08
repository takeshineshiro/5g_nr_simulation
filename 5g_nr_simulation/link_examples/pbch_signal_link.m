clear all

disp(" ***** start pbch signal link simulation *****")

str = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z');
disp(str);

%%

global_parameter();
synchronization_parameter();
channel_parameter();

global glo_ssb;

%%

global_parameter();
synchronization_parameter();
channel_parameter();

global glo_ssb;

global  glo_channel;
glo_channel.data.snr = -20;  

%% 

generation_synchronization_frame();

baseband_ssb_signal = glo_ssb.grid.data;
radio_channel_wave_signal = radio_channel(baseband_ssb_signal);

decoded_ssb_list = decoding_synchronization_frame(radio_channel_wave_signal);

v_ssb_max_num = length(decoded_ssb_list);   

for v_ssb_num =0:1: v_ssb_max_num-1    
    a_pbch_mib_data(v_ssb_num+1) =  decode_pbch(decoded_ssb_list(v_ssb_num+1).pbch);
    glo_ssb.decoded
end


disp(" *****  pbch signal link simulation end *****")

