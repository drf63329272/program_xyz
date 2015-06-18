%% xyz  2015.6.8
%% �� Hip �� ����NEDȫ�� ��Ԫ���õ� ��̬��

% HipQ�� Hip ���� �� NED ��������ϵ �µ���̬  [4*N]
% HipAttitude�� [ yaw; pitch; roll ]  rad

function HipAttitude = GetHipAttitude( HipQ )
N = size( HipQ,2 );
HipAttitude = zeros( 3,N );
for k=1:N
    HipAttitude(:,k) = GetHipAttitude_One( HipQ(:,k) ) ;
end


function Attitude = GetHipAttitude_One( HipQuaternion_k )

HipQuaternion_k = Qinv( HipQuaternion_k ) ; % ��Ԫ�������� ˳ʱ�� ��Ϊ ��ʱ�롣

CHip_k = Q2C(HipQuaternion_k);  % bone �� bvhGlobal        
Attitude = C2Euler( RotateX(pi/2)*CHip_k ,'ZYX' ) ;

