function aggregate = pcryStackFrames(imstack,option)
%COLLAPSEIMSTACK Returns the aggregate of a stack of images
%   Detailed explanation goes here
    s = size(imstack);
    aggregate = zeros(s(1:2));
    
    if option == "BW"
        cmap = ones(s(3),1);
    elseif option == "GS"
        cmap = linspace(0,1,s(3));
    else
        error('Invalid input argument');
    end
  
    for i = 1:s(3)
        aggregate(imstack(:,:,i) ~= 0) = cmap(i);
    end
end

