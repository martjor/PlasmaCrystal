function ax = pcryVoronoi(x,y,varargin)
%PCRYVORONOI computes the voronoi tessellation around a given set of points
%and colors the cells according to the specified vector.
%   AX = PCRYVORONOI(X,Y): Computes the Voronoi teselation with the default
%   coloring of the generated polygons.
%
%   AX = PCRYVORONOI(X,Y,C): Computes the Voronoi tessellation and colors
%   the polygons around the particles according to a specified color
%   vector C. 

    % VALIDATE INPUTS
    if nargin == 3
        color = varargin{1};
        if (length(x) ~= length(color)) || (length(y) ~= length(color))
            error('Error: dimensions of input vectors diff')
        end
    elseif nargin < 3
        color = 'None';
    else
        error('Number of input parameters is invalid');
    end

    % CALCULATE TRIANGULATION
    [v,c] = voronoin([x y]);
        
    % Plot
    ax = gca;
   
    hold on
    plotVoronoi(ax,v,c,color);
    scatter(ax,x,y,50,'.k','DisplayName','Dust');
    hold off
        
    function plotVoronoi(ax,v,c,color)
        % Determine the different geometries present in the dataset
        N = length(c);
        geometry = zeros(N,1);
        for i = 1:N
            geometry(i) = length(c{i});
        end

        % Loop through each geometry and plot
        vx = v(:,1);
        vy = v(:,2);

        shape = unique(geometry);
        for i = 1:numel(shape)
            idx = geometry == shape(i);
            jdx = cell2mat(c(idx))';

            if ischar(color)
                patch(ax,vx(jdx),vy(jdx),'r','FaceColor','None');
            else
                colormap cool
                patch(ax,vx(jdx),vy(jdx),color(idx),'LineStyle','None');
                colorbar
            end
        end
    end
end