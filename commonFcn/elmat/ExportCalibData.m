%% ��  calibData ��ȡ12���궨����
%       buaaxyz

%   Tcb_c:����ϵ�����ϵƽ��ʸ��(m)
%   Rbc:�����������ϵ������ϵ��ת����
%   cameraSettingAngle���������Ա���ϵ��װ��(���� ��� ƫ��) rad
%   om���������������İ�װ�Ƕ� (���� ��� ƫ��) rad
%   T �� ��������������ƽ��ʸ�� = ���������ϵ���������λ�� =��ƽ��˫Ŀʱ�� [-B 0 0] ��BΪ���ߣ�  m
%   cc_left,cc_right�� ����������������꣨���أ�
%   fc_left,fc_right�� ����������� �����أ�
%   ��������� alpha_c_left,alpha_c_right,kc_left,kc_right
function [ Rbc,Tcb_c,T,alpha_c_left,alpha_c_right,cc_left,cc_right,fc_left,fc_right,kc_left,kc_right,om,calibData ] = ExportCalibData( calibData )

T = calibData.T;  % mmΪ��λ���д洢
alpha_c_left = calibData.alpha_c_left;
alpha_c_right = calibData.alpha_c_right;
cc_left = calibData.cc_left;
cc_right = calibData.cc_right;
fc_left = calibData.fc_left;
fc_right = calibData.fc_right;
kc_left = calibData.kc_left;
kc_right = calibData.kc_right;
om = calibData.om;

if ~isfield(calibData,'cameraSettingAngle')
    answer = inputdlg({'�����װ�ǡ�'},'���� ��� ƫ�� ',1,{'0 0 0'});
    cameraSettingAngle = sscanf(answer{1},'%f')'*pi/180;  
    calibData.cameraSettingAngle = cameraSettingAngle ;
else
    cameraSettingAngle = calibData.cameraSettingAngle ;
end

if ~isfield(calibData,'Tcb_c')
    calibData.Tcb_c = [0;0;0] ;
    disp('û��Tcb_c��ȡ0');
end
Tcb_c = calibData.Tcb_c ;
if ~isfield(calibData,'Tcb_c_error')
    calibData.Tcb_c_error = [0;0;0] ;
    disp('Tcb_c_error��ȡ0');
end
if ~isfield(calibData,'Rbc')
   if isfield(calibData,'isEnableCalibError')
        if  calibData.isEnableCalibError==1
            disp('˫Ŀ�Ӿ�����');
            T =  T+calibData.T_error ;
            om = om+calibData.om_error ;
            cameraSettingAngle = cameraSettingAngle+calibData.cameraSettingAngle_error ;
            Tcb_c = Tcb_c + calibData.Tcb_c_error ;
        end
    end

    Cbb1 = FCbn(cameraSettingAngle)';   % cameraSettingAngle �Ǵ�bϵ��c(�м�)ϵ��ת����
    Cb1c = [1, 0, 0;     % ����ϵ�����������ϵ:��x��ת��-90��
           0, 0,-1;     % ���������ϵc�� x��y�����ƽ�棬y���£�x���ң�z��ǰ
           0, 1, 0];    % ����ϵb��x���ң�y��ǰ��z����
    Rbc = Cb1c*Cbb1 ;
    calibData.Rbc = Rbc ;
else
    Rbc = calibData.Rbc ;
end