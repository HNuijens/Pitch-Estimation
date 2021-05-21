% Function to estimating the fundamental frequency using the comb filtering method
function pitch = PECF(data, minFreq, maxFreq) % Pitch estimation comb filter
     nData = length(data);
    minTau = max(1,ceil(1 / maxFreq));   % Minimum period
    maxTau = min(nData,floor(1 / minFreq));   % Maximum period
    nTau = maxTau - minTau;         % Range of tau's 
    
    %indexVec = (maxTau:nData-1)+1;
    objectiveFunc = zeros(nTau,1);  % Objective funciton we want to minimize
    
    for tau = minTau:maxTau
        xt = data(1:end-tau);
        x = data(tau+1:end);             % Trimmed input data
        xSumSq = 0;
        xtSumSq = 0;
        xxtSum = 0;
        for n=1:length(x)
            xSumSq = xSumSq + x(n)^2;
            xtSumSq = xtSumSq + xt(n)^2;
            xxtSum = xxtSum + x(n)*xt(n);
        end
        normCrossCor = xxtSum / sqrt(xSumSq*xtSumSq);
        objectiveFunc(tau-minTau+1) = max(normCrossCor,0);
    end
    [M, I] = max(objectiveFunc);
    pitch = 1/(I+minTau);
  
end