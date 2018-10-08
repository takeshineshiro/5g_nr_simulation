function  sss_sequence = generation_sss()
disp("function: generation_sss");

    global glo_cell;
    global glo_ssb;    
    
    v_nid1 = glo_cell.param.physical_cell_identity.nid1;
    v_nid2 = glo_cell.param.physical_cell_identity.nid2;   

    x0(1+0) = 1;
    x0(1+1) = 0;
    x0(1+2) = 0;
    x0(1+3) = 0;
    x0(1+4) = 0;
    x0(1+5) = 0;
    x0(1+6) = 0;

    x1(1+0) = 1;
    x1(1+1) = 0;
    x1(1+2) = 0;
    x1(1+3) = 0;
    x1(1+4) = 0;
    x1(1+5) = 0;
    x1(1+6) = 0;
    
    for k=0:1:120
        x0(k+1+7) = mod((x0(k+1+4) + x0(k+1)) , 2);
        x1(k+1+7) = mod((x1(k+1+1) +(k+1)), 2);
    end
    
    for n=0:1:(127-1)
        m0 = 15*floor(v_nid1/112) + 5*v_nid2; 
        m1= mod(v_nid1, 112);        
        sss_sequence(n+1) = (1-2*x0(mod(n+m0, 127)+1)) * (1-2*x1(mod(n+m1, 127)+1));
    end

    glo_ssb.data.sss= sss_sequence;
    
    secondary_synchronization_signal = glo_ssb.data.sss;

end