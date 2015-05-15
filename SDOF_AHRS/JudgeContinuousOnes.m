%% xyz 2015.4.23   2015.5.12

%% ��ȡIsOnes������Ϊ1�Ĳ��֣��ɸĽ�Ϊʵʱ��
% Ŀ�ģ���ȡ�����ǲ�õĽ��ٶ�=0 �� �仯��=0 ��ʱ��
% ������ IsGyroNormZero ��ʱ��=0 ��ʱ���
%   1���ҵ�ʱ�䳤��>minContinuesN �� IsGyroNormZero=1 �������Σ�����Ϊ�Ǽ��ٶ�Ϊ0
%   2���ҵ������θ������������ݱ仯����ҵķ������Ը÷���������³��������ϸ���������Ϊһ��ֱ�ߣ�RANSA��LMedS��
%   3��������Ϻ�õ�ֱ�ߵ�б���ж��Ƿ�Ϊ ��ʱ��IsGyroNormZero=1
%   4�����������������������Σ��޳���Ⱥ����ٴ�ƽ�����õ����� ��ʱ��IsGyroNormZero=1 �Ľ��
%%% INput
% IsOnes: [1*N]��[N*1] �Ѿ��жϺõ� ��ƽ����ģ���ƽ�����жϳ����� �Ƿ�Ϊ1�Ľ��
function IsContinuousOnes = JudgeContinuousOnes( IsOnes,GyroData,frequency,minContinuesN,maxAngularAcc )

AbandomN = fix(0.02*frequency) ;     % �жϽǼ��ٶ�=0 ������ǰ���޳��ĸ���
AbandomN = max(AbandomN,2);

Nframes = length( IsOnes );
IsContinuousOnes = zeros( size(IsOnes) );

% ���������б仯����ҵ�
MeanGyroData = mean( abs(GyroData),2 );
[ ~,I ] = max(MeanGyroData);
GyroData_1Dim = GyroData(I,:);
winStart = 0;
for k=2:Nframes
    if IsOnes(k)==1
        if IsOnes(k-1)==0 || k==2  
            %��0->1
            winStart = k;            
        end
        
    else
        if IsOnes(k-1)==1
           %  1->0
            if winStart==0
                continue;
            end
            winEnd = k-1;
            M = winEnd-winStart+1 ;
            if M>minContinuesN
                %% 1���ҵ�ʱ�䳤��>minContinuesN �� IsGyroNormZero=1 �������Σ�����Ϊ�Ǽ��ٶ�Ϊ0
                % 2) ���������������������
                gyro = GyroData_1Dim(winStart:winEnd);
                time = (winStart:winEnd)/frequency;
                P = polyfit(time,gyro,1);
                GyroConstFitting = ( P(2)+P(1)* mean(time) ) ;  % ���ֱ���ڸ������е��ֵ������ֵΪ0
                GyroConstFitting_degree = GyroConstFitting*180/pi;
                AngularAcc = P(1)*180/pi;
                % P(1)Ϊ�Ǽ��ٶ�
                if abs(P(1))<maxAngularAcc && GyroConstFitting<1*pi/180  %��maxAngularAcc���Ǽ��ٶ���ֵ
                   %% 3���ж����� ���ٶ�=0 + �Ǽ��ٶ�=0
                   % 4) �޳���Ϲ����вв�ϴ������                   
                   IsContinuousOnes(winStart+AbandomN:winEnd-AbandomN) = 1 ;        
                end
            end
        end        
    end
end





% xyz 2015.4.23 

%     %% �ж�ĳ����k����������Ϊ1
%     % 1����k-1��Ϊ1,��k��Ϊ1,��k+1��Ϊ1
%     % 2����k��ǰ�� frontN ������ 70% ����Ϊ1
%     % 3����k���� laterN ������ 70% ����Ϊ1
%     %%% INput
%     % IsOnes: [1*N]��[N*1] �Ѿ��жϺõ� �Ƿ�Ϊ1�Ľ��
%     function IsContinuousOnes = JudgeContinuousOnes( IsOnes,frontT,laterT,frequency,minRateFront,minRateLater )
%     Nframes = length( IsOnes );
%     IsContinuousOnes = zeros( size(IsOnes) );
%     frontN = max( fix(frontT * frequency),3) ;
%     laterN = max( fix(laterT * frequency),1) ;
% 
%     for k = frontN+1:Nframes-laterN-1
%         IsOnes_kSegment = IsOnes( k-frontN:k+laterN ) ;
%         IsContinuousOnes(k) = JudgeContinuousOnes_One( IsOnes_kSegment,frontN+1,minRateFront,minRateLater );
%     end
% 
%     %% �����kʱ������� IsOnes_kSegment���Ƿ�Ϊ1�� �ж� �õ��Ƿ�Ϊ���� =1
%     % ���жϵĵ�Ϊ IsOnes_kSegment �ĵ�k����
%     function IsContinuousOnes_k = JudgeContinuousOnes_One( IsOnes_kSegment,k,minRateFront,minRateLater )
% 
%     IsContinuousOnes_k = 0;
%     N = length(IsOnes_kSegment);
%     if IsOnes_kSegment(k)==1 
%         if IsOnes_kSegment(k-1)==1 || IsOnes_kSegment(k+1) == 1  % ǰ�����������һ������
%             IsOnes_Front = IsOnes_kSegment( 1:k-1 );
%             IsOnes_Later = IsOnes_kSegment( k+1:N );
%             if sum( IsOnes_Front ) >= ceil( minRateFront*(k-1) )       % ǰ��1�ĸ�������
%                if  sum( IsOnes_Later ) >= fix( minRateLater*(N-k) )   % ����1�ĸ�������
%                    IsContinuousOnes_k = 1 ;               
%                end
%             end
%         end    
%     end
