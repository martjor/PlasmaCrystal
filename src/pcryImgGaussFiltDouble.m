% Name:         imgFilt
% Author:       Jorge Augusto Martinez-Ortiz
% Date Created: 01.25.2023

function A_filt2 = pcryImgGaussFiltDouble(A)
%PCRYIMGGAUSSFILTDOUBLE Applies a Gaussian filter twice to a given image
%   Filtering/processing to be applied to each frame on the 
%   frame stack. I try to follow the procedure described in the
%   paper by Couedel and Nosenko titled "Tracking and linking
%   of microparticle trajectories during mode-coupling induced 
%   melting in a two-dimensional complex plasma crystal". I'll 
%   use this paper as reference when describing the steps taken
%   by the function.

    sigma_BG = 50;
    sigma_RN = 10;

    % Eqs (2) and (3)
    B1 = imgaussfilt(A,sigma_BG);
    A_filt1 = imsubtract(A,B1);

    % Eqs (
    B2 = imgaussfilt(A_filt1,sigma_RN);
    A_filt2 = imsubtract(A_filt1,B2);
end



function A_filt2 = imgFilt(A)
    % Note that this parameters depend on the experimental setup. I'm not
    % entirely sure how to calculate sigma_BG, and I don't know how the
    % calculated sigma_RN before doing the particle tracking. For now, I'll
    % just copy the values given in the paper since they also give us good
    % result
    sigma_BG = 50;
    sigma_RN = 10;

    % Eqs (2) and (3)
    B1 = imgaussfilt(A,sigma_BG);
    A_filt1 = imsubtract(A,B1);

    % Eqs (
    B2 = imgaussfilt(A_filt1,sigma_RN);
    A_filt2 = imsubtract(A_filt1,B2);
end