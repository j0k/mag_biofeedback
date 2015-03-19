classdef musiccntrl < handle
    %MUSICCNTRL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        t;
        minV = NaN;
        maxV = NaN;
        port = 19999;
    end
    
    methods
        function obj  = musiccntrl()
            obj.t =  tcpip('localhost', 19999, 'NetworkRole', 'server');
        end
        
        function [dres] = stand(obj)
            fopen(obj.t);
            dres = 10;
        end
        
        function [dres] = restart(obj)
            if obj.connected()
                fclose(obj.t);
            end
            obj.stand();
        end
        
        function [t] = connected(obj)
            t = 0;
            if (strcmp(obj.t.Status, 'open'))
                t = 1;
            end
        end
        
        function [t] = setNewVolume(obj, d)
            if (length(d) > 0) 
                m = min(d);
                m = min(m,obj.minV);
                obj.minV = m;
                
                M = max(d);
                M = max(M,obj.maxV);
                obj.maxV = M;
                
                c = d(end);
                if (~ (M - m) == 0)
                    c = round(100 * ((M - c)/(M-m)));
                end
                
                if (obj.connected())
                   fwrite(obj.t, obj.volumeMessage(c));
                   fwrite(obj.t, 13);
                   fwrite(obj.t, 10);
                end
            end
        end
        
        function [str] = volumeMessage(obj,v)
            s = struct ;
            s.command = 'setVolume';
            s.value = v;
            
            str = savejson('',s,'Compact',1);
        end
    end
    
end

