function [ d, t ] = recv( inlet )
%RECV Summary of this function goes here
%   Detailed explanation goes here
d = [];
t = [];
if (~ isempty(inlet))
    [d, t] = inlet.pull_chunk();
end

end

