%% xyz 2015.4.30

%% �жϳ�ʱ��0���ٶ�����
%%% ���ã�
% 1����ʼ��λʱ�� = ��һ�� ��ʱ��0���ٶ�����
% 2��ת���Ż�ʱ��ҪѰ�� ת����С�������λ����Ҫ����  ��ʱ��0���ٶ� ����


%% �ж�ĳ��ʱ�̵� IsOnes=1 �Ƿ�ʱ�䱣��
% IsOnes �� [1*N]
% ��̬���Ƿ�0���ٶ��жϽ������������жϳ�ʼ��ֹ״̬������ʱ�䳤�ȡ�ʹ��ǰ����һ���ϳ�ʱ�䣨IsLongContinuousOnes_SmoothStepTime����ƽ��
% ���������� IsLongContinuousOnes_JudgeStepTime ��ʱ��0���ٶ�ʱ�ж�Ϊ��ֹ״̬��ʼ
% ������ �� ���� IsLongContinuousOnes_JudgeStepTime ��ʱ�䱣�־�ֹ�ж�Ϊ��ֹ״̬����
function [ LongContinuousOnsStart,LongContinuousOnsEnd,IsLongContinuous ] = JudgeLongContinuousOnes...
    ( IsOnes,IsLongContinuousOnes_SmoothStepTime,IsLongContinuousOnes_JudgeStepTime,frequency ) 
JudgeRate = 0.8 ;
IsLongContinuousOnes_AbandonTime = IsLongContinuousOnes_JudgeStepTime/6 ; % ����ÿ������ǰ��һС�ε�ʱ��

SmoothStepN = fix( IsLongContinuousOnes_SmoothStepTime*frequency ) ;
IsOnesSmooth = SmoothJudgeData( IsOnes,SmoothStepN,0.7 ) ;  % ���нϴ�Ĳ���ƽ���������ж�

stepN = fix( IsLongContinuousOnes_JudgeStepTime*frequency ) ;  %  ĳ����������� stepN ����������Ϊ1 �� ��������Ϊ1�� ����Ϊ0
abandonNum = fix(IsLongContinuousOnes_AbandonTime*frequency);

Nframes = length(IsOnesSmooth) ;
k=1;

LongContinuousOnsStart = zeros(1,10);
LongContinuousOnsEnd = zeros(1,10);
LongContinuousOnes_k = 0;

while k<Nframes-stepN
%     disp('JudgeLongContinuousOnes...')
    %% find LongContinuousOnsStart
    findStartOK = 0;
    findEndOK = 0;
    while k < Nframes-stepN
        if IsOnesSmooth(k)==1
            sum_k = sum( IsOnesSmooth(k:k+stepN-1) );
            if sum_k >= stepN*JudgeRate      % ����� stepN ���У�Ϊ1�ĸ����㹻�� �� �϶���Ϊ��1������Ŀ�ʼ
                                LongContinuousOnsStart_k = k  ;        % �������� IsLongContinuousOnes_JudgeStepTime ��ʱ��0���ٶ�ʱ�ж�Ϊ��ֹ״̬��ʼ
                findStartOK = 1 ;
                break;
            end        
        end
        k = k+1 ;
    end
    if findStartOK==1
        %% find initialStaticStop
        k = k+stepN-1 ;
        while k<Nframes
                sum_k = sum( IsOnesSmooth(k-stepN+1:k) );
                if sum_k < stepN*JudgeRate  % ��ǰ�� stepN ���У�Ϊ1�ĸ��������� �� �϶���Ϊ��1������Ľ���
                    % �ӵ�k����ʼ�Ѿ��������� IsLongContinuousOnes_JudgeStepTime ��ʱ�䱣��0���ٶ�                
                    for i=1:stepN
                        if IsOnesSmooth( k-i+1 )==1
                            LongContinuousOnsEnd_k = k-i+1  ; % ȡ������������һ��Ϊ1����Ϊ������
                            findEndOK = 1 ;
                            break;
                        end
                    end                  
                    break;
                end    
            k = k+1 ;
        end        
    end
    if findStartOK==1 && findEndOK==1
        LongContinuousOnes_k = LongContinuousOnes_k+1 ;
       LongContinuousOnsStart(LongContinuousOnes_k)  = LongContinuousOnsStart_k ;
       LongContinuousOnsEnd(LongContinuousOnes_k) = LongContinuousOnsEnd_k ;
       if LongContinuousOnsEnd(LongContinuousOnes_k)-LongContinuousOnsStart(LongContinuousOnes_k) > abandonNum*5
            LongContinuousOnsStart(LongContinuousOnes_k) = LongContinuousOnsStart(LongContinuousOnes_k)+abandonNum ;
            LongContinuousOnsEnd(LongContinuousOnes_k) = LongContinuousOnsEnd(LongContinuousOnes_k)-abandonNum ;
        end
    end
end

LongContinuousOnsStart = LongContinuousOnsStart(1:LongContinuousOnes_k) ;
LongContinuousOnsEnd = LongContinuousOnsEnd(1:LongContinuousOnes_k) ;

%% IsLongContinuous
IsLongContinuous = zeros( 1,Nframes );
LongContinuesTime = zeros( 1,Nframes );
for k=1:LongContinuousOnes_k
    temp = LongContinuousOnsStart(k):LongContinuousOnsEnd(k) ;
    IsLongContinuous( temp ) = 1 ;
    LongContinuesTime( LongContinuousOnsStart(k) ) = ( LongContinuousOnsEnd(k)-LongContinuousOnsStart(k)+1 )/frequency ;
end

% figure('name','JudgeLongContinuousOnes')
% axes('YLim',[-0.2 1.2])
% hold on
% plot(IsOnes,'k.')
% plot(IsOnesSmooth*0.97,'b.')
% plot(IsLongContinuous*0.95,'ro')
% 
% legend('IsOnes','IsOnesSmooth','IsLongContinuous')

