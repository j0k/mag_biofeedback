function [ result, inlet ] = conn( res, lib, eeg)
%CONN Summary of this function goes here
%   Detailed explanation goes here
result = res;

if isempty(res)
    result = lsl_resolve_byprop(lib, 'type', eeg);
end

inlet = {};
if (~ isempty(result))
    disp('conn inlet');
    inlet = lsl_inlet(result{1});
end    

end

