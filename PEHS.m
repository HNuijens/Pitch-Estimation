function pitch = PEHS(data, minFreq, maxFreq, nHarmonics)
nData = length(data);
nDFT = 5 * nData * nHarmonics; 
X = fft(data,nDFT);
minDftIndex = ceil(nDFT*minFreq);
maxDftIndex = floor(nDFT*maxFreq);
nFrequencies = maxDftIndex - minDftIndex; 
objectiveFunc = zeros(nFrequencies+1,1);
for w = minDftIndex:maxDftIndex
    for l = 1:nHarmonics
    objectiveFunc(w - minDftIndex + 1) = objectiveFunc(w - minDftIndex + 1) + abs(X(l*w))^2;
    end
    %objectiveFunc(w - minDftIndex + 1) = objective/nDFT;
end
[M,I] = max(objectiveFunc);
pitch = (I/nDFT) + minFreq;
end