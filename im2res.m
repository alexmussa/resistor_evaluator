function Resistance = im2res(MRim, gtoffset, dia1mag, dia1theta)

MRim = imread('MultipleResistors1.jpg');
imshow(MRim), title('Original Image');

if size(MRim,3) == 3
    MRim_lab = RGB2Lab(MRim);
    GRAYim = rgb2gray(MRim);
else
    GRAYim = MRim;
end

figure
imshow(GRAYim);

BWim = im2bw(GRAYim, graythresh(GRAYim)+gtoffset); %+.14 to Otsu's yields better detail. 

BWfilt = medfilt2(BWim);
CANNYim = edge(BWfilt ,'Canny');
SE = strel('line',dia1mag,dia1theta);
CANNYdia = imdilate(CANNYim,SE);

CANNYedgefill = vertextrfill(CANNYdia);

CANNYfill = imfill(CANNYedgefill, 'holes');

[B,L,N,A] = bwboundaries(CANNYfill);

% Image objects have been detected in CANNYfill now. For Color detection,
% set background to black.

ResistorsofOriginal = MRim;
for i = [1 2 3]
    for m=1:length(ResistorsofOriginal(:,1,i))
        for n=1:length(ResistorsofOriginal(1,:,i))
            if(CANNYfill(m,n) == false)
                ResistorsofOriginal(m,n,i) = 0; 
            end
        end
    end
end

[test,LargeObjects] = imobjcenters(MRim,CANNYfill,B,11,floor(length((MRim(1,:,1)))*(1/3))-1,2); %Change last variable until isolated center has no wire.

[BWmask,maskedRGBImage] = createMask(test{1});

figure
imshow(maskedRGBImage);

%BANDpad = padarray(maskedRGBImage,[1 1],255,'both');
BANDgray = rgb2gray(maskedRGBImage);
BANDbw = imbinarize(BANDgray,graythresh(BANDgray)+.1);
BANDfilt = medfilt2(BANDbw);
BANDedge = edge(BANDfilt,'Canny');
SE = strel('line',20,0); %can be adjusted to produce better segmentation.
BANDdia = imdilate(BANDedge,SE);
BANDedgevert = transpose(vertextrfill(transpose(BANDdia)));
BANDfill = imfill(BANDedgevert,'holes');
figure
imshow(BANDedgevert);
figure
imshow(BANDfilt);
figure
imshow(BANDfill);

[B2,L2,N2,A2] = bwboundaries(BANDfill,'noholes');
imshow(BANDfill); hold on;
colors=['b' 'g' 'r' 'c' 'm' 'y'];
for k=1:length(B2)
  boundary = B2{k};
  cidx = mod(k,length(colors))+1;
  plot(boundary(:,2), boundary(:,1),...
       colors(cidx),'LineWidth',2);
  rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
  col = boundary(rndRow,2); row = boundary(rndRow,1);
  h = text(col+1, row-1, num2str(L2(row,col)));
  set(h,'Color',colors(cidx),'FontSize',14,'FontWeight','bold');
end

[test2,LargeObjects2] = imobjcenters(maskedRGBImage,BANDfill,B2,3,25,7); %Change last variable until isolated center has no wire.

band1 = test2{1};
band2 = test2{2};
band3 = test2{3};
band4 = test2{4};

band1avg = uint8(cat(3,mean(mean(band1(:,:,1))), mean(mean(band1(:,:,2))), mean(mean(band1(:,:,3)))));
band2avg = uint8(cat(3,mean(mean(band2(:,:,1))), mean(mean(band2(:,:,2))), mean(mean(band2(:,:,3)))));
band3avg = uint8(cat(3,mean(mean(band3(:,:,1))), mean(mean(band3(:,:,2))), mean(mean(band3(:,:,3)))));
band4avg = uint8(cat(3,mean(mean(band4(:,:,1))), mean(mean(band4(:,:,2))), mean(mean(band4(:,:,3)))));

band1color = colornames('Natural',[mean(mean(band1(:,:,1))), mean(mean(band1(:,:,2))), mean(mean(band1(:,:,3)))]./255,'CIEDE2000');
band2color = colornames('Natural',[mean(mean(band2(:,:,1))), mean(mean(band2(:,:,2))), mean(mean(band2(:,:,3)))]./255,'CIEDE2000');
band3color = colornames('Natural',[mean(mean(band3(:,:,1))), mean(mean(band3(:,:,2))), mean(mean(band3(:,:,3)))]./255,'CIEDE2000');
band4color = colornames('Natural',[mean(mean(band4(:,:,1))), mean(mean(band4(:,:,2))), mean(mean(band4(:,:,3)))]./255,'CIEDE2000');

a = color2mult(band1color{1,1});
b = color2mult(band2color{1,1});
c = color2mult(band3color{1,1});

Resistance = (a*10 + b) * 10^(c);
X = ['The value of resistance is ', num2str(Resistance)];
disp(X);



end