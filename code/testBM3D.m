function denoisedImg = testBM3D(distortImg)

BM3D_SIGMA = 25;
[~,denoisedImg]=BM3D(1,distortImg,BM3D_SIGMA);
denoisedImg=im2uint8(denoisedImg);