%% xyz 2015.5.27

%% �����֣�����Ĵָ�ĽǶ�״̬���Ĵָ������ ����Poseʱ�� ����������ϵ�µ�ָ��
% Ĵָ�Ĺ���ϵΪ������ǰ������ת˳��Ϊ��YZX��
% w:���ر�����ϵ
% r:��wϵ��������Ϣ��ˮƽϵ��xָ���˵�ǰ����
% p���ض�pose������ϵ
%%% Input:
% rotateAngle��Ĵָ�ġ�YZX����ת�Ƕ�,��λ����  [3*1] 
% zd�� �˵�ǰ��������ϵ�µı�rϵx����wϵ�±�  [3*1]
% RightOrLeft�� ���֣� 'L'���� ���� ��'R'��
% pose"������ 'T' 'A'  'S'
function  bone_w = GenThumbDirection( rotateAngle,zd,RightOrLeft,pose )

if strcmp(RightOrLeft,'L')
    rotateAngle(1:2) = -rotateAngle(1:2);
end
rotateOrder = 'YZX';
rotateAngle = rotateAngle*pi/180 ;
%% ��ǰpose������ϵ p  -> Ĵָϵ
Cp_ThumbBone = Euler2C( rotateAngle,rotateOrder) ;
%% �޺��������ϵ r -> ��ǰpose������ϵ p
switch pose
    case 'T' 
        Crp = eye(3);
    case 'A'
        if strcmp(RightOrLeft,'L')
            Crp = RotateX(-pi/2);
        else
            Crp = RotateX(pi/2);
        end
    case 'S'
        if strcmp(RightOrLeft,'L')
            Crp = RotateZ(pi/2);
        else
            Crp = RotateX(-pi/2);
        end
    otherwise
        Crp = eye(3);
end
%% Crw
rx_w = zd ;                 % zd = [0; 1; 0];
rz_w = [0;0;1];
ry_w = cross( rx_w,rz_w );
Crw = [ rx_w,ry_w,rz_w ];  % 

%% Ĭ��ֵ ���˳���  zd = [0; 1; 0]; 
% Crw =
%      0     1     0
%      1     0     0
%      0     0     1
%%
Cw_ThumbBone =  Cp_ThumbBone * Crp * Crw' ;


bone_w = Cw_ThumbBone' * eye(3);
