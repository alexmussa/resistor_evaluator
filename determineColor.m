function [ color ] = determineColor( img )
%determineColor input an RGB image to determine it's color
%   Uses the LAB colorspace and predefined color thresholding to determine
%   the most likely color the input image could be. Only the colors used
%   for resistor color codes are available colors. Outputs the value
%   associated with a color as specified by the resistor color code chart.
img = rgb2lab(img);
color_arr = {@blackMask; @brownMask; @redMask; @orangeMask; @yellowMask; @greenMask; @blueMask; @purpleMask; @greyMask; @whiteMask};
probs = zeros(size(color_arr));
for i = 1:length(color_arr)
    [~, prob] = color_arr{i}(img);
    probs(i) = prob;
end
[~, color] = max(probs);
color = color - 1;


