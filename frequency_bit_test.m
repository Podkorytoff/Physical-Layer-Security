function p_value = frequency_bit_test(key)
    
    for idx = 1:length(key)
        if(key(idx) == 0)
            key(idx) = -1;
        end
    end
    S = abs(sum(key))/sqrt(length(key));
    p_value = erfc(S/sqrt(2));
    
    
  
            