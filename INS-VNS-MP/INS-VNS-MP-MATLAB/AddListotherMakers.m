%% xyz 2015.6.29

%% �Ƚ��ȳ���ʽ ��������

% ���������ݣ�������ǰ������ݼ���ȥ
% otherMakers [M*N]
% validN �� data��Ч���ݸ��� otherMakers(:,1:validN) ��Ч
% dataAdd �� ��������

function [ otherMakers,validN,removeN ] = AddListotherMakers( otherMakers,validN,dataAdd )

[M,dataN] = size(otherMakers);
dataAddN = size(dataAdd,2);
if validN > dataN
   fprintf('error (AddListData):validN > dataAddN '); 
end
if size(dataAdd,1) ~= M
   fprintf('error (AddListData):validN > size(dataAdd,1) ~= size(otherMakers,1) ');  
end

removeN = (validN+dataAddN)-dataN ;  % ��Ҫ��ǰ�漷��ȥ���ݸ���
if removeN > 0
   % ��Ҫ����ǰ�� removeN ������
   data_BackValid = otherMakers( :, removeN+1 : validN );  % ����������Ч����
   for i = 1:size(data_BackValid,2)
        ContinuesLastK_New = data_BackValid(i).ContinuesLastK-removeN;  % �����������
        for j=1:size(ContinuesLastK_New,2)
            if ContinuesLastK_New(j) <1
               ContinuesLastK_New(j) = 1; % �����������Ĳ��֣��������ȳ����˻��棩 
            end
        end        
        data_BackValid(i).ContinuesLastK = ContinuesLastK_New;
   end
   
   data_BackValid_N = dataN-dataAddN ;
   otherMakers(:,1:data_BackValid_N) = data_BackValid ;
   otherMakers(:,data_BackValid_N+1:dataN) = dataAdd;
   
   validN = dataN;
else
    % �����㹻
    otherMakers( :,validN+1:validN+dataAddN ) = dataAdd;
    validN = validN+dataAddN;
end

