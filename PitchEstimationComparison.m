%% Pitch Estimation Comparison
clear all;

%% Load input signal
[in, fs] = audioread("C:\Users\helme\Documents\Sound and Music Computing\SMC8\Sound and Music Signal Analysis\4. Slides and Exercises\Lecture 6 pitch estimation I\Exercises-20210407\09viola.flac");
nHarmonics = 5;

%% Or create input signal
fs = 44100;
dur = 3;
dt = 1/fs;
t = (0:dt:dur-dt)';
f = 200;
nHarmonics = 10; 
in = zeros(length(t),1);
for h = 1:nHarmonics
    in = in + sin(2*pi*f*t*h);
end

%% Function settings
minFreq = 100;
maxFreq = 1000;
overlap = 75;
nData = length(in);
segmentLength =  25/1000;
nSegmentLength = segmentLength * fs;
iVector = 1:nSegmentLength;
nShift = round((1-overlap/100)*nSegmentLength);
nSegments = ceil((nData-nSegmentLength+1)/nShift);

pitch = zeros(nData,1);

%% Estimating pitch
for i = 1:nSegments
    pitchVal =  PEHS(in(iVector), minFreq/fs, maxFreq/fs, nHarmonics);
    pitch(iVector) = pitchVal*fs;
    iVector = iVector + nShift;
end



%% Plot 
specSegmentLength = round(2*nSegmentLength);
specWindow = gausswin(specSegmentLength);
nDft = 4096;
specNOverlap = round(3*specSegmentLength/4);
[S, F, T] = spectrogram(in(:,1), specWindow, specNOverlap, nDft, fs);

imagesc(T*fs,F,20*log10(abs(S)))
set(gca,'YDir','normal')
hold on
plot(pitch,'r')
ylim([0,1000])
hold off
xlabel('time [samples]')
ylabel('frequency [Hz]')