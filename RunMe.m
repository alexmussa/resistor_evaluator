%ECE 6258 - Digital Image Processing - Georgia Institute of Technology -
%Final Project

%PROJECT: Reading Resistors Values using Image processing techniques

%INSTRUCTIONS: Ensure all functions are added to the path. To select the
%image to run, change the integer value from {3} to some value between
%1-10. To execute the code, select Editor -> Run. This page runs the code 
%through function img2resistance() and generates plots for viewing.

clear all; close all; clc;

images = ["ReReBr.png","ReReOr.png","ReReRe.png","BrBlBr.png",...
    "BrBlOr.png","MultipleResistors1.jpg","OrOrBr.jpg",...
    "YePrOr.png","YeBrBl.png","YePrRe.png"]; 

MRim = imread(images{3}); %CHANGE INTEGER TO VALUE OF 1 - 10 TO CHANGE IMAGE

[Resistance, centers, ResistanceMessage, CANNYfilt2, B, L, BANDfilt, B2, L2] = img2resistance(MRim);
%%
figure, imshow(MRim), title('Original Image');
ll = length(centers);

figure
imshow(CANNYfilt2), title('Detected Resistors are largest area objects.'); hold on;
colors=['b' 'g' 'r' 'c' 'm' 'y'];
for k=1:length(B),
  boundary = B{k};
  cidx = mod(k,length(colors))+1;
  plot(boundary(:,2), boundary(:,1),...
       colors(cidx),'LineWidth',2);
  rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
  col = boundary(rndRow,2); row = boundary(rndRow,1);
  h = text(col+1, row-1, num2str(L(row,col)));
  set(h,'Color',colors(cidx),'FontSize',14,'FontWeight','bold');
end

figure
    imshow(imcomplement(BANDfilt)), title('Detected resistor bands.'); hold on;
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

for kk = 1:ll
    figure, imshow(centers{kk}), title(ResistanceMessage{kk});
    disp(ResistanceMessage{kk})
end

