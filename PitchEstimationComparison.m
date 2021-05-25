%% Pitch Estimation Comparison
clear all;

%% Load input signal
[in, fs] = audioread("C:\Users\helme\Documents\Sound and Music Computing\SMC8\Sound and Music Signal Analysis\4. Slides and Exercises\Lecture 6 pitch estimation I\Exercises-20210407\09viola.flac");
in = in(:,1);       % Get one channel
%% Or create input signal
fs = 44100;
dur = 3;
dt = 1/fs;
t = (0:dt:dur-dt)';
f = 200;
nHarmonics = 50; 
freqTable = [200 400 500 633 233 980 120];
nFrequencies = length(freqTable);
in = zeros(length(t)*nFrequencies,1);
indexVec = (1:length(t)); 
for i = 1:nFrequencies
    inSegment = zeros(length(t),1);
    for h = 1:nHarmonics
        inSegment = inSegment + (1/h)*sin(2*pi*freqTable(i)*t*h);
    end
    in(indexVec) = inSegment;
    indexVec = indexVec + length(t);   
end

%% Adding Noise
nData = length(in);
SNR = 0.6;                   % Desired signal / noise 
e = rand(nData,1)*2 - 1;     % Noise signal
in = SNR*in + (1-SNR)*e;     % input signal plus added noise

%% Function settings
minFreq = 150;
maxFreq = 1000;
overlap = 75;
nData = length(in);
segmentLength =  25/1000;
nSegmentLength = segmentLength * fs;
iVector = 1:nSegmentLength;
nShift = round((1-overlap/100)*nSegmentLength);
nSegments = ceil((nData-nSegmentLength+1)/nShift);
nHarmonics = 5;
pitchAC = zeros(nData,1);
pitchCF = zeros(nData,1);
pitchHS = zeros(nData,1);

%% Estimating pitch
for i = 1:nSegments
    pitchAC(iVector) =  PEAC(in(iVector), minFreq/fs, maxFreq/fs);
    pitchCF(iVector) =  PECF(in(iVector), minFreq/fs, maxFreq/fs);
    pitchHS(iVector) =  PEHS(in(iVector), minFreq/fs, maxFreq/fs, nHarmonics);
    
    iVector = iVector + nShift;
    
    Text = ['Processing segment ',num2str(i), ' of ', num2str(nSegments)];
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