function [objcenterimages,largeobjects] = imobjcenters(rgbim,img,L,imheight,imwidth,tol,band) 
% Allie Alexander Ismael Mussa - Georgia institute of Technology - amussa@gatech.edu
% This findest the largest centroids of the blobs in L (from bwboundaries) 
% , whose area is tresholded by a product of the tolerance (tol). Returns
% [imHeight imWidth] images of the coilorbands of the resistors from the
% original RGB image. The band flag indicates if the function is being used
% to extract the three color bands from the center extracted strip (band =
% 1), or  extract the center strip from the original image (band = 0).

    if mod(imheight,2) ~= 1
        imheight=imheight+1;
    end
    if mod(imwidth,2) ~= 1
        imwidth=imwidth+1;
    end
    imarea = regionprops(L,'Area');
    imcentroid = regionprops(L,'Centroid');
    largeobjects=0; %only keep large objects.
    for ii = 1:length(imarea)
        if (getfield(imarea(ii),'Area')) > (tol*length(img))
            largeobjects = largeobjects + 1;
        end
    end
    if and(band == 1,largeobjects > 3)
        largeobjects = 3;
    end
    objnumbers = cell(1,largeobjects);
    iii=1;
    for ii = 1:length(imarea)
            if (getfield(imarea(ii),'Area')) > (tol*length(img))
                objcentroid = getfield(imcentroid(ii,1), 'Centroid');
                objcentroidy= floor(objcentroid(1,1));
                objcentroidx= floor(objcentroid(1,2));
                objnumbers{iii,1} = L(objcentroidx,objcentroidy); %subtraction from centroids y coordinate due to some bands centroid not landing on object, due to even symmetry.
                iii = iii + 1;
            end
    end
    objcenterimages = cell(1,largeobjects);
    for ii = 1:largeobjects
        objcentroid = getfield(imcentroid(objnumbers{ii,1},1), 'Centroid');
        objcentroidy= floor(objcentroid(1,1));
        objcentroidx= floor(objcentroid(1,2));
        objcenterimages{1,ii} = rgbim(((objcentroidx-((imheight-1)/2)+1):(objcentroidx+((imheight-1)/2)+1)),...
            ((objcentroidy-((imwidth-1)/2)+1):(objcentroidy+((imwidth-1)/2)+1)),:);
    end
end