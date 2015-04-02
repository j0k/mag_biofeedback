function [ Ares] = last( A, maxl)
    % add B to A
    la = length(A);
    Ares = [];
    if ( la > maxl)
        Ares = A((la - maxl + 1):end);
    else
        Ares = A;
    end
end
