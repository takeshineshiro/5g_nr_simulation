function  pbch_mib_data = decode_pbch(pbch_data)
disp("decode_pbch");

    % pbch_data,  432 pbch modulation symbols
    % 432 symol data from SSB 
    v_pbch_modulated_data =  pbch_data;
    v_pbch_scrambled2_data = pbch_demodulation(v_pbch_modulated_data);
    v_pbch_rate_matching_data = pbch_descrambling_2(v_pbch_scrambled2_data);
    v_pbch_polarred_data = pbch_dec_rate_matching(v_pbch_rate_matching_data);
    v_pbch_crc24_data = pbch_dec_polar(v_pbch_polarred_data);
    v_pbch_scrambled1_data = pbch_dec_crc24c(v_pbch_crc24_data);
    v_pbch_payload_data = pbch_descrambling_1(v_pbch_scrambled1_data);
    v_pbch_mib_data = pbch_dec_payload(v_pbch_payload_data);
    
    pbch_mib_data =v_pbch_mib_data;
end

%%
function pbch_data = pbch_demodulation(pbch_modulated_data)
disp("pbch_demodulation");

    % Code parameters
    K = 56;                            % Message length in bits, including CRC, K > 24 for DL
    E = 432;                          % Rate matched output length, E <= 8192
    EbNo = 0.8;                    % EbNo in dB
    R = K/E;                           % Effective code rate
    bps = 2;                           % bits per symbol, 1 for BPSK, 2 for QPSK
    EsNo = EbNo + 10*log10(bps);       
    snrdB = EsNo + 10*log10(R);       % in dB
    noiseVar = 1./(10.^(snrdB/10)); 

 % Soft demodulate
   pbch_qpsk_demodulation = comm.QPSKDemodulator('BitOutput',true,...
    'DecisionMethod','Hard decision');
   
   v_pbch_data  = pbch_qpsk_demodulation(pbch_modulated_data');

   pbch_data =v_pbch_data';
    
end

%%
function pbch_descramble_data = pbch_descrambling_2(pbch_scrambled2_data)
disp("pbch_descrambling_2");

    global glo_ssb;
    global glo_cell;
 
    v_pbch_data_len= length(pbch_scrambled2_data);    
    
    if glo_ssb.param.Lssb == 4
         v_scramble_v = de2bi(glo_ssb.param.issb, 4); 
        v_scramble_v = v_scramble_v(3:4);
    else
         v_scramble_v = de2bi(glo_ssb.param.issb, 6);
        v_scramble_v =  v_scramble_v(4:6);
    end   

    v_scramble_v = bi2de(v_scramble_v,'left-msb');
    
    v_cinit =  glo_cell.param.physical_cell_identity.nid;
    v_pn_sequence_len = v_pbch_data_len+v_scramble_v*v_pbch_data_len;     % refer 38.211
    pn_sequence = pseudo_random_sequence(v_pn_sequence_len, v_cinit);
       
   for v_pn_sequence_num =0:v_pbch_data_len-1
       v_bitxor_sequence(v_pn_sequence_num+1) = pn_sequence(v_pn_sequence_num+v_scramble_v*v_pbch_data_len+1);
       
   end     
   
    v_pbch_scramble2_data = bitxor(pbch_scrambled2_data, v_bitxor_sequence);       
     pbch_descramble_data  = v_pbch_scramble2_data;
     
end

%%
function pbch_recover_rate_matching_data = pbch_dec_rate_matching(pbch_rate_matching_data)
disp("pbch_dec_rate_matching");

    K = 56;               % Message length in bits, including CRC, K > 24 for DL 
    E = 864;             % Rate matched output length, E <= 8192
    nMax = 9;           % Maximum value of n, for 2^n, Section 7.3.3, [7]
    iBIL = false;         % Interleave coded bits, Section 5.4.1.3, [38212]    
    
    F = h5gPolarConstruct(K,E,nMax);  % 0 for information, 1 for frozen
    N = length(F);                    % Mother code block length

    % Rate match
    v_pbch_rate_matching_data = h5gRateRecoverPolar(pbch_rate_matching_data,K,N,iBIL);    
       
    pbch_recover_rate_matching_data =v_pbch_rate_matching_data';
    
end


%%
function pbch_polar_decoded_data = pbch_dec_polar(pbch_polarred_data)
disp("pbch_dec_polar");

    % Downlink channel parameters (K > 24, including CRC bits)
    crcLen = 24;      % Number of CRC bits for DL, Section 5.1, [7]
    nPC = 0;          % Number of parity check bits, Section 5.3.1.2, [7]
    nMax = 9;         % Maximum value of n, for 2^n, Section 7.3.3, [7]
    iIL = true;       % Interleave input, Section 5.3.1.1, [7]
    iBIL = false;     % Interleave coded bits, Section 5.4.1.3, [7]
    K = 56;               % Message length in bits, including CRC, K > 24 for DL 
    E = 864;             % Rate matched output length, E <= 8192
    L = 8;              % List length, a power of two, [2 4 8]

    % Code construction
    F = h5gPolarConstruct(K,E,nMax);  % 0 for information, 1 for frozen
    N = length(F);                    % Mother code block length

    % Polar Decoder
    pbch_polarDec = h5gPolarDecoder(N,K,F,L,crcLen,'DeinterleaveOutput',iIL); 

    % Polar decode
    v_pbch_polar_decoded_data = pbch_polarDec(pbch_polarred_data');

    pbch_polar_decoded_data = v_pbch_polar_decoded_data';
end

%%
function pbch_decoded_crc24c_data = pbch_dec_crc24c(pbch_crc24_data)
disp("pbch_dec_crc24c");

     crcLen = 24;      % Number of CRC bits for DL, Section 5.1, [7]
    
     v_bch_data_len = length(pbch_crc24_data);
      
      v_pbch_raw_data  = pbch_crc24_data(1:v_bch_data_len- crcLen);
      v_pbch_raw_crc_24bits = pbch_crc24_data(v_bch_data_len- crcLen+1 : v_bch_data_len);

       % Number of CRC bits for DL, Section 5.1, [38212]
      v_pbch_decoded_crc24_data = h5gCRCEncode(v_pbch_raw_data,'24C');
      v_pbch_crc24_data = v_pbch_decoded_crc24_data';      
 
        pbch_decoded_crc24c_data =v_pbch_raw_data;    
        
end


function pbch_descramble1_data = pbch_descrambling_1(pbch_scrambled1_data)
disp("pbch_descrambling_1");

    global glo_ssb;
    global glo_cell;
    
    v_scramble1_bitmap = glo_ssb.data.pbch.scramble1.bitmap;
    
    [v_tmp, v_pbch_data_len] = size(pbch_scrambled1_data);    
     
    v_scramble_sfn_v = glo_ssb.param.sfn(8:9) ;
    v_scramble_sfn_v = bi2de(v_scramble_sfn_v,'left-msb');
   
    if glo_ssb.param.Lssb == 64
        v_scramble_M = v_pbch_data_len-6;
    else
        v_scramble_M = v_pbch_data_len-3;
    end   
      
   v_scramble_index_i =0;
   v_scramble_index_j =0;
   v_scramble_data = 0;
   
   v_cinit =  glo_cell.param.physical_cell_identity.nid;
   v_pn_sequence_len = 18+v_scramble_sfn_v*v_scramble_M;      %  32- sfn(10bits) - half bit(1bit) - ssb index(3bits)
   pn_sequence = pseudo_random_sequence(v_pn_sequence_len, v_cinit);
      
   while v_scramble_index_i < v_pbch_data_len
      
        if  v_scramble1_bitmap(v_scramble_index_i+1) == 0    
            v_scramble_sequence(v_scramble_index_i+1) =0;
         
        else              
            v_scramble_sequence(v_scramble_index_i+1) = pn_sequence(v_scramble_index_j+v_scramble_sfn_v*v_scramble_M+1);
            v_scramble_index_j = v_scramble_index_j +1;   
            
        end    
        
        v_scramble_index_i = v_scramble_index_i +1;
   end  
   
    v_pbch_descramble1_data = bitxor(pbch_scrambled1_data, v_scramble_sequence);     

    pbch_descramble1_data = v_pbch_descramble1_data;
end

function pbch_dec_mib_data = pbch_dec_payload(pbch_payload_data)
disp("pbch_dec_payload");

    global glo_ssb;
    v_bcch_bch_indicator_num =0;
    v_systemFrameNumber_num = 0;
    v_subCarrierSpacingCommon_num =0;
    v_ssb_SubcarrierOffset_num =0;
    v_drms_type_a_position_num =0;
    v_pdcch_ConfigSIB1_num =0;
    v_cellBarred_num =0;
    v_intraFreqReselection_num =0;
    v_spare_num =0;
    v_half_frame_bit_num =0;
    v_Kssb_num =0;
    v_ssb_index_num =0;
    
   v_pbch_bit_position =0;
    v_bit_index =0;
   v_bit_max_index = length(pbch_payload_data);     
     
    for v_bit_index = 0:1:v_bit_max_index-1
        v_pbch_bit_position = pbch_payload_interleaver_reverse_index(v_bit_index) ;
        v_pbch_bit_attr = glo_ssb.data.pbch.attr(v_pbch_bit_position+1);
        
        if  v_pbch_bit_attr == "bcch_bch_indicator"          
            glo_ssb.decoded.bcch_bch_indicator(v_bcch_bch_indicator_num+1) = pbch_payload_data(v_bit_index+1);
            v_bcch_bch_indicator_num = v_bcch_bch_indicator_num +1;
            
        elseif  v_pbch_bit_attr == "systemFrameNumber"             
            glo_ssb.decoded.systemFrameNumber(v_systemFrameNumber_num+1) = pbch_payload_data(v_bit_index+1);
            v_systemFrameNumber_num = v_systemFrameNumber_num +1;
            
        elseif  v_pbch_bit_attr == "subCarrierSpacingCommon"
            glo_ssb.decoded.subCarrierSpacingCommon(v_subCarrierSpacingCommon_num+1) = pbch_payload_data(v_bit_index+1);
            v_subCarrierSpacingCommon_num = v_subCarrierSpacingCommon_num +1;
            
        elseif  v_pbch_bit_attr == "ssb_SubcarrierOffset"
            glo_ssb.decoded.ssb_SubcarrierOffset(v_ssb_SubcarrierOffset_num+1) = pbch_payload_data(v_bit_index+1);
            v_ssb_SubcarrierOffset_num = v_ssb_SubcarrierOffset_num +1;
            
        elseif  v_pbch_bit_attr == "drms_type_a_position"
            glo_ssb.decoded.drms_type_a_position(v_drms_type_a_position_num+1) = pbch_payload_data(v_bit_index+1);
            v_drms_type_a_position_num = v_drms_type_a_position_num +1;   
            
        elseif  v_pbch_bit_attr == "pdcch_ConfigSIB1"
            glo_ssb.decoded.pdcch_ConfigSIB1(v_pdcch_ConfigSIB1_num+1) = pbch_payload_data(v_bit_index+1);
            v_pdcch_ConfigSIB1_num = v_pdcch_ConfigSIB1_num +1;   
            
        elseif  v_pbch_bit_attr == "cellBarred"
            glo_ssb.decoded.cellBarred(v_cellBarred_num+1) = pbch_payload_data(v_bit_index+1);
            v_cellBarred_num = v_cellBarred_num +1;   
            
        elseif  v_pbch_bit_attr == "intraFreqReselection"
            glo_ssb.decoded.intraFreqReselection(v_intraFreqReselection_num+1) = pbch_payload_data(v_bit_index+1);
            v_intraFreqReselection_num = v_intraFreqReselection_num +1;             
        
        elseif  v_pbch_bit_attr == "half_frame_bit"
            glo_ssb.decoded.half_frame_bit(v_half_frame_bit_num+1) = pbch_payload_data(v_bit_index+1);
            v_half_frame_bit_num = v_half_frame_bit_num +1; 
           
        elseif  v_pbch_bit_attr == "Kssb"
            glo_ssb.decoded.Kssb(v_Kssb_num+1) = pbch_payload_data(v_bit_index+1);
            v_Kssb_num = v_Kssb_num +1; 
            
        elseif  v_pbch_bit_attr == "ssb_index"
            glo_ssb.decoded.ssb_index(v_ssb_index_num+1) = pbch_payload_data(v_bit_index+1);
            v_ssb_index_num = v_ssb_index_num +1;
            
        else             
           %elseif v_pbch_bit_attr == "spare"
            glo_ssb.decoded.spare(v_spare_num+1) = pbch_payload_data(v_bit_index+1);
            v_spare_num = v_spare_num +1;   
            
        end     
            
    end 
    
    pbch_dec_mib_data =0;
    
end

function payload_bit_index = pbch_payload_interleaver_reverse_index(interleaved_bit_index)
  
    global glo_pbch_payload_interleaver_patter;    
    
    v_table_bit_index =0;
    v_table_bit_max_index =0;    
    
    v_table_bit_max_index = length(glo_pbch_payload_interleaver_patter);    
    
    if interleaved_bit_index >= 32 
        error("fun(pbch_payload_interleaver_reverse_index): input parameter error")
    end    
  
    for v_table_bit_index=0:1: v_table_bit_max_index-1            
        
        if glo_pbch_payload_interleaver_patter(v_table_bit_index+1) == interleaved_bit_index
            payload_bit_index = v_table_bit_index;
            break;  
            
        end
    
    end     

end

