function R3D = pcryNorm3d(p0,p1)
%PCRYNORM3D Calculates the eucledian norm from the set of points in p0 to
%all the points in the set p1 on 3D space. 
%   Detailed explanation goes here
    Dx = pcryDistance(p0(:,1),p1(:,1));
    Dy = pcryDistance(p0(:,2),p1(:,2));
    Dz = pcryDistance(p0(:,3),p1(:,3));
    
    R3D = sqrt((Dx.^2) + (Dy.^2) + (Dz.^2));
end

