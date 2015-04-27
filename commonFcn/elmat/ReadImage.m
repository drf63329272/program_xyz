%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%           ��ȡͼƬ������ �Ӿ�����/ʵ������/kitti �������ݴ洢��ʽ
% ʹ�÷������� 
%       1) �ڶ�ȡ��һͼǰ����ͼƬ·���� ReadImage('SetImagePath')
%       2) ��ȡ�� N ͼ�� [leftImage,rightImage] = ReadImage('GetImage',N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [leftImage,rightImage,firstImageN,lastImageN] = ReadImage(command,n_image)


global projectDataPath leftPathName rightPathName leftSufffix rightSuffix leftPrefix rightPrefix imFormat 
switch command
    case 'SetImagePath'
    %% ����ͼƬ��ȡ·��
    if isempty(projectDataPath) % �������д˺���ʱ
        inputDataPath_left = pwd; 
        inputDataPath_right = pwd; 
    else
        inputDataPath_left = [projectDataPath,'\���1\��ʱ�ɼ�'];   % Ĭ��ͼ���IMU���ݱ�����ļ���
        inputDataPath_right= [projectDataPath,'\���2\��ʱ�ɼ�'];
        if ~isdir(inputDataPath_left)
            inputDataPath_left = uigetdir(projectDataPath,'ѡ�� �� ͼ�� ·��');
            if inputDataPath_left==0
                return;
            end
        end
        if ~isdir(inputDataPath_right)
            inputDataPath_right = uigetdir(projectDataPath,'ѡ�� �� ͼ�� ·��');
            if inputDataPath_right==0
                return;
            end
        end
    end
    %
    [leftFileName, leftPathName] = uigetfile({'*.bmp';'*.jpg';'*.png'},'ѡ�������������һ��ͼ��Ҫ��ֻ�б��Ϊ����',inputDataPath_left);
    if leftFileName==0
       return ;
    end
    [~, ~, imFormat] = fileparts(leftFileName) ;    % ͼƬ��ʽ��imFormat 
    [rightFileName, rightPathName] = uigetfile(['*',imFormat],'ѡ�������������һ��ͼ��Ҫ��ֻ�б��Ϊ����',inputDataPath_right);
    if rightFileName==0
       return ;
    end
    [leftPrefix,leftSufffix] = GetFileFix(leftFileName) ;
    [rightPrefix,rightSuffix] = GetFileFix(rightFileName) ;
    %% ����ͼƬ����
    if strcmp(leftPathName,rightPathName)==1
        % ������һ���ļ���
        allImageFile = ls([leftPathName,['*',imFormat]]);  % �����������ͼƬ���ļ���
        imNum = fix(size(allImageFile,1)/2);
    else
        leftImageFile = ls([leftPathName,leftPrefix,['*',imFormat]]);  % ���������ͼƬ���ļ���
        rightImageFile = ls([rightPathName,rightPrefix,['*',imFormat]]);
        imNum = min(size(leftImageFile,1),size(rightImageFile,1));   % ʱ����
    end
    answer = inputdlg('��ʼͼƬ�����0����1','��ʼͼƬ�����0����1',1,{'1'}) ;
    firstImageN = str2double(answer{1}) ;
    lastImageN = imNum-1+firstImageN ;    
    disp(['ʱ������ ',num2str(imNum)])   

    leftImage=[];
    rightImage=[];
    case 'GetImage'
    %% ��ȡͼƬ������
    leftImage = imread([leftPathName,getImageName(leftPrefix,n_image,leftSufffix),imFormat]);   
    rightImage = imread([rightPathName,getImageName(rightPrefix,n_image,rightSuffix),imFormat ]);
end

function imName = getImageName(Prefix,i,Sufffix)
if ~isempty(Prefix) && ~isempty(Sufffix)
    imName = [Prefix,num2str(i),Sufffix] ;  % �Ӿ������ͼƬ��1��ʼ����
else
    imName = num2str(i,'%010d');          % kitti��ͼƬ��ʽ  ��0��ʼ����
end

function [prefix,suffix] = GetFileFix(filename)
% �������з����ֲ���
if isNumStr(filename(1))
   disp('û��ǰ׺'); 
   prefixNum = 0;
   prefix=[];
else
    prefixNum = 1 ; % ��¼�������ַ��ĸ���
    for i=2:length(filename)
       if ~isNumStr(filename(i))  && ~isNumStr(filename(i-1))
           prefixNum = prefixNum+1 ;    % �ҵ�һ���ַ�  
       else
            break;
       end
    end
    prefix = filename(1:prefixNum); % ǰ׺
end

for i=prefixNum+1:length(filename)
   if ~isNumStr(filename(i)) 
       break;
   end
end
suffixNum = i;
for i_last=prefixNum+1:length(filename)
   if strcmp(filename(i_last),'.')
       break;
   end
end
if(suffixNum==i_last)
   suffix = [];     % ��׺
else
    suffix = filename(suffixNum:i_last-1);
end


function isNum = isNumStr(character)
% 
if strcmp(character,'i')
   isNum = 0; 
   return;
end
if isnan( str2double(character) )
    isNum = 0; 
else
    isNum = 1; 
end
