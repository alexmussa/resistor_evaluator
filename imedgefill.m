
function CANNYedgefill = imedgefill(CANNYimage,flag,currentvalue,lastvalue,currentneighborvalue,lastneighborvalue)
flag = false;
currentvalue = false;
lastvalue = false;
currentneighborvalue = false;
lastneighborvalue = false;
CANNYedgefill = zeros(length(CANNYim(:,1)),length(1,:));
for i = [1,length(CANNYim(:,1))]
    for ii = 1:length(CANNYim(1,:))
        if i == 1
            currentvalue = CANNYim(i,ii);
            currentneighborvalue = CANNYim(i+1,ii+1);
            if flag == false
                lastvalue = currentvalue;
                lastneighborvalue = currentneighborvalue;
                
        end
    end
end
end
             
                
            lastvalue = CANNYim