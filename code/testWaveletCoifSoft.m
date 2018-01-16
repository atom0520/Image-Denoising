function denoisedImg = testWaveletCoifSoft(distortImg)
distortImg = im2double(distortImg);
wname = 'coif4';
level = 5;

[C,S] = wavedec2(distortImg,level,wname);

thr = wthrmngr('dw2ddenoLVL','penalhi',C,S,3);
sorh = 's';

[denoisedImg,~,~] = wdencmp('lvd',C,S,wname,level,thr,sorh);

denoisedImg = im2uint8(denoisedImg);