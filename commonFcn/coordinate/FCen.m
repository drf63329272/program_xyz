%�������Ce_n

% ����
%   lat�����ȣ�rad�� [ -180 180 ]
%   lon��γ�ȣ�rad��   [-90 90]
   
function [Ce_n]=FCen(lat,lon)
format long

% 2014.9.1֮ǰ�� initialPosition_e ��λ������ �㣬��һ�¼���Ƿ�����
if abs(lat)>7 || abs(lon)>7
   errordlg('��γ�ȵĵ�λ�����˴��� ��ĳ� rad��(FCen)') ;
   lat = lat*pi/180 ;
   lon = lon*pi/180 ;
end

Ce_n(1,1)=-sin(lat); 
Ce_n(1,2)=cos(lat);
Ce_n(1,3)=0;                             
Ce_n(2,1)=-sin(lon)*cos(lat);
Ce_n(2,2)=-sin(lon)*sin(lat); 
Ce_n(2,3)=cos(lon);
Ce_n(3,1)=cos(lon)*cos(lat);                          
Ce_n(3,2)=cos(lon)*sin(lat);  
Ce_n(3,3)=sin(lon);

% ��
% Cen = [1 0 0;0 sin(lon) cos(lon) ;0 -cos(lon) sin(lon)]*[-sin(lat) cos(lat) 0;-cos(lat) -sin(lat) 0;0 0 1];

 
