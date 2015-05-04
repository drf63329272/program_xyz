%% xyz 2015.4.23

%% Judge is the IMU being state of acceleration==0
% IsSDOFAccelerationZero:N*1  ���� SDOF�˶��ص��ۺ��жϵ�
% IsSDOFAccelerationZero(k)==1: �ж�Ϊ��ֹ
% IsSDOFAccelerationZero(k)==1: �ж�Ϊ�Ǿ�ֹ
function [ AccelerationZeroJudge,initialStaticStart,initialStaticEnd ] = Judge0Acceleration( AHRSData,AHRSThreshod )
% load data
% gyro = AHRSData.gyro ;
% acc = AHRSData.acc ;
gyroNorm = AHRSData.gyroNorm ;
accNorm = AHRSData.accNorm ;
frequency = AHRSData.frequency ;
Nframes = AHRSData.Nframes ;

%%% the threshold value to judge is being static
AccNormZeroThreshod = AHRSThreshod.AccNormZeroThreshod ;
GyroNormZeroThreshod = AHRSThreshod.GyroNormZeroThreshod ;
GyroContinuousZeroTimeThreshod = AHRSThreshod.GyroContinuousZeroTimeThreshod ;
GyroContinuousZeroMinRate = AHRSThreshod.GyroContinuousZeroMinRate ;
IsContinuousGyroNormZeroSmoothStepTime = AHRSThreshod.IsContinuousGyroNormZeroSmoothStepTime ;
DynamicIsStaticSmoothStepTime = AHRSThreshod.DynamicIsStaticSmoothStepTime ;
IsLongContinuousOnes_SmoothStepTime = AHRSThreshod.IsLongContinuousOnes_SmoothStepTime ;
IsLongContinuousOnes_JudgeStepTime = AHRSThreshod.IsLongContinuousOnes_JudgeStepTime ;

DynamicIsStaticSmoothStepN = fix( DynamicIsStaticSmoothStepTime*frequency ) ;
%% ��1�����ٶȵ�ģ���������ٶ����С�� AccNormZeroThreshod = 1~3mg
accNormErr = abs( accNorm-1 ) ;
IsAccNormZero = accNormErr < AccNormZeroThreshod ;
IsAccNormZero = SmoothJudgeData( IsAccNormZero,DynamicIsStaticSmoothStepN,0.6 ) ; 
%% (2) ���ݲ����õ��Ľ��ٶȵ�ģС�� GyroNormZeroThreshod = 0.3~0.5 ��/s
IsGyroNormZero = gyroNorm < GyroNormZeroThreshod ;
IsGyroNormZero = SmoothJudgeData( IsGyroNormZero,DynamicIsStaticSmoothStepN,0.6 ) ; 
%% (3) ���ٶȱ仯��Ϊ0��  IsGyroNormZero = 1 �ĵ��Ƿ������� GyroVelocityZeroTimeThreshod = 0.05 S �ڱ���Ϊ0
frontT = GyroContinuousZeroTimeThreshod*0.8 ;
laterT = GyroContinuousZeroTimeThreshod*0.2 ;
minRateFront = GyroContinuousZeroMinRate ;
minRateLater = GyroContinuousZeroMinRate ;
% dbstop in JudgeContinuousOnes
IsContinuousGyroNormZero = JudgeContinuousOnes( IsGyroNormZero,frontT,laterT,frequency,minRateFront,minRateLater ) ;
stepN = fix( IsContinuousGyroNormZeroSmoothStepTime*frequency ) ;
IsContinuousGyroNormZero = SmoothJudgeData( IsContinuousGyroNormZero,stepN,0.6 ) ;      % 
%% ͬʱ�������������϶�Ϊ0���ٶ�
IsSDOFAccelerationZero = IsContinuousGyroNormZero.*IsAccNormZero ;  %  ������ٶȺͷ�����ٶȶ�Ϊ0
IsSDOFAccelerationToHeartZero = IsGyroNormZero.*IsAccNormZero ;  %  �����ļ��ٶ�Ϊ0

IsSDOFAccelerationZero = SmoothJudgeData( IsSDOFAccelerationZero,DynamicIsStaticSmoothStepN,0.6 ) ;
%% �жϳ�ʼ��λ��ֹʱ�䳤��
%  dbstop in JudgeLongContinuousOnes
[ LongSDOFAccelerationZeroStart,LongSDOFAccelerationZeroEnd,IsLongSDOFAccelerationZero ] = JudgeLongContinuousOnes...
    ( IsSDOFAccelerationZero,IsLongContinuousOnes_SmoothStepTime,IsLongContinuousOnes_JudgeStepTime,frequency ) ;
% ��һ�γ�ʱ�䱣��0λ��ʾΪ��λ�Ƕ�
initialStaticStart = LongSDOFAccelerationZeroStart(1);
initialStaticEnd = LongSDOFAccelerationZeroEnd(1);

%% Output All the Acceleration Zero result
[ ~,~,IsLongSDOFAccelerationToHeartZero ] = JudgeLongContinuousOnes...
    ( IsSDOFAccelerationToHeartZero,IsLongContinuousOnes_SmoothStepTime,IsLongContinuousOnes_JudgeStepTime,frequency ) ;
[ ~,~,IsLongAccNormZero ] = JudgeLongContinuousOnes...
    ( IsAccNormZero,IsLongContinuousOnes_SmoothStepTime,IsLongContinuousOnes_JudgeStepTime,frequency ) ;

AccelerationZeroJudge.IsSDOFAccelerationZero = IsSDOFAccelerationZero ;
AccelerationZeroJudge.IsSDOFAccelerationToHeartZero = IsSDOFAccelerationToHeartZero ;
AccelerationZeroJudge.IsAccNormZero = IsAccNormZero ;
AccelerationZeroJudge.IsLongSDOFAccelerationZero = IsLongSDOFAccelerationZero ;
AccelerationZeroJudge.IsLongSDOFAccelerationToHeartZero = IsLongSDOFAccelerationToHeartZero ;
AccelerationZeroJudge.IsLongAccNormZero = IsLongAccNormZero ;

%%%
DrawIsAccelerationZero( AHRSData,IsSDOFAccelerationZero,'IsSDOFAccelerationZero' ) ;

figure('name','Judge0Acceleration')
axes('YLim',[-0.2 1.2])
subplot(2,1,1)
hold on
plot(IsSDOFAccelerationZero,'k.')
plot(IsSDOFAccelerationToHeartZero*0.97,'b.')
plot(IsAccNormZero*0.95,'ro')
legend('IsSDOFAccelerationZero','IsSDOFAccelerationToHeartZero','IsAccNormZero')

subplot(2,1,2)
hold on
plot(IsLongSDOFAccelerationZero,'k.')
plot(IsLongSDOFAccelerationToHeartZero*0.97,'b.')
plot(IsLongAccNormZero*0.95,'ro')
legend('IsLongSDOFAccelerationZero','IsLongSDOFAccelerationToHeartZero','IsLongAccNormZero')



%% �����ʼʱ�̾�ֹ״̬��ʱ�䳤��
% IsSDOFAccelerationZero �� [1*N]
% ��̬���Ƿ�0���ٶ��жϽ������������жϳ�ʼ��ֹ״̬������ʱ�䳤�ȡ�ʹ��ǰ����һ���ϳ�ʱ�䣨InitialIsStaticSmoothStepTime����ƽ��
% ���������� InitialIsStaticJudgeStepTime ��ʱ��0���ٶ�ʱ�ж�Ϊ��ֹ״̬��ʼ
% ������ �� ���� InitialIsStaticJudgeStepTime ��ʱ�䱣�־�ֹ�ж�Ϊ��ֹ״̬����
function [ initialStaticStart,initialStaticEnd ] = CalInitialStaticN( IsSDOFAccelerationZero,InitialIsStaticSmoothStepTime,InitialIsStaticJudgeStepTime,InitialStaticAbandonTime,frequency ) 
JudgeRate = 0.8 ;
SmoothStepN = fix( InitialIsStaticSmoothStepTime*frequency ) ;
IsSDOFAccelerationZero = SmoothJudgeData( IsSDOFAccelerationZero,SmoothStepN,0.6 ) ;  % ���нϴ�Ĳ���ƽ���������ж�

stepN = fix( InitialIsStaticJudgeStepTime*frequency ) ;
Nframes = length(IsSDOFAccelerationZero) ;
k=1;
%% find initialStaticStart
while k<Nframes
    if IsSDOFAccelerationZero(k)==1
        sum_k = sum( IsSDOFAccelerationZero(k:k+stepN-1) );
        if sum_k >= stepN*JudgeRate
            initialStaticStart = k ;        % �������� InitialIsStaticJudgeStepTime ��ʱ��0���ٶ�ʱ�ж�Ϊ��ֹ״̬��ʼ
            break;
        end        
    end
    k = k+1 ;
end
%% find initialStaticStop
k = max( k,stepN );
while k<Nframes
    sum_k = sum( IsSDOFAccelerationZero(k:k+stepN-1) );
    if sum_k < stepN*JudgeRate
        initialStaticEnd = k ;    % �ӵ�k����ʼ�Ѿ��������� InitialIsStaticJudgeStepTime ��ʱ�䱣��0���ٶ�
        break;
    end        
    k = k+1 ;
end

abandonNum = fix(InitialStaticAbandonTime*frequency);
if initialStaticEnd-initialStaticStart > abandonNum*5
    initialStaticStart = initialStaticStart+abandonNum ;
    initialStaticEnd = initialStaticEnd-abandonNum ;
end

