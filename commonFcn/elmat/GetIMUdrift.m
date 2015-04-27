% buaa xyz 2014.1.14

% �� imuInputData �еõ� imu ��ֵ�����Ư��

% ���룺imuInputData����ʽ���ۺϳ���˵���ĵ���
% �����
%       pa:�ӼƳ�ֵƯ��
%       na:�Ӽ����Ư��
%       pg:���ݳ�ֵƯ��
%       ng:�������Ư��

function [pa,na,pg,ng,imuInputData,gp] = GetIMUdrift( imuInputData,planet )
% ����ʱ������֪���洢��imuInputData�У�ʵ��ʱ����δ֪���ֶ����� ��ֵƫ�� �� �����׼��
format long
if ~isfield(imuInputData,'flag')    
   if  isfield(imuInputData,'f_noise')  
       imuInputData.flag = 'sim';
   else
       imuInputData.flag = 'exp';
   end
end
if strcmp(imuInputData.flag,'sim')
    disp('���棺imuInputData�а���������Ա��P��Q���ֵ��f_noise��wib_noiseȷ��') 
    if ~isfield(imuInputData,'pg')  % ��δ������������
        % ��ֵ����
        imuInputData.pa = mean(imuInputData.f_noise,2);      % imuInputData.f_noise [3*n]
        imuInputData.pg = mean(imuInputData.wib_noise,2);
        % �����׼��
        imuInputData.na = std(imuInputData.f_noise,0,2);
        imuInputData.ng = std(imuInputData.wib_nois,0,2);
    end
    
else
    disp('ʵ�飺imuInputData�в�����������Ա��P��Q���ֵ���ֶ��������������ֵȷ��') 
    if strcmp(planet,'m')
        dlg_title = '����-IMU���鳣ֵƯ�ƴ�С';
        moonConst = getMoonConst;   % �õ�������
        gp = moonConst.g0 ;     % ���ڵ�������
    else
        dlg_title = '����-IMU���鳣ֵƯ�ƴ�С';
        earthConst = getEarthConst;   % �õ�������
        gp = earthConst.g0 ;     % ���ڵ�������
    end

    prompt = {'�ӼƳ�ֵ����:  (ug)   ','�Ӽ����������׼��: (ug)       .','���ݳ�ֵ����: (��/h)   ','�������������׼��: (��/h)  '};
    num_lines = 1;
   % def = {'50 50 50','30 30 30','5 5 5','3 3 3'};
    def = {'200 200 200','100 100 100','7 7 7','6 6 6'};
    % def = {'10 10 10','10 10 10','0.1 0.1 0.1','0.1 0.1 0.1'};
    %def = {'1','1','0.01','0.01'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    constNoise_f = sscanf(answer{1},'%f')*1e-6*gp ;   % �ӼƳ�ֵƫ��
    sigmaNoise_f = sscanf(answer{2},'%f')*1e-6*gp ;   % �Ӽ������ı�׼��
    constNoise_wib = sscanf(answer{3},'%f')*pi/180/3600 ; % ���ݳ�ֵƫ��
    sigmaNoise_wib = sscanf(answer{4},'%f')*pi/180/3600 ; % ���������ı�׼��

    imuInputData.pa = constNoise_f ;
    imuInputData.na = sigmaNoise_f ;
    imuInputData.pg = constNoise_wib ;
    imuInputData.ng = sigmaNoise_wib ;
end
% ��ֵ����
pg = imuInputData.pg ;
pa = imuInputData.pa ;
% �����׼��
ng = imuInputData.ng ;
na = imuInputData.na ;

