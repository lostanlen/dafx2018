addpath(genpath('~/scattering.m'));
Q1 = 12;
N = 2^17;


%% Load and pad signal.
[y, fs] = audioread(['/scratch/vl1019/dafx2018_data/original_waveforms/', ...
    'Synopsis_Seriation_dataset_Synopsis_Seriation_', ...
    int2str(channel_id), '.wav']);

y_length = length(y);
y_duration = y_length / fs;
hop_length = N / 2;
n_hops = ceil(y_length / hop_length);

padded_y_length = (1+n_hops) * hop_length;
padding_length = padded_y_length - y_length;
padded_y = cat(1, y, zeros(padding_length, 1));


%% Build scattering transform, filter, and window.

opts{1}.time.nFilters_per_octave = Q1;
opts{1}.time.T = N;
opts{1}.time.max_scale = Inf;
opts{1}.time.size = N;
opts{1}.time.is_chunked = false;
opts{1}.time.gamma_bounds = [1 Q1*16];
opts{1}.time.wavelet_handle = @morlet_1d;

opts{2}.time.nFilters_per_octave = 1;
opts{2}.time.wavelet_handle = @morlet_1d;

opts{2}.gamma.nFilters_per_octave = 1;
opts{2}.gamma.subscripts = 2;

archs = sc_setup(opts);

d = designfilt('bandpassiir', ...
    'FilterOrder', 2, ...
    'HalfPowerFrequency1', 100, ...
    'HalfPowerFrequency2', 10000, ...
    'SampleRate', fs);

hamming_window = 0.5 - 0.5 * fftshift(cos(2*pi*((-N/2):((N/2)-1))/N).');


%% Compute scattering transform.

% Extract frame.
hop_id = 0;
hop_start = 1 + hop_id * hop_length;
hop_stop = hop_start + N - 1;
x = padded_y(hop_start:hop_stop);

% Window.
x_windowed = x .* hamming_window;
x_windowed_filtered = filtfilt(d, x_windowed);

% Compute scattering transform.
[S, U] = sc_propagate(x_windowed_filtered, archs);

% Format scattering transform.
Sf = sc_format(S);
n_features = size(Sf, 1);

% Initialize matrix.
X = zeros(n_features, n_hops);

for hop_id = 0:(n_hops-1)
    % Extract frame.
    hop_start = 1 + hop_id * hop_length;
    hop_stop = hop_start + N - 1;
    x = padded_y(hop_start:hop_stop);

    % Window.
    x_windowed = x .* hamming_window;
    x_windowed_filtered = filtfilt(d, x_windowed);

    % Compute scattering transform.
    [S, U] = sc_propagate(x_windowed_filtered, archs);

    % Format scattering transform.
    Sf = sc_format(S);
    Sf = Sf(:, 2);

    % Store as a column in X.
    X(:, 1+hop_id) = Sf;
end


%% Save scattering transform at MAT file.
scattering_dir = '/scratch/vl1019/dafx2018_data/scattering_transforms/';
scattering_name = ['Synopsis_scattering_ch-', ...
    sprintf('%0.2d', channel_id), '.mat'];
scattering_path = [scattering_dir, scattering_name];
save(scattering_path, 'X', '-v7.3');
