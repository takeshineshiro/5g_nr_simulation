clear all

disp(" ***** start pbch dmrs link simulation *****")

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
received_ssb = search_ssb(radio_channel_wave_signal);

subplot(1,3,1);
pbch_dmrs_peak1= xcorr(glo_ssb.data.pbch_dmrs, glo_ssb.data.pbch_dmrs);
stem(abs(pbch_dmrs_peak1),"r");
title("origin sequence coorelation");

subplot(1,3,2);
pbch_dmrs_peak2 = xcorr(received_ssb.pbch_dmrs, received_ssb.pbch_dmrs);
stem(abs(pbch_dmrs_peak2),"g");
title("receive sequence coorelation");

subplot(1,3,3);
pbch_dmrs_peak3 = xcorr(glo_ssb.data.pbch_dmrs, received_ssb.pbch_dmrs);
stem(abs(pbch_dmrs_peak3),"b");
title("receive sequence coorelation");

disp(" *****  pbch dmrs link simulation end *****")

