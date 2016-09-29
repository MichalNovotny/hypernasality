function [Fn_mean, Fn_std, Fn_trend]=nasality(x, Fs)
%NASALITY Evaluates level and behavior of nasality during sustained phonation /i/.
%
%   [Fn_mean, Fn_std, Fn_trend]=nasality(x, Fs), where x is audio signal 
%   and Fs is sampling frequency, uses 1/3-octave spectra analysis to 
%   evaluate level and behavior of nasalance in the utterance. For the 
%   purposes of analysis a IIR filter bank is used and the computed values 
%   are transformed to dB scale using the sum of energy across of all 
%   1/3-octave spectra bands as the reference value.
%
%   Examples:
%
%   Define x and Fs:
%       [x,Fs]=audioread('HC06_2Ri.wav')
%       [Fn_mean, Fn_std, Fn_trend]=nasality(x,Fs)
%
%   Define x and assume Fs=48000Hz;
%       [x,Fs]=audioread('HC06_2Ri.wav')
%       [Fn_mean, Fn_std, Fn_trend]=nasality(x)
%
%  If you find this algorithm useful and wish to reference it in your publications, you can make a reference directly to this article: 
%  M. Novotny, J. Rusz, R. Cmejla, H. Ruzickova, J. Klempír, E. Ruzicka. (2016). "Hypernasality associated with basal ganglia dysfunction: evidence from Parkinson’s disease and Huntington’s disease, PeerJ, 4: 2530. 

 if nargin < 1
     error('myApp:argChk', 'Low number of input arguments')
 elseif nargin == 1;
     Fs = 48000;
 end

    fs=20000;
    stp=0.06*fs;
    
    pfilt=[];  
    ffilt=[];  
%% trim signal beginning and end
    x=x(floor(0.1*length(x(:,1))):ceil(0.9*length(x(:,1))),1);

%% downsample x to 20kHz and pre-process x
    x=resample(x,fs,Fs);
    x=x-mean(x);
    x=x/max(abs(x));

%% deffine window
    nsteps=floor(length(x)/stp);

%% first window analysis
    i=1;
    x2=x((i-1)*stp+1:i*stp);
    x2=x2.*hamming(length(x2));
    [pfilt(:,i),ffilt(:,i)]=oct3bank(x2,fs);
    

%% subsequent windows analysis
    for i = 2:nsteps
        x2=x((i-1)*stp+1:i*stp);
        x2=x2.*hamming(length(x2));
        [pfilt(:,i),ffilt(:,i)]=oct3bank(x2,fs);
    end
    
%% dB scale
    pfilt_dB=10*log10(pfilt./repmat(sum(pfilt),18,1));
    
   
%% 1kHz band
     Fn=pfilt_dB(12,:);
    
%% Fn features
    Fn_mean = mean(Fn);
    Fn_std = std(Fn);
    Fn_trend=robustfit(1:length(Fn),Fn);
    Fn_trend=Fn_trend(2);
   
