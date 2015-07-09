%% ���� otherMakers(k).ContinuesLasti ����ʱ�̵������߶ν�����������
%% ���� �ٶ� ���ٶ� ���β��� ��
% ContinuesLasti ��ǰʱ�� ������˵� ��Ӧ�� ��ʱ����˵����
function [ otherMakersContinues_New,A_k_waves_OKLast_All_New ] = ReOrderContinues( ContinuesLasti,otherMakersContinues,A_k_waves_OKLast_All ) 
%% ����Ҫ����
otherMakersN_Last = otherMakersContinues.otherMakersN;
otherMakersN_new = length(ContinuesLasti);

if   otherMakersN_Last==otherMakersN_new
    if otherMakersN_Last == 0 
        otherMakersContinues_New = otherMakersContinues; % ����Ҫ����
        A_k_waves_OKLast_All_New = A_k_waves_OKLast_All;
        return;
    end

    err = sum(abs(ContinuesLasti - (1:otherMakersN_Last)));
    if err == 0
        otherMakersContinues_New = otherMakersContinues; % ����Ҫ����
        A_k_waves_OKLast_All_New = A_k_waves_OKLast_All;
        return;
    end
end

%% ��Ҫ����
visualN = size(otherMakersContinues.data1,2);
otherMakersContinues_New = Initial_otherMakersContinues( visualN );

otherMakersContinues_New.otherMakersN = otherMakersN_new;
A_k_waves_OKLast_All_New = zeros(3,20);

for i=1:otherMakersN_new
    if ~isnan(ContinuesLasti(i)) && ContinuesLasti(i)>0    % otherMakersContinues ��ֵ     
        otherMakersContinues_New.dataN(:,i) = otherMakersContinues.dataN(:,ContinuesLasti(i));
        
        data_i = Read_otherMakersContinues_i( otherMakersContinues,ContinuesLasti(i) );
        otherMakersContinues_New = Write_otherMakersContinues_i( otherMakersContinues_New,i,data_i,0,Inf ); % ���һ��������Ч
        
        A_k_waves_OKLast_All_New(:,i) = A_k_waves_OKLast_All(:,ContinuesLasti(i));
    else
        otherMakersContinues_New.dataN(i) = 0;
        A_k_waves_OKLast_All_New(:,i) = zeros(3,1);
    end
end