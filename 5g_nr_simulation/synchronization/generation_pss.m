function  pss_sequence = generation_pss()
disp("fun: generation_pss");

    global glo_cell;     
    global glo_ssb;
    
    v_nid2 = glo_cell.param.physical_cell_identity.nid2;

    x = zeros(1,100);
    
    x(1+0)= 0;
    x(1+1)= 1;
    x(1+2)= 1;
    x(1+3)= 0;
    x(1+4)= 1;
    x(1+5)= 1;
    x(1+6)= 1;
        
    for k=0:1:120
        x(k+1+7) = mod((x(k+1+4) + x(k+1)), 2);    
    end    
                 
    for  n=0:1:(127-1)        
         m = mod((n + 43*v_nid2), 127);
        pss_sequence(n+1) = 1 -  2*x(m+1);
    end    
  
      glo_ssb.data.pss = pss_sequence;
      
      primary_synchronization_signal =  glo_ssb.data.pss;

end