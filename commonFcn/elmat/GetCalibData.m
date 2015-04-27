%   Ϊ�Ӿ������������궨����
%       buaa xyz 2013.12.24
%       nuaaxuyognzhi@yeah.net
% 2014.5.15 �޸� fov 

%  reslution = [1392 ;1040]
function calibData = GetCalibData(reslution)
% ˫Ŀ�����10������궨������������ά�ؽ�����om(rad),T(mm),fc_left,cc_left,kc_left,alpha_c_left,fc_right
%                                           cc_right,kc_right,alpha_c_right
% Output:
%           om,T: rotation vector and translation vector between right and left cameras (output of stereo calibration)
%           fc_left,cc_left,...: intrinsic parameters of the left camera  (output of stereo calibration)
%           fc_right,cc_right,...: intrinsic parameters of the right camera
%           (output of stereo calibration)
% Input:
%           B,fov,reslution,u

if ~exist('reslution','var')
    reslution = [1024;1024];
end
reslutionStr = sprintf('%d ',reslution);
answer = inputdlg({ 'Tcb_c:����ϵ�����ϵƽ��ʸ��(m)','�������װ��(���� ��� ƫ��)��','resolution ratio','B:���߾���/mm',...
                    'om:���������������İ�װ�Ƕ�/��','fov[ˮƽ ��ֱ]/��(������һ��Ϊ0����ʾ�������ӳ���)               .'},...
                    '��������궨�������޻��䣩',1,{'0.2 1.2 -0.8','0 0 0',reslutionStr,'200','0 0 0','0 45',});
                
str = sprintf('Tcb_c:����ϵ�����ϵƽ��ʸ��(m) = %s\n',answer{1});                
str = sprintf('%s �������װ��(���� ��� ƫ��)�� = %s\n',str,answer{2});    
str = sprintf('%s resolution ratio = %s\n',str,answer{3});  
str = sprintf('%s B:���߾���/mm = %s\n',str,answer{4});  
str = sprintf('%s om:���������������İ�װ�Ƕ�/�� = %s \n',str,answer{5});  
str = sprintf('%s fov[ˮƽ ��ֱ]/��(������һ��Ϊ0����ʾ�������ӳ���) = %s\n',str,answer{6});  

Tcb_c = sscanf(answer{1},'%f');
cameraSettingAngle = sscanf(answer{2},'%f')*pi/180'; 
reslution = sscanf(answer{3},'%f');
B = sscanf(answer{4},'%f');
om = sscanf(answer{5},'%f')*pi/180';
fov = sscanf(answer{6},'%f')';

T = [-B;0;0];   % ע�⸺��
if fov(1)*fov(2)~=0
   errordlg('fov ������һ��Ϊ0����ʾ����'); 
end
if fov(1)==0
   %% ���� ��ֱ�ӳ��� -> ˮƽ�ӳ���
%     fov(2,1) = 35 ; 
    % ���㽹��
    fc_left(2,1) = reslution(2)/2/tan(fov(2)/2*pi/180);
    fc_left(1,1) = fc_left(2,1) ;
    fov(1) = atan(reslution(1)/2/fc_left(1))*180/pi*2;
    fc_right = fc_left ;
else
    %% ���� ˮƽ�ӳ��� -> ��ֱ�ӳ���
%     fov(1,1) = 45 ;  % ˮƽ������ӳ��� ����ֱ������ӳ�����ͨ�� fov �ͷֱ��ʽ��������
%     % ���㽹��
    fc_left(1,1) = reslution(1)/2/tan(fov(1)/2*pi/180);
    fc_left(2,1) = fc_left(1,1) ;
    fov(2) = atan(reslution(2)/2/fc_left(1))*180/pi*2;
    fc_right = fc_left ;
end

%% 
cc_left = reslution/2 ;
cc_right = reslution/2 ;

kc_left = [0;0;0;0;0];
kc_right = [0;0;0;0;0];

alpha_c_left = 0;
alpha_c_right = 0;


%���
calibData.om = om;  % mm
calibData.T = T;
calibData.fc_left = fc_left;
calibData.fc_right = fc_right;
calibData.cc_left = cc_left;
calibData.cc_right = cc_right;
calibData.kc_left = kc_left;
calibData.kc_right = kc_right;
calibData.alpha_c_left = alpha_c_left;
calibData.alpha_c_right = alpha_c_right;
calibData.fov = fov;
calibData.cameraSettingAngle = cameraSettingAngle ;
calibData.Tcb_c = Tcb_c ;
calibData.str = str ;

save('SceneVisualCalib_data','om','T','fc_left','cc_left','kc_left','alpha_c_left','fc_right','cc_right','kc_right','alpha_c_right','fov','cameraSettingAngle')

disp('���ɲ����� �Ӿ���������궨���ݳɹ� SceneVisualCalib_data.mat')
% 
% om=om'
% T=T'
% fc_left=fc_left'
% fc_right=fc_right'
% cc_left=cc_left'
% cc_right=cc_right'
% kc_left=kc_left'
% kc_right=kc_right'
% alpha_c_left=alpha_c_left'
% alpha_c_right=alpha_c_right'
% fov=fov'
