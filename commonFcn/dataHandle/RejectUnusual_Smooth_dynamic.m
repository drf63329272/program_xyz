%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           xyz
%                        2014.3.2
%              �޳���̬���ݵ��쳣��������������ƽ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ����
% old_data��ԭʼ���ݡ�spanTime��ƽ���������ȡ�maxAbsError���������ޣ���λ����������һ�£�
%% ���
% real_data���޳��쳣������ݣ�smooth_data���޳��쳣���ٽ���ƽ��������ݣ�std_str���������ݵ�
% Ϊ�˼򻯴����޳���Ұֵ����ԭλ�÷������֮������ݴ���
function [smooth_data,real_data] = RejectUnusual_Smooth_dynamic( old_data,spanTime,maxAbsError )
%% ˼·��
%��1����������С��������ƽ��
%��2����ƽ�����ֵΪ׼ȷֵ��ɾȥԶ��׼ȷֵ���� maxAbsError ������
%��3���ٴζ�ȥ���쳣�����ݽ�����С��������ƽ��
format long
%% ��1��һ��ƽ��
span = spanTime*100 ;
smooth_data = zeros(size(old_data));
tic
smooth_data(1,:) = smooth(old_data(1,:),span,'rlowess');
sprintf('��һ��ƽ������ĵ�1�н�����%0.2f  min\n',toc/60)
smooth_data(2,:) = smooth(old_data(2,:),span,'rlowess');
sprintf('��һ��ƽ������ĵ�2�н�����%0.2f  min\n',toc/60)
smooth_data(3,:) = smooth(old_data(3,:),span,'rlowess');
sprintf('��һ��ƽ������ĵ�3�н�����%0.2f  min\n',toc/60)
%% ��2��ȥ���쳣
    %% ��һ��
L = length(old_data);
first_maxAbsError = maxAbsError ;
errorNum = 0;
for k=1:L
    error = abs(smooth_data(:,k)-old_data(:,k));
    compare = error>first_maxAbsError ;
    if sum(compare)>0
       % old_data(:,k)�д������޵�����
       errorNum = errorNum+1 ;
       old_data(:,k) =  smooth_data(:,k);    
    end    
end
sprintf('ɾ���쳣���ݸ�����%d(%0.2f%%)  min\n',errorNum,errorNum/L*100)
real_data = old_data ;
%% ���޳��쳣������ݽ���ƽ��
span = spanTime*100 ;
smooth_data = zeros(size(old_data));
smooth_data(1,:) = smooth(old_data(1,:),span,'rlowess');
sprintf('�ڶ��Σ��޳���ƽ������ĵ�1�н�����%0.2f  min\n',toc/60)
smooth_data(2,:) = smooth(old_data(2,:),span,'rlowess');
sprintf('�ڶ��Σ��޳���ƽ������ĵ�2�н�����%0.2f  min\n',toc/60)
smooth_data(3,:) = smooth(old_data(3,:),span,'rlowess');
sprintf('�ڶ��Σ��޳���ƽ������ĵ�3�н�����%0.2f  min\n',toc/60)
