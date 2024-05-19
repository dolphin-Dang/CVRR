function filteredImg = myconv(img,banks)
    [m,m,d] = size(banks);
    [h,w] = size(img);
    filteredImg = zeros(h,w,d);
    for i=1:d
        filteredImg(:,:,i) = conv2(img, banks(:,:,i), "same");
    end
end

