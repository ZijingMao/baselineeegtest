classdef second_class < first_class
    %SECOND_CLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        GPU_name = 'NVIDIA GeForce 9300 GS';
        CUDA_Toolkit = 'v.4.0';
        CUDA_CC = 2.0;
    end
    
    properties
        Z
        Y
        XXX
    end
    
    methods
        function obj = second_class(measuarizer) %constructor method?
            obj.Z = 22*rand;
            obj.Y = 10*rand;
            measuarizer = measuarizer + sqrt(obj.Z^2 + obj.Y^2);
            obj.XXX = 10*measuarizer;
        end
        
        function disp(obj)
            disp(obj.XXX);
        end
    end
end

