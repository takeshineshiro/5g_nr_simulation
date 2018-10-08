%% synchronization_signal_link

clear all

disp("***** start synchronization signal link simulation *****");
str = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z');
disp(str);

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

%%  display pss and sss sequence 

[v_null , v_ssb_max_num]  = size(decoded_ssb_list);

subplot(1,3,1);  
pss_peak1= xcorr(glo_ssb.data.pss, glo_ssb.data.pss); 
stem(abs(pss_peak1),"r");
title("origin pss autocorrelation "); 

subplot(1,3,2);   
sss_peak1= xcorr(glo_ssb.data.sss, glo_ssb.data.sss); 
stem(abs(sss_peak1),"r");
title("origin sss autocorrelation "); 

subplot(1,3,3);    
pbch_dmrs_peak1 = xcorr(glo_ssb.data.pbch_dmrs, glo_ssb.data.pbch_dmrs);  
stem(abs(pbch_dmrs_peak1),"g");
title("receive pbch dmrs autocorrelation");    

 figure;
 v_plot_figure_num  =0; 
for v_num_ssb_plot = 0:1: v_ssb_max_num-1
    
     receive_ssb.pss= decoded_ssb_list(v_num_ssb_plot+1).pss;
     receive_ssb.sss= decoded_ssb_list(v_num_ssb_plot+1).sss;
     receive_ssb.pbch_dmrs= decoded_ssb_list(v_num_ssb_plot+1).pbch_dmrs;
     
      v_plot_figure_num = v_plot_figure_num+1; 
      subplot(v_ssb_max_num,3,v_plot_figure_num);   
      pss_peak2 = xcorr(receive_ssb.pss, receive_ssb.pss);  
      stem(abs(pss_peak2),"g");
      title("receive pss autocorrelation");
    
      v_plot_figure_num = v_plot_figure_num+1;   
      subplot(v_ssb_max_num,3,v_plot_figure_num);   
      sss_peak2 = xcorr(receive_ssb.sss, receive_ssb.sss);  
      stem(abs(sss_peak2),"g");
      title("receive sss autocorrelation");    
      
      v_plot_figure_num = v_plot_figure_num+1;   
      subplot(v_ssb_max_num,3,v_plot_figure_num);   
      pbch_dmrs_peak2 = xcorr(receive_ssb.pbch_dmrs, receive_ssb.pbch_dmrs);  
      stem(abs(pbch_dmrs_peak2),"g");
      title("receive pbch dmrs autocorrelation");    

    
end

 figure;
 v_plot_figure_num  =0; 
for v_num_ssb_plot = 0:1: v_ssb_max_num-1
    
     receive_ssb.pss= decoded_ssb_list(v_num_ssb_plot+1).pss;
     receive_ssb.sss= decoded_ssb_list(v_num_ssb_plot+1).sss;   
     receive_ssb.pbch_dmrs= decoded_ssb_list(v_num_ssb_plot+1).pbch_dmrs;
    
      v_plot_figure_num = v_plot_figure_num+1; 
      subplot(v_ssb_max_num,3,v_plot_figure_num);   
      pss_peak3 = xcorr(glo_ssb.data.pss, receive_ssb.pss);  
      stem(abs(pss_peak3),"b");
      title("pss cross correlation");  

    
      v_plot_figure_num = v_plot_figure_num+1; 
      subplot(v_ssb_max_num,3,v_plot_figure_num);   
      sss_peak3 = xcorr(glo_ssb.data.sss, receive_ssb.sss);  
      stem(abs(sss_peak3),"b");
      title("sss  cross correlation");     
      
       v_plot_figure_num = v_plot_figure_num+1; 
      subplot(v_ssb_max_num,3,v_plot_figure_num);   
      pbch_dmrs_peak3 = xcorr(glo_ssb.data.pbch_dmrs, receive_ssb.pbch_dmrs);  
      stem(abs(pbch_dmrs_peak3),"b");
      title("sss  cross correlation");   
    
end

disp("*****  synchronization signal link simulation end *****");
