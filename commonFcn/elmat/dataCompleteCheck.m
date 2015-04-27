%% ���������Լ��

function data = dataCompleteCheck(dataStyle,data)

switch dataStyle
    case 'visualInputData'
        visualInputData = data ;
        if ~isfield(visualInputData,'frequency')
            answer = inputdlg('�Ӿ���ϢƵ��');
            visualInputData.frequency = str2double(answer);
        end
        if ~isfield(visualInputData,'calibData')
            visualInputData.calibData = loadCalibData() ;
        end
        data = visualInputData ;
end




function calibData = loadCalibData()
% ѡ���Ƿ��������궨��������ӣ��������ʵʵ��ɼ�������أ�������Ӿ�����ɼ�������㡣
global projectDataPath
button =  questdlg('����ͼƬ��ȡ�ķ���ѡ��','��ӱ궨����','�Ӿ����棺����궨����','��ʵʵ�飺����궨�����ļ�','�����','�Ӿ����棺����궨����') ;
if strcmp(button,'�Ӿ����棺����궨����')
    calibData = GetCalibData() ;
end
if strcmp(button,'��ʵʵ�飺����궨�����ļ�')
    if isempty(projectDataPath) % �������д˺���ʱ
        calibDataPath = pwd; 
    else
        calibDataPath = [GetUpperPath(projectDataPath),'\����궨����'];   % Ĭ������궨����·��
    end
    [cameraCalibName,cameraCalibPath] = uigetfile('.mat','ѡ������궨����',[calibDataPath,'\*.mat']);
    calibData = importdata([cameraCalibPath,cameraCalibName]); 
end