%% xyz 2015.6.1

%% ����ĳ������ٶ�
%% �õ� �� k �����λ�ú󣬼�����ǵ� k_calV ������ٶȣ� k_calV = data_k-dN_CalV ;��
% dT_CalV�� �ٶȼ��㲽��
%  V(k) = (X(k+dN_CalV) - X(k-dN_CalV)) / (dT_CalV*2)

% fre�� Ƶ��
% dT_CalV�� �ٶȼ���Ĳ���ʱ��
% MinXYVNorm_CalAngle�� ����xy�ٶȷ���Ҫ�����Сxy�ٶ�ģֵ
% CalVFlag�� �ٶȼ��㷽����־

%% Velocity_k
% Velocity_k(1:3,1) : xyz��ά���ٶ�
% Velocity_k(4,1) : xyƽ���ٶȵ�ģ
% Velocity_k(5,1) : xyƽ���ٶ�����ǰ��֮��ļнǣ�ģ����0.2m/sʱ�ż��㣩

%% DataStore ���ݴ洢��ʽ
% DataStore.IsLoopStore =0/1  �Ƿ�ѭ���洢
% DataStore.BN   BufferN    �����С
% DataStore.EN   EndN       �������
% DataStore.SN   StartN     ��ʼ���

function [ Velocity_k,k_calV ] = CalVelocity( Position,data_k,fre,dT_CalV,MinXYVNorm_CalAngle,CalVFlag )

% �ٶȼ���Ĳ�������

dT_CalV = min(dT_CalV,0.2);
dN_CalV = fix(dT_CalV*fre) ;
dN_CalV = max(dN_CalV,1);

angleXY = NaN ;
Velocity_k = NaN(5,1) ;

%% �����ٶȣ� 
% ����� k_calV �������ٶȣ��� [ k_calV-dN_CalV, k_calV+dN_CalV  ] ��һ������
% �õ� data_k ���ݺ󣬼���� data_k-dN_CalV �������ٶ�
k_calV = data_k-dN_CalV ;

if k_calV-dN_CalV<1 || k_calV+dN_CalV>length(Position)    
    return; 
end


%% xyz��ά���ٶ�
switch CalVFlag
    case 1
        %% ֱ�Ӳ��ö�����˵���б��
        Position1 = Position( :,k_calV+dN_CalV ) ;
        Position2 = Position( :,k_calV-dN_CalV ) ;
        
    case 2
        %% ���� [k_calV-dN_CalV:k_calV-1 ]��[k_calV+1:k_calV+dN_CalV]�ľ�ֵ��б��
        Position1_A = Position( :,k_calV+1:k_calV+dN_CalV ) ;
        Position2_A = Position( :,k_calV-dN_CalV:k_calV-1 ) ;
        Position1 = mean(Position1_A,2);
        Position2 = mean(Position2_A,2);
end

if isnan( Position1(1) ) || isnan( Position2(1) )
    Velocity_k = NaN(5,1) ;
    return;  % �����ٶȵ��������и���ʧ�ܵĵ� 
end
Velocity_k = ( Position1 - Position2 ) / (dT_CalV*2) ;
        

% �����д洢xyƽ���ٶȵ�ģ
trackedMarkerVelocity_xyNorm = normest(Velocity_k(1:3)) ; 

% �����д洢xyƽ���ٶ�����ǰ��֮��ļнǣ�ģ����0.2m/sʱ�ż��㣩
if trackedMarkerVelocity_xyNorm >  MinXYVNorm_CalAngle 
   temp =  [0 1]*Velocity_k(1:2) / trackedMarkerVelocity_xyNorm ;
   angleXY = acos(temp);
   if Velocity_k(1)>0
       angleXY = -angleXY ;
   end
end
Velocity_k = [ Velocity_k; trackedMarkerVelocity_xyNorm;angleXY ]; 