function frameTable = pcryGetFrame(Table,frame)
%PCRYGETFRAME Returns a subsection of the table at the specified frame
%   The function returns a table containing the following fields
%       frame:  the number of the frame from which the data was retrieved
%       x:      a column vector containing the x positions of the particles
%       y:      a column vector containing the y positions of the particles
%       particle: the particle number
%   The function assumes that the larger table has the format provided by
%   trackpy generated data
    idx = Table.frame == frame;
    
    frameTable = Table(idx,:);
end

