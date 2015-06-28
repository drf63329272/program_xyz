
%% ��ֵ��������
function [ makerTrackThreshold,INSVNSCalibSet ] = SetConstParameters( visionFre )


moveTime = 2 ;          % sec �켣�����ж�ʱ�䲽��
moveDistance = 0.5 ;      % m   �켣�����ж�λ�Ʋ���  ������ֵ����0.4m-0.7m��
MaxMoveSpeed = 6 ; % m/s  ��˵��˶����������ٶȣ���������ٶ�����Ϊ������
makerTrackThreshold.moveTime = moveTime ;
makerTrackThreshold.MaxMoveTime = 3 ;
makerTrackThreshold.moveDistance = moveDistance ;
makerTrackThreshold.MaxContinuesDisplacement = min( 1/visionFre*MaxMoveSpeed,0.1) ; % ��˵������ж����λ��ģ
makerTrackThreshold.PositionErrorBear_dT = 0.05*moveTime;   % �̶�ʱ�������˶���������һ������λ�Ʋ��������Χ�ڵģ�ֱ���ж�<У��1>ͨ��
makerTrackThreshold.ContinuesTrackedMagnifyRate = 1.3 ;      % �������ڸ��ٳɹ��ĵ�ʱ���Ŵ�PositionErrorBear_dT
MaxStaticSpeed = 0.1 ; % m/s ��ֹʱ������������������
makerTrackThreshold.MaxStaticDisp_dT = max(MaxStaticSpeed*moveTime,0.02) ;           % �̶�ʱ�������˶��������ڶ�����������һ����ͨ����λ�Ʋ�ĳ����ǹ���λ�Ƴ��ȵ�MaxPositionError_dT������
makerTrackThreshold.MaxPositionError_dS = moveDistance*0.7;     % �˶��̶�����λ�Ƶ�����˶��������˶������50% ����Ҫ�������Ƕ�Լ����
makerTrackThreshold.Max_dPAngle_dS = 20*pi/180 ;      % �˶��̶�����λ�Ƶ����λ�Ʒ���ǶȲ�

makerTrackThreshold.MaxMarkHighChange = 0.4 ;      % m �������Ӿ�Ŀ����˵�߶Ȳ�仯���Χ�������޳��߶����ϴ�ĵ�

makerTrackThreshold.MaxHighMoveErrRate = [ -0.3  0.5 ] ;  %  �߶ȷ���仯��ʱ�����仯����С�����ֵ��ֱ���϶�����OK
        % ���ָ߶ȷ�������ǳ�
makerTrackThreshold.BigHighMove = 0.18 ;         % m �������ֵ����Ϊ�߶ȷ���仯��
%% ����ϵ�궨����
INSVNSCalibSet.Min_xyNorm_Calib = 0.3 ; % m  ���ڱ궨�����ݵ���С�˶�λ�Ƴ���
INSVNSCalibSet.MaxTime_Calib = 2  ;  % sec  ���ڱ궨�����ݵ��ʱ��
INSVNSCalibSet.MaxVXY_DirectionChange_Calib = 30*pi/180 ;     % �� XYƽ���ٶȷ���仯���Χ
INSVNSCalibSet.MaxVZ_Calib = 0.1 ;     % m/s Z�����ٶ�������ֵ
INSVNSCalibSet.MinVXY_Calib = 0.2;   	% m/s XY ƽ���ٶ�ģ��С����ֵ
INSVNSCalibSet.angleUniformityErr = 10*pi/180 ; % �� λ��ʸ��������������
% �ٶȼ���
INSVNSCalibSet.dT_CalV_Calib = 0.15 ; % �����ٶ�ʱ�䲽�����궨λ������ѡ��  0.1 
INSVNSCalibSet.MinXYVNorm_CalAngle = 0.1 ;  %  m/s xy�ٶ�ģ�������ֵ�ż����ٶȵķ���

makerTrackThreshold.INSMarkH0 = NaN ;
makerTrackThreshold.VNSMarkH0 = NaN ;