% buaa xyz 2013.12.27

% ��ȡ��ͬƽ�����ݽ��д���ʱ���������ݵ���Ч����

% ���룺���ݵĳ��ȡ�Ƶ�ʣ�������ʽ��
% ��������ݵ���Ч���� ��������ʽ��
% ������ʼ��һ�£��������Ƶ��ȡƵ����С�ķ�������

function [validLenthArray,combineK,combineLength,combineFre] = GetValidLength(lengthArrayOld,frequencyArray)

N = length(lengthArrayOld);  % ���ݸ���
validTime = (lengthArrayOld(1)-1)/frequencyArray(1);
for k=1:N
    validTime = min(validTime,(lengthArrayOld(k)-1)/frequencyArray(k)) ;
end
validLenthArray = zeros(1,N);
for k=1:N
    validLenthArray(k) = min( lengthArrayOld(k),fix(validTime*frequencyArray(k))+1 );
end
% ������ݳ���
% �������ȡƵ����С���Ǹ�����
combineFre = min(frequencyArray) ;
combineK = 0;
for k=1:length(frequencyArray)
   if  combineFre==frequencyArray(k)
       combineK = k ;
       break;
   end
end
combineLength = validLenthArray(combineK);