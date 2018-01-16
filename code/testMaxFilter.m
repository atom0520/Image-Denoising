function denoisedImg = testMaxFilter(distortImg)
KERNEL_SIZE = [5,5];
denoisedImg = maxFilter(distortImg, KERNEL_SIZE(1), KERNEL_SIZE(2));