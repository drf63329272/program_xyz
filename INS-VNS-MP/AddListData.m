%% xyz 2015.6.29

%% �Ƚ��ȳ���ʽ ��������

% ���������ݣ�������ǰ������ݼ���ȥ
% data [M*N]
% validN �� data��Ч���ݸ��� data(:,1:validN) ��Ч
% dataAdd �� ��������

function [ dataNew,validN ] = AddListData( data,validN,dataAdd )

[M,dataN] = size(data);
dataAddN = size(dataAdd,2);
if validN > dataN
   errordlg('error (AddListData):validN > dataAddN '); 
end
if size(dataAdd,1) ~= M
   errordlg('error (AddListData):validN > size(dataAdd,1) ~= size(data,1) ');  
end

removeN = (validN+dataAddN)-dataN ;  % ��Ҫ��ǰ�漷��ȥ���ݸ���
if removeN > 0
   % ��Ҫ�Ƶ�ǰ�� removeN ������
   data_BackValid = data( :, removeN+1 : validN );  % ����������Ч����

   dataNew = NaN(M,dataN);
   
   data_BackValid_N = dataN-dataAddN ;
   dataNew(:,1:data_BackValid_N) = data_BackValid ;
   dataNew(:,data_BackValid_N+1:dataN) = dataAdd;
   
   validN = dataN;
else
    % �����㹻
    dataNew = data;
    dataNew( :,validN+1:validN+dataAddN ) = dataAdd;
    validN = validN+dataAddN;
end

