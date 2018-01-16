clc; clear;

IMG_NUM = 30;

imgTypes = {};
imgTypes{end+1}='natural';
imgTypes{end+1}='synthetic';

deFuncs = {};
deNames = {};

deFuncs{end+1}=@testArithmeticMean;
deNames{end+1}='arithmeticMean';

deFuncs{end+1}=@testGeometricMean;
deNames{end+1}='geometricMean';

deFuncs{end+1}=@testHarmonicMean;
deNames{end+1}='harmonicMean';

deFuncs{end+1}=@testPosContraharmonicMean;
deNames{end+1}='posContraHarmonicMean';

deFuncs{end+1}=@testNegContraharmonicMean;
deNames{end+1}='negContraHarmonicMean';

deFuncs{end+1}=@testMedianFilter;
deNames{end+1}='median';

deFuncs{end+1}=@testMaxFilter;
deNames{end+1}='max';

deFuncs{end+1}=@testMinFilter;
deNames{end+1}='min';

deFuncs{end+1}=@testMidpointFilter;
deNames{end+1}='midpoint';

deFuncs{end+1}=@testBM3D;
deNames{end+1}='BM3D';

deFuncs{end+1}=@testWaveletHaarSoft;
deNames{end+1}='waveletHaarSoft';

deFuncs{end+1}=@testWaveletDbSoft;
deNames{end+1}='waveletDbSoft';

deFuncs{end+1}=@testWaveletCoifSoft;
deNames{end+1}='waveletCoifSoft';

deFuncs{end+1}=@testWaveletSymSoft;
deNames{end+1}='waveletSymSoft';

deFuncs{end+1}=@testWaveletFKSoft;
deNames{end+1}='waveletFKSoft';

deFuncs{end+1}=@testWaveletDMeyerSoft;
deNames{end+1}='waveletDMeyerSoft';
 
deFuncs{end+1}=@testWaveletBiorSoft;
deNames{end+1}='waveletBiorSoft';

deFuncs{end+1}=@testWaveletBiorHard;
deNames{end+1}='waveletBiorHard';

deFuncs{end+1}=@testWaveletReBiorSoft;
deNames{end+1}='waveletReBiorSoft';

for k = 1:length(imgTypes)
    imgType = imgTypes{k};
    
    cleanImgPath = strcat('..\data\',imgType,'\clean\');
    
    cleanImgFiles = dir(strcat(cleanImgPath,'*.png'));
    cleanImgs = cell(1,IMG_NUM);
    cleanImgFilenames = cell(1,IMG_NUM);
    
    for i = 1 : length(cleanImgFiles)
      filename = strcat(cleanImgPath,cleanImgFiles(i).name);
      img = imread(filename);
      cleanImgs{i}=img;
      cleanImgFilenames{i}=cleanImgFiles(i).name;
    end

    distortedImgPath = strcat('..\data\',imgType,'\distorted\');

    distortedImgFiles = dir(strcat(distortedImgPath,'*.png'));
    distortedImgs = cell(1,IMG_NUM);
    distortedImgFilenames = cell(1,IMG_NUM);

    for i = 1 : length(distortedImgFiles)
      filename = strcat(distortedImgPath,distortedImgFiles(i).name);
      img = imread(filename);
      distortedImgs{i}=img;
      distortedImgFilenames{i}=distortedImgFiles(i).name;
    end
        
    imgNum = length(distortedImgs);
    
    prePSNRs = zeros(1,IMG_NUM);    
    prePSNR_HVSs = zeros(1,IMG_NUM);
    prePSNR_HVS_Ms = zeros(1,IMG_NUM);
    
    if images.internal.isFigureAvailable()
        testProgressBar = waitbar(0,strcat({'Compute the original metric values of '},imgType,' images...'));
    else
        testProgressBar = [];
    end

    for i = 1:imgNum     
        prePSNRs(i) = psnr(distortedImgs{i},cleanImgs{i});

        [prePSNR_HVS_Ms(i), prePSNR_HVSs(i)] = psnrhvsm(distortedImgs{i},cleanImgs{i});        

        if ~isempty(testProgressBar)
           waitbar(i/imgNum,testProgressBar);
        end
    end
    
    avgPrePSNR = mean(prePSNRs);
    avgPrePSNR_HVS = mean(prePSNR_HVSs);
    avgPrePSNR_HVS_M = mean(prePSNR_HVS_Ms);
    
    close(testProgressBar);
    
    % test denoising methods
    for j = 1:length(deFuncs)

        postPSNRs = zeros(1,IMG_NUM);    
        postPSNR_HVSs = zeros(1,IMG_NUM);
        postPSNR_HVS_Ms = zeros(1,IMG_NUM);

        resultsPath = strcat('..\results\',deNames{j},'\',imgType,'\');
        status = mkdir(resultsPath);
        txtFilename = strcat('results_',deNames{j},'.txt');

        fileID = fopen(strcat(resultsPath,txtFilename),'w');

        fprintf(fileID,'%-24s%-32s%-32s%-32s\r\n','Image Name','PSNR','PSNR-HVS','PSNR-HVS-M');

        if images.internal.isFigureAvailable()
            testProgressBar = waitbar(0,strcat({'Apply '},deNames{j},{' to '},imgType,' images...'));
        else
            testProgressBar = [];
        end     

        for i = 1:imgNum
            deFunc = deFuncs{j};
            denoisedImg=deFunc(distortedImgs{i});

            denoisedImg = im2uint8(denoisedImg);

            postPSNRs(i) = psnr(denoisedImg,cleanImgs{i});

    %         denoisedImg_im2double = im2double(denoisedImg);
    %         denoisedImg_double = double(denoisedImg);
    %         denoisedImg_double_im2uint8 = im2uint8(denoisedImg_double);
    %         denoisedImg_im2double_im2uint8 = im2uint8(denoisedImg_im2double);
 
            [postPSNR_HVS_Ms(i), postPSNR_HVSs(i)] = psnrhvsm(denoisedImg,cleanImgs{i});        

            imgNameParts = split(cleanImgFilenames{i},'_');

            fi = figure;  
            set(fi, 'Visible', 'off');

            subplot(1, 3, 1), imshow(cleanImgs{i}), title('clean');
            subplot(1, 3, 2), imshow(distortedImgs{i}), title('distorted');
            subplot(1, 3, 3), imshow(denoisedImg), title('denoised');    

            fprintf(fileID,'%-24s',imgNameParts{1});

            fprintf(fileID,'%-10f->%-20f',prePSNRs(i),postPSNRs(i));
            fprintf(fileID,'%-10f->%-20f',prePSNR_HVSs(i), postPSNR_HVSs(i));
            fprintf(fileID,'%-10f->%-20f\r\n',prePSNR_HVS_Ms(i), postPSNR_HVS_Ms(i));

            figureName = strcat(resultsPath,imgNameParts{1},'_',deNames{j},'.png');    
            saveas(gcf,figureName);

            if ~isempty(testProgressBar)
               waitbar(i/imgNum,testProgressBar);
            end
            
            clear deFunc
            clear denoisedImg
            clear imgNameParts
            
            clear fi
            
            clear figureName
        end

        fprintf(fileID,'\r\n');
     
        avgPostPSNR = mean(postPSNRs);
        fprintf(fileID,'Average PSNR: %-10f->%-20f\r\n',avgPrePSNR,avgPostPSNR);

        avgPostPSNR_HVS = mean(postPSNR_HVSs);
        fprintf(fileID,'Average PSNR-HVS: %-10f->%-20f\r\n',avgPrePSNR_HVS,avgPostPSNR_HVS);

        avgPostPSNR_HVS_M = mean(postPSNR_HVS_Ms);
        fprintf(fileID,'Average PSNR-HVS-M: %-10f->%-20f\r\n',avgPrePSNR_HVS_M,avgPostPSNR_HVS_M);
        fclose(fileID);

        close(testProgressBar);
        
        clear postPSNRs
        clear postPSNR_HVSs
        clear postPSNR_HVS_Ms
        
        clear resultsPath
        clear status
        clear txtFilename
        clear fileID
        
        clear avgPostPSNR
        clear avgPostPSNR_HVS
        clear avgPostPSNR_HVS_M
        
        clear testProgressBar
    end
    
    clear cleanImgPath
    clear cleanImgFiles
    clear cleanImgs
    clear cleanImgFilenames
    
    clear distortedImgPath
    clear distortedImgFiles
    clear distortedImgs
    clear distortedImgFilenames
    
    clear prePSNRs
    clear prePSNR_HVSs
    clear prePSNR_HVS_Ms
    
    clear avgPrePSNR
    clear avgPrePSNR_HVS
    clear avgPrePSNR_HVS_M
end
 

