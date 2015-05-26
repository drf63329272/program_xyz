%% xyz 2015.5.25
%% otherMakers ����˵�ʶ���ڶ����˵����ҵ���ȷ����˵�
% ��˵㶪ʧʱ���� NaN

%% �ж�˼·���Ƚ�2�����λ��ʸ����1��dT(3 sec)�˶�ʱ��ʱ  2��dS��1m���˶�λ�Ƴ���ʱ
% 1)dT(3 sec)ʱ���ڣ����Ժ��Ӿ�λ�������Ĵ�С��<0.1m�������<60�㣨��λ��ʸ������С��0.2mʱ���ȽϷ���

function trackedMakerPosition = GetRightOtherMaker( otherMakers,InertialData )
global inertialFre visionFre makerTrackThreshold
%% ��ֵ��������
dT_1 = 3 ;    % sec �켣�����ж�ʱ�䲽��
dS_2 = 1 ;    % m   �켣�����ж�λ�Ʋ���
makerTrackThreshold.MaxPositionError_dT = dT_1*0.05 ;   % �̶�ʱ�������˶�������0.05mÿs
makerTrackThreshold.MaxPositionError_dS = dS_2*0.2;     % �˶��̶�����λ�Ƶ�����˶��������˶������20%
makerTrackThreshold.MaxDisplaceAngle = 45*pi/180 ;      % �˶��̶�����λ�Ƶ����λ�Ʒ���ǶȲ�
%% load data
visionFre = otherMakers(1).frequency ;
MarkerSet= otherMakers(1).MarkerSet ;
inertialTime = InertialData.time ;
inertialFre = InertialData.frequency ;

switch MarkerSet 
    case 'Head'
        InertialPosition = InertialData.HeadPosition ;
    case 'Hip'
        InertialPosition = InertialData.HipPosition ;
end

dT_Ninertial = fix(dT_1/inertialFre) ;
dT_Nvision = fix(dT_1/visionFre) ;

%%
makerN = length(otherMakers);
trackedMakerPosition = NaN(3,makerN); % �жϳɹ�����˵�λ��

wh = waitbar(0,'SearchDistanceK');
for k=1:makerN
    maker_time = otherMakers(k).time ;
    % inertial_k
    inertialTimeErr = abs( inertialTime - maker_time );
    [~,inertial_k] = min(inertialTimeErr);
    %  last_dT_k
    inertial_dT_k_last = inertial_k - dT_Ninertial ;
    inertial_dT_k_last = max(inertial_dT_k_last,1);
    vision_dT_k_last = k - dT_Nvision ;
    vision_dT_k_last = max(vision_dT_k_last,k);
    
    % find the point which moved dS_2
    dS_Inertial_last_k = SearchDistanceK( InertialPosition,inertial_k,dS_2,trackedMakerPosition ) ;    
    
    otherMakers_k = otherMakers(k) ;    
    
%      dbstop in JudgeMaker
    trackedMakerPosition(:,k) = JudgeMaker...
        ( otherMakers_k,inertial_k,trackedMakerPosition,InertialPosition,inertial_dT_k_last,...
            vision_dT_k_last,dS_Inertial_last_k ) ;
    waitbar(k/makerN);
end
close(wh);

%% Judge which is the right maker
% 1) �̶��˶�ʱ��λ���жϣ�ֻ�ж�λ�Ʋ��
% 2���̶��˶�����λ���жϣ�ͬʱ�ж�λ�Ʋ�Ⱥͷ���

function trackedMakerPosition_k = JudgeMaker...
( otherMakers_k,inertial_k,trackedMakerPosition,InertialPosition,inertial_dT_k_last,...
            vision_dT_k_last,dS_Inertial_last_k )
global inertialFre visionFre makerTrackThreshold

trackedMakerPosition_k = NaN;  % ������˵�ʧ���� NaN

M = otherMakers_k.otherMakersN ;
otherMakersPosition_k = otherMakers_k.Position ;

for i=1:M
    otherMakersPosition_k_i = otherMakersPosition_k(:,i);
    
    %% dT ʱ��ε�λ�Ʋֻ����λ��ʸ����С
    % ��� vision_dT_k_last û���ٳɹ�����ʱ����ǰ��
    while vision_dT_k_last>0 && isnan( trackedMakerPosition(1,vision_dT_k_last) ) % trackedMakerPosition(1) ������֪����Ϊnan��
        vision_dT_k_last = vision_dT_k_last-1 ;
        inertial_dT_k_last = fix( vision_dT_k_last*inertialFre/visionFre );
        inertial_dT_k_last = max(inertial_dT_k_last,1);
    end
    if vision_dT_k_last==0
        % ��һ����˵㻹δ�жϣ����ù��Ժ��Ӿ�������ϵԭ���غ�
        trackedMakerPosition_last_k_dT = [0;0;otherMakersPosition_k(3,1)] ;
    else
        trackedMakerPosition_last_k_dT = trackedMakerPosition(:,vision_dT_k_last) ;
    end
    
    dP_Inertial = InertialPosition(:,inertial_k) - InertialPosition(:,inertial_dT_k_last);
    dP_Vision = otherMakersPosition_k_i - trackedMakerPosition_last_k_dT;
    dPError_dT = dP_Inertial-dP_Vision ;
    if normest(dPError_dT) > makerTrackThreshold.MaxPositionError_dT
        % �����㣬�������˵㲻��Ҫ���н�һ���ж�
        continue;
    end
    %% dS λ�Ƴ��ȶε�λ�Ʋͬʱ����λ�Ʋ��С�ͷ���
    if isnan(dS_Inertial_last_k)
        % �Ҳ����˶����� dS ������trackedMakerPosition�и��ٵ��ĵ�
        % ֻ����ΪҲ���㣨�����Ŷ�û����ô�ߣ�������
        trackedMakerPosition_k = otherMakersPosition_k_i ;
        continue; 
    end
    dS_Vision_last_k = fix(dS_Inertial_last_k*inertialFre/visionFre) ;    
    dP_Inertial = InertialPosition(:,inertial_k) - InertialPosition(:,dS_Inertial_last_k);
    dP_Vision = otherMakersPosition_k_i - trackedMakerPosition(:,dS_Vision_last_k);
    dPError_dS = dP_Inertial-dP_Vision ;
    if normest(dPError_dS) < makerTrackThreshold.MaxPositionError_dS
        % �������㣬�жϷ���
        temp = dP_Inertial.*dP_Vision / normest(dP_Inertial) / normest(dP_Vision) ;
        angleErr = acos(temp) ;
        if angleErr < makerTrackThreshold.MaxDisplaceAngle
           % ��������������������˵�ɹ�
           trackedMakerPosition_k = otherMakersPosition_k_i ;
           break;
        end
    end
end
if isnan(trackedMakerPosition_k)
   disp('tracke MakerPosition failed') 
end

%% ���ҹ���kʱ��ǰ�˶��˴��� dS ���������ĵ�
% �Ҹõ�trackedMakerPosition���ٳɹ�
function dS_Inertial_last_k = SearchDistanceK( InertialPosition,kCurrent,dS,trackedMakerPosition )
InertialPosition_kSea = InertialPosition(:,kCurrent);
dS_Inertial_last_k = NaN ;     % Ĭ�����ã�Ѱ��ʧ��
%wh = waitbar(0,'SearchDistanceK');
for i=1:kCurrent-1
    dP = InertialPosition(:,kCurrent-i) - InertialPosition_kSea ;
    distance = normest( dP ); 
    if distance > dS && ~isnan(trackedMakerPosition(kCurrent-i))
        % �������㣬�� trackedMakerPosition ���ٳɹ�
        dS_Inertial_last_k = kCurrent-i ;
        break;
    end
 %   waitbar(i/kCurrent);
end
%close(wh)

