%% xyz 2015.4.23

%% Judge is the IMU being state of acceleration==0
% IsSDOFAccelerationZero:N*1  ���� SDOF�˶��ص��ۺ��жϵ�
% IsSDOFAccelerationZero(k)==1: �ж�Ϊ��ֹ
% IsSDOFAccelerationZero(k)==1: �ж�Ϊ�Ǿ�ֹ
function [ IsSDOFAccelerationZero,initialStaticStart,initialStaticEnd,IsSDOFAccelerationToHeartZero,IsAccNormZero ] = Judge0Acceleration( AHRSData,AHRSThreshod )
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
InitialIsStaticJudgeStepTime = AHRSThreshod.InitialIsStaticJudgeStepTime ;
InitialStaticAbandonTime = AHRSThreshod.InitialStaticAbandonTime ;
IsContinuousGyroNormZeroSmoothStepTime = AHRSThreshod.IsContinuousGyroNormZeroSmoothStepTime ;
DynamicIsStaticSmoothStepTime = AHRSThreshod.DynamicIsStaticSmoothStepTime ;
InitialIsStaticSmoothStepTime = AHRSThreshod.InitialIsStaticSmoothStepTime ;

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
% dbstop in CalInitialStaticN
[ initialStaticStart,initialStaticEnd ] = CalInitialStaticN( IsSDOFAccelerationZero,InitialIsStaticSmoothStepTime,InitialIsStaticJudgeStepTime,InitialStaticAbandonTime,frequency )  ;

%%%
DrawIsAccelerationZero( AHRSData,IsSDOFAccelerationZero,'IsSDOFAccelerationZero' ) ;

disp('');

 %% ƽ��
 % JudgeData�� [1*N]
 % stepN :ƽ������
% 1001 -> 1111
% ���ڣ� ǰ�� stepN �� ���� stepN/3 ��
% �������У�
% 1����βminNum����1�� 2�������е�1��������һ��(SmoothRate)����Ϊ��һ�ξ�Ϊ1
function JudgeData = SmoothJudgeData( JudgeData,stepN,SmoothRate )
Nframes = length(JudgeData) ;
stepN = max(stepN,4);
minNum = fix(stepN/8) ;  % ��β minNum ��Ҫ����1
minNum = max( minNum,1 );
fillNum = 0;

for k=1:Nframes-stepN+1
    end_k = k+stepN-1 ;
    sumHead = sum( JudgeData( k:k+minNum-1 ) );
    sumEnd = sum( JudgeData( end_k-minNum+1:end_k ) );
    if sumHead == minNum && sumEnd == minNum   % ��β��1
        staticSum = sum( JudgeData( k:end_k ) );
        if staticSum>=stepN*SmoothRate       % �����е�1��������һ��
            JudgeData( k:end_k ) = ones( stepN,1 );
            fillNum = fillNum + stepN - staticSum ;
        end 
    end
end
display( sprintf('fillNum = %0.0f',fillNum) );

%% �ж�ĳ����k����������Ϊ1
% 1����k-1��Ϊ1,��k��Ϊ1,��k+1��Ϊ1
% 2����k��ǰ�� frontN ������ 70% ����Ϊ1
% 3����k���� laterN ������ 70% ����Ϊ1
%%% INput
% IsOnes: [1*N]��[N*1] �Ѿ��жϺõ� �Ƿ�Ϊ1�Ľ��
function IsContinuousOnes = JudgeContinuousOnes( IsOnes,frontT,laterT,frequency,minRateFront,minRateLater )
Nframes = length( IsOnes );
IsContinuousOnes = zeros( size(IsOnes) );
frontN = max( fix(frontT * frequency),3) ;
laterN = max( fix(laterT * frequency),1) ;

for k = frontN+1:Nframes-laterN-1
    IsOnes_kSegment = IsOnes( k-frontN:k+laterN ) ;
    IsContinuousOnes(k) = JudgeContinuousOnes_One( IsOnes_kSegment,frontN+1,minRateFront,minRateLater );
end

%% �����kʱ������� IsOnes_kSegment���Ƿ�Ϊ1�� �ж� �õ��Ƿ�Ϊ���� =1
% ���жϵĵ�Ϊ IsOnes_kSegment �ĵ�k����
function IsContinuousOnes_k = JudgeContinuousOnes_One( IsOnes_kSegment,k,minRateFront,minRateLater )

IsContinuousOnes_k = 0;
N = length(IsOnes_kSegment);
if IsOnes_kSegment(k)==1 
    if IsOnes_kSegment(k-1)==1 || IsOnes_kSegment(k+1) == 1  % ǰ�����������һ������
        IsOnes_Front = IsOnes_kSegment( 1:k-1 );
        IsOnes_Later = IsOnes_kSegment( k+1:N );
        if sum( IsOnes_Front ) >= ceil( minRateFront*(k-1) )       % ǰ��1�ĸ�������
           if  sum( IsOnes_Later ) >= fix( minRateLater*(N-k) )   % ����1�ĸ�������
               IsContinuousOnes_k = 1 ;               
           end
        end
    end    
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
disp('');
