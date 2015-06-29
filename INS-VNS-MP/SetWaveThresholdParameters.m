%% xyz 2015.6.28

%% ���η����Ĳ�������
% dataStyle�� ����������������

function waveThreshold = SetWaveThresholdParameters( dataStyle )
switch dataStyle
    case 'INSAcc' 
        waveThreshold.adjacentT = 0.09;  %  ���岨���ж��ӳ�ʱ��
        waveThreshold.waveThreshold_Min_dataA  = 30;  %   ����/���� data_V ��б�ʣ���data�ļ��ٶȣ���Сֵ
        waveThreshold.MinWaveData = 0.3;   % ���岨�ȴ� abs(data) ��Сֵ
        waveThreshold.dT_CalV = 0.15;       % �ٶȼ���Ĳ���ʱ��
        waveThreshold.MinXYVNorm_CalAngle = 2;  % ����xy�ٶȷ���Ҫ�����Сxy�ٶ�ģֵ  
        
    case 'VNSAcc'
        waveThreshold.adjacentT = 0.07;  %  ���岨���ж��ӳ�ʱ��
        waveThreshold.waveThreshold_Min_dataA  = 20;  %   ����/���� data_V ��б�ʣ���data�ļ��ٶȣ���Сֵ
        waveThreshold.MinWaveData = 0.3;   % ���岨�ȴ� abs(data) ��Сֵ
        waveThreshold.dT_CalV = 0.15;       % �ٶȼ���Ĳ���ʱ��
        waveThreshold.MinXYVNorm_CalAngle = 2;  % ����xy�ٶȷ���Ҫ�����Сxy�ٶ�ģֵ  
end

