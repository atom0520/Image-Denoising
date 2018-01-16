function denoisedImg = testNegContraharmonicMean(distortImg)

CHMEAN_Q = -1.5;

KERNEL_SIZE = [5,5];

distortImg = im2double(distortImg);

denoisedImg = chMean(distortImg,KERNEL_SIZE(1),KERNEL_SIZE(2),CHMEAN_Q);

denoisedImg=im2uint8(denoisedImg);
