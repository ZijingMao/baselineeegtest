classdef first_class
    %FIRST_CLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties              % block of normal variables
        Symbol
        OpeningPrice
    end
    
    properties (GetAccess='private', SetAccess='private') % Private v.
        X_side
        Y_side
    end
    
    properties (Constant)   % block of constant variables
        initial = 0.65;
        final = 12.86
    end
    
    methods
        function [res1, res2] = calculate_res(obj, zpt)  % a general function (method)
            obj.Symbol = rand*rand*rand^rand;
            obj.OpeningPrice = 465;
            res1 = obj.Symbol^2 + 232;
            res2 = sqrt(zpt) + res1^11;
        end
        
         function var2 = view_private(obj, var1)        % only the methods like this one
            obj.X_side = 64;                            % can operate over the private porperties
            obj.Y_side = 645^rand*32;
            var1 = var1*obj.X_side;
            var2 = sqrt(obj.Y_side+obj.X_side) + var1^11;
        end
    end
                
end

