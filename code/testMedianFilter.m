function denoisedImg = testMedianFilter(distortImg)
KERNEL_SIZE = [5,5];
denoisedImg = medianFilter(distortImg, KERNEL_SIZE(1), KERNEL_SIZE(2));