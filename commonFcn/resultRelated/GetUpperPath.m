% ���ߣ�xyz
% ���ڣ�2013.12.23
% ���ܣ��õ�·������һ��·��
% ���룺·���ַ���
% �������һ��·���������ļ�����

function [upperPath,curName] = GetUpperPath(path)
% �ҵ����һ��'\'�����
for k=1:length(path)
    if strcmp(path(k),'\')
       curNum = k; 
    end    
end
upperPath = path(1:curNum-1);
curName = path(curNum+1:length(path));