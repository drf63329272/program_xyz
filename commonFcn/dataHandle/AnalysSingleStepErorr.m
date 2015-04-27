%% ����������������
% buaa xyz 2014 5 22
% ����һ����������3*n��
% ��� ��ֵ��������ֵ

function [errorStr,errorMean,errorStd,errrMax] = AnalysSingleStepErorr(errorData)
N = length(errorData);
errorData = errorData*1e3; % m->mm
if N==size(errorData,1)
   errorData = errorData'; 
end
errorMean = mean(errorData,2);
errorStd = std(errorData,0,2);
errrMax = max(abs(errorData),[],2);
errorSum = sum(errorData,2);

errorMeanStr = sprintf('%0.2g ',errorMean);
errorStdStr = sprintf('%0.2g ',errorStd);
errrMaxStr = sprintf('%0.2g ',errrMax);
errorSumStr = sprintf('%0.2g ',errorSum);
errorStr = sprintf('\t(mm)ƽ��ֵ��%s\t����:%s\t���ֵ��%s\t�ۻ���%s',errorMeanStr,errorStdStr,errrMaxStr,errorSumStr);

