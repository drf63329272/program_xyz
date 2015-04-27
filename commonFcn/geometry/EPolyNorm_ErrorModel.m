%% xyz 2015 3.20
% �� ePoly ת��Ϊ�� ���������ģ�� ��Ӧ�ı�׼ ePolyNormalized
% H_Norm Ϊ��ʵ�Ĵų�ʸ��ģ��С  ����Բʱ H_Norm Ϊ��תƽ���ڵĴΰ����ѹ�ʸ��ģ������ʱΪ3ά�ռ�ģ��

function [ ePolyNormalized,rate ] = EPolyNorm_ErrorModel( ePoly,H_Norm)

[ A,B,C,D,E,F ] = deal( ePoly(1),ePoly(2),ePoly(3),ePoly(4),ePoly(5),ePoly(6) ) ;
K = [ A  B/2; B/2  C ];
b  = ((-2*K)')\[D;E]; 

rate = H_Norm^2 / ( b'*K*b-F ) ;
ePolyNormalized = ePoly*rate ;