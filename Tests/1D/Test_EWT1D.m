%% Script to test the Empirical Wavelet Transform
% Based on the papers:
% J. Gilles, "Empirical Wavelet Transform", IEEE
% Trans. on Signal Processing, 2013
% J. Gilles, G. Tran, S. Osher, "2D Empirical transforms. Wavelets, 
% Ridgelets and Curvelets Revisited", SIAM Journal on Imaging Sciences,
% 2014
% J. Gilles, K. Heal, "A parameterless scale-space approach to find 
% meaningful modes in histograms - Application to image and spectrum 
% segmentation", submitted 2014.
%
% Don't hesitate to modify the parameters and try
% your own signals!
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2014
% Version: 2.0
clear all
close all

%% User setup

% Choose the signal you want to analyze
% (sig1,sig2,sig3,sig4=ECG,sig5=seismic,sig6=EEG,sig7=compplex signal1)
signal = 'sig1';
params.SamplingRate = 16000; %put -1 if you don't know the sampling rate
%params.SamplingRate = 4000; %put -1 if you don't know the sampling rate
%channel = 50; %for EEG only

% Choose the wanted global trend removal (none,plaw,poly,morpho,tophat,opening)
params.globtrend = 'none';
params.degree=4; % degree for the polynomial interpolation

% Choose the wanted regularization (none,gaussian,average,closing)
params.reg = 'gaussian';
params.lengthFilter = 100;
params.sigmaFilter = 1.5;

% Choose the wanted detection method (locmax,locmaxmin,
% adaptive,adaptivereg,scalespace)
% params.detect = 'scalespace';
params.detect = 'scalespace';%locmax,locmaxmin,locmaxminf,adaptivereg,adaptive,scalespace
params.typeDetect='otsu'; %for scalespace:otsu,halfnormal,empiricallaw,mean,kmeans
params.N = 4; % maximum number of bands
params.completion = 0; % choose if you want to force to have params.N modes
                       % in case the algorithm found less ones (0 or 1)
params.InitBounds = [4 8 13 30];
% params.InitBounds = [2 25];

% Perform the detection on the log spectrum instead the spectrum
params.log=0;

% Choose the results you want to display (Show=1, Not Show=0)
Bound=1;   % Display the detected boundaries on the spectrum
Comp=1;    % Display the EWT components
Rec=1;     % Display the reconstructed signal
TFplane=0; % Display the time-frequency plane (by using the Hilbert 
           % transform). You can decrease the frequency resolution by
           % changing the subresf variable below. (WORKS ONLY FOR REAL
           % SIGNALS
Demd=0;    % Display the Hilbert-Huang transform (WORKS ONLY FOR REAL 
           % SIGNALS AND YOU NEED TO HAVE FLANDRIN'S EMD TOOLBOX)
           
subresf=1;

InitBounds = params.InitBounds;
           


fileId = fopen('E:\Matlab_workspace\Tests\1D\qianliuwei16000.pcm','r');
sin100500 = fread(fileId,inf,'int16');
% sin100500 = audioread('E:\Matlab_workspace\Tests\1D\cs375_20000.wav');
fid=fopen('E:\Matlab_workspace\Tests\Resignal.pcm','wb');
frame_num = 0;
cs_size = 4000;
f = sin100500((1):(cs_size));


t=0:length(f)-1;
%% We perform the empirical transform and its inverse
% compute the EWT (and get the corresponding filter bank and list of 
% boundaries)
[ewt,mfb,boundaries]=EWT1D(f,params);

% boundaries'*16000/2/pi
%% Show the results

if Bound==1 %Show the boundaries on the spectrum
    div=1;
    if (strcmp(params.detect,'adaptive')||strcmp(params.detect,'adaptivereg'))
        Show_EWT_Boundaries(f,boundaries,div,params.SamplingRate,InitBounds);
    else
        Show_EWT_Boundaries(f,boundaries,div,params.SamplingRate);
    end
end

if Comp==1 %Show the EWT components and the reconstructed signal
        Show_EWT(ewt);
end

if Rec==1
        %compute the reconstruction
        for ewi = 1:length(ewt)
            ewt_max(ewi) = max(ewt{ewi});
        end
        rec = zeros(cs_size,1);
        [ewt_max_num,ewt_max_index] = sort(ewt_max,'descend');
        for ewi = 1:length(ewt)
            if ewt_max_num(ewi) > ewt_max_num(1)*0.20
                ewt_index = ewi;
            end
        end
        for i = 1:ewt_index
            rec = rec + ewt{ewt_max_index(i)};
        end
        figure;
%         rec=iEWT1D(ewt,mfb,~isreal(f));
        subplot(2,1,1);plot(f);title('Original signal');
        subplot(2,1,2);plot(rec);title('Reconstructed signal');
%         filename = 'E:\Matlab_workspace\Tests\Resignal.wav';
%         audiowrite(filename,round(rec),16000);
        fwrite(fid,rec,'int16');
        disp('Reconstruction error:');
        norm(f-rec,Inf)
end

%Plot the time-frequency plane by using the Hilbert transform for the real
%case
if ((TFplane==1) && (isreal(f))) 
    EWT_TF_Plan(ewt,boundaries,params.SamplingRate,f,[],[],subresf,[]);
end

%% EMD comparison: if you have Patrick Flandrin's EMD toolbox you can 
%% perform the EMD and display the corresponding Time-Frequency plane
if Demd==1
    imf=emd(f);
    Disp_HHT(imf,t,f,1,1);
end