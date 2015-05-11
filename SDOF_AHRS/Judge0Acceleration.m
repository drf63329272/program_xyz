%% xyz 2015.4.23

%% Judge is the IMU being state of acceleration==0
% IsSDOFAccelerationZero:N*1  ���� SDOF�˶��ص��ۺ��жϵ�
% IsSDOFAccelerationZero(k)==1: �ж�Ϊ��ֹ
% IsSDOFAccelerationZero(k)==1: �ж�Ϊ�Ǿ�ֹ
function [ AccelerationZeroJudge,initialStaticStart,initialStaticEnd ] = Judge0Acceleration( AHRSData,AHRSThreshod,RefRotateAngle )
% load data
% gyro = AHRSData.gyro ;
% acc = AHRSData.acc ;
gyroNorm = AHRSData.gyroNorm ;
accNorm = AHRSData.accNorm ;
frequency = AHRSData.frequency ;
Nframes = AHRSData.Nframes ;

IsDoSmooth = 1;
IsDraw = 0 ;

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
%% ��1��IsAccNormZero�����ٶȵ�ģ���������ٶ����С�� AccNormZeroThreshod = 1~3mg
accNormErr = abs( accNorm-1 ) ;
IsAccNormZero = accNormErr < AccNormZeroThreshod ;
if IsDoSmooth==1
    IsAccNormZero = SmoothJudgeData( IsAccNormZero,DynamicIsStaticSmoothStepN,0.6 ) ; 
end
%% (2) IsGyroNormZero�����ݲ����õ��Ľ��ٶȵ�ģС�� GyroNormZeroThreshod = 0.3~0.5 ��/s
IsGyroNormZero = gyroNorm < GyroNormZeroThreshod ;
IsGyroNormZero = SmoothJudgeData( IsGyroNormZero,DynamicIsStaticSmoothStepN,0.6 ) ; 
%% (3) IsContinuousGyroNormZero�����ٶ�Ϊ0�ұ仯��Ϊ0��  IsGyroNormZero = 1 �ĵ��Ƿ������� GyroVelocityZeroTimeThreshod = 0.05 S �ڱ���Ϊ0
frontT = GyroContinuousZeroTimeThreshod*0.8 ;
laterT = GyroContinuousZeroTimeThreshod*0.2 ;
minRateFront = GyroContinuousZeroMinRate ;
minRateLater = GyroContinuousZeroMinRate ;
% dbstop in JudgeContinuousOnes
IsContinuousGyroNormZero = JudgeContinuousOnes( IsGyroNormZero,frontT,laterT,frequency,minRateFront,minRateLater ) ;
stepN = fix( IsContinuousGyroNormZeroSmoothStepTime*frequency ) ;
if IsDoSmooth==1
    IsContinuousGyroNormZero = SmoothJudgeData( IsContinuousGyroNormZero,stepN,0.6 ) ;      % 
end
%% IsSDOFAccelerationZero�� ���ٶ�ģС + ���ٶ�Ϊ0 + ���ٶȱ仯��Ϊ0 
%% IsSDOFAccelerationToHeartZero�� ���ٶ�ģС + ���ٶ�Ϊ0
IsSDOFAccelerationZero = IsContinuousGyroNormZero.*IsAccNormZero ;  %  ������ٶȺͷ�����ٶȶ�Ϊ0
% IsSDOFAccelerationZero = IsContinuousGyroNormZero ;
IsSDOFAccelerationToHeartZero = IsGyroNormZero.*IsAccNormZero ;  %  �����ļ��ٶ�Ϊ0
% IsSDOFAccelerationToHeartZero = IsGyroNormZero ;
if IsDoSmooth==1
    IsSDOFAccelerationZero = SmoothJudgeData( IsSDOFAccelerationZero,DynamicIsStaticSmoothStepN,0.6 ) ;
end
%% �жϳ�ʼ��λ��ֹʱ�䳤��
%  dbstop in JudgeLongContinuousOnes
[ LongSDOFAccelerationZeroStart,LongSDOFAccelerationZeroEnd,IsLongSDOFAccelerationZero ] = JudgeLongContinuousOnes...
    ( IsSDOFAccelerationZero,IsLongContinuousOnes_SmoothStepTime,IsLongContinuousOnes_JudgeStepTime,frequency ) ;
% ��һ�γ�ʱ�䱣��0λ��ʾΪ��λ�Ƕ�
if ~isempty(LongSDOFAccelerationZeroStart)
    initialStaticStart = LongSDOFAccelerationZeroStart(1);
    initialStaticEnd = LongSDOFAccelerationZeroEnd(1);
else
    initialStaticStart = [] ;
    initialStaticEnd = [] ;
end

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

if IsDraw==1
    DrawIsAccelerationZero( AHRSData,IsAccNormZero,'IsAccNormZero',RefRotateAngle ) ;
    DrawIsAccelerationZero( AHRSData,IsSDOFAccelerationToHeartZero,'IsSDOFAccelerationToHeartZero' ,RefRotateAngle) ;
    DrawIsAccelerationZero( AHRSData,IsSDOFAccelerationZero,'IsSDOFAccelerationZero' ,RefRotateAngle ) ;
    DrawIsAccelerationZero( AHRSData,IsLongSDOFAccelerationZero,'IsLongSDOFAccelerationZero' ,RefRotateAngle ) ;

    figure('name','Judge0Acceleration')
    subplot1=subplot(2,1,1);
    ylim(subplot1,[0.9 1.05]);
    hold on
    plot(IsSDOFAccelerationZero,'k.')
    plot(IsSDOFAccelerationToHeartZero*0.97,'b.')
    plot(IsAccNormZero*0.95,'r.')
    legend1=legend('IsSDOFAccelerationZero','IsSDOFAccelerationToHeartZero','IsAccNormZero');
    set(legend1,...
        'Position',[0.3 0.86 0.44 0.145]);

    subplot2=subplot(2,1,2);
    ylim(subplot2,[0.9 1.05]);
    hold on
    plot(IsLongSDOFAccelerationZero,'k.')
    plot(IsLongSDOFAccelerationToHeartZero*0.97,'b.')
    plot(IsLongAccNormZero*0.95,'r.')
    legend2=legend('IsLongSDOFAccelerationZero','IsLongSDOFAccelerationToHeartZero','IsLongAccNormZero');
    set(legend2,...
        'Position',[0.267 0.396 0.489 0.145]);
end

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

