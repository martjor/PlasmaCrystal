function T = pcryReadTable(path,varargin)
%PCRYREADTABLE Reads table from a csv file into a format that is compatible
%with the rest of the PCRY functions.
%   T = PCRYREADTABLE(PATH) reads table from the csv file at the specified
%   path with the format provided by TrackPy
%
%   T = PCRYREADTABLE(PATH,'fiji') reads table from the csv file at the
%   specified path with the format provided by FIJI

    applyFormat = false;
    
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
    
    T = readtable(path);
    
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
    
    T = T(:,["particle","frame","x","y","label"]);
end

