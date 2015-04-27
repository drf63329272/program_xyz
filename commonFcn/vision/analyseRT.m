
%% ���� Rbb Tbb ����������
% �� Rbb Tbb Ϊ��˹������
function [RTerrorStr,AngleError,TbbError] = analyseRT(Rbb,Tbb,trueRbb,trueTbb)

RbbNum = length(Rbb);
trueRbbNum = length(trueRbb);
num = min(RbbNum,trueRbbNum);
TbbError = Tbb(:,1:num)-trueTbb(:,1:num);
RbbError = zeros(3,3,num);
AngleError = zeros(3,num);
opintions.headingScope = 180 ;
for k=1:num
    RbbError(:,:,k) = Rbb(:,:,k)*trueRbb(:,:,k)';
    AngleError(:,k) = GetAttitude(RbbError(:,:,k),'degree',opintions);
end

TbbErrorMean = mean(TbbError,2);
TbbErrorStd = std(TbbError,0,2);
AngleErrorMean = mean(AngleError,2);
AngleErrorStd = std(AngleError,0,2);

TbbErrorMeanstr = sprintf('%0.3e ',TbbErrorMean);
TbbErrorStdstr = sprintf('%0.3e ',TbbErrorStd);
AngleErrorMeanstr = sprintf('%0.3e ',AngleErrorMean*180/pi);
AngleErrorStdstr = sprintf('%0.3e ',AngleErrorStd*180/pi);

RTerrorStr = sprintf('Tbb������ԣ�\n\t��ֵ��%s m\n\t���%s m',TbbErrorMeanstr,TbbErrorStdstr);
RTerrorStr = sprintf('%s\nRbb�������ԣ�\n\t��ֵ��%s ��\n\t���%s ��',RTerrorStr,AngleErrorMeanstr,AngleErrorStdstr);