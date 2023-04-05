classdef pcryAnimator
    properties (Access=public)
        FileName
        AnimFunc
    end
    properties (Access=private)
        VideoWriter
    end

    methods
        function obj = pcryAnimator(fileName,func)
            % Initialize variables
            obj.FileName = fileName; 
            obj.AnimFunc = func;

            % Initialize VideoWriter
            obj.VideoWriter = VideoWriter(obj.FileName);
        end

        function plotFrame(obj,n)
            gcf
            obj.AnimFunc(n);
        end

        function print(obj)
            disp(obj.FileName);
        end

    end
end
