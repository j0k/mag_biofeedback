function [ Ares] = addD( A, B, maxl)
    % add B to A
    la = length(A);
    lb = length(B);
    lA = la+lb;
    
    if (lA >= maxl)
        if (lb >= maxl)
            Ares = B((end - maxl)+1:end);
        else
            ind = max(1, 1+ la-(maxl-lb));
            Ares = [ A(ind:end), B];
        end
    else
        Ares = [A,B];
    end
end

