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
    if nargin > 3
        error('Number of input parameters is invalid')
    end

    % CALCULATE TRIANGULATION
    [v,c] = voronoin([x y]);

    if nargin == 3
        C = varargin{1};
        
        if numel(C) ~= numel(x)
            error('The number of elements in C must match the size of X')
        end

        % Generate the data we need for the plot
        color = mean(C(DT),2,'omitnan');
        
        % Plot
        colormap hot
        ax = patch(vx,vy,color','LineStyle','none');
        

        hold on
        scatter(x,y,50,'.m');
        hold off
    else
        hold on
        ax = plotVoronoi(v,c);
        scatter(ax,x,y,50,'.k');
        hold off
        
        % Format plot
        xlim([min(x) max(x)])
        ylim([min(y) max(y)])
        xlabel('x')
        ylabel('y')
        axis equal
        
    end

    function ax = plotVoronoi(v,c)
        % Determine the different geometries present in the dataset
        N = length(c);
        geometry = zeros(N,1);
        for i = 1:N
            geometry(i) = length(c{i});
        end

        % Loop through each geometry and plot
        vx = v(:,1);
        vy = v(:,2);
        ax = axes;
        shape = unique(geometry);
        for i = 1:numel(shape)
            idx = geometry == shape(i);
            jdx = cell2mat(c(idx))';
            patch(ax,vx(jdx),vy(jdx),'r');
        end
    end
end