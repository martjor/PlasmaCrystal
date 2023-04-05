path = '/Users/jorgeaugustomartinezortiz/Library/CloudStorage/OneDrive-BaylorUniversity/CASPER/projects/plasma_crystal/crystal_analysis/torsions_datasets/laser_pulse_20221006_crop_0_999.csv';
T = pcryReadTable(path);

% Define function and initialize animator
numFrames = unique(T.frame)
myFunc = @(frameNum) plotFrame(T,frameNum);
Anim = pcryAnimator(myFunc)

figure
ax = axes;
xlim([min(T.x) max(T.x)])
ylim([min(T.y) max(T.y)])
colormap copper
clim([0 1])

%Anim.animate(1:999)
Anim.recordVideo(1:999,'localBondOrder.avi')
function plotFrame(T,frameNum)
    % Get current frame
    frame = pcryGetFrame(T,frameNum);
    x = frame.x;
    y = frame.y;

    % Calculate the Delaunay triangulation
    DT = delaunay([x y]);
    
    % Calculate the local bond order parameter for n=6 
    g6 = pcryLocalBondOrder(DT,[x y],6);

    pcryVoronoi(x,y,g6);
    title(sprintf("Frame %i",frameNum));
end