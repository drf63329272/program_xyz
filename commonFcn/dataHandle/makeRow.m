% buaa xyz 2014.1.8

% ʹ�����д洢/�д洢

function new = makeRow(old,format,n)

%%������
% format����ʽ
% n������ѡ���룩���ݷ��������������ݷ�����������ʱ�����Ǳ���ָ����

if ~strcmp(format,'��Ϊʱ') && ~strcmp(format,'��Ϊʱ')
   errordlg('��ָ����ʽ') 
   new=[];
   return
end
if strcmp(format,'��Ϊʱ')
    % ʹΪ һ��һ��ʱ��
    if exist('n','var')
       momentNum = n;       % ��������
    else
        momentNum = min(size(old));
    end
    if size(old,2)==momentNum
        new = old ;
    else        
       new = old'; 
    end
else
    % һ��һ��ʱ��
    if exist('n','var')
       momentNum = n;       % ��������
    else
        momentNum = min(size(old));
    end
    if size(old,1)==momentNum
        new = old ;
    else
        new = old'; 
    end
end




    