% comb filter function
clear all;
[in, fs] = audioread("C:\Users\helme\Documents\Sound and Music Computing\SMC8\Sound and Music Signal Analysis\4. Slides and Exercises\Lecture 6 pitch estimation I\Exercises-20210407\09viola.flac");
overlap = 75;
nData = length(in);
segmentLength =  25/1000;
nSegmentLength = segmentLength * fs;
iVector = 1:nSegmentLength;
nShift = round((1-overlap/100)*nSegmentLength);
nSegments = ceil((nData-nSegmentLength+1)/nShift);
pitch = zeros(nSegments,1);

for i = 1:nSegments
    pitchVal =  PEAC(in(iVector), 100/fs, 1000/fs);
    pitch(i) = pitchVal*fs;
    iVector = iVector + nShift;
    if i > 1553
        %dbstop at 18
    end
end

specSegmentLength = round(2*nSegmentLength);
specWindow = gausswin(specSegmentLength);
nDft = 4096;
specNOverlap = round(3*specSegmentLength/4);
[S, F, T] = spectrogram(in(:,1), specWindow, specNOverlap, nDft, fs);

subplot(211);
imagesc(T,F,20*log10(abs(S)))
set(gca,'YDir','normal')

ylim([0,1000])
hold off
xlabel('time [s]')
ylabel('frequency [Hz]')

subplot(212)
plot(pitch)
ylim([0,1000]) 