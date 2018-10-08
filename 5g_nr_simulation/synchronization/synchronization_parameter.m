function synchronization_parameter
disp("fun: synchronization_parameter");

    global glo_ssb;

    glo_ssb.param.Lssb = 4; % max_ssb_num=4 or 8    
    glo_ssb.param.half_frame_indicator =0;
    glo_ssb.param.sfn = [0,1,0,0,0,0,0,0,0,1,0,1];
    glo_ssb.param.issb =0;  % ssb index value
    glo_ssb.param.kssb=0;
    glo_ssb.param.logical_antenna_port =4000;

    glo_ssb.param.ssb_block_type ="TYPEA";  % type A or type B , decided by frame.u parameter 
    glo_ssb.param.ssb_case = "CASE_A"; % refer to 38.213, case A to case E
    glo_ssb.data.pss =0;
    glo_ssb.data.sss =0;
    
    % glo_ssb.data.pbch.data , pbch payload raw data
    %  systemFrameNumber, half_frame_bit, Kssb, ssb_index,bcch_bch_indicator,subCarrierSpacingCommon,ssb_SubcarrierOffset,drms_type_a_position
    %  pdcch_ConfigSIB1,cellBarred,intraFreqReselection,spare
    glo_ssb.data.pbch.data=0;
    glo_ssb.data.pbch.attr=""; 
    
    glo_ssb.data.pbch.scramble1.bitmap=0;
    glo_ssb.data.pbch.qpsk=0;
    
    glo_ssb.data.pbch_dmrs=0;
    glo_ssb.grid.antenna_logical_port=0;
    glo_ssb.grid.data =0;
    
    global glo_base_ssb_index_case_a;
    global glo_base_ssb_index_case_a_max_len;   
    
    glo_base_ssb_index_case_a = [2,8];
    glo_base_ssb_index_case_a_max_len = length(glo_base_ssb_index_case_a);         
    
    %38.212Table 7.1.1-1: Value of PBCH payload interleaver pattern
    global glo_pbch_payload_interleaver_patter;
    glo_pbch_payload_interleaver_patter = [16, 23, 18, 17, 8, 30, 10, 6, 24, 7, 0, 5, 3, 2, 1, 4, 9, 11, 12, 13, 14, 15, 19, 20, 21, 22, 25, 26, 27, 28, 29,31];      
   
    %%
    glo_ssb.data.pbch.mib.data =[];
    glo_ssb.data.pbch.mib.attr =[];   
    generation_mib();     
    
   %%
   glo_ssb.decoded.bcch_bch_indicator =0;
   glo_ssb.decoded.systemFrameNumber =0;
   glo_ssb.decoded.spare =0;
   
end




