function g = pcryLocalBondOrder(DT,P,n)
    N = size(P,1);
    g = zeros(N,1);

    for i = 1:N 
        % Find neighbors of the current particle
        idxNeighbors = getNeighbors(DT,i);

        % Get coordinates
        P0 = P(i,:);
        PNeighbors = P(idxNeighbors,:);

        % Calculate g6
        g(i) = gn(P0,PNeighbors,n);

    end
end

% This functions finds the indices of the neigboring particles and
% returns them as a column vector
function idxNeighbors = getNeighbors(DT,i)
    idx = any(DT==i,2);
    idxNeighbors = setdiff(unique(DT(idx,:)),i)';
end

% Calculates the local bond order for the current particle
function g = gn(P0,PNeighbors,n)
    % Number of neighbors
    N = size(PNeighbors,1);

    x = PNeighbors(:,1) - P0(1);
    y = PNeighbors(:,2) - P0(2);

    theta = atan2(y,x);

    g = abs(sum(exp(1i * n * theta)))/N;
end
