# Image-Denoising
This project applies different image de-noising methods on natural and synthetic images that are distorted by level 5 AWGN (Additive white Gaussian noise), and conducts a comparative evaluation on the results of different methods in terms of quantity and quality.

<br/>

## Program Usage
1.  Open the “Test.m” script in the “code” Folder in Matlab. 
2.  Run the “Test.m” script.

<br>

## Parameter Settings
* For wavelet methods, both hard and soft filters are tested. We choose Biorthogonal 3.5 as the wavelet filter when comparing wavelet with other method. The DWT level is set as 3.
* For BM3D, the sigma value is set as 25.
* For spatial filters, the kernel size is set as 5x5.
* For Contra Harmonic Mean Filters, the positive and negative Q parameters are set as 1.5 and -1.5 respectively.

<br>

## Evaluation Metrics
* For quantitative analysis, the evaluation metrics include the well-known PSNR as well as PSNR-HVS-M suggested by Nikolay Ponomarenko, et al (On between-coefficient contrast masking of DCT basis functions, CD-ROM Proceedings of the Third International Workshop on Video Processing and Quality Metrics for Consumer Electronics VPQM-07, Scottsdale, Arizona, USA, 25-26 January, 2007, 4 p).

* For qualitative analysis, we observe the de-noised images visually to make subjective evaluations on their visual qualities.

<br>

## Quantitative Evaluation Results
10 de-noising methods have been tested, and their quantitative results are shown as below:

| Methods | Natural Images PSNR | Natural Images PSNR-HVS-M | Synthetic Images PSNR | Synthetic Images PSNR-HVS-M |
| --- | --- | --- | --- | --- |
| Wavelet Soft | 26.675779 | 24.892400 | 18.323596 | 20.717732 |
| Wavelet Hard | 26.503098 | 25.253358 | 20.242995 | 22.673620 |
| BM3D | 29.465977 | 29.398808 | 26.115930 | 30.154313 |
| Arithmetic Mean |	24.622222	| 22.720622	| 15.153704	| 16.424611 |
| Geometric Mean | 21.755651 | 18.621081 | 10.419596 | 7.208516 |
| Harmonic Mean |	20.982258 | 17.587961 |	9.888079 | 6.510725 |
| Positive ContraHarmonic Mean | 21.125803 | 17.743720 | 11.782731 | 9.021239 |
| Negative ContraHarmonic Mean | 20.093378 | 16.481105 | 9.434632 | 5.951107 |
| Median | 24.893158 | 22.920620 | 14.881578 | 15.471420 |
| Midpoint | 16.780611 | 12.749748 | 12.161655 | 9.552054 |

Insights:
* BM3D and wavelet produce competitive results, which always rank the first and second respectively in each column of the results. 
* Median filter generally outperforms the average filters, and Midpoint filter achieves the poor results.

<br/>

8 wavelet filters have been tested using soft thresholding, and their quantitative results are shown as below:

| Wavelet Filters (Soft) | Natural Images PSNR | Natural Images PSNR-HVS-M | Synthetic Images PSNR | Synthetic Images PSNR-HVS-M |
| --- | --- | --- | --- | --- |
| Haar | 23.622835 | 19.928527 | 17.451116 | 16.932536 |
| Daubechies | 24.647095 | 21.691431 | 16.872221 | 17.102421 |
| Coiflets | 24.219864 | 21.020080 | 16.626447 | 16.392394 |
| Symlets |	24.777326 | 21.940320 | 16.796563 | 17.104850 |
| Fejer-Korovkin | 24.014337 | 21.156380 | 17.347374 | 17.448833 |
| Discrete Meyer | 24.859222 | 21.967668 | 16.658263 | 16.888724 |
| Biorthogonal | 26.675779 | 24.892400 | 18.323596 | 20.717732 |
| Reverse Biorthogonal | 22.834260 | 19.172639 | 15.672878 |14.445390 |

Insights:
The Biorthogonal filter outperforms all other Wavelet filters in each column of measurement, which is why we choose Biorthogonal filter as the Wavelet filter when comparing Wavelet with other de-noising methods.

<br/>

## Qualitative Evaluation Results
We conduct the qualitative evaluation by examining the de-noised images of different methods, and get the following insights:
* BM3D and Wavelet are the best two denoising methods.
* BM3D can reduce much noise density, however it tends to smoothen the images and lose important details. 
* Wavelet performs quite well in denoising natural images but cannot outperform BM3D from either quantitative or qualitative aspect. 
* All the denoising methods get worse results for synthetic images than their results for natural images, and the rankings of different methods with respect to processing natural and synthetic images are different, which indicates the performance and strength of each method may also depend on specific image data.

Note: The de-noised images of different methods can be found in the “results” folder.
