function R2D = pcryNorm2d(p0,p1)
%PCRYNORM2D Calculates the eucledian norm from the set of points in p0 to
%all the points in the set p1 on a two-dimensional plane. 
%   Detailed explanation goes here
    Dx = pcryDistance(p0(:,1),p1(:,1));
    Dy = pcryDistance(p0(:,2),p1(:,2));
    
    R2D = sqrt((Dx.^2) + (Dy.^2));
end

