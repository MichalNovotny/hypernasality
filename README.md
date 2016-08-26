# Hypernasality
1/3 octave spectra analysis of sustained phonation

# Example
Nasality is described using the parameters Fn_mean, Fn_std and Fn_trend. These parameters are 
evaluated by the function 'nasality.m' which is designed for prolonged vowels /i/ and may be 
called as:

		[x,Fs]=audioread('prolonged_vowel_i.wav');
		[Fn_mean, Fn_std, Fn_trend]=nasality(x,Fs)

# Dependencies

	Matlab:

			Signalprocessing Toolbox
			Statistics and Machine Learning Toolbox

	This algorithm is based on 1/3 octave filter bank designed by Christophe Couvreur.
	Avalilable at: https://www.mathworks.com/matlabcentral/fileexchange/69-octave/content/octave/oct3bank.m
