%% Pitch Estimation Comparison
clear all;

%% Load input signal
[in, fs] = audioread("C:\Users\helme\Documents\Sound and Music Computing\SMC8\Sound and Music Signal Analysis\3. Mini Project\Samples\roy.wav");
in = in(:,1);       % Reduce to mono

%% Or create input signal
fs = 44100;                                         
dur = 3;                                            % Duration of each frequency
dt = 1/fs;                                          % Sample period
t = (0:dt:dur-dt)';                                 % time vector                                             
nHarmonics = 50;                                    % Amount of harmonics
freqTable = [200 400 500 633 233 734 333];          % Frequency content of signal
nFrequencies = length(freqTable);                   % Amount of frequencies
in = zeros(length(t)*nFrequencies,1);               
indexVec = (1:length(t));    

for i = 1:nFrequencies                              % Repeat for each frequency
    inSegment = zeros(length(t),1);                     
    for h = 1:nHarmonics                            % Add harmonics to the signal
        inSegment = inSegment + (1/h)*sin(2*pi*freqTable(i)*t*h);
    end
    in(indexVec) = inSegment;                       % Copy segment to the input signal
    indexVec = indexVec + length(t);   
end

%% Adding Noise
nData = length(in);
noiseRatio = 0.50;                     % Mix between signal and noise, 0 is only noise 
e = rand(nData,1)*2 - 1;               % Noise signal
in = noiseRatio*in;                    % Scale signal according to ratio
e = (1-noiseRatio)*e;                  % Scale noise according to ratio
Pin = rms(in)^2;                       % Power of input signal
Pe = rms(e)^2;                         % Power of noise signal
SNR = Pin/Pe;                          % Signal to Noise Ratio
disp(['SNR = ',num2str(SNR)]);         % Display SNR                          
in = in+e;                             % Input signal plus added noise

%% Function settings
minFreq = 230;                                      % Minimum frequency that can be estimated
maxFreq = 1000;                                     % Maximum frequency that can be estimated
overlap = 75;                                       % Percentage overlap from previous segment
nData = length(in);                                 % Total amount of samples
segmentLength =  25/1000;                           % Length of each segment in miliseconds
nSegmentLength = segmentLength * fs;                % Segment Length in samples
iVector = 1:nSegmentLength;                         % Vector used for indexing
nShift = round((1-overlap/100)*nSegmentLength);     % Segment shift in samples
nSegments = ceil((nData-nSegmentLength+1)/nShift);  % Total amount of segments                                   
nHarmonics = 5;                                     % Amount of harmonics of analyzed signal

pitchAC = zeros(nData,1);                           % Vector containing the estimated pitch using Auto Correlation
pitchCF = zeros(nData,1);                           % Vector containing the estimated pitch using Comb Filtering
pitchHS = zeros(nData,1);                           % Vector containing the estimated pitch using Harmonic Summation

%% Estimating pitch
for i = 1:nSegments
    pitchAC(iVector) =  PEAC(in(iVector), minFreq/fs, maxFreq/fs);              % Estimate pitch using Auto Correlation
    pitchCF(iVector) =  PECF(in(iVector), minFreq/fs, maxFreq/fs);              % Estimate pitch using Comb Filtering
    pitchHS(iVector) =  PEHS(in(iVector), minFreq/fs, maxFreq/fs, nHarmonics);  % Estimate pitch using Harmonic Summation
    
    iVector = iVector + nShift;
    
    Text = ['Processing segment ',num2str(i), ' of ', num2str(nSegments)];      % Display current segment
    disp(Text)
end
   pitchAC = pitchAC*fs;
   pitchCF = pitchCF*fs;
   pitchHS = pitchHS*fs;

%% Plot & Compare
specSegmentLength = round(2*nSegmentLength);
specWindow = gausswin(specSegmentLength);
nDft = 4096;
specNOverlap = round(3*specSegmentLength/4);
[S, F, T] = spectrogram(in(:,1), specWindow, specNOverlap, nDft, fs);

subplot(311)
imagesc(T*fs,F,20*log10(abs(S)))
set(gca,'YDir','normal')
hold on
plot(pitchAC,'r')
ylim([0,1000])
hold off
xlabel('time [samples]')
ylabel('frequency [Hz]')
title('Auto Correlation');

subplot(312)
imagesc(T*fs,F,20*log10(abs(S)))
set(gca,'YDir','normal')
hold on
plot(pitchCF,'r')
ylim([0,1000])
hold off
xlabel('time [samples]')
ylabel('frequency [Hz]')
title('Comb Filter');

subplot(313)
imagesc(T*fs,F,20*log10(abs(S)))
set(gca,'YDir','normal')
hold on
plot(pitchHS,'r')
ylim([0,1000])
hold off
xlabel('time [samples]')
ylabel('frequency [Hz]')
title('Harmonic Summation');

%% Save figure
saveas(gcf,'C:\Users\helme\Documents\Sound and Music Computing\SMC8\Sound and Music Signal Analysis\3. Mini Project\Visials\sax0p04SNR.png')