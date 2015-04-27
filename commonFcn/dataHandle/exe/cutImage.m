
% 
function cutImage()

answer = inputdlg('ͼƬ���е�','�ֱ���',1,{'1392 1040'});
res = sscanf(answer{1},'%d');
newPath = [pwd,'\cutedImage_',num2str(res(1)),'x',num2str(res(2)),'\'];
if isdir(newPath)
	delete([newPath,'\*']);
else
	mkdir(newPath); 
end

allImageFile = ls([pwd,'\*.bmp']);  % �����������ͼƬ���ļ���
imNum = fix(size(allImageFile,1));

for k=1:imNum
    name=allImageFile(k,:);
    image = imread(name);
    image = image(1:res(2),1:res(1));
    
    newName = [newPath,name];
    imwrite(image,newName)
end

disp('cutImage ok')
