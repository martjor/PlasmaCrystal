function T = pcryReadTable(path,varargin)
%PCRYREADTABLE Reads table from a csv file into a format that is compatible
%with the rest of the PCRY functions.
%   T = PCRYREADTABLE(PATH) reads table from the csv file at the specified
%   path with the format provided by TrackPy
%
%   T = PCRYREADTABLE(PATH,'fiji') reads table from the csv file at the
%   specified path with the format provided by FIJI

    applyFormat = false;
    format = 'trackpy';
    
    % Check Inputs
    if nargin > 2
        error("Invalid number of inputs.");
    elseif nargin == 2
        format = varargin{1};
        
        if ~strcmp(format,'fiji')
            error("Invalid specified format for input file")
        else
            applyFormat = true;
        end
    end
    
    % Read the table from the specified path
    T = readtable(path);

    % As a safety check, rename the columns according to the software that
    % was used to generate them
    if strcmp(format,'trackpy')
        T.Properties.VariableNames = ["Var1",...
                                      "y",...
                                      "x",...
                                      "mass",...
                                      "size",...
                                      "ecc",...
                                      "signal",...
                                      "raw_mass",...
                                      "ep",...
                                      "frame",...
                                      "particle"];
    end
    
    label = {'background'};
    label = repmat(label,size(T,1),1);
    label = categorical(label,{'background','torsion','cage'});
    
    T = [T table(label)];
    
    if applyFormat
        idx1 = strcmp('Trajectory',T.Properties.VariableNames);
        idx2 = strcmp('Frame',T.Properties.VariableNames);
        
        T.Properties.VariableNames{idx1} = 'particle';
        T.Properties.VariableNames{idx2} = 'frame';
    end
    
    % Put everything together into a table
    T = T(:,["particle","frame","x","y","label"]);

    % Mirror along the y-axis
    T.y = T.y - max(T.y);
    T.y = -T.y;

    % Correct particle number to start at 1
    if min(T.particle == 0)
        T.particle = T.particle + 1;
    end
end

