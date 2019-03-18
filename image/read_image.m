function [I,B,X,Y,J] = read_image(filename,sigma_blur)
% read image
I = imread(filename);
% I = I ./ 255;
% convert to grayscale
I = rgb2gray(I);
% flip
I = flipud(I);
% binarize
% J = imbinarize(I,'global');
J = imbinarize(I,'adaptive','Sensitivity',0.9);
% dark pixels
dark = J==0;
% indices of dark pixels
B = find(dark);
% positions of dark pixels
[Y,X] = find(dark);
% blur the image
if nargin > 1
    if sigma_blur > 0
        I = imgaussfilt(I,sigma_blur);
    end
end