%%
% generation_ssb() function creates only one ssb block
% one ssb block has threee symbols,  from the  first symbol 0 and first frequency 0  (one ssb, 4 symbol length, 240 scs bandwith)

function ssb=generation_ssb(issb_index)
disp("fun: generation_ssb");

global glo_ssb;
global glo_cell;
global FFT_SIZE;

% output ssb, only one ssb block

%  glo_ssb.param.issb used in generation_pbch() and generation_pbch_dmrs() functions
%  the bit data for pbch and pbch dmrs have related with ssb index
glo_ssb.param.issb = issb_index ;

% generate primary synchronization signal
generation_pss();

% generate secondary synchronization signal
generation_sss();

% the procedures related with pbch data and channel coding
generation_pbch();

% the procedures related with creating pbch dmrs
generation_pbch_dmrs();

% glo_ssb.data.pbch.qpsk, the data generated in  generation_pbch() function
% glo_ssb.data.pbch_dmrs;   the data generated in generation_pbch_dmrs() function
a_pss = glo_ssb.data.pss;
a_sss = glo_ssb.data.sss;
a_pbch = glo_ssb.data.pbch.qpsk;
a_pbch_dmrs = glo_ssb.data.pbch_dmrs;
v_n_cellid = glo_cell.param.physical_cell_identity.nid;      % defined in gobal_parameter()

a_ssb =zeros(FFT_SIZE, 4);
v_pss_pos =0;
v_sss_pos =0;
v_pbch_pos=0;
v_pbch_dmrs_pos =0;

% generate ssb block with pss, sss, pbch and pbch dmrs
% refer 3gpp 38.211 chapter

v_tmp_symbol = 0;
for k=56:1:182
    a_ssb(k+1,1+v_tmp_symbol) = a_pss(v_pss_pos+1);
    v_pss_pos = v_pss_pos +1;
end

v = mod(v_n_cellid, 4);
v_tmp_symbol = 1;

for k=0:1:239
    if mod(k,4) == v
        a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch_dmrs(v_pbch_dmrs_pos+1);
        v_pbch_dmrs_pos = v_pbch_dmrs_pos +1;
    else
        a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch(v_pbch_pos+1);
        v_pbch_pos = v_pbch_pos+1;
    end
end

v_tmp_symbol =2;

for k=0:1:47
    if mod(k,4) == v
        a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch_dmrs(v_pbch_dmrs_pos+1);
        v_pbch_dmrs_pos = v_pbch_dmrs_pos +1;
    else
        a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch(v_pbch_pos+1);
        v_pbch_pos = v_pbch_pos+1;
    end
end

for k=56:1:182
    a_ssb(k+1,1+v_tmp_symbol) = a_sss(v_sss_pos+1);
    v_sss_pos = v_sss_pos +1;
end

for k=192:1:239
    if mod(k,4) == v
        a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch_dmrs(v_pbch_dmrs_pos+1);
        v_pbch_dmrs_pos = v_pbch_dmrs_pos +1;
    else
        a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch(v_pbch_pos+1);
        v_pbch_pos = v_pbch_pos+1;
    end
end

v_tmp_symbol =3;

for k=0:1:239
    if mod(k,4) == v
        a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch_dmrs(v_pbch_dmrs_pos+1);
        v_pbch_dmrs_pos = v_pbch_dmrs_pos +1;
    else
        a_ssb(k+1, 1+v_tmp_symbol)  = a_pbch(v_pbch_pos+1);
        v_pbch_pos = v_pbch_pos+1;
    end
end

ssb = a_ssb;
glo_ssb.data.ssb = a_ssb;
synchornization_signal_block = a_ssb;

end



