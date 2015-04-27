%% ����ϵ->��ؾ�γϵ
% �ס���>��γ��

function station_vns_lon_lat = meter_to_lon_lat(station_vns_w_m,lon_lat_start,planet) 

% ����ϵ -> ���ֱ��ϵ
N = size(station_vns_w_m,2);
station_vns_e_m = zeros(3,N) ;
e_start = FJWtoZJ(lon_lat_start,planet);
Cwe = FCen(lon_lat_start(1,1),lon_lat_start(2,1))';
for k=1:N
    station_vns_e_m(:,k) = e_start + Cwe*station_vns_w_m(:,k) ;    
end

% ���ֱ��ϵ -> ��ؾ�γϵ
station_vns_lon_lat = zeros(3,N);
for k=1:N
    station_vns_lon_lat(:,k) = FZJtoJW(station_vns_e_m(:,k),planet);
end
