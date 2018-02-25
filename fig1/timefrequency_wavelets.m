addpath(genpath('~/scattering.m'));
addpath(genpath('~/export_fig'));

clear opts;
N = 32768;
opts{1}.time.size = N;
opts{1}.time.U_log2_oversampling = 3;
opts{1}.time.nFilters_per_octave = 48;
opts{1}.time.T = 256;
opts{1}.time.max_scale = 4096;

opts{2}.time.T = 32768;
opts{2}.time.U_log2_oversampling = 3;
opts{2}.time.handle = @morlet_1d;
opts{2}.time.max_Q = 1;
opts{2}.time.max_scale = Inf;
opts{2}.time.nFilters_per_octave = 2;

opts{2}.gamma.invariance = 'bypassed';
opts{2}.gamma.U_log2_oversampling = Inf;
opts{2}.gamma.S_log2_oversampling = Inf;
opts{2}.gamma.phi_bw_multiplier = 1;

archs = sc_setup(opts);

%%
Y2_1 = display_secondorder_wavelets(archs, 0.55);
z1 = Y2_1{3}{1,1}.data{10}{5}(:,:,1);
rez1 = real(z1(round(0.3*end):round(0.8*end), :).');
rez1 = rez1 / max(abs(rez1(:)));

Y2_2 = display_secondorder_wavelets(archs, 0.4);
z2 = Y2_2{3}{1,1}.data{11}{3}(:,:,2);
rez2 = real(z2(round(0.3*end):round(0.8*end), :).');
rez2 = rez2 / max(abs(rez2(:)));

Y2_3 = display_secondorder_wavelets(archs, 0.5);
z3 = Y2_3{3}{1,2}.data{11};
rez3 = real(z3(round(0.3*end):round(0.8*end), :).');
rez3 = rez3 / max(abs(rez3(:)));


%%
magma_colormap = hot();
inv_magma_colormap = 1 - magma_colormap(end:-1:1, :);
rev_magma_colormap = magma_colormap(end:-1:1, :);
div_magma_colormap = ...
    cat(1, inv_magma_colormap, rev_magma_colormap);
div_magma_colormap = div_magma_colormap(1:2:end, :);

%
rez = [rez1, rez2,rez3];
rez = rez(130:270, :);
rez(abs(rez(:)) < 1e-2) = 0.0;

median_rez = median(rez(:));
deviation = std(rez(:));

rez = (rez - median_rez) / (15.0 * deviation);
rez = (rez + 0.5) * 256;
image(1+rez);

colormap(div_magma_colormap);
axis off;

export_fig('dafx2018_fig1.png');