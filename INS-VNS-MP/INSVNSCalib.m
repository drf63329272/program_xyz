%% xyz 2015 ��ͯ�� �ع�
%% ���� �Ӿ� ����ϵ�궨
% λ�Ʋ����ݣ� dX_Vision
% rϵ�� �Ӿ�ϵ
% wϵ�� ����ϵ��NED��
% Crw�� �Ӿ�ϵ����ϵ��ϵ�ķ������Ҿ���

function Crw = INSVNSCalib( INSVNSCalib_VS_k,Calib_N_New,dX_Vision,InertialPosition )
coder.extrinsic('fprintf');
coder.inline('never');
global VisionData_inertial_k

N = Calib_N_New;
dX_Inertial = zeros(3,N);
INSVNSCalib_IS_k = zeros(size(INSVNSCalib_VS_k));
for k=1:N
    INSVNSCalib_IS_k(1,k) = VisionData_inertial_k( INSVNSCalib_VS_k(1,k) );
    INSVNSCalib_IS_k(2,k) = VisionData_inertial_k( INSVNSCalib_VS_k(2,k) );
        
    dX_Inertial(:,k) = InertialPosition( :, INSVNSCalib_IS_k(2,k)) - InertialPosition( :, INSVNSCalib_IS_k(1,k)) ;
    
    dX_Inertial(3,k) = 0; % �����0
end


Crw = dX_Inertial(1:2,:) / dX_Vision(1:2,:) ;
Crw = [Crw [0;0]; [0 0 1]];

if coder.target('MATLAB')
    Attitude = C2Attitude( Crw,'NED' ) ;
    fprintf( '�Ӿ�������ϵ����̬�� [ %0.2f  %0.2f  %0.2f ]�� \n',Attitude.yaw*180/pi,Attitude.pitch*180/pi,Attitude.roll*180/pi );

    if abs(Attitude.yaw) > 10*pi/180
       fprintf('�Ӿ������Եĺ���ǱȽϴ�'); 
    end
end
