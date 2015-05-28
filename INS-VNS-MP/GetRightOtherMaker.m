%% xyz 2015.5.25
%% otherMakers ����˵�ʶ���ڶ����˵����ҵ���ȷ����˵�
% ��˵㶪ʧʱ���� trackedMakerPosition = NaN
%%% ����˵�����ж�˼·

%%%  ��һ����֮����ٷ���
% 1������߶ȣ��߶�����Ļ�������2��  [����������һ�����߶ȷ��򲻿��á���Ϊ���Բ���Hip��Ϊԭ�㣬ֻ�������ᵼ�¸߶ȱ仯�����������¶ײ��ᷢ���߶ȱ仯��]
%  ע������������ݽŵĸ߶ȣ������ͷ��Ե���ĸ߶ȣ����ø߶���Ϣ�����߼�⾫�ȣ�����
% 2�� ��˵��������ж�
%   �����һʱ�̵ĵ���˵���ٳɹ������ڵ�ǰ��˵���Ѱ������һʱ����ӽ�����˵㣬λ�Ʋ�ģС�� 1/visionFre*0.5����С2cm��
%   ʱ��Ϊ�������������ٳɹ���( TrackFlag=1 )
%       �ж�ʧ�ܣ���˵㲻����������ڶ�����
% 3) ��ʱ�䣨dT=3���˶��Ĺ��̣����Ժ��Ӿ�λ�Ʋ� dPError_dT �����ж��� dPError_dT(i) = normest(dP_Inertial-dP_Vision)
%       3.1�� dP_InertialģС��0.03 m������׼��ֹ״̬����dPError_dTģ���� 0.01*moveTime �����ʧ�ܡ�
%             ��������OK ( TrackFlag=3.1 )    ���� ( TrackFlag=1.31 )  ����4�� 
%       3.2�� dP_Inertialģ����0.03 m�������˶�״̬�� 
%             dPError_dT ��ģС�� 0.01*moveTime ʱ����OK ( TrackFlag=3.5 )
%             ��dP_Vision��ģ�ǳ�С��ֱ���޳���    ���� ( TrackFlag=1.35 ) ����4��
%       1) 2)�ж���ʧ�ܣ���˵㲻�������ҹ��Ժ��Ӿ�λ������Դ󣬽�����ж�3���������ܴ����ڿ����˶�������У�
% 4) Ѱ�ҹ����˶� dS ����(���� moveDistance)������˵���ٳɹ�����ʱ�̣��ж� dP_Inertial �� dP_Vision��
%       4.0) ���������ʧ�ܣ� TrackFlag=-1.29
%       4.1�� dPError_dS ��ģС�� MaxPositionError_dS��moveDistance*0.35�� 
%       4.2) dP_Inertial �� dP_Vision �ļн�С��MaxDisplaceAngle
%       ͬʱ���� 4.1�� �� 4.2����Ϊ��˵���ٳɹ� ( TrackFlag=4+TrackFlag )������ ( TrackFlag=-TrackFlag )
%%% ��һ����ĸ��ٷ���
% ͨ���˶�״̬������һ����

%% �ж�˼·���Ƚ�2�����λ��ʸ����1��dT(3 sec)�˶�ʱ��ʱ  2��dS��1m���˶�λ�Ƴ���ʱ
% 1)dT(3 sec)ʱ���ڣ����Ժ��Ӿ�λ�������Ĵ�С��<0.1m�������<60�㣨��λ��ʸ������С��0.2mʱ���ȽϷ���

function trackedMakerPosition = GetRightOtherMaker( otherMakers,InertialData )
global  makerTrackThreshold moveDistance
global otherMakersTime  inertialTime 
global visionFre  inertialFre
%% load data
visionFre = otherMakers(1).frequency ;
MarkerSet= otherMakers(1).MarkerSet ;
inertialTime = InertialData.time ;
inertialFre = InertialData.frequency ;

%% ��ֵ��������
moveTime = 2 ;          % sec �켣�����ж�ʱ�䲽��
moveDistance = 0.4 ;      % m   �켣�����ж�λ�Ʋ���  ������ֵ����0.4m-0.7m��
makerTrackThreshold.MaxContinuesDisplacement = min( 1/visionFre*0.3,0.02) ; % ��˵������ж����λ��ģ
makerTrackThreshold.PositionErrorBear_dT = 0.01*moveTime;   % �̶�ʱ�������˶���������һ������λ�Ʋ��������Χ�ڵģ�ֱ���ж�<У��1>ͨ��
makerTrackThreshold.MaxStaticDisp_dT = max(0.005*moveTime,0.02) ;           % �̶�ʱ�������˶��������ڶ�����������һ����ͨ����λ�Ʋ�ĳ����ǹ���λ�Ƴ��ȵ�MaxPositionError_dT������
makerTrackThreshold.MaxPositionError_dS = moveDistance*0.7;     % �˶��̶�����λ�Ƶ�����˶��������˶������50% ����Ҫ�������Ƕ�Լ����
makerTrackThreshold.MaxDisplaceAngle = 20*pi/180 ;      % �˶��̶�����λ�Ƶ����λ�Ʒ���ǶȲ�


switch MarkerSet 
    case 'Head'
        InertialPosition = InertialData.HeadPosition ;
    case 'Hip'
        InertialPosition = InertialData.HipPosition ;
end

dT_Ninertial = fix(moveTime/inertialFre) ;

%%
MarkerTN = length(otherMakers);
trackedMakerPosition = NaN(3,MarkerTN); % �жϳɹ�����˵�λ��
%% ��Ҫ���һ������֪ 
% trackedMakerPosition(:,1)  = otherMakers(1).Position(:,1) ;

% otherMakersNew = struct;
TrackFlag = zeros(1,MarkerTN);
ObjectMakerHigh = CalObjectMakerHigh( otherMakers );

otherMakers(1).ContinuesFlag = 0 ; % ������
otherMakers(1).ContinuesLastPosition = NaN ;
otherMakers(1).ContinuesLastTime = NaN ;
otherMakers(1). ContinuesLastK = NaN;


dPi_ConJudge = NaN(1,MarkerTN);   
dPError_dT_xy = NaN(1,MarkerTN);  
dPError_dT_z = NaN(1,MarkerTN);  
dPError_dS_xyNorm = NaN(1,MarkerTN);  
dP_Inertial_xyNorm = NaN(1,MarkerTN);  
angleErr_dS = NaN(1,MarkerTN);  
dP_Inertial_z = NaN(1,MarkerTN); 

 wh = waitbar(0,'SearchDistanceK');
for k=1:MarkerTN
    inertial_k = VisionK_to_InertialK(k);
    
    %  last_dT_k
    inertial_dT_k_last = inertial_k - dT_Ninertial ;
    inertial_dT_k_last = max(inertial_dT_k_last,1);
    vision_dT_k_last = InertialK_to_VisionK(inertial_dT_k_last);           
    
    otherMakers_k = otherMakers(k) ;  
    if k>1
        otherMakers_k_last = otherMakers(k-1) ; 
    else
        otherMakers_k_last = [];
    end
%      dbstop in JudgeMaker
   if k==150
      disp('') 
   end
     
    [ trackedMakerPosition(:,k),otherMakersNew_k,TrackFlag(k),JudgeIndex  ] = JudgeMaker...
        ( otherMakers_k,otherMakers_k_last,k,inertial_k,trackedMakerPosition,InertialPosition,inertial_dT_k_last,...
            vision_dT_k_last,ObjectMakerHigh ) ;
    otherMakers(k)=otherMakersNew_k;
    dPi_ConJudge(k) = JudgeIndex.dPi_ConJudge  ;
    dPError_dT_xy(k) = JudgeIndex.dPError_dT_xy ;
    dPError_dT_z(k) = JudgeIndex.dPError_dT_z ;
    dPError_dS_xyNorm(k) = JudgeIndex.dPError_dS_xyNorm ;
    dP_Inertial_xyNorm(k) = JudgeIndex.dP_Inertial_xyNorm ;
    dP_Inertial_z(k) = JudgeIndex.dP_Inertial_z ;
    angleErr_dS(k) = JudgeIndex.angleErr_dS ;
    
    if mod(k,fix(MarkerTN/10))==0
        waitbar(k/MarkerTN);
    end
end
 close(wh);

figure('name','trackFlag')
plot(otherMakersTime,TrackFlag,'.')
xlabel('time sec')

figure('name','dPi_ConJudge')
plot(otherMakersTime,dPi_ConJudge)
temp = makerTrackThreshold.MaxContinuesDisplacement ;
line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' )

xlabel('time sec')

figure('name','dPError_dT_xy')
plot(otherMakersTime,dPError_dT_xy)
temp = makerTrackThreshold.PositionErrorBear_dT ;
line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' )
xlabel('time sec')
legend( 'dPError\_dT\_xy','PositionErrorBear\_dT' )

figure('name','dPError_dT_z')
plot(otherMakersTime,dPError_dT_z)
temp = makerTrackThreshold.PositionErrorBear_dT ;
line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' )
xlabel('time sec')
legend( 'dPError\_dT\_z','PositionErrorBear\_dT' )

figure('name','dP_Inertial_xyNorm')
plot(otherMakersTime,dP_Inertial_xyNorm)
temp = makerTrackThreshold.MaxStaticDisp_dT ;
line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' )
xlabel('time sec')
legend( 'dPError\_dT','MaxStaticDisp\_dT' )

figure('name','dP_Inertial_z')
plot(otherMakersTime,dP_Inertial_z)
temp = makerTrackThreshold.MaxStaticDisp_dT ;
line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' )
xlabel('time sec')
legend( 'dPError\_dT','MaxStaticDisp\_dT' )


figure('name','dPError_dS_xyNorm')
plot(otherMakersTime,dPError_dS_xyNorm)
temp = makerTrackThreshold.MaxPositionError_dS ;
line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' )
xlabel('time sec')

figure('name','angleErr_dS')
plot(otherMakersTime,angleErr_dS*180/pi)
temp = makerTrackThreshold.MaxDisplaceAngle*180/pi ;
line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' )
xlabel('time sec')


FailTrackFlagNum = sum( TrackFlag<=0 );
fprintf( 'FailTrackFlagNum=%d ( %0.3f ) \n',FailTrackFlagNum,FailTrackFlagNum/length(TrackFlag) );

% ������˵�ĸ߶� ObjectMakerHigh ��
% ��Ϊ��ʼʱ��0.5����Ŀ����˵���һ�����ٵ���

function ObjectMakerHigh = CalObjectMakerHigh( otherMakers )
global  visionFre
N = fix(visionFre*0.5);
for k=1:N
    if otherMakers(k).otherMakersN > 0 
        otherMakersPosition_k = otherMakers(k).Position ;
        if abs(otherMakersPosition_k(1))<0.1 && abs(otherMakersPosition_k(2))<0.1
            ObjectMakerHigh = -otherMakersPosition_k(3) ;
            return;
        end
    end
end


%% Judge which is the right maker
% 1) �̶��˶�ʱ��λ���жϣ�ֻ�ж�λ�Ʋ��
% 2���̶��˶�����λ���жϣ�ͬʱ�ж�λ�Ʋ�Ⱥͷ���

function [ trackedMakerPosition_k_OK,otherMakers_k,TrackFlag,JudgeIndex ] = JudgeMaker...
( otherMakers_k,otherMakers_k_last,k_vision,inertial_k,trackedMakerPosition,InertialPosition,inertial_dT_k_last,...
            vision_dT_k_last,ObjectMakerHigh )
global inertialFre visionFre makerTrackThreshold moveDistance

JudgeIndex.dPi_ConJudge = NaN ;
JudgeIndex.dPError_dT_xy = NaN ;
JudgeIndex.dPError_dT_z = NaN ;
JudgeIndex.dPError_dS_xyNorm = NaN ;
JudgeIndex.dP_Inertial_xyNorm = NaN ;
JudgeIndex.angleErr_dS = NaN  ;
JudgeIndex.dP_Inertial_z = NaN  ;

trackedMakerPosition_k_OK = NaN;  % ������˵�ʧ���� NaN
TrackFlag = 0;

M = otherMakers_k.otherMakersN ;
otherMakersPosition_k = otherMakers_k.Position ;

if isempty(otherMakersPosition_k)
    return;
end

%% ��˵��������ж�
[ otherMakers_k,dPi_ConJudge ] = ContinuesJudge( otherMakers_k,otherMakers_k_last,trackedMakerPosition,k_vision );
JudgeIndex.dPi_ConJudge = dPi_ConJudge ;

%% dT ʱ��ε�λ�Ʋֻ����λ��ʸ����С
% ��� vision_dT_k_last û���ٳɹ�����ʱ����ǰ��
while vision_dT_k_last>1 && isnan( trackedMakerPosition(1,vision_dT_k_last) ) % trackedMakerPosition(1) ������֪����Ϊnan��
    vision_dT_k_last = vision_dT_k_last-1 ;
    inertial_dT_k_last = VisionK_to_InertialK(vision_dT_k_last);
end
if isnan( trackedMakerPosition(1,vision_dT_k_last) )
    %% Ѱ�ҵ�һ���㣨��һ���㣺��ô���Ҳ���֮ǰ���ٳɹ��ĵ㣩
    % ��������������㣬������ǰ��˵���ÿһ�������㣬���ĳ��������� dT �ж�ͨ��������Ϊ���ǵ�һ����
    IsSearchingFirst = 0;
    for i=1:M
        if  otherMakers_k.ContinuesFlag == 2
            IsSearchingFirst = 1;
%             vision_dT_T_last = otherMakers_k.ContinuesLastTime(i); % ��Ӧ�������ʱ��
            vision_dT_k_last = otherMakers_k.ContinuesLastK(i); % ��Ӧ����������
            inertial_dT_k_last = VisionK_to_InertialK(vision_dT_k_last);
            % ��һ����˵������Ĺؼ����Ե�ǰ��˵��Ӧ�����������Ϊ���ٳɹ���
            trackedMakerPosition_last_k_dT = otherMakers_k.ContinuesLastPosition(:,i) ; 
            
            [ trackedMakerPosition_k_OK,TrackFlag,min_dT_k,dPError_dT_xy,dPError_dT_z,dP_Inertial_xyNorm,dP_Inertial_z ] = Track_dT_Judge...
                ( otherMakers_k,InertialPosition,inertial_k,inertial_dT_k_last,trackedMakerPosition_last_k_dT );
            JudgeIndex.dPError_dT_xy = dPError_dT_xy ;
            JudgeIndex.dPError_dT_z = dPError_dT_z ;
            JudgeIndex.dP_Inertial_xyNorm = dP_Inertial_xyNorm ;
            JudgeIndex.dP_Inertial_z = dP_Inertial_z;
            if ~isnan(trackedMakerPosition_k_OK)
               fprintf('��һ����˵������ɹ�  k_vision = %d dPError_dT_xy = %0.3f,  dPError_dT_z = %0.3f \n ',k_vision,dPError_dT_xy,dPError_dT_z); 
               return;
            end        
        end        
    end
    if IsSearchingFirst==0
        % ���Ҳ���֮ǰ���ٳɹ��ĵ㣬���Ҳ��������ĵ㣬������
        fprintf('������һ���㣺�ȴ��㹻�������Եĵ� k_vision = %d \n ',k_vision)
        return; 
    end
else
    % ֮ǰ�и��ٳɹ�������
    trackedMakerPosition_last_k_dT = trackedMakerPosition(:,vision_dT_k_last) ;
    [ trackedMakerPosition_k_OK,TrackFlag,min_dT_k,dPError_dT_xy,dPError_dT_z,dP_Inertial_xyNorm,dP_Inertial_z ] = Track_dT_Judge( otherMakers_k,InertialPosition,inertial_k,inertial_dT_k_last,trackedMakerPosition_last_k_dT );
    JudgeIndex.dPError_dT_xy = dPError_dT_xy ;
    JudgeIndex.dPError_dT_z = dPError_dT_z ;
    JudgeIndex.dP_Inertial_xyNorm = dP_Inertial_xyNorm ;
    JudgeIndex.dP_Inertial_z = dP_Inertial_z;
end
if ~isnan(trackedMakerPosition_k_OK)    
   return;  % ����OK 
end
otherMakersPosition_k_min = otherMakersPosition_k(:,min_dT_k);


      
%% dS λ�Ƴ��ȶε�λ�Ʋͬʱ����λ�Ʋ��С�ͷ���
[ trackedMakerPosition_k_OK,TrackFlag,dPError_dS_xyNorm,angleErr_dS ] = Track_dS_Judge...
    ( InertialPosition,inertial_k,moveDistance,trackedMakerPosition,otherMakersPosition_k_min,TrackFlag ) ;
JudgeIndex.dPError_dS_xyNorm = dPError_dS_xyNorm  ;
JudgeIndex.angleErr_dS = angleErr_dS  ;

%% ��˵��ж� 4) Ѱ�ҹ����˶� dS ����(���� moveDistance)������˵���ٳɹ�����ʱ�̣��ж� dP_Inertial �� dP_Vision��
function [ trackedMakerPosition_k_OK,TrackFlag,dPError_dS_xyNorm,angleErr_dS ] = Track_dS_Judge...
    ( InertialPosition,inertial_k,moveDistance,trackedMakerPosition,otherMakersPosition_k_min,TrackFlag )
global  makerTrackThreshold
trackedMakerPosition_k_OK=  NaN ;
%% dS λ�Ƴ��ȶε�λ�Ʋͬʱ����λ�Ʋ��С�ͷ���
% find the point which moved moveDistance
dS_Inertial_last_k = SearchDistanceK( InertialPosition,inertial_k,moveDistance,trackedMakerPosition ) ;  
if isnan(dS_Inertial_last_k)
    % �Ҳ����˶����� dS ������trackedMakerPosition�и��ٵ��ĵ�
%     fprintf('�Ҳ����˶��̶����ȵĵ㣬��������֤<2>������ʧ�ܡ�\n');
    dPError_dS_xyNorm = -0.2 ;    % ����ֵ��ʾû���ҵ�
    angleErr_dS = -10*pi/180;
    TrackFlag = -1.29 ;
    return; 
end
dS_Vision_last_k = InertialK_to_VisionK(dS_Inertial_last_k) ;    

dP_Inertial = InertialPosition(:,inertial_k) - InertialPosition(:,dS_Inertial_last_k);
dP_Vision = otherMakersPosition_k_min - trackedMakerPosition(:,dS_Vision_last_k);
dPError_dS = dP_Inertial-dP_Vision ;
dPError_dS(3) = 0 ; %  ��ʱû�м�¼�ţ����ø߶���Ϣ
dPError_dS_xyNorm = normest(dPError_dS(1:2)) ;
temp = dP_Inertial'*dP_Vision / normest(dP_Inertial) / normest(dP_Vision) ;
angleErr_dS = acos(temp) ;

if dPError_dS_xyNorm < makerTrackThreshold.MaxPositionError_dS  && angleErr_dS < makerTrackThreshold.MaxDisplaceAngle
    % ����ͽǶ� ����
    trackedMakerPosition_k_OK = otherMakersPosition_k_min ;
    TrackFlag = 4+TrackFlag ;
%     fprintf('3.1��3.2�� ģ=%0.3f���ǶȲ�=%0.3f������OK \n',normest(dPError_dS),angleErr_dS*180/pi);
else
    TrackFlag = -TrackFlag ;
%     fprintf('3.1��3.2�� ģ=%0.3f���ǶȲ�=%0.3f������ʧ�� \n',normest(dPError_dS),angleErr_dS*180/pi);
end

%% ��˵��ж� 3) ��ʱ�䣨dT=3���˶��Ĺ��̣����Ժ��Ӿ�λ�Ʋ� dPError_dT �����ж��� dPError_dT(i) = normest(dP_Inertial-dP_Vision)

function [ trackedMakerPosition_k_OK,TrackFlag,min_dT_k,dPError_dT_xy,dPError_dT_z,dP_Inertial_xyNorm,dP_Inertial_z ] = Track_dT_Judge( otherMakers_k,InertialPosition,inertial_k,inertial_dT_k_last,trackedMakerPosition_last_k_dT )
global  makerTrackThreshold
trackedMakerPosition_k_OK = NaN ;
otherMakersPosition_k = otherMakers_k.Position ;
TrackFlag = 0;

M = size(otherMakersPosition_k,2) ;
dP_Inertial = InertialPosition(:,inertial_k) - InertialPosition(:,inertial_dT_k_last);
dP_Inertial_xy = dP_Inertial(1:2);
dP_Inertial_z = dP_Inertial(3);
dPError_dT  = zeros(1,M);
dPError_dT_xy  = zeros(1,M);
dPError_dT_z  = zeros(1,M);
dP_Vision = zeros(3,M);
for i=1:M
    otherMakersPosition_k_i = otherMakersPosition_k(:,i);
    dP_Vision(:,i) = otherMakersPosition_k_i - trackedMakerPosition_last_k_dT;
    dPError_dT(i) = normest(dP_Inertial-dP_Vision(:,i)) ;
    dPError_dT_xy(i) = normest(dP_Inertial_xy-dP_Vision(1:2,i)) ;
    dPError_dT_z(i) = normest(dP_Inertial_z-dP_Vision(3,i)) ;
end
[dPError_dT_xy,min_dT_k] = min(dPError_dT_xy,[],2);  % �����Ǹ߶�
dPError_dT_z = dPError_dT_z(min_dT_k);
% ����λ�ƴ�С �� ���۾�ֹ�����˶�
otherMakersPosition_k_min = otherMakersPosition_k(:,min_dT_k);
dP_Inertial_Norm = normest(dP_Inertial) ;  % ��ʱû�м�¼�ţ��޷��ø߶���Ϣ
dP_Inertial_xyNorm = normest(dP_Inertial(1:2)) ;
dP_Inertial_z = dP_Inertial(3) ;
if dP_Inertial_xyNorm < makerTrackThreshold.MaxStaticDisp_dT  
    %% ׼��ֹ״̬����dSλ���ж�
    % ��˵������˶�������ʧ��
    if dPError_dT > makerTrackThreshold.PositionErrorBear_dT
        TrackFlag = 1.31;
        return;
    end
    if otherMakers_k.ContinuesFlag(1,min_dT_k)==1
        trackedMakerPosition_k_OK = otherMakersPosition_k(:,min_dT_k) ;
        TrackFlag = 3.1;
        return;
    end
else
    %% �˶�״̬��
    % ��ֹ��ֱ���޳�
    if normest( dP_Vision(:,min_dT_k) )<makerTrackThreshold.MaxStaticDisp_dT
        TrackFlag=1.35;
        return;
    end
    if dPError_dT < makerTrackThreshold.PositionErrorBear_dT
        trackedMakerPosition_k_OK = otherMakersPosition_k_min ;
        TrackFlag = 3.5;
    %     fprintf( '3.5�������Ӿ�λ�Ʋ��=%0.4f ������OK\n',normest(dPError_dT) );
        return;
    end
end


%% ��˵��������ж�
function [ otherMakers_k,dPi_ConJudge ] = ContinuesJudge( otherMakers_k,otherMakers_k_last,trackedMakerPosition,k_vision )


% ǰһʱ�̸��ٳɹ�ʱ��������ǰ���Ƿ���Ը��ٳɹ��ĵ�������  Continues = 1
% ǰһʱ�̸���ʧ��ʱ��������ǰÿ�����Ƿ�Ϊ������Ľ��,�Ҽ�¼�Ÿ�������������ǰ���磨��������dT���ĵ��λ�ú�ʱ�䡣
%        Continues = 2 ��

global inertialFre visionFre makerTrackThreshold moveDistance

M = otherMakers_k.otherMakersN ;
otherMakers_k.ContinuesFlag = zeros(1,M) ; % ������
otherMakers_k.ContinuesLastPosition = NaN(3,M) ;
otherMakers_k.ContinuesLastTime = NaN(1,M) ;
otherMakersPosition_k = otherMakers_k.Position ;    
if k_vision>1 
    
    if ~isnan(trackedMakerPosition(1,k_vision-1))
        %% ֻ�жϵ�ǰ��˵��Ƿ���ǧʳ�͸��ٳɹ�����˵�����
        trackedMakerPosition_kLast = trackedMakerPosition(:,k_vision-1) ;
        otherMakersPosition_k_Dis = otherMakersPosition_k-repmat(trackedMakerPosition_kLast,1,M) ;
        otherMakersPosition_k_Dis_Norm = zeros(1,M);
        for j=1:M
            otherMakersPosition_k_Dis_Norm(j) = normest(otherMakersPosition_k_Dis(:,j));
        end
        [dPi_ConJudge,minCon_k] = min(otherMakersPosition_k_Dis_Norm);  
        if dPi_ConJudge < makerTrackThreshold.MaxContinuesDisplacement
    %         trackedMakerPosition_k_OK = otherMakersPosition_k(:,m) ;
    %         TrackFlag = 1;
    %         fprintf('��˵�������λ��=%0.4f������OK \n',Min_otherMakersPosition_k_Dis_Norm);
            
            otherMakers_k.ContinuesFlag(1,minCon_k) = 1 ; % ��������������ٳɹ���˵�����
            otherMakers_k.ContinuesLastPosition(:,minCon_k) = trackedMakerPosition_kLast ;
            otherMakers_k.ContinuesLastTime(minCon_k) = otherMakers_k_last.time ;
            otherMakers_k.ContinuesLastK(minCon_k) = k_vision-1 ;
        end
        
    else
        %% �жϵ�ǰ��˵��Ƿ�Ϊ������˵㣬��¼ÿ�����Ӧ�����磨��������dT��������
        M_last = otherMakers_k_last.otherMakersN ;
        % һ���� M*M_last �����
        for i=1:M
            dPi = repmat(otherMakers_k.Position( :,i ),1,M_last)- otherMakers_k_last.Position ;
            dPiNorm = normest(dPi);
            [dPi_ConJudge,min_i] = min(dPiNorm);   
            if normest(dPi_ConJudge) < makerTrackThreshold.MaxContinuesDisplacement
                %  otherMakers_k.Position( :,i ) �� otherMakers_k_last.Position(:,min_i) ����
                % �ҵ�һ�������ĵ㣬��¼��һ��
                otherMakers_k.ContinuesFlag(i) = 2 ; % �������͸���ʧ�ܵĵ�����
                % ���ǰһ����Ϊ�����㣬��ǰһ�����������¼���ݹ���
                if otherMakers_k_last.ContinuesFlag(min_i) == 2
                    otherMakers_k.ContinuesLastK(i) = otherMakers_k_last.ContinuesLastK(min_i) ; % ���ݼ�¼��һ��ʱ�̴洢��������Ϣ
                    otherMakers_k.ContinuesLastPosition(:,i) = otherMakers_k_last.ContinuesLastPosition(:,min_i) ;
                    otherMakers_k.ContinuesLastTime(i) = otherMakers_k_last.ContinuesLastTime(min_i);
                elseif otherMakers_k_last.ContinuesFlag(min_i) == 0
                    otherMakers_k.ContinuesLastK(i) = k_vision-1 ; % ֱ�Ӽ�¼��һ��ʱ��
                    otherMakers_k.ContinuesLastPosition(:,i) = otherMakers_k_last.Position( :,min_i ) ;
                    otherMakers_k.ContinuesLastTime(i) = otherMakers_k_last.time( min_i ) ;                    
                elseif otherMakers_k_last.ContinuesFlag(min_i) == 1
                    % ��һʱ�̸���ʧ�ܣ���������ʱ�̸��ٳɹ�������һʱ��������ʱ����������ʵӦ��Ҳ���ڸ��ٳɹ�����������ָ�겻���Ŷ�û���϶���
                    % ͬʱ��ǰ��������һʱ�������������Ϊ��ǰʱ��������ʱ������
                    otherMakers_k.ContinuesFlag(i) = 1 ;
                    otherMakers_k.ContinuesLastK(i) = otherMakers_k_last.ContinuesLastK(min_i) ; % ���ݼ�¼��һ��ʱ�̴洢��������Ϣ
                    otherMakers_k.ContinuesLastPosition(:,i) = otherMakers_k_last.ContinuesLastPosition(:,min_i) ;
                    otherMakers_k.ContinuesLastTime(i) = otherMakers_k_last.ContinuesLastTime(min_i);
                end
            else
                otherMakers_k.ContinuesFlag(i) = 0 ; % ������
                otherMakers_k.ContinuesLastPosition(:,i) = NaN ;
                otherMakers_k.ContinuesLastTime(i) = NaN ;
                otherMakers_k.ContinuesLastK(i) = NaN ;
            end
                        
        end
        
    end
else
    dPi_ConJudge=nan;
end



%% ���ҹ���kʱ��ǰ�˶��˴��� dS ���������ĵ�
% �Ҹõ�trackedMakerPosition���ٳɹ�
function dS_Inertial_last_k = SearchDistanceK( InertialPosition,kCurrent,dS,trackedMakerPosition )
global inertialFre visionFre
stepT = 1 ;  % ��������ʱ��
MaxSearchT = 60 ; % �����ʱ�䳤��
stepK = fix(inertialFre*stepT) ; % ��������

maxSearchK = min( kCurrent-1,fix(inertialFre*MaxSearchT) );
InertialPosition_kSea = InertialPosition(:,kCurrent);
dS_Inertial_last_k = NaN ;     % Ĭ�����ã�Ѱ��ʧ��
%wh = waitbar(0,'SearchDistanceK');
for i=1:stepK:maxSearchK
    dP = InertialPosition(:,kCurrent-i) - InertialPosition_kSea ;
    distance = normest( dP ); 
    if distance > dS
        kCurrent_Vision = InertialK_to_VisionK(kCurrent-i);
        if ~isnan(trackedMakerPosition(1,kCurrent_Vision))            
            % �������㣬�� trackedMakerPosition ���ٳɹ�
            dS_Inertial_last_k = kCurrent-i ;
            break;
        end
    end
 %   waitbar(i/kCurrent);
end
%close(wh)
disp('')

