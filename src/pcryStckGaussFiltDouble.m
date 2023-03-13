function stack_filt = pcryStckGaussFiltDouble(stack)
%PCRYSTCKGAUSSFILTDOUBLE Applies a Gaussian filter twice to a stack of
%images
%   It really is just just a for loop that applies the 
%   processImage function to a whole stack, but it will keep
%   the code clean.
    stack_filt = zeros(size(stack));

    for i = 1:size(stack_filt,3)
        stack_filt(:,:,i) = pcryImgGaussFiltDouble(stack(:,:,i));
    end

    stack_filt = stack_filt / 255;
end