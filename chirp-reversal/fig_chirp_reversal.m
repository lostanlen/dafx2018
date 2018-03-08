%%
addpath(genpath('~/scattering.m'));


%% Options for spectrogram.
Q1 = 24;
T = 2^10;
opts = cell(1, 1);
opts{1}.time.nFilters_per_octave = Q1;
opts{1}.time.T = T;
opts{1}.time.size = 131072;
opts{1}.time.gamma_bounds = [1+Q1*0.5 Q1*1.5];
opts{1}.time.wavelet_handle = @morlet_1d;
opts{1}.time.is_chunked = false;

archs = sc_setup(opts);


%%

[x, fs] = audioread('reich_rev_filtered.wav');
x = x(1:131072);
[S, U] = sc_propagate(x, archs);


%
x_U1 = display_scalogram(U{1+1});
x_U1 = x_U1(1:21, 1:(7/8*end));

imagesc(-log1p(10*min(x_U1, 1)));
colormap rev_magma
