%% xyz 2015.4.23
% ����Ԫ������ȡ�ǶȺ͵�λʸ��
% angle�� -pi ~ pi  [1*N]
% vectorNormed�� [3*N]  ��λʸ��������һ��

function [ QAngle,QVectorNormed] = GetQAngle( Q )


Q = Make_Const_N(Q,4);
Q_NormVector = GetNormVectorQ( Q );
QVectorNormed = Q_NormVector( 2:4,: );

N = size(Q,2);
QAngle =  zeros(1,N);
for k=1:N
    QAngle(k) = acot( Q_NormVector(1,k) )*2 ;
end
