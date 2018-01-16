function denoisedImg = testWaveletBiorHard(distortImg)
distortImg = im2double(distortImg);
wname = 'bior3.5';
level = 3;

[C,S] = wavedec2(distortImg,level,wname);

thr = wthrmngr('dw2ddenoLVL','penalhi',C,S,3);
sorh = 'h';

[denoisedImg,~,~] = wdencmp('lvd',C,S,wname,level,thr,sorh);

denoisedImg = im2uint8(denoisedImg);