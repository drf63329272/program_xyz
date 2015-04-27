% �� ��γ�߶� ת��Ϊ ��ʼʱ�̵���ֱ��ϵ����������ϵ��
% ��ʼʱ�̵���ֱ��ϵ: ������->xָ���ʼ��,yָ���ʼ����zָ���ʼ��

function position_w = lon_lat_alt_to_Wxyz(lon_lat_alt,planet)

% poser stationr(��;γ;��)
N = size(lon_lat_alt,2);

% ����ؾ�γ���� ת���� ֱ������
station_e_xyz = zeros(3,N);
for k=1:N
    station_e_xyz(:,k) = FJWtoZJ(lon_lat_alt(:,k),planet);
end

% �����ֱ������ ת�� ��ʼʱ������ϵ
position_w = zeros(3,N);
Cew = FCen(lon_lat_alt(1,1),lon_lat_alt(2,1));
for k=1:N
    position_w(:,k) = Cew*( station_e_xyz(:,k)-station_e_xyz(:,1) );
end
