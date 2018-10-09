function pbch_qpsk_data =  generation_pbch()
disp("fun: generation_pbch");

% output:  glo_ssb.data.pbch.qpsk , pbch data  for physical mapping
% input:  mib data generated in  generation_mib() function, the generation_mib() function is invoked in synchrnization_parameter()

global glo_ssb;

% the more detailed information, please refer 38.211 and 38.212
v_pbch_enc_raw_data =  pbch_payload_generation();
v_pbch_enc_scramble1_data = pbch_scrambling_1(v_pbch_enc_raw_data) ;
v_pbch_enc_crc24_data = pbch_crc24c(v_pbch_enc_scramble1_data);
v_pbch_enc_polarred_data = pbch_polar(v_pbch_enc_crc24_data);
v_pbch_enc_rate_matching_data = pbch_rate_matching(v_pbch_enc_polarred_data);
v_pbch_enc_scramble2_data  =  pbch_scrambling_2(v_pbch_enc_rate_matching_data);
v_pbch_enc_qpsk_data = pbch_modulation(v_pbch_enc_scramble2_data);

glo_ssb.data.pbch.qpsk = v_pbch_enc_qpsk_data;
physical_broadcast_channel_data  = glo_ssb.data.pbch.qpsk;

end

%%
function pbch_interleaved_data =  pbch_payload_generation()
disp("pbch_payload_generation")

% input:  mib data generated in  generation_mib() function, the generation_mib() function is invoked in synchrnization_parameter()
% glo_ssb.data.pbch.data
% glo_ssb.data.pbch.attr
% append 8 bit data

pbch_interleaved_data =0;

global glo_ssb;
global glo_pbch_payload_interleaver_patter;

% get the 4 least bits of SFN
v_least_sfn_4bits.data  = glo_ssb.param.sfn(7:10);
v_least_sfn_4bits.attr = ["SFN4"  "SFN3"  "SFN2"  "SFN1"];

% get half frame bit defined in synchronization_parameter() function
v_half_frame_bit.data = glo_ssb.param.half_frame_indicator;
v_half_frame_bit.attr = ["half_frame_bit"];

% Lssb value maybe 4,8,64
v_Lssb =  glo_ssb.param.Lssb;

% pbch and appendix bits interleve table
% 38.212 Table 7.1.1-1: Value of PBCH payload interleaver pattern
v_interleaver_pattern = glo_pbch_payload_interleaver_patter;

v_timing_related_pbch_payload_bit.data =  [v_least_sfn_4bits.data   v_half_frame_bit.data];
v_timing_related_pbch_payload_bit.attr =    [v_least_sfn_4bits.attr     v_half_frame_bit.attr];

v_issb = glo_ssb.param.issb ;
if v_Lssb == 64
    disp("Lssb=64")
    v_issb_binary = de2bi(v_issb,  6, 'left-msb');
    v_ssb_indx_456bit.data = v_issb_binary(4:6)
    v_ssb_indx_456bit.attr = ["ssb_index"  "ssb_index" "ssb_index"];
    v_timing_related_pbch_payload_bit.data = [v_timing_related_pbch_payload_bit.data  v_ssb_indx_456bit.data];
    v_timing_related_pbch_payload_bit.attr = [v_timing_related_pbch_payload_bit.attr  v_ssb_indx_456bit.attr];
else
    v_most_kssb_1bit.data =  glo_ssb.param.kssb;  % only one bit
    v_most_kssb_1bit.attr =["Kssb"];
    v_timing_related_pbch_payload_bit.data = [v_timing_related_pbch_payload_bit.data  v_most_kssb_1bit.data];
    v_timing_related_pbch_payload_bit.attr = [v_timing_related_pbch_payload_bit.attr  v_most_kssb_1bit.attr];
    
    v_issb_binary = de2bi(v_issb,  5, 'left-msb') ;
    v_ssb_indx_45bit.data = v_issb_binary(4:5);
    v_ssb_indx_45bit.attr = ["ssb_index"  "ssb_index"];
    v_timing_related_pbch_payload_bit.data = [v_timing_related_pbch_payload_bit.data  v_ssb_indx_45bit.data];
    v_timing_related_pbch_payload_bit.attr = [v_timing_related_pbch_payload_bit.attr  v_ssb_indx_45bit.attr];
    
end

a_pbch.data = [glo_ssb.data.pbch.mib.data  v_timing_related_pbch_payload_bit.data] ;
a_pbch.attr =   [glo_ssb.data.pbch.mib.attr    v_timing_related_pbch_payload_bit.attr ];

% save the pbch raw data (32 bits ) and their attribution
% use the  glo_ssb.data.pbch.attr to decode the pbch data

glo_ssb.data.pbch.data = a_pbch.data ;
glo_ssb.data.pbch.attr = a_pbch.attr;

% interleaving for pbch payload data
% the initial value come from 38.212

[v_tmp, v_bit_index_max_num] = size(a_pbch.data) ;
[v_tmp, v_pbch_mib_len] =size(glo_ssb.data.pbch.mib.data);
v_bit_index_num =0;

% refer to 38.211 for pbch payload interleave parameters
% caution, the sequence subscript from 0 start
v_j_sfn =0;
v_j_hrf =10;
v_j_ssb=11;
j_other=14;

% generate 32 pbch bits data with interleaved procedure

for v_bit_index_num =0:1:v_bit_index_max_num-1    
    
    if  strncmp(a_pbch.attr(v_bit_index_num+1), "SFN", 3) == true
        disp("SFN");
        a_interleave_pbch.data(glo_pbch_payload_interleaver_patter(v_j_sfn+1)+1) =  a_pbch.data(v_bit_index_num+1);
        a_interleave_pbch.attr(glo_pbch_payload_interleaver_patter(v_j_sfn+1)+1)  = a_pbch.attr(v_bit_index_num+1) ;
        v_j_sfn = v_j_sfn +1;
        
    elseif a_pbch.attr(v_bit_index_num+1) == "half_frame_bit"
        disp("half_frame_bit");
        a_interleave_pbch.data(glo_pbch_payload_interleaver_patter(v_j_hrf+1)+1) =  a_pbch.data(v_bit_index_num+1);
        a_interleave_pbch.attr(glo_pbch_payload_interleaver_patter(v_j_hrf+1)+1)  = a_pbch.attr(v_bit_index_num+1);
        
    elseif   v_bit_index_num+1 >=v_pbch_mib_len+1+5 &&  v_bit_index_num+1 <= v_pbch_mib_len+1+7
        disp("issb index");
        a_interleave_pbch.data(glo_pbch_payload_interleaver_patter(v_j_ssb+1)+1) =  a_pbch.data(v_bit_index_num+1);
        a_interleave_pbch.attr(glo_pbch_payload_interleaver_patter(v_j_ssb+1)+1)  = a_pbch.attr(v_bit_index_num+1);
        v_j_ssb = v_j_ssb +1;
        
    else
        disp("mib data");
        a_interleave_pbch.data(glo_pbch_payload_interleaver_patter(j_other+1)+1) =  a_pbch.data(v_bit_index_num+1);
        a_interleave_pbch.attr(glo_pbch_payload_interleaver_patter(j_other+1)+1)  = a_pbch.attr(v_bit_index_num+1) ;
        j_other = j_other +1;
        
    end
    
end

% 32 bit raw data (payload interleaved PBCH data)
pbch_interleaved_data =  a_interleave_pbch;

end

%%

function  pbch_scramble1 = pbch_scrambling_1(pbch_data)
disp("pbch_scrambling_1")

% The bits for corresponds to any one of the bits belonging to the SS/PBCH block index, the half radio frame index, 
% and 2nd and 3rd least significant bits of the system frame number,  these bits are need not scrambles

% input:  pbch_data,  32 interleaved bit sequece with 32 string attribution
% pbchd_data has two dimenstion, one for data bit sequence and one for attribution

global glo_ssb;
global glo_cell;

[v_tmp, v_pbch_data_len] = size(pbch_data.data);

v_scramble_sfn_v = glo_ssb.param.sfn(8:9) ;                      %  least significant 2 bits
v_scramble_sfn_v = bi2de(v_scramble_sfn_v,'left-msb');

if glo_ssb.param.Lssb == 64
    v_scramble_M = v_pbch_data_len-6;
else
    v_scramble_M = v_pbch_data_len-3;
end

% local variables 
v_scramble_index_i =0;
v_scramble_index_j =0;
v_scramble_data = 0;

% glo_ssb.data.pbch.scramble1.bitmap is used to record the scramble bit during scramble1 procedure.
% v_scramble1_bitmap record the scramble bit position, 0 = no scramble, 1= scrambled, and save to glo_ssb.data.pbch.scramble1.bitmap at last.
% the  glo_ssb.data.pbch.scramble1.bitmap will be used to decode the recieve the pbch data.
v_scramble1_bitmap =0;

% the more detailed information, refer to 3gpp 38.212 
v_cinit =  glo_cell.param.physical_cell_identity.nid;
v_pn_sequence_len = 26+v_scramble_sfn_v*v_scramble_M;      %  32- sfn(2bits) - half bit(1bit) - ssb index(3bits)
pn_sequence = pseudo_random_sequence(v_pn_sequence_len, v_cinit);

while v_scramble_index_i < v_pbch_data_len
    
    if  (pbch_data.attr(v_scramble_index_i+1) == "SFN2")  ||   (pbch_data.attr(v_scramble_index_i+1) == "SFN3")  || ...
        (pbch_data.attr(v_scramble_index_i+1) == "half_frame_bit")  ||  (pbch_data.attr(v_scramble_index_i+1) == "ssb_index")  || ...
        (pbch_data.attr(v_scramble_index_i+1) == "Kssb")
        v_scramble_sequence(v_scramble_index_i+1) =0;
        
        v_scramble1_bitmap(v_scramble_index_i+1) = 0;
        
    else
        v_scramble_sequence(v_scramble_index_i+1) = pn_sequence(v_scramble_index_j+v_scramble_sfn_v*v_scramble_M+1);
        v_scramble_index_j = v_scramble_index_j +1;
        
        v_scramble1_bitmap(v_scramble_index_i+1) = 1;
        
    end
    
    v_scramble_index_i = v_scramble_index_i +1;
end

v_pbch_scramble1 = bitxor(pbch_data.data, v_scramble_sequence);
glo_ssb.data.pbch.scramble1.bitmap = v_scramble1_bitmap; 

pbch_scramble1 =v_pbch_scramble1;
end

%%
function pbch_crc24_data = pbch_crc24c(pbch_data)
disp("fun: pbch_crc24c")

% input 32 bits PBCH data
% output 32+24 = 56 bits PBCH data

% Number of CRC bits for DL, Section 5.1, [38212]
v_pbch_crc24_data = h5gCRCEncode(pbch_data,'24C');
pbch_crc24_data = v_pbch_crc24_data';

end

%%
function pbch_polarred_data = pbch_polar(pbch_data)
disp("pbch_polar");

% input 56 bits pbch data  (32 pbch data with 24 bits crc)

v_message_len = length(pbch_data);
% Code parameters
K = v_message_len;                   % Message length in bits, including CRC, K > 24 for DL
E = 864;                                       % Rate matched output length, E <= 8192

% Downlink channel parameters (K > 24, including CRC bits)
nPC = 0;               % Number of parity check bits, Section 5.3.1.2, [38212]
nMax = 9;              % Maximum value of n, for 2^n, Section 7.3.3, [38212]
iIL = true;               % Interleave input, Section 5.3.1.1, [38212]
iBIL = false;            % Interleave coded bits, Section 5.4.1.3, [38212]

F = h5gPolarConstruct(K,E,nMax);  % 0 for information, 1 for frozen
N = length(F);                                     % Mother code block length

% Polar Encoder
%   CodewordLength     - Code word length (N)
%   MessageLength        - Message length (K)
%   FrozenBits                 - Frozen bit vector of length N (F)
%   InterleaveInput          - Interleave input

polarEnc = h5gPolarEncoder(N,K,F,'InterleaveInput',iIL);

v_pbch_polarred_data = polarEnc(pbch_data);
pbch_polarred_data = v_pbch_polarred_data';

end

%%
function pbch_rate_matching_data = pbch_rate_matching(pbch_data)
disp("pbch_rate_matching");

K = 56;                  % Message length in bits, including CRC, K > 24 for DL
E = 864;                % Rate matched output length, E <= 8192
iBIL = false;           % Interleave coded bits, Section 5.4.1.3, [38212]

% Rate match
v_pbch_rate_matching_data = h5gRateMatchPolar(pbch_data,K,E,iBIL);
pbch_rate_matching_data = v_pbch_rate_matching_data';

end

%%
function pbch_scramble2_data = pbch_scrambling_2(pbch_data)
disp("pbch_scramble2_data");

global glo_ssb;
global glo_cell;

v_pbch_data_len= length(pbch_data);

if glo_ssb.param.Lssb == 4
    v_scramble_v = de2bi(glo_ssb.param.issb, 4, 'left-msb');
    v_scramble_v = v_scramble_v(3:4);
else
    v_scramble_v = de2bi(glo_ssb.param.issb, 6, 'left-msb');
    v_scramble_v =  v_scramble_v(4:6);
end

v_scramble_v = bi2de(v_scramble_v,'left-msb');

v_cinit =  glo_cell.param.physical_cell_identity.nid;
v_pn_sequence_len = v_pbch_data_len+v_scramble_v*v_pbch_data_len;     % refer 38.211
pn_sequence = pseudo_random_sequence(v_pn_sequence_len, v_cinit);

for v_pn_sequence_num =0:v_pbch_data_len-1
    v_bitxor_sequence(v_pn_sequence_num+1) = pn_sequence(v_pn_sequence_num+v_scramble_v*v_pbch_data_len+1);
end

v_pbch_scramble2_data = bitxor(pbch_data, v_bitxor_sequence);
pbch_scramble2_data = v_pbch_scramble2_data;

end

function pbch_qpsk_data = pbch_modulation(pbch_data)
disp("pbch_modulation");

% input:     pbch data, 864 bits 
% output:   pbch data, 432 qpsk symbols

% QPSK modulation 
pbch_qpsk_modulation_function = comm.QPSKModulator('BitInput', true);
v_pbch_qpsk_data = pbch_qpsk_modulation_function(pbch_data');

pbch_qpsk_data = v_pbch_qpsk_data';

end




