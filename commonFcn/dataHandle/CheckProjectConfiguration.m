%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ʼ���ڣ�2013.12.3
% ���ߣ�xyz
% ���ܣ����������ò��������ò�ȫʱ������ʾ�����½�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function projectConfiguration = CheckProjectConfiguration(projectConfiguration)

%% ��� isUpdateVisualData
if(~isfield(projectConfiguration,'isUpdateVisualData'))
    % ���Ƿ�������ã�ʵʱ����
    choice = menu({'δ�����Ƿ�����Ӿ���Ϣ';'�Ƿ�����Ӿ�������Ϣ��'},'��','��');
    if choice~=0
        if(choice==1)
            projectConfiguration.isUpdateVisualData = 1;    % ��
        else
            projectConfiguration.isUpdateVisualData = 0;    % ��
        end
    end
end
%% ��� visualDataSource
    if(~isfield(projectConfiguration,'visualDataSource'))
        % �Ӿ���ʵ��/����
        choice = menu({'�Ӿ���ϢԴ����Ϊ��';'����������'},'ʵ��','����');
        if choice~=0
            if(choice==1)
                projectConfiguration.visualDataSource = 'e';    % ʵ��
            else
                projectConfiguration.visualDataSource = 's';    % ����
            end
        end
    end
%% ��� isUpdateIMUData
if(~isfield(projectConfiguration,'isUpdateIMUData'))
    % ���Ƿ�������ã�ʵʱ����
    choice = menu({'δ�����Ƿ����IMU����';'�Ƿ����IMU���ݣ�'},'��','��');
    if choice~=0
        if(choice==1)
            projectConfiguration.isUpdateIMUData = 1;    % ��
        else
            projectConfiguration.isUpdateIMUData = 0;    % ��
        end
    end
end
%% ��� imuDataSource
if(~isfield(projectConfiguration,'imuDataSource'))
    % ���ùߵ�ʵ�黹�Ƿ���
    choice = menu({'δ����IMU����Դ';'����������'},'ʵ��','����');
    if choice~=0
        if(choice==1)
            projectConfiguration.imuDataSource = 'e';    % ʵ��
        else
            projectConfiguration.imuDataSource = 's';    % ����
        end
    end
end

%% isKnowTrueTrace
if(~isfield(projectConfiguration,'isKnowTrueTrace'))
    % ���Ƿ�������ã�ʵʱ����
    choice = menu({'δ�����Ƿ���֪��ʵ�켣';'�Ƿ���֪trueTrace��'},'��','��');
    if choice~=0
        if(choice==1)
            projectConfiguration.isKnowTrueTrace = 1;    % ��
        else
            projectConfiguration.isKnowTrueTrace = 0;    % ��
        end
    end
end
%% if projectConfiguration.isKnowTrueTrace==1
    % ��� isUpdateTrueTrace
    if(~isfield(projectConfiguration,'isUpdateTrueTrace'))
        % ���Ƿ�������ã�ʵʱ����
        choice = menu({'δ�����Ƿ������ʵ�켣����trueTrace';'�Ƿ����trueTrace��'},'��','��');
        if choice~=0
            if(choice==1)
                projectConfiguration.isUpdateTrueTrace = 1;    % ��
            else
                projectConfiguration.isUpdateTrueTrace = 0;    % ��
            end
        end
    end
% else
%     if isfield(projectConfiguration,'isUpdateTrueTrace')
%         projectConfiguration = rmfield(projectConfiguration,'isUpdateTrueTrace');
%     end
% end
%% isTrueX0
% if(~isfield(projectConfiguration,'isTrueX0'))
    % �Ƿ����׼ȷ�ĳ�ʼ״̬
  %  choice = menu({'�Ƿ����׼ȷ�ĳ�ʼ״̬';'�Ƿ����׼ȷ�ĳ�ʼ״̬�����߲���0��ʼ״̬��'},'׼ȷX0','���ݼӼ�Ư��0��ֵ');
    choice = 2;
    if choice~=0
        if(choice==1)
            projectConfiguration.isTrueX0 = 1;    % ��
        else
            projectConfiguration.isTrueX0 = 0;    % ��
        end
    end
% end