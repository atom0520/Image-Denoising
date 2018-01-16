function denoisedImg = testMidpointFilter(distortImg)
KERNEL_SIZE = [5,5];
denoisedImg = midpointFilter(distortImg, KERNEL_SIZE(1), KERNEL_SIZE(2));