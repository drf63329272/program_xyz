%% xyz 2015 ��ͯ�� �ع�
%% ���� �Ӿ� ����ϵ�궨
% λ�Ʋ����ݣ� dX_Vision
% rϵ�� �Ӿ�ϵ
% wϵ�� ����ϵ��NED��
% Crw�� �Ӿ�ϵ����ϵ��ϵ�ķ������Ҿ���

function Crw = INSVNSCalib( INSVNSCalib_VS_k,dX_Vision,InertialPosition )

N = size(INSVNSCalib_VS_k,2);
dX_Inertial = zeros(3,N);
for k=1:N
    INSVNSCalib_VS_k(1,k) = VisionK_to_InertialK( INSVNSCalib_VS_k(1,k) ) ;
    INSVNSCalib_VS_k(2,k) = VisionK_to_InertialK( INSVNSCalib_VS_k(2,k) ) ;
    
    dX_Inertial(:,k) = InertialPosition( :, INSVNSCalib_VS_k(2,k)) - InertialPosition( :, INSVNSCalib_VS_k(1,k)) ;
    
    dX_Inertial(3,k) = 0; % �����0
end


Crw = dX_Inertial(1:2,:) / dX_Vision(1:2,:) ;
Crw = [Crw [0;0]; [0 0 1]];

Attitude = C2Attitude( Crw,'NED' ) ;
fprintf( '�Ӿ�������ϵ����̬�� [ %0.2f  %0.2f  %0.2f ] \n',Attitude.yaw*180/pi,Attitude.pitch*180/pi,Attitude.roll*180/pi );

if abs(Attitude.yaw) > 10*pi/180
   fprintf('�Ӿ������Եĺ���ǱȽϴ�'); 
end
