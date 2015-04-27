% buaa xyz 2013.12.31

% ��̬��������쳣

function new_data = RejectUnusual_static( old_data,absErrorNeed )
format long
%% ���ܣ� ��ʸ������(��ά����)ȥ���쳣����
% absErrorNeed���������  �����Ժ����ֻ������һ�����ɣ�
% �ж��д洢�����д洢������Ϊʱ����
ErrorNum = 0 ;  %��ȥ����ʱ����
data_size = size(old_data) ;
%���Ϊ�д洢��תΪ�д洢��һ��һ��ʱ�̣�
if data_size(1)>data_size(2)
    old_data = old_data' ;
    data_size = size(old_data) ;
end
new_data = zeros(data_size) ;
for k = 1:data_size(1)    %�д洢��һ��һ��ʱ�̣�
    data_k = old_data(k,:) ;
    new_data_k = RejectUnusual_Scalar( data_k,absErrorNeed(k) ) ;
    new_data(k,:) = new_data_k ;
end
% ȥ���쳣���ݣ�����ʱ��ͬ���ԣ�ÿ��ֻҪ��һ���쳣������ȥ��
i = 1;
while i<=length(new_data)
   %һ���м��
   temp = isnan( new_data(:,i) ) ;
   if sum( temp ) ~= 0      %��i�к��� nan
       new_data(:,i) = [] ;     %ȥ����i��
       ErrorNum =ErrorNum +1 ;
   else
       i = i+1 ;
   end
end
disp('��ȥ����ʱ����')
display(ErrorNum)

function  new_data  = RejectUnusual_Scalar( old_data,absErrorNeed )
%% ���ܣ� �Ա������� ��ע �쳣���ݣ�һά���飨�쳣���עΪ nan��
% �����
    % new_data���µ�����
    % ErrorNum�������쳣���ݵĸ���
ErrorNum = 0 ;
data_size = size(old_data) ;
if min(data_size)>1
   errordlg('��������ݲ���һά(RejectUnusual_Scalar)') 
   return 
end
N_data = length(old_data) ;
new1_data = zeros(1,N_data) ;
data_temp = old_data ;

for k=1:5
     MaxError = absErrorNeed*(6-k)*5 ;    %����������
     data_ave = mean(old_data) ;
     for i=1:length(old_data)
         error_i = abs(old_data(i)-data_ave) ;   %i�����
        if error_i>MaxError
            new1_data(i) = nan ;
            data_temp(i) = 0 ;
            ErrorNum = ErrorNum+1 ;
        else
            new1_data(i) = old_data(i);
        end   
     end
    
end
new_data = new1_data;
