function denoisedImg = testMinFilter(distortImg)
KERNEL_SIZE = [5,5];
denoisedImg = minFilter(distortImg, KERNEL_SIZE(1), KERNEL_SIZE(2));