function opts = chirp_reversal_opts(Q1, J)

T = 2^J;

% Options for spectrogram.
opts{1}.time.nFilters_per_octave = Q1;
opts{1}.time.T = T;
opts{1}.time.max_scale = 8192;
opts{1}.time.size = 32768;
opts{1}.time.gamma_bounds = [1 Q1*4];
opts{1}.time.duality = 'hermitian';
opts{1}.time.wavelet_handle = @morlet_1d;
opts{1}.time.is_chunked = false;

% Options for temporal modulations.
opts{2}.time.nFilters_per_octave = 1;
opts{2}.time.wavelet_handle = @morlet_1d;
opts{2}.time.duality = 'hermitian';
 
% Options for frequential modulations.
opts{2}.gamma.duality = 'hermitian';
opts{2}.gamma.nFilters_per_octave = 1;
opts{2}.gamma.wavelet_handle = @morlet_1d;
opts{2}.gamma.subscripts = 2;


end