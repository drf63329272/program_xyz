%% xyz 2015 ��ͯ��

%% �������Ҿ���  -> ��̬��

function Attitude = C2Attitude( Cwb,NavigationFrame )


Qwb = C2Q(Cwb);
Attitude = Q2Attitude( Qwb,NavigationFrame ) ;
