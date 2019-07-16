function vertextrfill = vertextrfill(EDGEim)
    %this code fills vertical extremes, the leftmost and rightmost columns 
    %of the image, after the canny edges have been extracted. This can also 
    %fill the top and bottom by transposing EDGEim. EDGEim is the edge
    %image from the output of an edge detector.
    
    flagrise = false;
    flagfall = false;
    vertextrfill = EDGEim;
    
    for kk = [1,length(EDGEim(1,:))]
        currentnvalue = false; %current neighbor value
        lastnvalue = false;
        flagrise = false;
        flagfall = false;
        for jj = 1:length(EDGEim(:,1))
            if kk == 1         
                currentnvalue = vertextrfill(jj,kk+1);
                if and((currentnvalue == 0),(lastnvalue == 1))
                    flagfall = ~flagfall;
                elseif and((currentnvalue == 1),(lastnvalue == 0))
                    flagrise = ~flagrise;
                end  
                if or(flagrise,flagfall) == 0
                    lastnvalue = currentnvalue;
                elseif or(flagrise,flagfall) == 1
                    vertextrfill(jj,kk)=true;
                    lastnvalue = currentnvalue;
                end
            end
            if kk == length(EDGEim(1,:))
                currentnvalue = vertextrfill(jj,kk-1);
                if and((currentnvalue == 0),(lastnvalue == 1))
                    flagrise = ~flagrise;
                elseif and((currentnvalue == 1),(lastnvalue == 0))
                    flagfall = ~flagfall;
                end     
                if or(flagrise,flagfall) == 0
                    lastnvalue = currentnvalue;
                elseif or(flagrise,flagfall) == 1
                    vertextrfill(jj,kk)=true;
                    lastnvalue = currentnvalue;
                end
            end
        end
    end