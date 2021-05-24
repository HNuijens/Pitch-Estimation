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
        autoCor = 0;
        for n=1:length(x)
            autoCor = autoCor + (1/(nData-tau))*x(n)*xt(n);
        end
       % normCrossCor = xxtSum / sqrt(xSumSq*xtSumSq);
        objectiveFunc(tau-minTau+1) = max(autoCor,0);
    end
    [M, I] = max(objectiveFunc);
    pitch = 1/(I+minTau);
  
end