%% xyz 2015.6.29

%% �Ƚ��ȳ���ʽ ��������

% ���������ݣ�������ǰ������ݼ���ȥ
% data [M*N]
% validN �� data��Ч���ݸ��� data(:,1:validN) ��Ч
% dataAdd �� ��������

function [ data,validN,removeN ] = AddListData( data,validN,dataAdd )

[M,dataN] = size(data);
dataAddN = size(dataAdd,2);
if validN > dataN
   fprintf('error (AddListData):validN > dataAddN '); 
end
if size(dataAdd,1) ~= M
   fprintf('error (AddListData):validN > size(dataAdd,1) ~= size(data,1) ');  
end

removeN = (validN+dataAddN)-dataN ;  % ��Ҫ��ǰ�漷��ȥ���ݸ���
if removeN > 0
   % ��Ҫ����ǰ�� removeN ������
   
   data_BackValid_N = dataN-dataAddN ;
   for i=1:data_BackValid_N
       data(:,i) = data( :, removeN+i );  % ����������Ч����
   end
%    data(:,1:data_BackValid_N) = data( :, removeN+1 : validN );  % ����������Ч����
   data(:,data_BackValid_N+1:dataN) = dataAdd;
   
   
   validN = dataN;
else
    % �����㹻
    data( :,validN+1:validN+dataAddN ) = dataAdd;
    validN = validN+dataAddN;
end

