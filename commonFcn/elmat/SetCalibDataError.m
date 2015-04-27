%   Ϊ�Ӿ������趨����궨���� ���
%       buaa xyz 2014.7.17
%       nuaaxuyognzhi@yeah.net

function calibData = SetCalibDataError(calibData)


%% ���˫Ŀ�Ӿ�ϵͳ���
%             ����      Tcb_c_error    cameraSettingAngle_true     T_error           om_error       Flag
default_N1 = {'1','[ 1 -1 -1 ]/1000*5',  '[1 -1 1]*0.2',   '[1 1 -1]*0.1',   '[-1 1 -1]*0.02','����N1'} ; % �������װ������
default_N2 = {'1','[ -1 1 1 ]/1000*1',  '[1 -1 -1]*0.1',   '[1 -1 -1]*0.5',   '[1 -1 1]*0.1','����N2'} ; % ˫Ŀ���������
default_N3 = {'1','[ -1 1 1 ]/1000*5',  '[1 1 -1]*0.5',   '[1 -1 -1]*0',   '[1 -1 1]*0','����N3'} ;       % ���������װ���
default_N4 = {'1','[ 1 -1 -1 ]/1000*0',  '[1 -1 1]*0',   '[1 1 -1]*2',   '[-1 1 -1]*0.3','����N4'} ; % ��˫Ŀ������
default_N5 = {'1','[ 1 -1 -1 ]/1000*5',  '[1 -1 1]*0.5',   '[1 1 -1]*2',   '[-1 1 -1]*0.3','����N5'} ;

default_M1 = {'1','[ -1 1 1 ]/1000*7',  '[1 1 -1]*1',   '[1 -1 -1]*0',   '[1 -1 1]*0','����M1'} ;       % ���������װ���
default_M2 = {'1','[ 1 -1 -1 ]/1000*0',  '[1 -1 1]*0',   '[1 1 -1]*2',   '[-1 1 -1]*1','����M2'} ;      %��˫Ŀ������
default_M3 = {'1','[ 1 -1 -1 ]/1000*7',  '[1 -1 1]*1',   '[1 1 -1]*2',   '[-1 1 -1]*1','����M3'} ;
default_M4 = {'1','[ 1 -1 1 ]/1000*7',  '[1 -1 -1]*1',   '[1 -1 -1]*2',   '[1 1 1]*2','����M4'} ;
default_M5 = {'1','[ 1 -1 1 ]/1000*0',  '[1 -1 -1]*0',   '[1 -1 -1]*0',   '[1 1 1]*5','����M5'} ;

answer = inputdlg({'����˫Ŀ�Ӿ�ϵͳ���','Tcb_c_error��������������ƽ��ʸ�����(m)','�������װ�� ��� (���� ��� ƫ��)��(cameraSettingAngle_true)',...
    '����������λ����T_error��/mm','���������������װ��(om_error)/��','�������'},'˫Ŀ�Ӿ�ϵͳ�������',1,default_N5);
 
isEnableCalibError = str2double(answer{1}) ;
Tcb_c_error = eval(answer{2}) ;
cameraSettingAngle_error = eval(answer{3})*pi/180;
T_error = -eval(answer{4});
om_error = eval(answer{5})*pi/180;
calibErrorFlag = answer{6} ;

calibData.isEnableCalibError = isEnableCalibError ;
calibData.Tcb_c_error = Tcb_c_error' ;
calibData.cameraSettingAngle_error = cameraSettingAngle_error' ;
calibData.T_error = T_error' ;
calibData.om_error = om_error' ;
calibData.calibErrorFlag = calibErrorFlag ;

