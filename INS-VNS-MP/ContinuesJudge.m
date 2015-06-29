%% xyz

%% ��˵��������ж�
% dPi_ConJudge �� �������ж�ָ��Ĵ�С��ǰ����֡��λ��ģ
% ContinuesFlag = 0   ������
%               =1    ��������������ٳɹ���˵�����
%               =2   �������͸���ʧ�ܵĵ�����
function [ otherMakers_k,dPi_ConJudgeOut ] = ContinuesJudge( otherMakers_k,otherMakers_k_last,trackedMakerPosition,...
    k_vision,makerTrackThreshold )


% ǰһʱ�̸��ٳɹ�ʱ��������ǰ���Ƿ���Ը��ٳɹ��ĵ�������  Continues = 1
% ǰһʱ�̸���ʧ��ʱ��������ǰÿ�����Ƿ�Ϊ������Ľ��,�Ҽ�¼�Ÿ�������������ǰ���磨��������dT���ĵ��λ�ú�ʱ�䡣
%        Continues = 2 ��

% global inertialFre visionFre  moveDistance
% ��¼ÿ����˵����������
MaxOtherMarkerBufN = size(otherMakers_k.ContinuesFlag,2);
M = otherMakers_k.otherMakersN ;
otherMakers_k.ContinuesFlag = zeros(1,MaxOtherMarkerBufN) ; % ������
otherMakers_k.ContinuesLastPosition = NaN(3,MaxOtherMarkerBufN) ;
otherMakers_k.ContinuesLastTime = NaN(1,MaxOtherMarkerBufN) ;
otherMakersPosition_k = otherMakers_k.Position ;  

dPi_ConJudgeOut=nan;
dPi_ConJudge = nan(1,M);

if k_vision>1 
    trackedMakerPosition_kLast = trackedMakerPosition(:,k_vision-1) ;
    last_Tracked_i =  GetTrackedi( trackedMakerPosition_kLast,otherMakers_k_last );  % ��һʱ�̸��ٳɹ��ĵ�����
    
%     if ~isnan(trackedMakerPosition(1,k_vision-1))
%         %% ֻ�жϵ�ǰ��˵��Ƿ���ǰʱ�̸��ٳɹ�����˵�����
%         trackedMakerPosition_kLast = trackedMakerPosition(:,k_vision-1) ;
%         otherMakersPosition_k_Dis = otherMakersPosition_k(:,1:M)-repmat(trackedMakerPosition_kLast,1,M) ;
%         otherMakersPosition_k_Dis_Norm = zeros(1,M);
%         for j=1:M
%             otherMakersPosition_k_Dis_Norm(j) = normest(otherMakersPosition_k_Dis(:,j));
%         end
%         [dPi_ConJudge,minCon_k] = min(otherMakersPosition_k_Dis_Norm);  
%         if dPi_ConJudge < makerTrackThreshold.MaxContinuesDisplacement
%     %         trackedMakerPosition_k_OK = otherMakersPosition_k(:,m) ;
%     %         TrackFlag = 1;
%     %         fprintf('��˵�������λ��=%0.4f������OK \n',Min_otherMakersPosition_k_Dis_Norm);
%             
%             otherMakers_k.ContinuesFlag(minCon_k) = 1 ; % ��������������ٳɹ���˵�����
%             otherMakers_k.ContinuesLastPosition(:,minCon_k) = trackedMakerPosition_kLast ;
%             otherMakers_k.ContinuesLastTime(minCon_k) = otherMakers_k_last.time ;
%             otherMakers_k.ContinuesLastK(minCon_k) = k_vision-1 ;
%             otherMakers_k.ContinuesLasti(minCon_k) = lastTrackedi;  % ��¼���ڵ���һʱ����˵����
%         else
%             
%         end
%         
%     else
        %% �жϵ�ǰ��˵��Ƿ�Ϊ������˵㣬��¼ÿ�����Ӧ�����磨��������dT��������
        M_last = otherMakers_k_last.otherMakersN ;
        if M_last==0
            % ��ʱ������˵�
            for i=1:M
                otherMakers_k.ContinuesFlag(i) = 0 ; % ������
                otherMakers_k.ContinuesLastPosition(:,i) = NaN ;
                otherMakers_k.ContinuesLastTime(i) = NaN ;
                otherMakers_k.ContinuesLastK(i) = NaN ;
                otherMakers_k.ContinuesLasti(i) = NaN;  % ��¼���ڵ���һʱ����˵����
            end
            dPi_ConJudgeOut=nan;
            return;
        end
        % һ���� M*M_last �����
        for i=1:M
            % ���ڵ�i���� �� ��һʱ��ÿ�������
            dPi = repmat(otherMakers_k.Position( :,i ),1,M_last)- otherMakers_k_last.Position(:,1:M_last) ;
            dPiNorm = zeros(1,M_last);
            for j=1:M_last
                dPiNorm(j) = normest(dPi(:,j));
            end
            
            [dPi_ConJudge(i),min_last_i] = min(dPiNorm);     % min_last_i Ϊ��ǰ���Ӧ��������һʱ�̵�����
            if normest(dPi_ConJudge(i)) < makerTrackThreshold.MaxContinuesDisplacement
                %  otherMakers_k.Position( :,i ) �� otherMakers_k_last.Position(:,min_last_i) ����
                % �ҵ�һ�������ĵ㣬��¼��һ��
                if ~isnan(last_Tracked_i) && last_Tracked_i==min_last_i
                    otherMakers_k.ContinuesFlag(i) = 1 ; % �͸��ٳɹ��ĵ�����
                else
                    otherMakers_k.ContinuesFlag(i) = 2 ; % �͸���ʧ�ܵĵ�����
                end
                
                otherMakers_k.ContinuesLasti(i) = min_last_i;  % ��¼���ڵ���һʱ����˵����
                % ���ǰһ����Ϊ�����㣬��ǰһ�����������¼���ݹ���
                if otherMakers_k_last.ContinuesFlag(min_last_i) == 2
                    
                    otherMakers_k.ContinuesLastK(i) = otherMakers_k_last.ContinuesLastK(min_last_i) ; % ���ݼ�¼��һ��ʱ�̴洢��������Ϣ
                    otherMakers_k.ContinuesLastPosition(:,i) = otherMakers_k_last.ContinuesLastPosition(:,min_last_i) ;
                    otherMakers_k.ContinuesLastTime(i) = otherMakers_k_last.ContinuesLastTime(min_last_i);
                elseif otherMakers_k_last.ContinuesFlag(min_last_i) == 0 || isnan(otherMakers_k_last.ContinuesFlag(min_last_i))
                    otherMakers_k.ContinuesLastK(i) = k_vision-1 ; % ֱ�Ӽ�¼��һ��ʱ��
                    otherMakers_k.ContinuesLastPosition(:,i) = otherMakers_k_last.Position( :,min_last_i ) ;
                    otherMakers_k.ContinuesLastTime(i) = otherMakers_k_last.time ;                    
                elseif otherMakers_k_last.ContinuesFlag(min_last_i) == 1 
                    % ����ٳɹ����������ɹ���������ʶ��ʧ�ܵ���������ݵ����ڡ��������ʱ�䳬��2�룬���ٴ��ݡ�
                    if (otherMakers_k_last.ContinuesLastTime(min_last_i)-otherMakers_k.time) > 20
                        otherMakers_k.ContinuesFlag(i) = 2 ;
                    else
                        otherMakers_k.ContinuesFlag(i) = 1 ;
                    end                    
                    otherMakers_k.ContinuesLastK(i) = otherMakers_k_last.ContinuesLastK(min_last_i) ; % ���ݼ�¼��һ��ʱ�̴洢��������Ϣ
                    otherMakers_k.ContinuesLastPosition(:,i) = otherMakers_k_last.ContinuesLastPosition(:,min_last_i) ;
                    otherMakers_k.ContinuesLastTime(i) = otherMakers_k_last.ContinuesLastTime(min_last_i);
                end
            else
                otherMakers_k.ContinuesFlag(i) = 0 ; % ������
                otherMakers_k.ContinuesLastPosition(:,i) = NaN ;
                otherMakers_k.ContinuesLastTime(i) = NaN ;
                otherMakers_k.ContinuesLastK(i) = NaN ;
                otherMakers_k.ContinuesLasti(i) = NaN;  % ��¼���ڵ���һʱ����˵����
            end
            % ���֮ǰ�Ѿ��е��Ӧ��ͬһ�㣬��������ĵ���жϣ������� NaN
            for j=1:i-1
               if  otherMakers_k.ContinuesLasti(j) == otherMakers_k.ContinuesLasti(i)
                   if dPi_ConJudge(i) < dPi_ConJudge(j)
                       % ��ǰ�ĵ������ʱ�̸õ����
                       otherMakers_k.ContinuesFlag(j) = 0;
                       otherMakers_k.ContinuesLastPosition(:,j) = NaN ;
                       otherMakers_k.ContinuesLastTime(j) = NaN ;
                       otherMakers_k.ContinuesLastK(j) = NaN ;
                       otherMakers_k.ContinuesLasti(j) = NaN;
                   else
                       otherMakers_k.ContinuesFlag(i) = 0;
                       otherMakers_k.ContinuesLastPosition(:,i) = NaN ;
                       otherMakers_k.ContinuesLastTime(i) = NaN ;
                       otherMakers_k.ContinuesLastK(i) = NaN ;
                       otherMakers_k.ContinuesLasti(i) = NaN;
                   end
               end
            end
        end
        %%  ��¼ dPi_ConJudge ����Сֵ
        if M>0
            if dPi_ConJudge(i)<dPi_ConJudgeOut || isnan(dPi_ConJudgeOut)
                dPi_ConJudgeOut = dPi_ConJudge(i);
            end
        else
            dPi_ConJudgeOut = NaN;
        end
%     end
else
    dPi_ConJudge=nan;
end

% ���� trackedMakerPosition_k ������ٳɹ�����˵��Ӧ����ţ��ܲ��õİ취�������ڲ����ƻ�֮ǰ�����ݽṹ����ʱ��ô����
function Tracked_i =  GetTrackedi( trackedMakerPosition_k,otherMakers_k )
if isnan(trackedMakerPosition_k(1))
    Tracked_i = NaN;
    return;
end
M = otherMakers_k.otherMakersN ;
dPi = repmat(trackedMakerPosition_k,1,M)- otherMakers_k.Position(:,1:M) ;
            dPiNorm = zeros(1,M);
for j=1:M
    dPiNorm(j) = normest(dPi(:,j));
end

[dPi_ConJudge,min_last_i] = min(dPiNorm);   
Tracked_i = min_last_i;