%% xyz 2015.5.13

%% ͨ����ֹ����ʱ�����ӼƷ�����õ�ת�Ƿ������ת����㾫��
% AccZero_Num: ��ֹʱ�� ���

function YprAnalyzeStr = AnalyzeYpr( Qnb,Qwr,Ypr,AccZero_Num,YprName )

RotateAngle = CalculateRotateAngle_Acc( Qnb,Qwr,Ypr,AccZero_Num ) ;
std_RotateAngle = std(RotateAngle);
YprAnalyzeStr = sprintf( 'Ypr(%s)��ֹʱת�Ǳ�׼�%0.3f ��',YprName,std_RotateAngle*180/pi );
