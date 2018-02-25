function opts = synopsis_opts(Q1, J)

T = 2^J;

% Options for spectrogram.
opts{1}.banks.time.nFilters_per_octave = Q1;
opts{1}.banks.time.T = T;
opts{1}.banks.time.max_scale = 8192;
opts{1}.banks.time.size = 2 * 2^nextpow2(Q1 * T);
opts{1}.banks.time.is_chunked = true;
opts{1}.banks.time.gamma_bounds = [1 Q1*9];
opts{1}.banks.time.duality = 'hermitian';
opts{1}.banks.time.wavelet_handle = @morlet_1d;
opts{1}.invariants.time.invariance = 'summed';

% Options for temporal modulations.
opts{2}.banks.time.nFilters_per_octave = 1;
opts{2}.banks.time.wavelet_handle = @morlet_1d;
opts{2}.banks.time.duality = 'hermitian';
opts{2}.invariants.time.invariance = 'summed';
 
% Options for frequential modulations.
opts{2}.gamma.banks.duality = 'hermitian';
opts{2}.gamma.banks.nFilters_per_octave = 1;
opts{2}.banks.time.wavelet_handle = @morlet_1d;
opts{2}.gamma.banks.subscripts = 3;
opts{2}.banks.time.duality = 'hermitian';

end