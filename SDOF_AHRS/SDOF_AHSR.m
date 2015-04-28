%% xyz 2015.4.21



function SDOF_AHSR(  )

% clc
clear all
close all

dataFolder = 'E:\data_xyz\AHRS Data\ahrs_raw_data_4.20\Xu';
refDataFolder = [dataFolder,'\ref'];
%  dataFolder = 'E:\data_xyz_noitom\AHRS Data\staticData_4.21_250HZ';
% dataFolder = 'E:\data_xyz_noitom\AHRS Data\staticData_4.21';
dataName = 'ahrs1' ;
% dataName = 'static3';

AHRSData = importdata( [ dataFolder,'\',dataName,'.mat' ] );
Nframes  = length(AHRSData.accNorm);
AHRSData.Nframes = Nframes ;

%% ת̨�ο����ݣ��ڶ����ǲ���ֵ���㣬1000HZ
AHRSRefData_Raw = importdata( [ refDataFolder,'\',dataName,'.dat' ] );
RefRotateAngle = ( AHRSRefData_Raw(:,2)-30 ) *pi/180 ;
%%% �ҵ����ҵ�0����Ϊ���
k = 1 ;
while k<length(RefRotateAngle) 
   if sign( RefRotateAngle(k) )+sign( RefRotateAngle(k+1) ) ==0 || RefRotateAngle(k) == 0
       RefRotateAngle = RefRotateAngle( k:length(RefRotateAngle)  );       
       break;
   end
   k = k+1 ;
end

AHRSRefData.frequency = 1000 ;

NframesNew = fix( length(RefRotateAngle)* AHRSData.frequency / AHRSRefData.frequency ) ;
NframesNew = min( NframesNew,Nframes );
RefRotateAngleNew = zeros(1,NframesNew);
for k=1:NframesNew
    k_raw = fix( k* AHRSRefData.frequency / AHRSData.frequency);
    RefRotateAngleNew(k) = RefRotateAngle(k_raw);
end
AHRSRefData.RefRotateAngle = RefRotateAngleNew ;

%% parameters to set
NavigationFrame = 'NED';
%%% the threshold value to judge .. state
%%% ��̬�仯�����У�0���ٶ�ʱ�̵��ж� ָ��
AHRSThreshod.GyroNormZeroThreshod = 0.7 *pi/180 ;       % 0.5 ��/s  ���ٶ�Ϊ0�ж�����
AHRSThreshod.AccNormZeroThreshod = 2/1000 ;             % 3mg  ���ٶ�ģΪ0�ж�����
AHRSThreshod.InitialIsStaticSmoothStepTime = 0.5 ;      % ��̬��ֹƽ������ʱ��
AHRSThreshod.DynamicIsStaticSmoothStepTime = 0.05 ;     % ��̬��ֹƽ������ʱ��
AHRSThreshod.GyroContinuousZeroTimeThreshod = 0.3 ;     % ���ٶȱ仯��=0�жϣ����ٶ�Ϊ0����ʱ��
AHRSThreshod.GyroContinuousZeroMinRate = 0.7 ;          % ���ٶȱ仯��=0�жϣ����ٶ�Ϊ0�������ڱ��ֵı���
AHRSThreshod.IsContinuousGyroNormZeroSmoothStepTime = 0.2  ; % ���ٶȱ仯��Ϊ0�жϽ��ƽ������ ��������΢���㣩
%%% ��ʼ��λ�ж�ָ��
AHRSThreshod.InitialIsStaticJudgeStepTime = 0.1 ;       % ��ʼ��ֹ�жϲ���ʱ��
AHRSThreshod.InitialStaticAbandonTime = 0.05 ;          % ��ʼ��ֹʱ����β����ʱ��
%%% ת�����ָ��
AHRSThreshod.RoateVectorCalMinAngleFirst = 10*pi/180;   % ���躽�򱣳�0ʱ�������ͺ��ת����Ԫ����ת�Ǵ��� RoateVectorCalMinAngleFirst �Ƕ�ʱ��������ת��ĵ�һ�μ���
AHRSThreshod.RoateVectorCalMinAngleSecond = 20*pi/180;  % ���ݳ���ת���������ѡ��ת���Ƕȴ��� RoateVectorCalMinAngleSecond �Ľ���ת�����ϸ����
AHRSThreshod.RoateVectorCalMinAngleScope = 10*pi/180 ;  % ת���������ѡ���ת�Ƿ�Χ������ڶ�����ת��ת��С�������Χ����������
AHRSThreshod.RoateVectorCalMinAngleScopeSub = 1*pi/180 ;% ��ת�ǵ�ת�Ƿ�Χ �� ��ת�ǵ�ת�Ƿ�Χ �����ֵ
AHRSThreshod.RoateVectorCalTime  = 15 ;                 % �Ӿ�ֹ��ʼ���ʱ�����������ת����㡣֮���Ҫ������Ƕȡ�

%%
RotateAngle = SDOF_AHSR_One( AHRSData,AHRSRefData,NavigationFrame,AHRSThreshod ) ;

disp( 'SDOF_AHSR finish ' );
%% 
function RotateAngle = SDOF_AHSR_One( AHRSData,AHRSRefData,NavigationFrame,AHRSThreshod )

%% load data
% quaternion = AHRSData.quaternion ;
gyro = AHRSData.gyro ;
acc = AHRSData.acc ;
gyroNorm = AHRSData.gyroNorm ;
accNorm = AHRSData.accNorm ;
frequency = AHRSData.frequency ;
Nframes = AHRSData.Nframes ;
time = Nframes/frequency ;

%% SINS Data Format
imuInputData.wibb = gyro ;
imuInputData.fb_g = acc ;
imuInputData.frequency = frequency ;

InitialData.NavigationFrame = NavigationFrame;
InitialData.Vwb0 = zeros(3,1);
InitialData.rwb0 = zeros(3,1);

%% Calculate time of initial static state 
% dbstop in Judge0Acceleration
[ IsSDOFAccelerationZero,initialStaticStart,initialStaticEnd,IsSDOFAccelerationToHeartZero,IsAccNormZero ] = Judge0Acceleration( AHRSData,AHRSThreshod ) ;
SDOFStaticFlag.IsSDOFAccelerationZero = IsSDOFAccelerationZero ;
SDOFStaticFlag.IsSDOFAccelerationToHeartZero = IsSDOFAccelerationToHeartZero ;
SDOFStaticFlag.IsAccNormZero = IsAccNormZero ;

initialStaticTime = ( initialStaticEnd-initialStaticStart )/frequency ;
if initialStaticTime < 1
   errordlg(sprintf('��ʼ��ֹ״̬ʱ��=%0.2f sec�� ̫�̣�',initialStaticTime)); 
end
%% calculate the initial static attitude
[ pitch,roll,Qnb ] = Acc2PitchRoll( acc,NavigationFrame ) ;
%%% initial static acc  gyro  : r frame
accStatic = acc( :,initialStaticStart:initialStaticEnd ) ;
acc_r = mean( accStatic,2 );
gyroStatic = gyro( :,initialStaticStart:initialStaticEnd ) ;
gyro_r = mean( gyroStatic,2 );
[ pitch_r,roll_r,Qwr ] = Acc2PitchRoll( acc_r,NavigationFrame ) ;

InitialData.Qwb0 = Qwr ;
%% calculate the rotate vector only by Acc
%%% ��ȡ��λ����ʱ�ε����� Qnb_ZeroCal
RoateVectorCalTime = AHRSThreshod.RoateVectorCalTime ; 
RoateVectorCalN = RoateVectorCalTime*frequency ;
Qnb_RVCal = Qnb( :,1:RoateVectorCalN ) ;
[ Ypr_Acc,RecordStr_Ypr_Acc ] = GetRotateVector_Acc( Qnb_RVCal,Qwr,AHRSThreshod,SDOFStaticFlag ) ;
%% calculate the rotate vector only by Gyro
imuInputData_RVCal.wibb = gyro(:,initialStaticEnd:RoateVectorCalN); 
imuInputData_RVCal.fb_g = acc(:,initialStaticEnd:RoateVectorCalN); 
imuInputData_RVCal.frequency = frequency ;
% dbstop in GetRotateVector_Gyro
[ Ypr_Gyro,RecordStr_Ypr_Gyro ] = GetRotateVector_Gyro( imuInputData_RVCal,InitialData,AHRSThreshod,SDOFStaticFlag );

Ypr_Gyro_Acc_difAngle = acos( Ypr_Acc'*Ypr_Gyro )*180/pi ;
Ypr_Gyro_Acc_difAngleStr = sprintf( 'difference angle 0f Ypr_Gyro and Ypr_Acc = %0.2f degree',Ypr_Gyro_Acc_difAngle );
disp(Ypr_Gyro_Acc_difAngleStr)
%% ���Ӽ�ת�ǽ���
RotateAngle = CalculateRotateAngle_Acc( Qnb,Qwr,Ypr_Gyro ) ;

%%
stepN = 20 ;
k=stepN+1;
while k<length(RotateAngle)-stepN
   sum_sign1 =  sum ( sign( RotateAngle(k-stepN:k-1) ) )  ;
   sum_sign2 =  sum ( sign( RotateAngle(k+1:k+stepN) ) )  ;
   if sum_sign1 > stepN-1 && sum_sign2 < -stepN+1
       RotateAngleNew = RotateAngle( k:length(RotateAngle) );
       break;
   end
   k=k+1;
end

RefRotateAngle = AHRSRefData.RefRotateAngle ;
N = min( length(RotateAngleNew),length(RefRotateAngle) );
RotateAngleErr = RotateAngleNew(1:N) - RefRotateAngle(1:N) ;

RotateAngleErr_Mean = mean(RotateAngleErr)*180/pi;
RotateAngleErr_Std = std(RotateAngleErr)*180/pi;

figure
plot(RotateAngleErr*180/pi)

figure
plot( RotateAngleNew(1:N)*180/pi,'b' )
hold on
plot( RefRotateAngle(1:N)*180/pi,'r' )
% plot(RotateAngleErr*180/pi,'k,')

legend('RotateAngleNew','RefRotateAngle')


