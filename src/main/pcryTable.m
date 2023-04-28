classdef pcryTable
    % Public properties
    properties (Access=public)
       Data
    end

    % Dependent properties
    properties (Dependent)
        NumFrames
        NumParticles
        NumParticlesMean
    end

    % Private properties
    properties (Access=private)

    end

    % Public methods
    methods (Access=public)
        % Class constructor
        function obj = pcryTable(table)
            % Format table data
            obj.Data = obj.formatTable(table);
        end

        % Name:
        % Description:
        function [table,idx] = get(obj,parameter,n)
            parameter = lower(parameter);

            if strcmp(parameter,'particle')
                if (n < 1) || (n > obj.NumParticles)
                    error("Particle number must be in the range [1,%i]",obj.NumParticles)
                end
            elseif strcmp(parameter,'frame')
                if (n < 1) || (n > obj.NumFrames)
                    error("Frame number must be in the range [1,%i]",obj.NumFrames)
                end
            end

            idx = find(obj.Data.(parameter) == n);
            table = obj.Data(idx,:);
        end

        % Name:             FrameMean
        % Description:
        function FrameMean = FrameMean(obj)
            numParticles = obj.NumParticles;

            % Create mean frame table
            x = zeros(numParticles,1);
            y = zeros(numParticles,1);
            numFrames = zeros(numParticles,1);

            for i = 1:numParticles
                frame = obj.get('particle',i);
                
                % Calculate the mean position of the particles
                x(i) = mean(frame.x);
                y(i) = mean(frame.y);

                % 

                % Calculate the number of frames the particle was visible
                numFrames(i) = size(frame,1);
            end
            
            % Calculate visibility of the particle
            visibility = numFrames / obj.NumFrames;

            

            % Create table
            particle = (1:numParticles)';
            FrameMean = table(particle,x,y,numFrames,visibility);
        end
    end

    % Private methods
    methods (Access=private)
    end

    methods
        % Name:
        % Description:
        function numFrames = get.NumFrames(obj)
            numFrames = max(obj.Data.frame);
        end

        % Name:
        % Description
        function numParticles = get.NumParticles(obj)
            numParticles = max(obj.Data.particle);
        end

        % Name: 
        % Description
        function numParticles = get.NumParticlesMean(obj)
            numParticles = zeros(obj.NumFrames,1);

            for i = 1:obj.NumFrames
                table = obj.get('frame',i);
                numParticles(i) = size(table,1);
            end

            numParticles = floor(mean(numParticles));
        end
    end

    methods (Static)
        % name:             formatTable      
        % description:      
        function table = formatTable(table)
            % Get column names
            labels = table.Properties.VariableNames;

            % Create function that will index the columns
            index = @(cellArray,colName) cellfun(@(cell) strcmp(cell,colName),cellArray);

            % Identify format
            if any(index(labels,'Trajectory'))
                format = 'fiji';
            else
                format = 'trackpy';
            end

            % Correct format
            if strcmp(format,'fiji')
                % Determine column names to look for
                names = {'Trajectory';
                         'Frame';
                         'x';
                         'y'};
    
                % Determine new names
                newNames = {'particle'
                            'frame';
                            'x';
                            'y'};

                % Create index to the specified columns
                idx = cellfun(@(name) find(index(labels,name)),names);

                % Generate new table and update names
                table = table(:,idx);
                table.Properties.VariableNames = newNames;
            end
            
            % Mirror along the y-axis
            table.y = table.y - max(table.y);
            table.y = -table.y;
        
            % Correct particle number to start at 1
            if min(table.particle) == 0
                table.particle = table.particle + 1;
            end

            % Correct frame number to start at 0
            if min(table.frame) == 0
                table.frame = table.frame + 1;
            end
        end
    end
    
end
