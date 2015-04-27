%% xyz 2015.3.6
% ������Ԫ����ZYXŷ���ǵ�ת������Ϊ����������Ԫ��������ŷ���ǵ�ת����ͨ��Ԥ�Ƚ���Ԫ�����μ��ɡ�

% Euler = [ afa,beita,gama ] ����ŷ���Ǵ洢˳����ת˳�� ��Χ��Ϊ [ -pi,pi ]
function Euler = QtoEuler(Q,rotateOrder)

format long
coder.inline('never');

Q = Make_Const_N( 4,Q ) ; 
Nframes = size( Q,2 );
Euler = zeros( 3,Nframes );
for k=1:Nframes
   Euler(:,k) = QtoEuler_One(Q(:,k),rotateOrder) ;
end

function Euler = QtoEuler_One(Q,rotateOrder)

if ~exist('rotateOrder','var')
    rotateOrder = 'ZYX';
end

qs = Q(1) ;
qx = Q(2) ;
qy = Q(3) ;
qz = Q(4) ;
switch rotateOrder
    case 'ZYX' 
        Euler = FQtoZYX_Euler(Q) ;  % ���NED��̬�� [ yaw,pitch,roll ]        
    case 'ZXY'
        Q_New = [ qs,qy,qx,qz ];
        Euler = FQtoZYX_Euler(Q_New) ;
        
        Euler = FQtoZXY_Euler(Q) ;
    case 'XYZ'
        Q_New = [ qs,qz,qy,qx ];   
        Euler = FQtoZYX_Euler(Q_New) ;
        
        Euler = FQtoXYZ_Euler(Q) ;
    case 'XZY'
        Q_New = [ qs,qz,qx,qy ];   
        Euler = FQtoZYX_Euler(Q_New) ;
        
        Euler = FQtoXZY_Euler(Q) ;
    case 'YXZ'
        Q_New = [ qs,qy,qz,qx ];   
        Euler = FQtoZYX_Euler(Q_New) ;
        
        Euler = FQtoYXZ_Euler(Q) ;
    case 'YZX'
        Q_New = [ qs,qx,qz,qy ];   
        Euler = FQtoZYX_Euler(Q_New) ;
        
        Euler = FQtoYZX_Euler(Q) ;
end



%% ��Ԫ��Q��ZYXŷ����
% Euler=[ angZ,angY,angX ] ŷ���Ǵ洢˳����ת˳��
function Euler = FQtoZYX_Euler(Q)
format long
Cnb = FQtoCnb(Q) ;

angX = atan2( Cnb(2,3),Cnb(3,3) ) ;
angY = asin( -Cnb(1,3) ) ;
% ��һ��angY�Ľⷨ
% angY = atan2(-Cnb(1,3),sqrt(Cnb(3,2)^2+Cnb(3,3)^2)) ;
angZ = atan2(Cnb(1,2),Cnb(1,1)) ;

Euler=[ angZ;angY;angX ] ;  % ����ת˳��洢

function Euler = FQtoYXZ_Euler(Q)
format long
Cnb = FQtoCnb(Q) ;

angY = atan2( Cnb(3,1),Cnb(3,3) ) ;
angX = asin( -Cnb(3,2) ) ;
angZ = atan2(Cnb(1,2),Cnb(2,2)) ;

Euler=[ angY;angX;angZ ] ;  % ����ת˳��洢

function Euler = FQtoZXY_Euler(Q)
format long
Cnb = FQtoCnb(Q) ;

angZ = atan2( -Cnb(2,1),Cnb(2,2) ) ;
angX = asin( Cnb(2,3) ) ;
angY = atan2(-Cnb(1,3),Cnb(3,3)) ;

Euler=[ angZ;angX;angY ] ;  % ����ת˳��洢

function Euler = FQtoYZX_Euler(Q)
format long
Cnb = FQtoCnb(Q) ;

angY = atan2(-Cnb(1,3),Cnb(1,1)) ;
angZ = asin( Cnb(1,2) ) ; 
angX = atan2( -Cnb(3,2),Cnb(2,2) ) ;


Euler=[ angY;angZ;angX ] ;  % ����ת˳��洢

function Euler = FQtoXYZ_Euler(Q)
format long
C = FQtoCnb(Q) ;

angX = atan2( -C(3,2),C(3,3) ) ;
angY = asin( C(3,1) ) ;
angZ = atan2( -C(2,1),C(1,1) ) ;

Euler=[ angX;angY;angZ ] ;  % ����ת˳��洢

function Euler = FQtoXZY_Euler(Q)
format long
C = FQtoCnb(Q) ;

angX = atan2( C(2,3),C(2,2) ) ;
angZ = asin( -C(2,1) ) ;
angY = atan2( C(3,1),C(1,1) ) ;

Euler=[ angX;angZ;angY ] ;  % ����ת˳��洢

