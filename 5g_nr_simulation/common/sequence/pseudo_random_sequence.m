%%  pseudo_random_sequence

function pn_sequence = pseudo_random_sequence(pn_length, cinit)

    nc=1600;
    
    v_pn_sequence =0;

    x1 = zeros(1,31);
    x1(1+0) =1;
    
    % Convert decimal numbers to binary vectors  
    x2 = de2bi(cinit);
        
    for k=0:1:(pn_length-1+nc)
        x1(k+1+31) = mod((x1(k+1+3)+x1(k+1)), 2);
        x2(k+1+31) = mod((x1(k+1+3)+x1(k+1+2)+x1(k+1+1)+x2(k+1+0)), 2);
    end
    
    for n=0:1:pn_length-1
        v_pn_sequence(n+1) = mod((x1(n+1+nc) + x2(n+1+nc)), 2);
    end     
  
     pn_sequence =  v_pn_sequence;
    
end






