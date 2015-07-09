%% xyz 2015.6.28

%% ���η����Ĳ�������
% dataStyle�� ����������������

function waveThreshold = SetWaveThresholdParameters( dataStyle )
switch dataStyle
    case 'INSAcc' 
        waveThreshold.adjacentT = 0.15;  %  ���岨���ж��ӳ�ʱ�䣨�����ٶ�б�ʼ������䣬ȡԽ���ٶ�б�ʵĶ�ƽ���̶�Խ�󣬲����ֵ���ֵҲԽС��
        waveThreshold.waveThreshold_Min_dataA  = 6;  %   ����/���� data_V ��б�ʣ���data�ļ��ٶȣ���Сֵ
        waveThreshold.MinWaveData = 0.1;   % ���岨�ȴ� abs(data) ��Сֵ
        waveThreshold.dT_CalV = 0.1;       % �ٶȼ���Ĳ���ʱ��
        waveThreshold.MinXYVNorm_CalAngle = 0.5;  % ����xy�ٶȷ���Ҫ�����Сxy�ٶ�ģֵ  
        waveThreshold.FullWaveDataScope = 1 ;     % 100% ��ǿ��ʱ�� data ��Χ
    case 'VNSAcc'
        waveThreshold.adjacentT = 0.15;  %  ���岨���ж��ӳ�ʱ�䣨�����ٶ�б�ʼ������䣬ȡԽ���ٶ�б�ʵĶ�ƽ���̶�Խ��
        waveThreshold.waveThreshold_Min_dataA  = 15;  %   ����/���� data_V ��б�ʣ���data�ļ��ٶȣ���Сֵ
        waveThreshold.MinWaveData = 0.4;   % ���岨�ȴ� abs(data) ��Сֵ
        waveThreshold.dT_CalV = 0.1;       % �ٶȼ���Ĳ���ʱ��
        waveThreshold.MinXYVNorm_CalAngle = 2;  % ����xy�ٶȷ���Ҫ�����Сxy�ٶ�ģֵ  
        waveThreshold.FullWaveDataScope = 5 ;     % 100% ��ǿ��ʱ�� data ���²� ��Χ
end

