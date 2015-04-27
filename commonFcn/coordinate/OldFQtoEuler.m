%% xyz 2015.3.6
% ������Ԫ����ZYXŷ���ǵ�ת������Ϊ����������Ԫ��������ŷ���ǵ�ת����ͨ��Ԥ�Ƚ���Ԫ�����μ��ɡ�

% Euler = [ afa,beita,gama ] ����ŷ���Ǵ洢˳����ת˳�� ��Χ��Ϊ [ -pi,pi ]
function Euler = FQtoEuler(Q,rotateOrder)

if ~exist('rotateOrder','var')
    rotateOrder = 'ZYX';
end

qs = Q(1) ;
qx = Q(2) ;
qy = Q(3) ;
qz = Q(4) ;
switch rotateOrder
    case 'ZYX' 
        Q_New = Q ;  % ���NED��̬�� [ yaw,pitch,roll ]
    case 'ZXY'
        Q_New = [ qs,qy,qx,qz ];        
    case 'XYZ'
        Q_New = [ qs,qz,qx,qy ];   
    case 'XZY'
        Q_New = [ qs,qz,qy,qx ];   
    case 'YXZ'
        Q_New = [ qs,qy,qz,qx ];   
    case 'YZX'
        Q_New = [ qs,qy,qz,qx ];   
end
Euler = FQtoZYX_Euler(Q_New) ;


%% ��Ԫ��Q��ZYXŷ����
% Euler=[ angZ,angY,angX ] ŷ���Ǵ洢˳����ת˳��
function Euler = FQtoZYX_Euler(Q)
format long
Cnb = FQtoCnb(Q) ;

angX = atan2( Cnb(2,3),Cnb(3,3) ) ;
% angY = asin( -Cnb(1,3) ) ;
% ��һ��angY�Ľⷨ
angY = atan2(-Cnb(1,3),sqrt(Cnb(3,2)^2+Cnb(3,3)^2)) ;
angZ = atan2(Cnb(1,2),Cnb(1,1)) ;

Euler=[ angZ;angY;angX ] ;  % ����ת˳��洢
