% Function to estimating the fundamental frequency using the comb filtering method
function pitch = PECF(data, minFreq, maxFreq) % Pitch estimation comb filter
    nData = length(data);
    minTau = max(1,ceil(1 / maxFreq));        % Minimum period
    maxTau = min(nData,floor(1 / minFreq));   % Maximum period
    nTau = maxTau - minTau;                   % Range of tau's 
    
    objectiveFunc = zeros(nTau,1);            % Objective funciton we want to minimize
    
    for tau = minTau:maxTau
        xt = data(1:end-tau);                 % Trimmed delayed input signal
        x = data(tau+1:end);                  % Trimmed input data
        xSumSq = 0;
        xtSumSq = 0;
        xxtSum = 0;
        for n=1:length(x)
            xSumSq = xSumSq + x(n)^2;          % Summed input signal squared
            xtSumSq = xtSumSq + xt(n)^2;       % Summed delayed input signal squared 
            xxtSum = xxtSum + x(n)*xt(n);      % Summed input * delyed input
        end
        normCrossCor = xxtSum / sqrt(xSumSq*xtSumSq);       % Calculate the normalized cross correlation
        objectiveFunc(tau-minTau+1) = max(normCrossCor,0);  % Put the outcome into the objective function vec
    end
    [M, I] = max(objectiveFunc);                % Find best fit          
    pitch = 1/(I+minTau);
end