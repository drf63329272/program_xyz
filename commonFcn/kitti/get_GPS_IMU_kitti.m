% �� kitti �� 2011_09_26_drive_0048_extract\oxts ��ȡ��ʵ�켣�� IMU����

% (1) lat:   latitude of the oxts-unit (deg)  ע�������λ�Ƕ�
% (2) lon:   longitude of the oxts-unit (deg)
% (3) alt:   altitude of the oxts-unit (m)
% (4) roll:  roll angle (rad),    0 = level, positive = left side up,      range: -pi   .. +pi
% (5) pitch: pitch angle (rad),   0 = level, positive = front down,        range: -pi/2 .. +pi/2
% (6) yaw:   heading (rad),       0 = east,  positive = counter clockwise, range: -pi   .. +pi
% (7) vn:    velocity towards north (m/s)
% (8) ve:    velocity towards east (m/s)
% (9) vf:    forward velocity, i.e. parallel to earth-surface (m/s)
% (10) vl:    leftward velocity, i.e. parallel to earth-surface (m/s)
% (11) vu:    upward velocity, i.e. perpendicular to earth-surface (m/s)
% (12) ax:    acceleration in x, i.e. in direction of vehicle front (m/s^2)
% (13) ay:    acceleration in y, i.e. in direction of vehicle left (m/s^2)
% (14) ay:    acceleration in z, i.e. in direction of vehicle top (m/s^2)
% (15) af:    forward acceleration (m/s^2)
% (16) al:    leftward acceleration (m/s^2)
% (17) au:    upward acceleration (m/s^2)
% (18) wx:    angular rate around x (rad/s)
% (19) wy:    angular rate around y (rad/s)
% (20) wz:    angular rate around z (rad/s)
% (21) wf:    angular rate around forward axis (rad/s)
% (22) wl:    angular rate around leftward axis (rad/s)
% (23) wu:    angular rate around upward axis (rad/s)
% (24) pos_accuracy:  velocity accuracy (north/east in m)
% (25) vel_accuracy:  velocity accuracy (north/east in m/s)
% (26) navstat:       navigation status (see navstat_to_string)
% (27) numsats:       number of satellites tracked by primary GPS receiver
% (28) posmode:       position mode of primary GPS receiver (see gps_mode_to_string)
% (29) velmode:       velocity mode of primary GPS receiver (see gps_mode_to_string)
% (30) orimode:       orientation mode of primary GPS receiver (see gps_mode_to_string)

% ע��
%  ��1��ax~az wx~wz ��xyzָ���Ǳ���ϵ
%  ��2��vf~vu af~au wf~wu �е� f��l��uָ���� ����ϵӳ�䵽����ˮƽ�������ϵ��Ҳ����˵
%       f��l��ˮƽ���ڣ���f��ָ�����ű���ϵ�ĺ���u�������ϵ�������غϡ�
%  ��3��kitti�У������Ϊ0ָ�򶫣��ҵ�ϵͳ�к���Ϊ0Ϊָ�򱱡�kitti�У���������̧��Ϊ���������ǵ�ͷΪ�����ҵ�ϵͳ�У�������̧ͷΪ������������̧��Ϊ����
%           kitti����̬->��(mine)����̬��pitch_mine = roll_kitti�����������һ�µģ���
%           roll_mine = pitch_kitti(�������Ҳ��һ�µ�),yaw_mine = yaw_kitti-pi/2
%  ��4��kitti�У�����ϵ��bxָ��ǰ��byָ�����ҵ�ϵͳ�У�bxָ���ң�byָ��ǰ��
%           kitti����ϵ->�ҵı���ϵ��bx_mine = -by_kitti;by_mine = bx_kitti;bz_mine = bz_kitti
%   (5) kitti��ͼƬ��ʱ�䲻���ϸ�� 10HZ����ʱ����0.01~0.05s�Ĳ������Ҳ���������ۻ�
%   (6) kitti��oxt_extract��ʱ�䣬һ�����ϸ�100HZ�ģ����ǣ������ᷢ�� ͻ�䡢��ʧʱ�䡢����ʱ�䷴�� ������
%   # ���ݴ洢���򣺲�ͬ�������ݵĶ����Ϸ���Ƶ�ʹ���ͨ��runTime��¼ȷ�е�ʱ��
%%
function get_GPS_IMU_kitti()
format long
dbstop error
clc
clear all
close all

 raw_data_dir = 'E:\�����Ӿ�����\NAVIGATION\data_kitVO\';
%raw_data_dir = 'O:\KITTI\';
pro_name = '2011_09_26_drive_0096';
 % pro_name='2011_10_03_drive_0034';
prodir = [raw_data_dir,pro_name];
base_sync_dir = [prodir,'\',pro_name,'_sync'];
base_extract_dir = [prodir,'\',pro_name,'_extract'];
%% ��ȡԭʼGPS-IMU����
if exist(base_extract_dir,'file')
   isLoad_extract = 1;
else
    isLoad_extract=0;
end
if isLoad_extract==1
    oxts_extract_old = loadOxtsliteData(base_extract_dir);
    % 100HZ δ����GPS_IMU���ݵĲ���ʱ��
    ts_oxts_extract = loadTimestamps([base_extract_dir,'\oxts']) ;
    runTime_IMU_extract_old = ts_to_runTime(ts_oxts_extract) ;
    stepTime_IMU_extract_old = runTime_to_setpTime(runTime_IMU_extract_old) ;
    figure
    plot(runTime_IMU_extract_old)
    title('ԭʼδ����� 100HZ IMU���ݲɼ�ʱ��')
    
    figure
    plot(stepTime_IMU_extract_old)
    title('ԭʼδ����� 100HZ IMU���ݲɼ�ʱ�� ����')
end
oxts_sync = loadOxtsliteData(base_sync_dir)';


%% 10HZ �����GPS_IMU���ݵĲ���ʱ��
ts_oxts_sync = loadTimestamps([base_sync_dir,'\oxts']) ;
% 10HZ ��ͼƬʱ��
ts_image0_sync = loadTimestamps([base_sync_dir,'\image_00']) ;

%% 100HZ IMU������ȡ���޳� oxts_extract_old ����Чͷβ  -> oxts_extract_new
% ���� oxts_extract_new ��oxts_extract_old�ĵ�һ����� k_extract_old_start
if isLoad_extract==1
    for j=1:length(ts_oxts_extract)
       if strcmp(ts_oxts_extract{j},ts_oxts_sync{1}) 
           k_extract_old_start = j;
           break;
       end
    end
    % ���� oxts_extract_new ��oxts_extract_old���һ����� k_extract_old_end
    for j=1:length(ts_oxts_extract)
       if strcmp(ts_oxts_extract{j},ts_oxts_sync{length(ts_oxts_sync)}) 
           k_extract_old_end = j;
           break;
       end
    end

    oxts_extract_new_N = k_extract_old_end-k_extract_old_start+1 ;   
    % ��ȡ�õ� oxts_extract_new
    oxts_extract_new = oxts_extract_old(k_extract_old_start:k_extract_old_end) ;    % 100HZ GPS-IMU�������뵼����������ݣ�
    ts_oxts_extract_new = ts_oxts_extract(k_extract_old_start:k_extract_old_end) ;
    isPic_IMUFlag = zeros(oxts_extract_new_N,1);            % ��¼��ǰ GPS-IMU ʱ���Ƿ��Ӧ��һ��ͼ��ʱ�̣�0/1��Ϊ1�������ʱ�̽�����Ϣ�ں�
    isIMU_PicFlag = zeros(length(ts_oxts_sync),1);
end

%% runTime
if isLoad_extract==1
    runTime_IMU_extract = ts_to_runTime(ts_oxts_extract_new) ;
    %%% runTime_IMU_extract
    runTime_IMU_extract_error = zeros(oxts_extract_new_N,1);
    for n=1:oxts_extract_new_N
        runTime_IMU_extract_error(n) = runTime_IMU_extract(n)-(n-1)*0.01;
    end
    figure('name','δͬ�� 100HZ��IMU���� ��Ƶ��֮��ľ������')
    plot(runTime_IMU_extract_error)
    title('δͬ�� 100HZ��IMU���� ��Ƶ��֮��ľ������')
    saveas(gcf,[prodir,'\δͬ�� 100HZ��IMU���� ��Ƶ��֮��ľ������.fig'])

end
runTime_IMU_sync = ts_to_runTime(ts_oxts_sync) ;
runTime_image0_sync = ts_to_runTime(ts_image0_sync) ;
stepTime_IMU_sync = runTime_to_setpTime(runTime_IMU_sync) ;
stepTime_image0_sync = runTime_to_setpTime(runTime_image0_sync) ;
%%% runTime_IMU_sync
runTime_IMU_sync_error = zeros(length(runTime_IMU_sync),1);
for n=1:length(runTime_IMU_sync)
    runTime_IMU_sync_error(n) = runTime_IMU_sync(n)-(n-1)*0.1;
end

%%% runTime_image0_sync
runTime_image0_sync_error = zeros(length(runTime_image0_sync),1);
for n=1:length(runTime_image0_sync)
    runTime_image0_sync_error(n) = runTime_image0_sync(n)-(n-1)*0.1;
end

figure('name','ͬ���� 10HZ ͼ�� �� IMUʱ�� ��Ƶ��֮��ľ������')
hold on
title('ͬ���� 10HZ ͼ�� �� IMUʱ�� ��Ƶ��֮��ľ������')
plot(runTime_IMU_sync_error,'color','r')
plot(runTime_image0_sync_error,'color','b')
legend('10HZ IMU','10HZ ͼ��')
saveas(gcf,[prodir,'\ͬ���� 10HZ ͼ�� �� IMUʱ�� ��Ƶ��֮��ľ������.fig'])

figure('name','ͬ���� 10HZ ͼ�� �� IMUʱ��')
hold on
title('ͬ���� 10HZ ͼ�� �� IMUʱ��')
plot(runTime_IMU_sync,'color','r')
plot(runTime_image0_sync,'color','b')
legend('10HZ IMU','10HZ ͼ��')

saveas(gcf,[prodir,'\ͬ���� 10HZ ͼ�� �� IMUʱ��.fig'])

figure
plot([stepTime_IMU_sync stepTime_image0_sync])
legend('������10HZ IMU�ɼ� ����','�Ӿ��ɼ� ����')
title('�ɼ�����')
 %% �� isPic_IMUFlag
% k_extract_old_search = 1;
% k_extract_new_last = 1;
% for k_extract_new=1:oxts_extract_new_N
% % �жϴ�ʱ���Ƿ��Ӧ�� ͼƬ
%     dT = abs(runTime_IMU_extract(k_extract_new)-runTime_IMU_sync(k_extract_old_search)) ;
%     if dT<1/100/2
%         if k_extract_new>1
%             k_step = k_extract_new-k_extract_new_last ;
%             if k_step>13 || k_step<8
%                 errordlg(sprintf('�Ƿ��ӦͼƬ���жϣ���%d������',k_extract_new));
%             end
%             k_extract_new_last = k_extract_new ;
%         end
%         k_extract_old_search = k_extract_old_search+1 ;
%         isPic_IMUFlag(k_extract_new) = 1;
%     end
% end
% if isPic_IMUFlag(oxts_extract_new_N)~=1
%     errordlg('isPic_IMUFlag���һ������1������');
% end

%% �� oxts_extract_new ת��Ϊ trueTrace ��ʽ imuInputData ��ʽ
% ���ݴ洢���򣺲�ͬ�������ݵĶ����Ϸ���Ƶ�ʹ���ͨ��runTime��¼ȷ�е�ʱ��
% ȡУ�����10HZ����
[imuInputData,trueTrace,IMU_data_t,trueTrace_data_t,pos_accuracy,vel_accuracy] = oxts_to_imuInputData_trueTrace(oxts_sync) ;  

disp('ȡͬ��֮���10HZ����')

imuInputData.runTime = runTime_IMU_sync ;
imuInputData.frequency = 10 ;
imuInputData=IMU_sub1(imuInputData);

trueTrace.runTime_IMU = runTime_IMU_sync ;
trueTrace.runTime_image = runTime_image0_sync ;
trueTrace.frequency = 10 ;

IMU_data_t.runTime_IMU = runTime_IMU_sync ;
IMU_data_t.frequency = 10 ;
trueTrace_data_t.frequency = 10 ;
trueTrace_data_t.runTime_image = runTime_image0_sync ;
trueTrace_data_t.runTime_IMU = runTime_IMU_sync ;

lon_lat_alt = trueTrace.lon_lat_alt ;
position_w = trueTrace.position ;
attitude_w = trueTrace.attitude ;
velocity_w = trueTrace.velocity ;

wholeLength = CalRouteLength( trueTrace.position );
describe = sprintf('·�̳��ȣ�%0.2f m\tʱ�䣺%0.2f sec',wholeLength,runTime_IMU_sync(length(runTime_IMU_sync)));
display(describe)
trueTrace.describe = describe ;

save imuInputData imuInputData
save trueTrace trueTrace
save([prodir,'\imuInputData'],'imuInputData')
save([prodir,'\imuInputData_measure'],'imuInputData')
save([prodir,'\trueTrace'],'trueTrace')
disp('imuInputData/imuInputData_measure��ֱ�Ӳ�����IMU����')
disp('imuInputData�п��ܱ��滻�ɷ��Ƶ�IMU����')
% �������е���ϵ����������Ҫ�õ������� IMU_data_t trueTrace_data_t
save IMU_data_t IMU_data_t
save trueTrace_data_t trueTrace_data_t
save([prodir,'\IMU_data_t'],'IMU_data_t')
save([prodir,'\trueTrace_data_t'],'trueTrace_data_t')
disp('IMU_data_t,trueTrace_data_t:����ϵ������Ҫ������')

lineWidth=2.5;
labelFontSize = 16;
axesFontsize = 13;

ph_pos_accuracy = figure('name',[pro_name,'_pos_accuracy']);
plot(pos_accuracy)
ylabel('m')
title('pos\_accuracy (m)')

ph_vel_accuracy = figure('name',[pro_name,'_vel_accuracy']);
plot(vel_accuracy)
ylabel('m/s')
title('vel\_accuracy (m/s)')

ph1 = figure('name',[pro_name,'_position_xyz_w']);
plot(runTime_IMU_sync,position_w')
title('position\_xyz\_w (m)')
legend('x','y','z');
xlabel('sec')
ylabel('m')

ph2 = figure('name',[pro_name,'_trace_xy']);
plot(position_w(1,:),position_w(2,:))
title('trace\_xy (m)')
ylabel('y/N')
xlabel('x/E')
hold on
plot(position_w(1,1),position_w(2,1),'o')


figure('name',[pro_name,'_trace_xy_lon_lat']);
set(cla,'fontsize',15)
plot(lon_lat_alt(1,:)*180/pi,lon_lat_alt(2,:)*180/pi)
% title('trace\_xy (rad)')
ylabel('latitude(��)','fontsize',20)
xlabel('longitude(��)','fontsize',20)
hold on
plot(lon_lat_alt(1,1)*180/pi,lon_lat_alt(2,1)*180/pi,'o')
saveas(gcf,[prodir,'\',[pro_name,'_trace_xy_lon_lat'],'.fig'])

ah = figure('name',[pro_name,'_attitude_w']);
plot(runTime_IMU_sync,attitude_w')
title('attitude\_w (rad)')
legend('pitch','roll','yaw');
xlabel('sec')
ylabel('rad')

saveas(ph1,[prodir,'\',[pro_name,'_position_xyz_w'],'.fig'])
saveas(ph2,[prodir,'\',[pro_name,'_trace_xy'],'.fig'])
saveas(ah,[prodir,'\',[pro_name,'_attitude_w'],'.fig'])
saveas(ph_pos_accuracy,[prodir,'\',[pro_name,'_pos_accuracy'],'.fig'])
saveas(ph_vel_accuracy,[prodir,'\',[pro_name,'_vel_accuracy'],'.fig'])
saveas(ph_pos_accuracy,[prodir,'\',[pro_name,'_pos_accuracy'],'.fig'])
saveas(ph_vel_accuracy,[prodir,'\',[pro_name,'_vel_accuracy'],'.fig'])

disp('getTrueTrace_kitti ok')

function [imuInputData,trueTrace,IMU_data_t,trueTrace_data_t,pos_accuracy,vel_accuracy] = oxts_to_imuInputData_trueTrace(oxts_extract_new)

%% �� oxts_extract_new ת��Ϊ trueTrace ��ʽ imuInputData ��ʽ

ax = get_oxt_part(oxts_extract_new,12);
ay = get_oxt_part(oxts_extract_new,13);
az = get_oxt_part(oxts_extract_new,14);
af = get_oxt_part(oxts_extract_new,15);
al = get_oxt_part(oxts_extract_new,16);
au = get_oxt_part(oxts_extract_new,17);
wx = get_oxt_part(oxts_extract_new,18);
wy = get_oxt_part(oxts_extract_new,19);
wz = get_oxt_part(oxts_extract_new,20);
wf = get_oxt_part(oxts_extract_new,21);
wl = get_oxt_part(oxts_extract_new,22);
wu = get_oxt_part(oxts_extract_new,23);

% kitti ����ϵ���ҵı���ϵ��������
fib = [-ay;ax;az];      
wib = [-wy;wx;wz];

imuInputData.dataSource = 'kitti';
imuInputData.flag = 'exp';
imuInputData.f = fib ;
imuInputData.wib = wib ;

lat = get_oxt_part(oxts_extract_new,1) * pi/180; % γ��
lon = get_oxt_part(oxts_extract_new,2) * pi/180;
alt = get_oxt_part(oxts_extract_new,3);
pos_accuracy = get_oxt_part(oxts_extract_new,24);
vel_accuracy = get_oxt_part(oxts_extract_new,25);
roll_kitti = get_oxt_part(oxts_extract_new,4);
pitch_kitti = get_oxt_part(oxts_extract_new,5);
yaw_kitti = get_oxt_part(oxts_extract_new,6);
%%%%%%%%%  �� kitti ����̬���� -> �ҵ���̬����
yaw = yaw_kitti-pi/2 ;
yaw = yawHandle(yaw) ;  % �� ����� ת���� -180~180 
pitch = roll_kitti;
roll = pitch_kitti;

vn = get_oxt_part(oxts_extract_new,7);
ve = get_oxt_part(oxts_extract_new,8);
vf = get_oxt_part(oxts_extract_new,9);
vl = get_oxt_part(oxts_extract_new,10);
vu = get_oxt_part(oxts_extract_new,11);
velocity_t = [ve;vn;vu] ;

% attitude_t �� ����ϵ��� ������ ����̬����������ҵĳ��ö���
attitude_t = [pitch;roll;yaw];
% kitti �Դ��� ��γ��->�� ת�������������ǵ���ϵ�ı䶯��
[ position_w_kitti,attitude_w_kitti,position_b1 ] = oxts_to_posW(oxts_extract_new,attitude_t);
% �ҵ�
lon_lat_alt = [lon;lat;alt]   ;
position_w_me = lon_lat_alt_to_Wxyz(lon_lat_alt,'e') ;
attitude_w_me = attitude_t_to_attitude_w(attitude_t,lon_lat_alt) ;

position_w = position_w_me ;
attitude_w = attitude_w_me ;

velocity_w = velocity_t_to_velocity_w(velocity_t,lon_lat_alt) ;
velocity_b = velocity_t_to_velocity_b(velocity_t,attitude_t) ;              %%%%%% ?????????? Ϊʲô bz���ٶ���ô��by���ٶ���ôС�������������⣩

initialAttitude_r = attitude_t(:,1);

trueTrace.dataSource = 'kitti';
trueTrace.planet = 'e';
trueTrace.initialPosition_e = [lon(1),lat(1),alt(1)];
trueTrace.initialPosition_r = zeros(3,1);
trueTrace.initialVelocity_r = velocity_w(:,1);
trueTrace.initialAttitude_r = initialAttitude_r ;

trueTrace.lon_lat_alt = lon_lat_alt;    % ��γ�߶�
trueTrace.position = position_w;        % ����ϵ����ʼʱ�̵���ϵ��λ��
trueTrace.attitude_t = attitude_t ;
trueTrace.attitude = attitude_w ;
trueTrace.velocity = velocity_w ;
trueTrace.velocity_b = velocity_b ;

IMU_data_t.fib = fib ;
IMU_data_t.wib = wib ;
trueTrace_data_t.lon_lat_alt = lon_lat_alt ;
trueTrace_data_t.attitude_t = attitude_t ;
trueTrace_data_t.velocity_t = velocity_t ;

%% IMU ���ݼ���һ��
function imuInputData=IMU_sub1(imuInputData)
N = length(imuInputData.f);
imuInputData.f(:,N) = [];
imuInputData.wib(:,N) = [];
imuInputData.runTime(N) = [];

function [ position_w,attitude_w,position_b1 ] = oxts_to_posW(oxts_extract_new,attitude_t)
pose_extract_new = convertOxtsToPose(oxts_extract_new);
N = length(pose_extract_new);
% position_b1������ڵ�һ��ʱ��
%   xָ��ǰ��yָ����
position_b1 = zeros(3,N);   
attitude_w = zeros(3,N);
Cb1w = FCbn(attitude_t(:,1));
for k=1:N
    position_b1(:,k) = pose_extract_new{k}(1:3,4);
    Cb1_bk = pose_extract_new{k}(1:3,1:3);
    Cw_bk = Cb1_bk * Cb1w' ;
    opintions.headingScope = 180 ;
    attitude_w(:,k) = GetAttitude(Cw_bk,'rad',opintions);
end

position_w = Cb1w * position_b1 ;



function data_k = get_oxt_part(oxts,k)
oxts_length = length(oxts);
data_k = zeros(1,oxts_length);
for i=1:oxts_length
    data_k(i) = oxts{i}(k);
end


%% ��������ʱ�����ʱ��ת��Ϊ �ӵ�һ��ʱ�̿�ʼ�� ʱ�䣬��λ����
% ֻ���� ʱ����
function runTime_sec = ts_to_runTime(ts)
ts_length = length(ts);
runTime_sec = zeros(ts_length,1);

[ts_sec_1,ts_min_1,ts_h_1] = tsFormat_to_secFormat(ts{1}) ;

for k=1:ts_length
    
    [ts_sec_k,ts_min_k,ts_h_k] = tsFormat_to_secFormat(ts{k}) ;
    runTime_sec(k) = ts_sec_k-ts_sec_1 + (ts_min_k-ts_min_1)*60 + (ts_h_k-ts_h_1)*60*60 ;
end
disp('')

function [ts_sec_k,ts_min_k,ts_h_k] = tsFormat_to_secFormat(ts_k)
% ��
ts_sec_k = ts_k(18:length(ts_k));
ts_sec_k = str2double(ts_sec_k) ;
% ��
ts_min_k = ts_k(15:16);
ts_min_k = str2double(ts_min_k) ;
% ʱ
ts_h_k = ts_k(12:13);
ts_h_k = str2double(ts_h_k) ;

function velocity = postion_to_velocity(postion,runTime)
N = length(postion);
velocity = zeros(size(postion));
for k=1:N
    if k==1
        k1 = 1 ;
        k2 = 2 ;
    elseif k==N
        k1 = N-1 ;
        k2 = N ;
    else
        k1 = k-1 ;
        k2 = k+1 ;
    end
    velocity(:,k) = (postion(:,k2)-postion(:,k1))/(runTime(k2)-runTime(k1));
end
