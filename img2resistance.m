function [Resistance, centers, ResistanceMessage, CANNYfilt2, B, L, BANDfilt, B2, L2] = img2resistance(MRim)
%Allie Alexander Mussa - Georgia Institute of Technology - ECE 6258 - Final
%Projec

warning('off', 'Images:initSize:adjustingMag');

if size(MRim,3) == 3
    GRAYim = rgb2gray(MRim);
else
    GRAYim = MRim;
end

BWim = imbinarize(GRAYim, graythresh(MRim)+0.16); %+.08 to Otsu's yields better detail. 
filt1= ones(3,3)/9;
BWfilt = imfilter(BWim,filt1);
BWfilt = imfilter(BWfilt,filt1);
BWfilt = imfilter(BWfilt,filt1); %averaging filter 3 times to remove noise.
CANNYim = edge(BWfilt ,'Canny'); %Canny's method of edge detection.

CANNYedgefill = vertextrfill(CANNYim); %This function fills the left and right most column extremes for proper imfill operation.

SE = strel('line',5,0);
CANNYdia = imdilate(CANNYedgefill,SE);
SE = strel('line',5,270);
CANNYdia = imdilate(CANNYdia,SE);
SE = strel('line',5,90);
CANNYdia = imdilate(CANNYdia,SE);
SE = strel('line',5,180);
CANNYdia = imdilate(CANNYdia,SE); %Dilation for imfill preparation.

CANNYfill = imfill(CANNYdia, 'holes'); %Fills in gaps or holes between logical true values(conditioned edges).

filt1= ones(3,3)/9;
CANNYfilt2 = imfilter(CANNYfill,filt1); %noise filtering post imfill.

[B,L,~,~] = bwboundaries(CANNYfilt2); % Image objects have been detected and boundaries labeled now. 

lengthmultiplier = 0.45; %0.4 or 1/4 for 3 imgs
[centers,LargeObjects] = imobjcenters(MRim,CANNYfill,L,11,floor(length((MRim(1,:,1)))*(lengthmultiplier)),20,0); 
%This function calculates the objects with an area greater than tol, a threshold
%(tuned to find largest objects, just resistors) to eliminate
%"noise" objects. Then extracts an image of height, imheight, and length imlength
%(tuned to get full resistance band) from each of the largest objects and
%returns them as a cell.
Resistance = cell(1,LargeObjects);
ResistanceMessage = cell(1,LargeObjects);

for kk = 1:LargeObjects %Calculate resistance from all
    [~,maskedRGBImage] = createMask(centers{kk}); %Removes "Beige" from 1/4w resistor band.
    BANDgray = rgb2gray(maskedRGBImage);
    BANDbw = imbinarize(BANDgray,graythresh(BANDgray));
    BANDfilt = medfilt2(BANDbw);
    filt1= ones(3,3)/9;
    BANDfilt2 = imfilter(imcomplement(BANDfilt),filt1);
    SE = strel('line',10,270);
    BANDdia = imdilate(BANDfilt2,SE);
    SE = strel('line',10,90);
    BANDdia = imdilate(BANDdia,SE);
    
    [B2,L2,~,~] = bwboundaries(BANDdia,'noholes');

    [colorbandcenters,LargeObjects2] = imobjcenters(centers{1},BANDdia,L2,3,19,0.3,1);

    
    if LargeObjects2 >0
        band1 = colorbandcenters{1};
    end
    if LargeObjects2 >1
        band2 = colorbandcenters{2};
    end
    if LargeObjects2 >2
        band3 = colorbandcenters{3};
    end

    if LargeObjects2 >= 3
        a = determineColor(band1);
        b = determineColor(band2);
        c = determineColor(band3);
        band1color = mult2color(a);
        band2color = mult2color(b);
        band3color = mult2color(c);
        Resistance{kk} = (a*10 + b) * 10^(c);
        ResistanceMessage{kk} = ['The color of resistor ', num2str(kk) ,' is ', band1color,' ', band2color,' ', band3color,' ', 'which gives a value of resistance: ', num2str(Resistance{kk}), ' ohms.'];
    end
    
    if LargeObjects2 == 2
        a = determineColor(band1);
        b = determineColor(band2);
        band1color = mult2color(a);
        band2color = mult2color(b);
        ResistanceMessage{kk} = ['Only 2 bands detected in resistor ', num2str(kk), ', which are ', band1color,' ', band2color,'.'];
    end
    
    if LargeObjects2 == 1
        a = determineColor(band1);
        band1color = mult2color(a);
        ResistanceMessage{kk} = ['Only 1 band detected in resistor ', num2str(kk), ', which is ', band1color,'.'];
    end
    
    if LargeObjects2 == 0
        ResistanceMessage{kk} = ['No bands were detected.'];
    end
    
end
end