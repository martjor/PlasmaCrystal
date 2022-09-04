function ax1 = pcryPlayTracking(Table)
%PCRYPLAYTRACKING Animates the motion of the particles tracked using
%Trackpy
%   The funcion takes in a table containing the information of the
%   particles tracked. The format of the table is assumed to have x, y,
%   particle, and frame information of the particles as provided by trackpy
%   the function will display each frame in the table.

    frame = pcryGetFrame(Table,0);
    maxFrame = max(Table.frame);
    
    fig = figure;

    ax1 = axes(fig,'Color','black',...
                   'XGrid','on','YGrid','on',...
                   'GridColor','white');
    hold all
    
    particles = scatter(frame.x,frame.y,100,frame.particle,'.');
    % The following if statements just takes care of determining whether or
    % not to show the colorbar based on how many particles are being passed
    % into to the function
    if numel(unique(Table.particle)) > 1
        c = colorbar;
        c.Label.String = 'Trajectory';
        caxis([0 max(Table.particle)])
        string = 'Frame: ';
    elseif numel(unique(Table.particle))
        string = ['Particle ' num2str(Table.particle(1)) ', Frame: '];
    end
    
    title([string '0']);
    xlabel('x')
    ylabel('y')
    axis([min(Table.x) max(Table.x) min(Table.y) max(Table.y)])
    
    
    
    currFrame = 1;
    while(currFrame <= maxFrame && isvalid(fig))
        title([string num2str(currFrame)])
        frame = pcryGetFrame(Table,currFrame);
   
        set(particles,'XData',frame.x,'YData',frame.y,'CData',frame.particle);
        pause(0.1);
        
        currFrame = currFrame + 1;
    end
end

