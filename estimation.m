function chanest = estimation(data, rec_data, L)
        xmtx = convmtx(data, L); 
        xmtx(end-L+2:end, :) = []; 
        pinv_xmtx = pinv(xmtx); 
        chanest = pinv_xmtx*rec_data; 
       