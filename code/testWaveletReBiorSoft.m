function denoisedImg = testWaveletReBiorSoft(distortImg)
distortImg = im2double(distortImg);
wname = 'rbio3.5';
level = 3;

[C,S] = wavedec2(distortImg,level,wname);

thr = wthrmngr('dw2ddenoLVL','penalhi',C,S,3);
sorh = 's';

[denoisedImg,~,~] = wdencmp('lvd',C,S,wname,level,thr,sorh);

denoisedImg = im2uint8(denoisedImg);