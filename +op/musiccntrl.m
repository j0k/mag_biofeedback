classdef musiccntrl < handle
    %MUSICCNTRL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        t; %tcpip
        minV = NaN;
        maxV = NaN;
        port = 19999;
        volumes = [];
        power = [];
        M = 300;
        lasNumPower = 50;
        
        avgAmp = 0;
        maxAmp = 0;
        feedback_syncvolume = true;
    end
    
    methods
        function obj  = musiccntrl()
            obj.t =  tcpip('localhost', 19999, 'NetworkRole', 'server');
        end
        
        function [] = setPositiveFeedbacktype(obj, biotype)
            obj.feedback_syncvolume = biotype;
        end
        
        function [] = setAmps(obj, avgAmp, maxAmp)
            obj.avgAmp = avgAmp;
            obj.maxAmp = maxAmp;
        end
        
        function [dres] = stand(obj)
            fopen(obj.t);
            dres = 10;
        end

        function [dres] = restart_data(obj)
            minV = NaN;
            maxV = NaN;
            volumes = [];
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
        
        %handles.musc.calcVolume(d_power, d_raw, handles.data.d, handles.data.draw);
        function [value] = calcVolume(obj, d_power, d_raw, d, draw)
            
            dr = op.last (draw, length(d_raw) * 2);
            
            drMaxAmp = sort(abs(dr - mean(dr)));
            drMaxAmp = mean( op.last(drMaxAmp,3));
            
            value = NaN;
            if (drMaxAmp > 1.5 * obj.maxAmp)
                % artefact
            else
                obj.power = op.addD(obj.power, d_power, obj.M);
                value = setNewVolume(obj, obj.power);
            end
            %if (draw)
        end
        
        function [c] = setNewVolume(obj, d)
            c = NaN;
            if (length(d) > 0) 
                m = min(d);
                m = min(m,obj.minV);
                obj.minV = m;
                
                M = max(d);
                M = max(M,obj.maxV);
                obj.maxV = M;
                
                c = mean( op.last(d, obj.lasNumPower) ); %d(end);
                
                if (~ (M - m) == 0)
                    % M - c
                    if (obj.feedback_syncvolume)
                        % positive biofeedback
                        c = round(100 * ((c-m)/(M-m)));
                    elseif (~ obj.feedback_syncvolume)
                        % negative biofeedback
                        c = round( abs( 100 * ((c-M)/(M-m)) ));
                    end
                end
                
                if (obj.connected())
                   fwrite(obj.t, obj.volumeMessage(c));
                   
                   fwrite(obj.t, 13); % '\n'
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

