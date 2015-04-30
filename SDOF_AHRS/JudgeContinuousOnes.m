%% xyz 2015.4.23

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
