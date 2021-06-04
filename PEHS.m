function pitch = PEHS(data, minFreq, maxFreq, nHarmonics)
nData = length(data);
nDFT = 5 * nData * nHarmonics;              % Size of the DFT (5 * signalLength * number of harmonics)
X = fft(data,nDFT);                         % Take DFT
maxFreq = min(maxFreq, 1/(2*nHarmonics));   % Max frequency
minDftIndex = ceil(nDFT*minFreq);           % Minimal fundamental frequency bin
maxDftIndex = floor(nDFT*maxFreq);          % Maximal fundamental frequency bin
nFrequencies = maxDftIndex - minDftIndex; 
objectiveFunc = zeros(nFrequencies+1,1);

for w = minDftIndex:maxDftIndex
    for l = 1:nHarmonics
    objectiveFunc(w - minDftIndex + 1) = objectiveFunc(w - minDftIndex + 1) + abs(X(l*w))^2; % HS Estimater
    end
end
[M,I] = max(objectiveFunc); % Find best fit
pitch = (I/nDFT) + minFreq;
end