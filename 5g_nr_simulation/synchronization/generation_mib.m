function generation_mib()

    % 38.331  master information block
    
    global glo_ssb;
    
    %% define the content of Master information block
    
    ssb.pbch.mib.bcch_bch_indicator.data = [1];
    ssb.pbch.mib.bcch_bch_indicator.attr = "bcch_bch_indicator";
    
    ssb.pbch.mib.systemFrameNumber.data = [1,1,1,1,1,1];
     ssb.pbch.mib.systemFrameNumber.attr = "systemFrameNumber";
     
    ssb.pbch.mib.subCarrierSpacingCommon.data = [1];
    ssb.pbch.mib.subCarrierSpacingCommon.attr = "subCarrierSpacingCommon";
     
    ssb.pbch.mib.ssb_SubcarrierOffset.data =[1,1,1,1];
    ssb.pbch.mib.ssb_SubcarrierOffset.attr = "ssb_SubcarrierOffset";
    
    ssb.pbch.mib.dmrs_TypeA_Position.data =[1];
    ssb.pbch.mib.dmrs_TypeA_Position.attr = "drms_type_a_position";
    
    ssb.pbch.mib.pdcch_ConfigSIB1.data = [1,1,1,1,1,1,1,1];
     ssb.pbch.mib.pdcch_ConfigSIB1.attr = "pdcch_ConfigSIB1";
    
    ssb.pbch.mib.cellBarred.data =[1];
    ssb.pbch.mib.cellBarred.attr ="cellBarred";
    
    ssb.pbch.mib.intraFreqReselection.data = [1];
    ssb.pbch.mib.intraFreqReselection.attr = "intraFreqReselection";
    
    ssb.pbch.mib.spare.data = [1];
    ssb.pbch.mib.spare.attr = "spare";
        
    %% construct the mib data block according to 38.331 , total 24 bits
    %  modify  the content of MIB, need not change the below source code
     
    glo_ssb.data.pbch.mib.data = [];
     glo_ssb.data.pbch.mib.attr  = [];   
    
    [v_tmp, v_item_max_len] = size(ssb.pbch.mib.bcch_bch_indicator.data);
    glo_ssb.data.pbch.mib.data = [glo_ssb.data.pbch.mib.data  ssb.pbch.mib.bcch_bch_indicator.data ];
    for v_item_len =0:1:v_item_max_len-1
        glo_ssb.data.pbch.mib.attr = [glo_ssb.data.pbch.mib.attr   ssb.pbch.mib.bcch_bch_indicator.attr];
    end
     
    [v_tmp, v_item_max_len] = size(ssb.pbch.mib.systemFrameNumber.data);
    glo_ssb.data.pbch.mib.data = [glo_ssb.data.pbch.mib.data  ssb.pbch.mib.systemFrameNumber.data ];
    for v_item_len =0:1:v_item_max_len-1
        glo_ssb.data.pbch.mib.attr = [glo_ssb.data.pbch.mib.attr   ssb.pbch.mib.systemFrameNumber.attr];
    end
    
     [v_tmp, v_item_max_len] = size(ssb.pbch.mib.subCarrierSpacingCommon.data);
    glo_ssb.data.pbch.mib.data = [glo_ssb.data.pbch.mib.data  ssb.pbch.mib.subCarrierSpacingCommon.data ];
    for v_item_len =0:1:v_item_max_len-1
        glo_ssb.data.pbch.mib.attr = [glo_ssb.data.pbch.mib.attr   ssb.pbch.mib.subCarrierSpacingCommon.attr];
    end
    
    [v_tmp, v_item_max_len] = size(ssb.pbch.mib.ssb_SubcarrierOffset.data);
    glo_ssb.data.pbch.mib.data = [glo_ssb.data.pbch.mib.data  ssb.pbch.mib.ssb_SubcarrierOffset.data ];
    for v_item_len =0:1:v_item_max_len-1
        glo_ssb.data.pbch.mib.attr = [glo_ssb.data.pbch.mib.attr   ssb.pbch.mib.ssb_SubcarrierOffset.attr];
    end
    
    [v_tmp, v_item_max_len] = size(ssb.pbch.mib.dmrs_TypeA_Position.data);
    glo_ssb.data.pbch.mib.data = [glo_ssb.data.pbch.mib.data  ssb.pbch.mib.dmrs_TypeA_Position.data ];
    for v_item_len =0:1:v_item_max_len-1
        glo_ssb.data.pbch.mib.attr = [glo_ssb.data.pbch.mib.attr   ssb.pbch.mib.dmrs_TypeA_Position.attr];
    end
    
     [v_tmp, v_item_max_len] = size(ssb.pbch.mib.pdcch_ConfigSIB1.data);
    glo_ssb.data.pbch.mib.data = [glo_ssb.data.pbch.mib.data  ssb.pbch.mib.pdcch_ConfigSIB1.data ];
    for v_item_len =0:1:v_item_max_len-1
        glo_ssb.data.pbch.mib.attr = [glo_ssb.data.pbch.mib.attr   ssb.pbch.mib.pdcch_ConfigSIB1.attr];
    end
    
    [v_tmp, v_item_max_len] = size(ssb.pbch.mib.cellBarred.data);
    glo_ssb.data.pbch.mib.data = [glo_ssb.data.pbch.mib.data  ssb.pbch.mib.cellBarred.data ];
    for v_item_len =0:1:v_item_max_len-1
        glo_ssb.data.pbch.mib.attr = [glo_ssb.data.pbch.mib.attr   ssb.pbch.mib.cellBarred.attr];
    end
    
    [v_tmp, v_item_max_len] = size(ssb.pbch.mib.intraFreqReselection.data);
    glo_ssb.data.pbch.mib.data = [glo_ssb.data.pbch.mib.data  ssb.pbch.mib.intraFreqReselection.data ];
    for v_item_len =0:1:v_item_max_len-1
        glo_ssb.data.pbch.mib.attr = [glo_ssb.data.pbch.mib.attr   ssb.pbch.mib.intraFreqReselection.attr];
    end
    
    [v_tmp, v_item_max_len] = size(ssb.pbch.mib.spare.data);
    glo_ssb.data.pbch.mib.data = [glo_ssb.data.pbch.mib.data  ssb.pbch.mib.spare.data ];
    for v_item_len =0:1:v_item_max_len-1
        glo_ssb.data.pbch.mib.attr = [glo_ssb.data.pbch.mib.attr   ssb.pbch.mib.spare.attr];
    end   
    
end