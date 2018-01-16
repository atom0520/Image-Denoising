clc; clear;

IMG_NUM = 30;

imgTypes = {};
imgTypes{end+1}='natural';
imgTypes{end+1}='synthetic';

deName = 'DL';

for k = 1:length(imgTypes)
    imgType = imgTypes{k};
    
    cleanImgPath = strcat('..\dl_data\',imgType,'\clean\');
    
    cleanImgFiles = dir(strcat(cleanImgPath,'*.png'));
    cleanImgs = cell(1,IMG_NUM);
    cleanImgFilenames = cell(1,IMG_NUM);
    
    for i = 1 : length(cleanImgFiles)
      filename = strcat(cleanImgPath,cleanImgFiles(i).name);
      img = imread(filename);
      cleanImgs{i}=img;
      cleanImgFilenames{i}=cleanImgFiles(i).name;
    end

    distortedImgPath = strcat('..\dl_data\',imgType,'\distorted\');

    distortedImgFiles = dir(strcat(distortedImgPath,'*.png'));
    distortedImgs = cell(1,IMG_NUM);
    distortedImgFilenames = cell(1,IMG_NUM);
    
    for i = 1 : length(distortedImgFiles)
      filename = strcat(distortedImgPath,distortedImgFiles(i).name);
      img = imread(filename);
      distortedImgs{i}=img;
      distortedImgFilenames{i}=distortedImgFiles(i).name;
    end
    
    denoisedImgPath = strcat('..\dl_data\',imgType,'\denoised\');

    denoisedImgFiles = dir(strcat(distortedImgPath,'*.png'));
    denoisedImgs = cell(1,IMG_NUM);
    denoisedImgFilenames = cell(1,IMG_NUM);
    
    for i = 1 : length(denoisedImgFiles)
      filename = strcat(denoisedImgPath,denoisedImgFiles(i).name);

      img = imread(filename);
      denoisedImgs{i}=img;
      denoisedImgFilenames{i}=denoisedImgFiles(i).name;
    end
   
    prePSNRs = zeros(1,IMG_NUM);    
    prePSNR_HVSs = zeros(1,IMG_NUM);
    prePSNR_HVS_Ms = zeros(1,IMG_NUM);
    
    postPSNRs = zeros(1,IMG_NUM);    
    postPSNR_HVSs = zeros(1,IMG_NUM);
    postPSNR_HVS_Ms = zeros(1,IMG_NUM);
    
    resultsPath = strcat('..\results\',deName,'\',imgType,'\');
    status = mkdir(resultsPath);
    txtFilename = strcat('results_',deName,'.txt');

    fileID = fopen(strcat(resultsPath,txtFilename),'w');

    fprintf(fileID,'%-24s%-32s%-32s%-32s\r\n','Image Name','PSNR','PSNR-HVS','PSNR-HVS-M');
        
    if images.internal.isFigureAvailable()
        testProgressBar = waitbar(0,strcat({'Compute the metric values of '},imgType,' images...'));
    else
        testProgressBar = [];
    end

    for i = 1:IMG_NUM     
        prePSNRs(i) = psnr(distortedImgs{i},cleanImgs{i});
        [prePSNR_HVS_Ms(i), prePSNR_HVSs(i)] = psnrhvsm(distortedImgs{i},cleanImgs{i});        

        postPSNRs(i) = psnr(denoisedImgs{i},cleanImgs{i}); 
        [postPSNR_HVS_Ms(i), postPSNR_HVSs(i)] = psnrhvsm(denoisedImgs{i},cleanImgs{i});        

        imgNameParts = split(cleanImgFilenames{i},'_');

        fi = figure;  
        set(fi, 'Visible', 'off');

        subplot(1, 3, 1), imshow(cleanImgs{i}), title('clean');
        subplot(1, 3, 2), imshow(distortedImgs{i}), title('distorted');
        subplot(1, 3, 3), imshow(denoisedImgs{i}), title('denoised');    

        fprintf(fileID,'%-24s',imgNameParts{1});

        fprintf(fileID,'%-10f->%-20f',prePSNRs(i),postPSNRs(i));
        fprintf(fileID,'%-10f->%-20f',prePSNR_HVSs(i), postPSNR_HVSs(i));
        fprintf(fileID,'%-10f->%-20f\r\n',prePSNR_HVS_Ms(i), postPSNR_HVS_Ms(i));

        figureName = strcat(resultsPath,imgNameParts{1},'_',deName,'.png');    
        saveas(gcf,figureName);
        
        if ~isempty(testProgressBar)
           waitbar(i/IMG_NUM,testProgressBar);
        end
    end
    
    fprintf(fileID,'\r\n');
          
    avgPrePSNR = mean(prePSNRs);
    avgPrePSNR_HVS = mean(prePSNR_HVSs);
    avgPrePSNR_HVS_M = mean(prePSNR_HVS_Ms);
    
    avgPostPSNR = mean(postPSNRs);
    fprintf(fileID,'Average PSNR: %-10f->%-20f\r\n',avgPrePSNR,avgPostPSNR);

    avgPostPSNR_HVS = mean(postPSNR_HVSs);
    fprintf(fileID,'Average PSNR-HVS: %-10f->%-20f\r\n',avgPrePSNR_HVS,avgPostPSNR_HVS);

    avgPostPSNR_HVS_M = mean(postPSNR_HVS_Ms);
    fprintf(fileID,'Average PSNR-HVS-M: %-10f->%-20f\r\n',avgPrePSNR_HVS_M,avgPostPSNR_HVS_M);
    
    close(testProgressBar);
    
end