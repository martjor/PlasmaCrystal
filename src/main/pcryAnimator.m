classdef pcryAnimator
    properties (Access=public)
        AnimFunc
        BatchSize = 50;
    end

    methods
        % Class Constructor
        function obj = pcryAnimator(func)
            % Initialize plot function
            obj.AnimFunc = func;
        end


        function plotFrame(obj,n)
            obj.AnimFunc(n);
        end

        function animate(obj,frameVec)
            % Determine number of frames
            numFrames = numel(frameVec);

            % Get current figure and axes
            fig = gcf;
            gca;

            % Animate
            i = 1;
            while (i <= numFrames) && isvalid(fig)
                cla
                obj.plotFrame(frameVec(i))
                drawnow
                
                i = i + 1;
            end
        end

        function recordVideo(obj,frameVec,fileName,varargin)
            % Determine the number of frames
            numFrames = numel(frameVec);
            frameLast = frameVec(end);
            frameFirst = frameVec(1);

            % Generate struct to store data
            M(obj.BatchSize) = struct('cdata',[],'colormap',[]);

            % Get current figure and axes
            fig = gcf;
            fig.Visible = 'off';
            gca;

            % Create VideoWriter and open file
            video = VideoWriter(fileName);
            video.Quality = 100;
            open(video);

            % Animate and record
            i = 1; j = 0;
            while (i <= numFrames) && isvalid(fig)
                % Generate plot
                cla
                obj.plotFrame(frameVec(i))
                drawnow

                % Store frame
                cdata = print('-RGBImage','-r300');
                M(j+1) = im2frame(cdata);

                % Update
                percent = i/numFrames * 100;
                fprintf("Generating frame %i (%.1f%%)\n",frameVec(i),percent);

                % Update batch index
                j = j+1;
                if (mod(j,obj.BatchSize) == 0) || (j == numFrames)
                    numFramesGenerated = j;
                    j = 0;
                end
    
                % Write batch
                if (j==0) && (i~=1) 
                    fprintf("\tWriting...\n")
                    writeVideo(video,M(1:numFramesGenerated));
                    fprintf("\tDone.\n")
                end
                i = i + 1;
            end

            % Close video
            close(video);
        end

        % SETTERS
        function obj = set.BatchSize(obj,n)
            obj.BatchSize = n;
        end
    end
end
