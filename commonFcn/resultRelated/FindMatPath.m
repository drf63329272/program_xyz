%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ʼ���ڣ�2013.12.2
% ���ߣ�xyz
% ���ܣ�Ѱ��.mat��ʽ�ļ���·���������ļ��Ĺؼ�ʶ���ַ�keystr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function matFindResultPath = FindMatPath(findPath,keyStr)

% ���룺��Ѱ�ҵ��ļ��е�·�� findPath����Ѱ���ļ����Ĺؼ�ʶ���ַ� keyStr
% ����� ��Ѱ���ļ��������ļ�·�� resultPath���������򷵻�0
matFindResultPath=0;    % ���Ԥ��0

allFiles = dir([findPath,'\*.mat']);
filenum = size(allFiles);
findSuccNum = 0;    %�ɹ��ҵ��ĸ���
for i=1:filenum
   fileName =  allFiles(i).name;
   iFindResult = strfind(fileName,keyStr);  % ��fileName�в����ַ���keyStr
   if(~isempty(iFindResult))    % �ҵ���
      findSuccNum = findSuccNum+1; 
      if findSuccNum==1
           matFindResultPath = [findPath,'\',fileName];
       else
           errordlg({'�ҵ�������ϵ��ļ���',['ȡ��һ����',matFindResultPath]});
       end
   end
end
if(findSuccNum==0)
    errordlg('û�ҵ����ϵ��ļ���');
    matFindResultPath=0;
end
