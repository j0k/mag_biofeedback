classdef data < handle
    %DATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        d = [];
        m = 300; % MAX
    end
    
    methods
        function obj  = data()
        end
        
        function [dres] = add(obj, d_recv)
            obj.d = op.addD(obj.d, d_recv, obj.m);
            dres = obj.d;
        end
    end
    
end


