function pcryAnnotateRings(Table,radius,style)
%PCRYANNOTATERINGS Highlight a set of particles by displaying rings around
%them on a previously generated two-dimensional scatter plot
%   The function reads in a table that is assumed to contain an x and y
%   column with the positions of the particles to display. Radius can
%   either be a vector with the same number of elements as the number of
%   rings to be drawn, or a single value that will be copied for all rings.
%   Finally, style can be any type of line accepted by a regular matlab
%   plot

    if numel(radius) == 1
        radius = repmat(radius,size(Table,1),1);
    end
    theta = linspace(0,2*pi,50);
    
    hold on
    for i = 1:numel(radius)
        plot(radius(i) * cos(theta) + Table.x(i),...
             radius(i) * sin(theta) + Table.y(i),...
             style);
    end
    hold off
end

