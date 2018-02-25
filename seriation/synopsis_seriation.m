%% Setup wavelet filterbanks.
% Import toolboxes.
addpath(genpath('~/scattering.m'));
addpath(genpath('~/export_fig'));

Q1 = 4;
J = 13;
T = 2^J;
opts = synopsis_opts(Q1, J);
archs = sc_setup(opts);


%% Load and buffer signal.
waveform_path = 'Formulations_textures-1_splice08_Q=12_J=08_sc=tf.wav';
[waveform, sample_rate] = audioread(waveform_path);
waveform = waveform((8.0*sample_rate):(18.0*sample_rate));
n_frames = 40;
waveform = waveform(1:(n_frames*T));
waveform(1:(end/4)) = randn(round(length(waveform)/4), 1);
waveform = waveform(end:-1:1);


hop_length = T / 2;
n_hops = 2 * n_frames - 1;
buffered_waveform = zeros(T, n_hops);
hann_window = hann(T);
for hop_id = 1:n_hops
    buffer_start = 1 + (hop_id-1) * hop_length;
    buffer_stop = buffer_start + T - 1;
    buffer = waveform(buffer_start:buffer_stop);
    buffer = buffer .* hann_window;
    buffered_waveform(:, hop_id) = buffer;
end


%% Compute scattering transform.
S = sc_propagate(buffered_waveform, archs);
S = sc_format(S, [1, 2]);


%%
S_l1norm = sum(abs(S), 1);
X = bsxfun(@rdivide, S, S_l1norm);

%%
threshold = Inf;
t0 = 1;
t1 = 1;
segments = {};
tmp = [];

while t1 < size(X, 2)
    t1 = t1 + 1;
    
    % Define range of temporal samples.
    t = (t0:(t1-1));
    
    % Compute cumulative sums
    Xp = cumsum(X(:, t), 2);
    Xpf = sum(X(:, t), 2) + X(:, t1);
    Xf = bsxfun(@minus, Xpf, Xp);

    % Compute half-logarithm of generalized likelihood ratio.
    glm = ...
        (t1 - t0) * entropy(Xpf) + ...
        (t - t0) .* entropy(Xp) + ...
        (t1 - t) .* entropy(Xf);
    
    % Maximize entropy.
    [max_entropy, delta_t] = max(glm);
    tmp = [tmp, delta_t];
    
    % Test alternate hypothesis.
    if max_entropy > threshold
        t0 = t0 + delta_t -1;
        segments = cat(1, segments, t0);
    end

    
end



%%
imagesc(log1p(S(1:40, :)));
magma_colormap = magma();
rev_magma_colormap = magma_colormap(end:-1:1, :);
colormap(rev_magma_colormap);
