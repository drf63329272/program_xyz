%% xyz 2015
%%

function  QnbNewNorm  = QuaternionDifferential( Qnb,Wnbb,T )
%��Ԫ��΢�ַ���
% ��������
            
dAngleV = Wnbb*T ;
dAngle0 = sqrt( dAngleV(1)^2+dAngleV(2)^2+dAngleV(3)^2 ) ;
dAngleM = [     0    ,-dAngleV(1),-dAngleV(2),-dAngleV(3);
            dAngleV(1),     0    , dAngleV(3),-dAngleV(2);
            dAngleV(2),-dAngleV(3),     0    , dAngleV(1);
            dAngleV(3), dAngleV(2),-dAngleV(1),     0   ];
% �Ľ׽�������
QnbNew = ( (1-dAngle0^2/8-dAngle0^4/384)*eye(4)+(1/2-dAngle0^2/48)*dAngleM )*Qnb ;
QnbNewNorm = QnbNew/norm(QnbNew);
end

