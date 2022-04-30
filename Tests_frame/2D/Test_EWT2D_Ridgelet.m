%% This script permits to test the 2D Empirical Ridgelet Transform
% It generates all the results given in the paper
% J. Gilles, G. Tran, S. Osher, "2D Empirical tranforms. Wavelets, 
% Ridgelets and Curvelets Revisited" submitted at SIAM Journal on
% Imaging Sciences. 2013
%
% Don't hesitate to modify the parameters and try
% your own images!
%
% Author: Jerome Gilles - Giang Tran
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
clear all

%% User setup
% Choose the image you want to analyze (texture,lena,barb)
signal = 'texture';

% Choose the wanted preprocessing (none,plaw,poly,morpho,tophat)
params.globtrend = 'none';
params.degree=5; % degree for the polynomial interpolation

% Choose the wanted regularization (none,gaussian,average,closing)
params.reg = 'none';
params.lengthFilter = 10;
params.sigmaFilter = 1.5;

% Choose the wanted detection method (locmax,locmaxmin,ftc,scalespace)
params.detect = 'scalespace';
params.typeDetect='otsu'; %for scalespace:otsu,halfnormal,empiricallaw,mean,kmeans

params.N = 4; % maximum number of band for the locmaxmin method
params.completion=0;

% Perform the detection on the log spectrum instead the spectrum
params.log=0;

% Choose the results you want to display (Show=1, Not Show=0)
Bound=1;   % Display the detected boundaries on the spectrum
Comp=1;    % Display the EWT components
Rec=1;     % Display the reconstructed signal
           
switch lower(signal)
    case 'texture'
        load('texture.mat');
    case 'lena'
        load('lena.mat');
    case 'barb'
        load('barb.mat');
end

%% We perform the 2D Littlewood-Paley EWT
[ewtc,mfb,boundaries]=EWT2D_Ridgelet(f,params);

%% Show results
if Comp==1
   Show_EWT2D(ewtc);
end

if Rec==1
   rec=iEWT2D_Ridgelet(ewtc,mfb);
   figure;imshow(rec,[]); 
   disp('Reconstruction error:');
   norm(f(:)-rec(:),Inf)
end

if Bound==1
   EWT_LP_boundaries(f,boundaries)
end