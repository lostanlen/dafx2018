%% Load signal
[y, fs] = audioread(['~/dafx2018/data/original_waveforms/', ...
    'Synopsis_Seriation_dataset_Synopsis_Seriation_1.wav']);

N = 2^20; % TODO make this 2^19
Q1 = 12;
x = y(1:N);

%% 
clear opts;

opts{1}.time.nFilters_per_octave = Q1;
opts{1}.time.T = N;
opts{1}.time.max_scale = Inf;
opts{1}.time.size = N;
opts{1}.time.is_chunked = false;
opts{1}.time.gamma_bounds = [1 Q1*12];
opts{1}.time.wavelet_handle = @morlet_1d;

%opts{2}.time.nFilters_per_octave = 1;
%opts{2}.time.wavelet_handle = @morlet_1d;

%opts{2}.gamma.nFilters_per_octave = 1;
%opts{2}.gamma.subscripts = 2;

archs = sc_setup(opts);

%%
hamming_window = 0.5 - 0.5 * fftshift(cos(2*pi*((-N/2):((N/2)-1))/N).');
x_windowed = x .* hamming_window;

[S, U] = sc_propagate(x_windowed, archs);
U1 = display_scalogram(U{1+1});
imagesc(log1p(U1));
%%