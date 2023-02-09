function ax = pcryDelaunay(x,y,varargin)
%PCRYDELAUNAY computes the Delaunay triangulation of the given set of
%points and color the cells according to the specified vector.
%   AX = PCRYDELAUNAY(X,Y) computes the Delaunay triangulation of the given
%   set of points and returns a handle to the newly created axis.
%   
%   AX = PCRYDELAUNAY(X,Y,C) computes the Delaunay triangiulation of the
%   given set of points and colors the cells with the values stored in C.

    % VALIDATE INPUTS
    if nargin > 3
        error('Number of input parameters is invalid')
    end

    % CALCULATE TRIANGULATION
    DT = delaunay(x,y);

    if nargin == 3
        C = varargin{1};
        
        if numel(C) ~= numel(x)
            error('The number of elements in C must match the size of X')
        end

        % Generate the data we need for the plot
        vx = x(DT)';
        vy = y(DT)';
        color = sqrt(mean(C(DT),2,'omitnan'));
        
        % Plot
        colormap hot
        ax = patch(vx,vy,color','LineStyle','none');
        xlim([min(x) max(x)])
        ylim([min(y) max(y)])
        xlabel('x')
        ylabel('y')
        axis equal

        hold on
        scatter(x,y,50,'.m');
        hold off
    else
        ax = triplot(DT,x,y,'--m');

        hold on
        scatter(x,y,50,'.k');
        hold off
    end
        
        
    



    


end