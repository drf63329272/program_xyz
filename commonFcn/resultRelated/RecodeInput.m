%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                             xyz
%                           2014.3.7
%                          ��¼�������ݵ�txt�ļ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function RecodeInput (fid,visualInputData,imuInputData,trueTrace)

fprintf(fid,'%s','       ʵ��ʼ�\n');

%% ��¼�������
% �켣������
if isfield(trueTrace,'traceRecord')
    fprintf(fid,'���ù켣���������ɹ켣\n%s\n\n',trueTrace.traceRecord) ;
end
if isfield(trueTrace,'InitialPositionError')
    str1 = sprintf('%0.4f  ',trueTrace.InitialPositionError) ;
    str2 = sprintf('%0.4f  ',trueTrace.InitialAttitudeError) ;
    str3 = sprintf('%0.4f  ',trueTrace.InitialAttitudeError * 180/pi*3600) ;
    fprintf(fid,'��ʼλ����%s m\n��ʼ��̬��%s rad\n��ʼ��̬��%s ��\n\n',str1,str2,str3);
else
    fprintf(fid,'�޳�ʼλ�á���̬���\n\n');
end
% �Ӿ���Ϣ
if ~isempty(visualInputData)
    fprintf(fid,'�Ӿ���ϢƵ�ʣ�%0.3f\n',visualInputData.frequency);
    calibData=visualInputData.calibData ;
    
    % �������Գ���λ��
    if isfield(calibData,'Tcb_c')
        str_Tcb_c = sprintf('%0.3g ',calibData.Tcb_c);
        fprintf(fid,'�������Գ���λ��(Tcb_c)��%s m',str_Tcb_c);
        if isfield(calibData,'Tcb_c_error') && isfield(calibData,'isEnableCalibError') &&    calibData.isEnableCalibError == 1  
            str_Tcb_c_error = sprintf('%0.3g ',calibData.Tcb_c_error );
            fprintf(fid,'\t  ��%s m\n',str_Tcb_c_error);
        else
            fprintf(fid,'\n');
        end
    end
    % �������Գ��尲װ��     
    if isfield(calibData,'cameraSettingAngle')
        str_cameraSettingAngle = sprintf('%0.3g ',calibData.cameraSettingAngle*180/pi);
        fprintf(fid,'�������Գ��尲װ�ǣ�%s ��',str_cameraSettingAngle);
        if isfield(calibData,'cameraSettingAngle_error') && isfield(calibData,'isEnableCalibError') &&    calibData.isEnableCalibError == 1  
            str_cameraSettingAngle_error = sprintf('%0.3g ',calibData.cameraSettingAngle_error*180/pi);
            fprintf(fid,'\t  ��%s ��\n',str_cameraSettingAngle_error);
        else
            fprintf(fid,'\n');
        end
    end
    % �������������λ��
    str_T = sprintf('%0.3g ',calibData.T);
    fprintf(fid,'��ʵ�������������λ��(T)��%s mm',str_T);
    if isfield(calibData,'T_error') && isfield(calibData,'isEnableCalibError') &&    calibData.isEnableCalibError == 1  
        T_error=calibData.T_error;
        str_T_error = sprintf('%0.3g ',T_error);
        fprintf(fid,'\t ��%s mm\n',str_T_error);
    else
        fprintf(fid,'\n');
    end
    % ���������������װ��
    str_om = sprintf('%0.3g ',calibData.om*180/pi);
    fprintf(fid,'��ʵ���������������װ��(om)��%s ��',str_om);
    if isfield(calibData,'om_error') && isfield(calibData,'isEnableCalibError') &&    calibData.isEnableCalibError == 1  
        om_error=calibData.om_error;
        str_om_error = sprintf('%0.3g ',om_error*180/pi);
        fprintf(fid,'\t ��%s ��\n',str_om_error);
    else
        fprintf(fid,'\n');
    end
    % ���� calibData.fc_left
    str_fc_left = sprintf('%0.3g ',calibData.fc_left);
    fprintf(fid,'��ʵ�󽹾�(fc_left)��%s ����',str_fc_left);
    if isfield(calibData,'fc_left_error') && isfield(calibData,'isEnableCalibError') &&    calibData.isEnableCalibError == 1  
        fc_left_error=calibData.fc_left_error;
        str_fc_left_error = sprintf('%0.3g ',fc_left_error);
        fprintf(fid,'\t ��%s ����\n',str_fc_left_error);
    else
        fprintf(fid,'\n');
    end
    
    % û�����
    if ~isfield(calibData,'isEnableCalibError') ||   calibData.isEnableCalibError == 0
        fprintf(fid,'\n\t ˫Ŀ�Ӿ�����ϵͳ�����\n');
    end
     
    if isfield(visualInputData,'RTError')
        textStr =  'ֱ�ӷ�������RT������ΪRT��������ӵ�������\n';
      %  str = num2str(visualInputData.RTError.TbbErrorMean);
        str = sprintf('%0.3g ',visualInputData.RTError.TbbErrorMean);
        textStr = [textStr  'TbbError��ֵ��'  str  ' (m)\n'];
 %       str = num2str(visualInputData.RTError.TbbErrorStd);
        str = sprintf('%0.3g ',visualInputData.RTError.TbbErrorStd);
        textStr = [textStr   'TbbError��׼�'   str   '(m)\n'];

    %    str1 = num2str(visualInputData.RTError.AngleErrorMean);
        str1 = sprintf('%0.3g ',visualInputData.RTError.AngleErrorMean);
   %     str2 = num2str(visualInputData.RTError.AngleErrorMean*180/pi*3600);
        str2 = sprintf('%0.3g ',visualInputData.RTError.AngleErrorMean*180/pi*3600);
        textStr = [textStr   'AngleError��ֵ��'   str1 ,'(rad)  ', str2,  '(��)\n'];
     %   str1 = num2str(visualInputData.RTError.AngleErrorStd);
        str1 = sprintf('%0.3g ',visualInputData.RTError.AngleErrorStd);
   %     str2 = num2str(visualInputData.RTError.AngleErrorStd*180/pi*3600);
        str2 = sprintf('%0.3g ',visualInputData.RTError.AngleErrorStd*180/pi*3600);
        textStr = [textStr  'AngleError��׼�'   str1 ,'(rad)  ', str2,  '(��)\n'];

        fprintf(fid,textStr);
    end
end
% �ߵ���Ϣ
planet = trueTrace.planet ;
if strcmp(planet,'m')
    moonConst = getMoonConst;   % �õ�������
    gp = moonConst.g0 ;     % ���ڵ�������
    wip = moonConst.wim ;
    fprintf(fid,'\n�ߵ���Ϣ(����)\n');
else
    earthConst = getEarthConst;   % �õ�������
    gp = earthConst.g0 ;     % ���ڵ�������
    wip = earthConst.wie ;
    fprintf(fid,'\n�ߵ���Ϣ������\n');
end
if ~isempty(imuInputData)
    fprintf(fid,'�ߵ���ϢƵ�ʣ�%0.1f\n',imuInputData.frequency);
    if isfield(imuInputData,'pa')    
        pa = imuInputData.pa/(gp*1e-6);
        fprintf(fid,'�ӼƳ�ֵƫ�ã�(%g,%g,%g) (ug)\n',pa(1),pa(2),pa(3));
        na = imuInputData.na/(gp*1e-6);
        fprintf(fid,'�Ӽ����Ư�ƣ�(%g,%g,%g) (ug)\n',na(1),na(2),na(3));
        pg = imuInputData.pg*180/pi*3600;
        fprintf(fid,'���ݳ�ֵƫ�ã�(%g,%g,%g) (��/h)\n',pg(1),pg(2),pg(3));
        ng = imuInputData.ng*180/pi*3600;
        fprintf(fid,'�������Ư�ƣ�(%g,%g,%g) (��/h)\n',ng(1),ng(2),ng(3));
    end
end
