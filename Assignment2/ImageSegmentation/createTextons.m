function [textons] = createTextons(imStack, bank, k)
    allResponses = [];
    [~,n] = size(imStack);
    for i = 1:n
        % disp(size(imStack{i}))
        % disp(size(bank));
        responses = myconv(imStack{i}, bank);
        [h,w,d] = size(responses);
        responses = reshape(responses, [h*w,d]);
        allResponses = [allResponses; responses];
    end
    
    % random sampling
    numSamples = 1000;
    sampleIdx = randperm(size(allResponses, 1), min(numSamples, size(allResponses, 1)));
    sampledResponses = allResponses(sampleIdx, :);
    
    % do k-means
    [~,textons] = kmeans(sampledResponses, k);
end