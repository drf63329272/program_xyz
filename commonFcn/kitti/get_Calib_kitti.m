
function get_Calib_kitti()

format long
dbstop error
clc
clear all
close all

% raw_data_dir = 'E:\�����Ӿ�����\NAVIGATION\data\kitti\raw data\';

% raw_data_dir = 'I:\NAVIGATION\data\';
raw_data_dir='E:\�����Ӿ�����\NAVIGATION\data_kitVO\';
numStr = '0034';
 dateStr = '2011_10_03';
 
% numStr = '0034';
%  dateStr = '2011_10_30';

base_dir = [raw_data_dir,sprintf('%s_drive_%s\\',dateStr,numStr)];
calib_name = sprintf('%s_drive_%s\\%s_calib\\%s\\',dateStr,numStr,dateStr,dateStr);

calib_dir = [raw_data_dir,calib_name];

calib = loadCalibrationCamToCam(fullfile(calib_dir,'calib_cam_to_cam.txt'));
Tr_velo_to_cam = loadCalibrationRigid(fullfile(calib_dir,'calib_velo_to_cam.txt'));
Tr_imu_to_velo = loadCalibration_imuTovelo(fullfile(calib_dir,'calib_imu_to_velo.txt')) ;
S = calib.S{1};
K_0 = calib.K{1};
K_1 = calib.K{2} ;
D_0 = calib.D{1};
D_1 = calib.D{2};
T_0 = calib.T{1};
T_1 = calib.T{2};
R_0 = calib.R{1} ;
R_1 = calib.R{2} ;
P_rect_0 = calib.P_rect{1} ;
P_rect_1 = calib.P_rect{2} ;
S_rect = calib.S_rect{1};
R_rect_0 = calib.R_rect{1} ;
R_rect_1 = calib.R_rect{2} ;

% ���� IMU �� cam֮��İ�װ��ϵ
Tr_imu_to_cam = Tr_velo_to_cam * Tr_imu_to_velo ;
R_imu_to_cam = Tr_imu_to_cam(1:3,1:3) ;
Rbc = R_imu_to_cam*[0 1 0;-1 0 0;0 0 1];
Tcb_c = Tr_imu_to_cam(1:3,4);
Cb1c = [1, 0, 0;     % ����ϵ�����������ϵ:��x��ת��-90��
        0, 0,-1;     % ���������ϵc�� x��y�����ƽ�棬y���£�x���ң�z��ǰ
        0, 1, 0];
Cbb1 = Cb1c' * Rbc ;
opintions.headingScope = 180 ;
cameraSettingAngle = GetAttitude(Cbb1,'rad',opintions) ;
Tcb_c_str = sprintf('%0.4f  ',Tcb_c);
sprintf('Tcb_c�����ֵΪ -0.32 0.72 -1.08���궨ֵΪ��%s\n',Tcb_c_str)
cameraSettingAngle_str = sprintf('%0.4f  ',cameraSettingAngle*180/pi);
sprintf('cam0���IMU��װ�ǵ����ֵΪ 0 0 0���궨ֵΪ��%s ��\n',cameraSettingAngle_str)
%%%%%%%%%%%%% ??????????????????
% Ϊʲô K �� P_rect �еĽ����ܶࣿ������ô��ı佹�ࣿ

% �����ǣ��������λ�����  T_0 R_rect_0
%% ����ǰ������궨����
calibData_extract.T = (T_1-T_0)*1000 ;    % ת��Ϊ mm ��λ
calibData_extract.om = R_1*R_0' ;
calibData_extract.fc_left = [K_0(1,1);K_0(2,2)] ;
calibData_extract.fc_right = [K_1(1,1);K_1(2,2)];
calibData_extract.cc_left = [K_0(1,3);K_0(2,3)];
calibData_extract.cc_right = [K_1(1,3);K_1(2,3)];
calibData_extract.kc_left = zeros(5,1);
calibData_extract.kc_right = zeros(5,1);
calibData_extract.alpha_c_left = 0 ;
calibData_extract.alpha_c_right = 0;
display(calibData_extract.fc_left)

calibData_extract.cameraSettingAngle = cameraSettingAngle ;
calibData_extract.Tcb_c = Tcb_c;
calibData_extract.Rbc = Rbc ;
%% �����������궨����
calibData_rect.T = T_1*1000 ;    % ת��Ϊ mm ��λ
om_R = R_rect_1*R_rect_0' ;
om_R=R_1;
om_R = [0;0;0]; % У����Ϊ0
calibData_rect.om = om_R ;
calibData_rect.fc_left = [P_rect_0(1,1);P_rect_0(2,2)] ;
calibData_rect.fc_right = [P_rect_1(1,1);P_rect_1(2,2)];
calibData_rect.cc_left = [P_rect_0(1,3);P_rect_0(2,3)];
calibData_rect.cc_right = [P_rect_1(1,3);P_rect_1(2,3)];
calibData_rect.kc_left = zeros(5,1);
calibData_rect.kc_right = zeros(5,1);
calibData_rect.alpha_c_left = 0 ;
calibData_rect.alpha_c_right = 0;

calibData_rect.cameraSettingAngle = cameraSettingAngle ;
calibData_rect.Tcb_c = Tcb_c;
calibData_rect.Rbc = Rbc ;

opintions.headingScope = 180 ;
om_R_rect_1 = GetAttitude(R_rect_1,'rad',opintions)*180/pi

om_rect_1_0 = GetAttitude(R_rect_1*R_rect_0','rad',opintions)*180/pi


om_1 = GetAttitude(R_1,'rad',opintions)*180/pi

display(calibData_rect.fc_left)
%% 
if exist([base_dir,'\visualInputData.mat'],'file')
    visualInputData = importdata([base_dir,'\visualInputData.mat']);
end
visualInputData.dataSource = 'kitti';
visualInputData.calibData = calibData_rect ;

calibData = calibData_rect ;
% if isfield(visualInputData,'VisualRT')
%     visualRbbTbb = backRT_to_frontRT(visualInputData,base_dir);
%     save([base_dir,'\visualRbbTbb.mat'],'visualRbbTbb')
% end

if isfield(visualInputData,'errorStr')
    errorStr = visualInputData.errorStr;
    fid=fopen([base_dir,'�Ӿ��������.txt'],'w+');
    fprintf(fid,'�Ӿ��������:\n%s',errorStr);
    fclose(fid);
end
save([base_dir,'\calibData.mat'],'calibData')
save([base_dir,'\visualInputData.mat'],'visualInputData')

disp('get_Calib_kitti OK:������·���б��浽calibData��visualInputData�� ')
display(base_dir)