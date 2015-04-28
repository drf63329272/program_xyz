%  buaa xyz 2014.1.9

% ������
% http://www.solarsystem.nasa.gov/planets/
%% ���������س���
% ע�������gֻ�д�С������������
function earth_const = getEarthConst(place)
format long

%earth_const.g0=9.7803267714;
%% ����g ����
% earth_const.g0=9.80665;
% 
% earth_const.gk1 = 0.0052884;
% earth_const.gk2 = 0.0000059;

%% ������g������Ϊ�˼򻯼��㣬ֱ��ȡʵ�鵱�ص��������ٶȣ�����ʱ����ô����
earth_const.g0=9.80665; 
earth_const.gNorm=9.80665; 

earth_const.gk1 = 0 ;
earth_const.gk2 = 0 ;

earth_const.wie=7.292115147e-5;  
earth_const.Re = 6378245 ;
% earth_const.Re = 6378137;   % kitti
earth_const.e = 1/298.3 ;

if exist('place','var')
    if strcmp(place,'kitti')
        earth_const.Re = 6378137;   % kitti
        earth_const.g0=9.80665; 
    end
end

