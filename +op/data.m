classdef data < handle
    %DATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        d = [];
        draw = [];
        dvol = [];
        m = 300; % MAX
        mraw = 600; 
    end
    
    methods
        function obj  = data()
        end
        
        function [dres] = add(obj, d_recv)
            obj.d = op.addD(obj.d, d_recv, obj.m);
            dres = obj.d;
        end
        
        function [dres] = addRaw(obj, d_recv)
            obj.draw = op.addD(obj.draw, d_recv, obj.mraw);
            dres = obj.draw;
        end
        
        function [dres] = addVol(obj, d_recv)
            obj.dvol = op.addD(obj.dvol, d_recv, obj.m);
            dres = obj.dvol;
        end
        
    end
    
end


