DAFX 4 AUDIO TEXTURE SYNTHESIS

In this section, we describe a gradient descent algorithm for re-synthesizing a sound from its time-frequency scattering coefficients, after they have been averaged at the typical time scale $T=\SI{500}{ms}$. We describe how the recursive process involved in this algorithm, gradually converging from random Gaussian noise towards an almost identical reconstruction, is applied to the creation of five computer music pieces.


three pieces, dramatizing the ideas of compositional time, computational time, and pluriphony.

DAFX 5 SCALE-RATE DAFX
As an example, we implement chirp rate reversal, a new digital audio effect that flips the pitch contour of every note in a melody.

In spite of its wide adoption, the phase vocoder is inherently limited by its dichotomy of time scales
This observation has led to specific improvements (cite Röbel).


The development of digital audio technology allowed composers to apply so-called \emph{intimate transformations} \cite{risset1999chapter} to music signals, affecting certain certain time scales of sound perception while preserving others.
The most prominent of such transformations is perhaps the phase vocoder \cite{roebel2010dafx}, which transposes melodies and/or stretches them in time.
For example, the phase vocoder of \cite{kronland1988cmj} implements frequency transposition in the wavelet domain as a translation on the axis $\log \lambda$ while leaving the temporal dimension $t$ unchanged.
As such, it affects time scales corresponding to the auditory range (20 Hz to 20 kHz) while leaving time scales corresponding to the perception of transients and melody (20 Hz and below) unchanged.
In spite of its wide adoption, the phase vocoder is inherently restricted by the dichotomy of time scales it imposes on the signal: there is no mid-level time scale betweeen the hearing range (above 20 Hz) and the perception of transients (below 20 Hz). As such, there is no possibility of designing intimate transformation that will preserve both the spectral envelope and the temporal envelope, but will affect some mid-level aspects of musical timbre, corresponding to time scales between 2 Hz and 20 Hz.
With the time-frequency scattering, we have three, rather than two levels.
In between the short time scales expressed by $lambda$ and the coarse scales expressed by $t$, there is room for spectrotemporal modulations $\alpha, \beta$.
Applications range from modifying the vibrato rate, vibrato depth, varying roughness.

In order to implement scale-rate DAFX, we amend Equation X into