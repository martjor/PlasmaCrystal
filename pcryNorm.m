function Distance = pcryNorm(p0,p1)
%PCRYNORM Calculates the eucledian distance between two sets of points
%   Detailed explanation goes here
    
    if size(p0,2) ~= size(p1,2)
        error('Error: The points must have the same number of dimensions')
    end
    
    NUM_DIM = size(p0,2);
    Distance = zeros(size(p0,1),size(p1,1));
    
    for i = 1:NUM_DIM
        Distance = Distance + (pcryDistance(p0(:,i),p1(:,i))).^2;
    end
    
    Distance = sqrt(Distance);
end

