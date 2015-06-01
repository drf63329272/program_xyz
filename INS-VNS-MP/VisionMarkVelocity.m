%% xyz 2015.6.1

%% ���ݸ��ٳɹ�����˵���ȡ�����Ӿ�����ϵ�궨����
% ÿ���ٳɹ�һ�����ж�������Ƿ���Ը�������ϵ�궨����

function [ trackedMarkerVelocity_k,k_calV ] = VisionMarkVelocity( trackedMakerPosition,vision_k )

global  visionFre INSVNSCalibSet

dT_CalV_Calib = INSVNSCalibSet.dT_CalV_Calib ; % �����ٶ�ʱ�䲽�����궨λ������ѡ��
dN_CalV_Calib = fix(dT_CalV_Calib*visionFre) ;
dN_CalV_Calib = max(dN_CalV_Calib,2);
dN_CalV_Calib = min(dN_CalV_Calib,7);

angleXY = NaN ;
trackedMarkerVelocity_k = NaN(5,1) ;

% �����ٶȣ� 
% ����� k_calV �������ٶȣ��� [ k_calV-dN_CalV_Calib, k_calV+dN_CalV_Calib  ] ��һ������
% �õ� vision_k ���ݺ󣬼���� vision_k-dN_CalV_Calib �������ٶ�
k_calV = vision_k-dN_CalV_Calib ;
if k_calV-dN_CalV_Calib<1 || k_calV+dN_CalV_Calib>length(trackedMakerPosition)    
    return; 
end

trackedMakerPosition1 = trackedMakerPosition( :,k_calV+dN_CalV_Calib ) ;
trackedMakerPosition2 = trackedMakerPosition( :,k_calV-dN_CalV_Calib ) ;
if isnan( trackedMakerPosition1(1) ) || isnan( trackedMakerPosition2(1) )
    trackedMarkerVelocity_k = NaN(5,1) ;
    return;  % �����ٶȵ��������и���ʧ�ܵĵ� 
end

trackedMarkerVelocity_k = ( trackedMakerPosition1 - trackedMakerPosition2 ) / (dT_CalV_Calib*2) ;
% �����д洢xyƽ���ٶȵ�ģ
trackedMarkerVelocity_xyNorm = normest(trackedMarkerVelocity_k(1:2)) ; 

% �����д洢xyƽ���ٶ�����ǰ��֮��ļнǣ�ģ����0.2m/sʱ�ż��㣩
if trackedMarkerVelocity_xyNorm >  INSVNSCalibSet.MinXYVNorm_CalAngle 
   temp =  [0 1]*trackedMarkerVelocity_k(1:2) / trackedMarkerVelocity_xyNorm ;
   angleXY = acos(temp);
   if trackedMarkerVelocity_k(1)>0
       angleXY = -angleXY ;
   end
end
trackedMarkerVelocity_k = [ trackedMarkerVelocity_k; trackedMarkerVelocity_xyNorm;angleXY ]; 