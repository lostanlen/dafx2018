function [S, F, T] = my_spectrogram(x, window, noverlap, nfft, fs)
%       Calculate and plot the spectrogram of a time-domain audio signal.
%
%       Parameters
%       ----------
%       x_t : 1 x T array
%           time domain signal
%       window : N x 1 array or int
%           if array, a window function of length N; if int, the length of
%           a Hamming window, N
%       noverlap : int
%           number of overlapping samples
%       nfft : int
%           fft length (in samples)
%       fs : int
%           sample rate (Hz)
%
%       Returns
%       -------
%       S: K x M array
%           STFT matrix
%       F: K x 1 array
%           frequencies of the STFT bins (Hz)
%       T: 1 x M array
%           times of each STFT frame (s)
    [win_dim1, win_dim2] = size(window);
    if (win_dim1 == 1)
        win = hamming(window);
        win_size = window;
    else
        win = window;
        win_size = length(window);
    end

    % Compute DFT matrix
    %D = dftmtx(nfft);
    [N_idxs, K_idxs] = meshgrid(0:(nfft-1), 0:(nfft-1));
    D = conj(exp(2.0i*pi/nfft * N_idxs .* K_idxs));

    % Split x(t) into overlapping frames
    X = buffer(x, win_size, noverlap, zeros(win_size/2,1)); % <- Make sure the windows are centered
    [W, M] = size(X);

    % Truncates frames like MATLAB does (truncates signal so windows never
    % contain zero-padded values (unrelated to zero-padding to increase FFT
    % size))
    M = fix((length(x)-noverlap)/(win_size-noverlap));
    X = X(:,1:M);

    % Apply window function to each frame and zero pad
    for frame_idx = 1:M
       X(:, frame_idx) = X(:, frame_idx) .* win; 
    end

    % Truncate DFT matrix rows (equivalent to zero padding
    D = D(:, 1:W);

    if isreal(x)
        % If signal is real, truncate DFT matrix columns (to get rid of redundant half of matrix)
        D = D(1:nfft/2 + 1, :);
    end

    % Compute STFT matrix

    S = D * X;

    [K, N] = size(D);
    del_t = (win_size - noverlap) / fs;
    del_f = fs / nfft;
    % since we centered each STFT frame, the time for each should be hop_length / fs

    T = (0:(M-1)) .* del_t;
    F = (0:(K-1)) .* fs/nfft;
    F = F'; % Transpose to be consistent with MATLAB
end
