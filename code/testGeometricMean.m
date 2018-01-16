function denoisedImg = testGeometricMean(distortImg)

KERNEL_SIZE = [5,5];

distortImg = im2double(distortImg);

denoisedImg = gMean(distortImg,KERNEL_SIZE(1),KERNEL_SIZE(2));

denoisedImg=im2uint8(denoisedImg);
