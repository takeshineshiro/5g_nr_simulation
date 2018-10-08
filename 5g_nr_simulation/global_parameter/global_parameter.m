function global_parameter()
disp("fun: global_parameter");

    global glo_cell;
    global FFT_SIZE;
    global glo_cp_mode;
       
    FFT_SIZE =4096;
    glo_cp_mode.normal_cp = 14;
    glo_cp_mode.extend_cp =12;
    
   
    glo_cell.param.physical_cell_identity.nid1 =1;
    glo_cell.param.physical_cell_identity.nid2 =1;
    glo_cell.param.physical_cell_identity.nid =0;
    
    glo_cell.param.subframe.length =2; % simulation subframe length
    glo_cell.param.subframe.u=0;
    glo_cell.param.subframe.symbols =0;
    glo_cell.param.subframe.slots =0;
    glo_cell.param.pointA =0;
    
    glo_cell.param.physical_cell_identity.nid = 3*glo_cell.param.physical_cell_identity.nid1 + glo_cell.param.physical_cell_identity.nid2;
    glo_cell.param.subframe.slots = power(2, glo_cell.param.subframe.u);
    glo_cell.param.subframe.symobls =  glo_cp_mode.normal_cp * glo_cell.param.subframe.slots;
   
end
