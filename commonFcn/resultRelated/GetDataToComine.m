% buaaxyz 2014.1.3

% ��ͬƵ�����ݵĺϲ� ʱʹ��
% ���ܣ�������ϲ��������ݵ����ݺ�Ƶ�ʣ���������ݵ�Ƶ��
%   �������������ȡ�Ŀ�����ֱ�Ӻϲ�������

function toCombineData  = GetDataToComine(subData,subFre,combineFre)
% subData Ϊһά��toCombineData��subDataͬ�洢��ʽ
subLength = length(subData);
combineLength = fix(subLength*combineFre/subFre);
toCombineData = zeros(size(subData));
toCombineData = toCombineData(1:combineLength);

toCombineData(1) = subData(1) ;
for k=2:combineLength
    toCombineData(k) = subData(fix((k-1)/combineFre*subFre)+1);
end
