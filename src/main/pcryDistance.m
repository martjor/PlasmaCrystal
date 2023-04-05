function D = pcryDistance(p0,p1)
%PCRYDISTANCE Calculates the distances from the set of points on P1 to 
%all the points in the set P1.
%   Detailed explanation goes here
    [X1,X2] = meshgrid(p1,p0);
    
    D = X1-X2;
end

