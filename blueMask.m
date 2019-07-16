function [BW,prob] = blueMask(I)
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder App. The colorspace and
%  minimum/maximum values for each channel of the colorspace were set in the
%  App and result in a binary mask BW and a composite image maskedRGBImage,
%  which shows the original RGB image values under the mask BW.

% Auto-generated by colorThresholder app on 27-Nov-2017
%------------------------------------------------------


% Convert RGB image to chosen color space

%TODO Channel min and maxes
channel1Min = min([14.366,44.414]);
channel1Max = max([42.523,67.691]);
channel2Min = min([1.596,-9.019]);
channel2Max = max([18.158,3.474]);
channel3Min = min([-45.490,-35.504]);
channel3Max = max([-20.277,-5.726]);


% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = I;

prob = mean2(BW);
end
