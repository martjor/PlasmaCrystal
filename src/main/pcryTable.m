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

    % Public methods ======================================================
    methods (Access=public)
        % CLASS CONSTRUCTOR
        function obj = pcryTable(table)
            % Format table data
            obj.Data = obj.formatTable(table);

            % Append particle displacements
            obj.Data = [obj.Data,obj.calculateDisplacements];
        end

        % Name:             get
        % Description:      This function takes a parameter
        %                   {particle,frame,...} and returns the a
        %                   subsection of the original table that contains
        %                   only does entries that match the specified
        %                   parameter
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
            else
                error('Error: invalid parameter name')
            end

            idx = find(obj.Data.(parameter) == n);
            table = obj.Data(idx,:);
        end

        % Name:             stats
        % Description:      Calculate important statistics of the particles
        %                   across every frame in the tracking. 
        %                   The statistics calculated are the following:
        %                       - Mean x and y positions for every particle
        %                       - Visibility: the fraction of the total
        %                       number of frames that the particle remains
        %                       visible.
        function FrameMean = stats(obj)
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

                % Calculate the number of frames the particle was visible
                % for
                numFrames(i) = size(frame,1);
            end
            
            % Calculate visibility of the particle
            visibility = numFrames / obj.NumFrames;

            % Create table
            particle = (1:numParticles)';
            FrameMean = table(particle,x,y,numFrames,visibility);
        end

        % Name:             particleFrameStats
        % Description:      Calculates statistics about the frames missed
        %                   by a particle 
        function [Frames,count] = particleFrameStats(obj,particleNum)
            % Get particle table
            particleTable = obj.get('particle',particleNum);

            % Pad the frame vector and calcualate the differences
            count = diff([1;particleTable.frame;obj.NumFrames]);

            % Create an index to the differences in the middle of the
            % vector
            idx = 2:(length(count)-1);

            % Count the number of frames skipped
            count(idx) = count(idx)-1;
            count = count(count > 0);
            
            Frames.ParticleNumber = particleNum;
            Frames.FirstFrame = particleTable.frame(1);
            Frames.LastFrame = particleTable.frame(end);
            Frames.TotalMissed = sum(count);

            if ~isempty(count)
                Frames.MaxFramesMissed = max(count);
                Frames.MinFramesMissed = min(count);
                Frames.MeanFramesMissed = mean(count);
            else
                Frames.MaxFramesMissed = 0;
                Frames.MinFramesMissed = 0;
                Frames.MeanFramesMissed = 0;
            end
        end
    end

    % Private methods =====================================================
    methods (Access=private)
        % Name:             calculateDisplacements
        % Description:      Calculates the displacements of the particle
        %                   positions between frames 
        function Table = calculateDisplacements(obj)
            rows = size(obj.Data,1);

            % Prellocate displacements
            dx = zeros(rows,1);
            dy = zeros(rows,1);

            for i = 1:obj.NumParticles
                [particle,idx] = obj.get('particle',i);

                % Calculate particle displacements
                dr = obj.displacement(particle);

                dx(idx) = dr(:,1);
                dy(idx) = dr(:,2);
            end

            % Return displacements
            Table = table(dx,dy);
        end
    end

    % Getters & Setters====================================================
    methods
        % Name:             get.NumFrames
        % Description:      Get method for the NumFrames property of the
        %                   table. Returns the number of frames contained
        %                   in the table.
        function numFrames = get.NumFrames(obj)
            numFrames = max(obj.Data.frame);
        end

        % Name:             get.NumParticles
        % Description:      Get method for the NumParticles property of the
        %                   table. Returns the number of particles
        %                   contained in the table.
        function numParticles = get.NumParticles(obj)
            numParticles = max(obj.Data.particle);
        end

        % Name:             get.NumParticlesMean
        % Description       Get method for the NumParticles property of the
        %                   table. Returns an estimate of the real
        %                   number of particles present in the recording by
        %                   caculating the average number of particles
        %                   visible in each frame
        function numParticles = get.NumParticlesMean(obj)
            numParticles = zeros(obj.NumFrames,1);

            for i = 1:obj.NumFrames
                table = obj.get('frame',i);
                numParticles(i) = size(table,1);
            end

            numParticles = floor(mean(numParticles));
        end
    end
    
    % Static methods ======================================================
    methods (Static)
        % name:             formatTable      
        % description:      Reads an already existing table (a table
        %                   formatted by fiji or TrackPy) and applies the
        %                   format that is consistent with our analysis. 
        %                   This formatting takes care of the following:
        %                       - Establishing proper variable names for
        %                       the columns of the table
        %           
        %                       - Setting the number of the first particle
        %                       to 1 for compatibility with matlab syntax
        %                   
        %                       - Applies a coordinate transformation so
        %                       that the origin of the coordinate system of
        %                       the particles tracked is located at the
        %                       bottom left corner of the screen.                 
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

        % Name:             calculateDisplacements
        % Description:      Calculates the displacements between the
        %                   positions of a particle contained in a particle
        %                   table
        function dr = displacement(particleTable)
            % Initialize displacement variable
            dr = nan(size(particleTable,1),2);

            % Calculate displacements in x and y directions
            dr(2:end,1) = diff(particleTable.x);
            dr(2:end,2) = diff(particleTable.y);

            % Identify disjoint frames (the first frame is always disjoint)
            idx = find(logical(diff(particleTable.frame) > 1)) + 1;

            % Correct displacement for disjoint frames
            dr(idx,:) = nan;
        end
    end
end
