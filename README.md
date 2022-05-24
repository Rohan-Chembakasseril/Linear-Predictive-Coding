# Linear Predictive Coding #
Linear Predictive Coding is a speech analysis technique used to estimate the basic parameters of speech as pitch (through frequency) and intensity (through loudness). Here, it is implemented and studied through Graphical User Interface(GUI) in MATLAB.

## Introduction: ##
Linear Predictive Coding is a speech analysis technique used to estimate the
basic parameters of speech. Speech samples can be approximated as a linear 
combination of the past samples by minimizing the error. This is done by minimizing 
the sum of squared differences between the actual speech signal samples and the linearly
predicted ones. The sampled input speech signal is applied to an analyzer,
which determines the parameters of the speech signal to be transmitted to the
synthesizer. This speech synthesizer reconstructs the approximated speech
signal. The input provided to the encoder is the comparison between the
sampled signal and the approximated signal with the parameters. This encoder
forms the digital signal known as LPC as output. This LPC output is provided to
the Low Pass Filter, which reconstructs the audio signal x(t) by performing the
interpolation of samples in the input.

## Graphical User Interface and working of LPC model: ##
<img src = "https://user-images.githubusercontent.com/88222317/169949712-c13954a6-e24d-40aa-bf65-22013d0673c4.png" width="800" height="350" />

* Graphical User Interface(GUI) is created in MATLAB using Guide in command
window.
* It has a button for recording the speech which records the sound for 5 seconds and is saved as a file and
a play button which plays the audio and plots the graph of the input speech
signal.
* It takes the input length of audio segment in ms and the percentage of overlap
from the user which segments it down into smaller segments.
* It has a dropdown menu which asks user to select the type of window(Hanning, Hamming, Bartlett, Blackman).
* It has a dropdown menu which asks use to slect the order of the filter(12,48,72,96)
* The sampled input speech signal is fed to analyzer for calculating the the filter coefficients of LP Filter and the pitch of each segment which is then fed to syntesizer for further operations.
* It has a button for pitch calculation which on clicking plots the pitch of each segment of the input speech signal.
* It has a button for reconstruction of signal without pitch and reconstruction of the signal with pitch. On clicking it shows the output graph and reconstructs the signal.
* The approximated speech signal is then reconstructed by syntesizer. The input to the encoder is the comparison between the sampled signal and the approximated signal with the parameters.
* The output obtained from encoder is the LPC output.
* The LPC output is then passed to to the Low Pass Filter for reconstruction of the speech signal using interpolation of samples of the input with two cases that are, with and without pitch information.


## Explanation of Linear Predictive Filter Code: ##
<img src ="https://user-images.githubusercontent.com/88222317/169951663-15fc09d6-a164-4b37-9617-d83a86a22bf7.png" width="800" height="400" />

## Results: ##
### Input Speech Signal: ###
<img src ="https://user-images.githubusercontent.com/88222317/169954931-085bc3a5-1313-4a8c-bda2-d7fab3635da9.png" width="800" height="350" />

### Plot of Pitch: ###
<img src ="https://user-images.githubusercontent.com/88222317/169955010-255abb72-284a-4f67-ba82-052455b978e2.png" width="800" height="350" />

### Reconstruction of Speech Signal Without Pitch: ###
<img src ="https://user-images.githubusercontent.com/88222317/169955785-dd2b3ed1-3fa0-41f6-be7e-369309b1d456.png" width="800" height="350" />


### Reconstruction of Speech Signal With Pitch: ###
<img src ="https://user-images.githubusercontent.com/88222317/169955537-49a3350f-30c3-4b8c-b65b-8b7de0ad67df.png" width="800" height="350" />


## Analysis of Reconstructed Speech: ##
### For LP Filter of Order 12: ###
The quality of the reconstructed speech signal output was relatively low. As
compared to the original speech signal, due to higher rate of compression, the
output speech signal was distorted and less legible. The pitch of output signal
was also low, as the output was deeper than the input speech.

### For LP Filter of Order 48: ###
The quality of output speech signal increases as the number of previous samples
(order of the LP filter) for prediction increases. Thus, due to a lesser rate of
compression (higher order filter – 48), the reconstructed speech signal was less
distorted and more legible. The pitch of output was also marginally higher than
before.

### For LP Filter of Order 72: ###
As order of the LP filter increases, the quality of output speech signal increases.
The speech is much more understandable due to very less distortion. The
distortion is less as the rate of compression is less. Thus, overall output quality
is better for the LP filter of order 72.

### For LP Filter of Order 96: ###
Quality of output speech signal is the best for a LP filter of order 96. Since 96
previous samples have been considered to reconstruct the output, the
compression rate is less, and thus the distortion of the output is also less. The
output is completely legible and quality is not coarse, as compared to the
previous lower order filters.

## Computation of Amount of Compression achieved with Filters of different Orders: ##
Order of LP Filter  | Without Pitch Detection  | With Pitch Detection
------------------  | -----------------------  | --------------------
12                  | 9.3 to 1                 | 8.6 to 1
48                  | 2.45 to 1                | 2.35 to 1
72                  | 1.65 to 1                | 1.57 to 1
96                  | 1.24 to 1                | 1.20 to 1

## Comparison of Quality of Speech Reconstruction With and Without Pitch Detection: ##
* With Pitch Detection:
    * The rate of compression of input speech signal is reduced and hence the distortion in the output is also reduced.
    * It produces a clear output and the nasality tone of the output was more prominent.
* Without Pitch Detection:
    * It produces a signal with higher pitch/depth.

## Link to the Video of the Project: ##
click [here](https://drive.google.com/file/d/1NT17fd1ytRTeBPmg53qjrnF1My6NuH2K/view?usp=sharing) to view the demonstration.
