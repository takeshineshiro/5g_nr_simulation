clear all

disp(" ***** start synchronization search link simulation *****")

str = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z');
disp(str);

%%

global_parameter();
synchronization_parameter();
channel_parameter();

global glo_ssb;

%% 

generation_synchronization_frame();

baseband_ssb_signal = glo_ssb.grid.data;
radio_channel_wave_signal = radio_channel(baseband_ssb_signal);

[pss_time_peak, pss_frequency_peak]   = synchronization_pss_detection(radio_channel_wave_signal);
[sss_time_peak, sss_frequency_peak]   = synchronization_sss_detection(radio_channel_wave_signal);

  subplot(2,2,1)
  stem(pss_time_peak);  
  title("pss time detection"); 
  
  subplot(2,2,2)
  stem(pss_frequency_peak);  
  title("pss frequency detection"); 
  
  subplot(2,2,3)
  stem(sss_time_peak);  
  title("sss time detection"); 
  
  subplot(2,2,4)
  stem(sss_frequency_peak);  
  title("sss frequency detection"); 

disp(" *****  synchronization search link simulation end *****")
