%% xyz 2015.5.25
%% otherMakers ����˵�ʶ���ڶ����˵����ҵ���ȷ����˵�
% trackedMakerPosition �� [3*N] ÿ��ʱ�̸��ٳɹ���˵�λ�ã�����ʧ�� NaN(3,1)
% trackedMarkerVelocity �� [5*N] ���ٳɹ���˵���ٶȣ�ǰ����xyz�ٶȣ�
    % 	trackedMarkerVelocity(4,:)Ϊxyƽ������˵��ٶ�ģ��trackedMarkerVelocity(5,:)Ϊxyƽ������˵��ٶ���[0 1 0] �ļн�

%% ���ٲ�����˵���ĵ�

%% �ж�˼·���Ƚ�2�����λ��ʸ����1��dT(3 sec)�˶�ʱ��ʱ  2��dS��1m���˶�λ�Ƴ���ʱ
% 1)dT(3 sec)ʱ���ڣ����Ժ��Ӿ�λ�������Ĵ�С��<0.1m�������<60�㣨��λ��ʸ������С��0.2mʱ���ȽϷ���

function [ trackedMakerPosition_InertialTime_Out,otherMakers ] = ...
    GetRightOtherMaker( otherMakers,InertialPosition )
coder.extrinsic('fprintf');
coder.extrinsic('DrawTracedINSVNS');

global    visionFre inertialFre 
global      IsGetFirstMarker 
global      CalStartVN CalEndVN  CalStartIN  CalEndIN  

%% ��ֵ��������
persistent makerTrackThreshold INSVNSCalibSet 
if isempty(makerTrackThreshold)
    [ makerTrackThreshold,INSVNSCalibSet ] = SetParameters( );
end

IsGetFirstMarker = 0 ;

dT_Ninertial = fix(makerTrackThreshold.moveTime*inertialFre) ;

%% ����/���� ��һ��Ҫ��Ԥ���������С
persistent   trackedMakerPosition_InertialTime  trackedMakerPosition TrackFlag trackedMarkerVelocity  InertialVelocity
persistent INSVNSCalib_VS_k  Calib_N_New  IsCalibDataEnough
MarkerTN = length(otherMakers);   %  �Ӿ�ʱ�䳤��
InertialN = size(InertialPosition,2);

if isempty(InertialVelocity)
    TrackFlag = zeros(1,MarkerTN);
    trackedMakerPosition = NaN(3,MarkerTN); % �жϳɹ�����˵�λ��
    trackedMakerPosition_InertialTime = NaN( 3,InertialN );
    
    InertialVelocity = NaN(5,InertialN);
    trackedMarkerVelocity = NaN(5,MarkerTN); 
    
    INSVNSCalib_VS_k = NaN(2,50); % INSVNSCalib_VS_k��:,i���洢һ��λ��
    Calib_N_New = 0;   % �����˵�λ�ƶθ���
    IsCalibDataEnough = 0;
end
%% ��Щ�ж�ָ��ֻ������ʱ��¼
persistent dPi_ConJudge dPError_dT_xy  dPError_dT_z  dPError_dS_xyNorm dP_Inertial_xyNorm  angleErr_dS  angleErr_dT_Min ConTrackedFailed INSVNSMarkHC_Min
if isempty(dPi_ConJudge)
    dPi_ConJudge = NaN(1,MarkerTN);   
    dPError_dT_xy = NaN(1,MarkerTN);  
    dPError_dT_z = NaN(1,MarkerTN);  
    dPError_dS_xyNorm = NaN(1,MarkerTN);  
    dP_Inertial_xyNorm = NaN(1,MarkerTN);  
    angleErr_dS = NaN(1,MarkerTN);  
    angleErr_dT_Min = NaN(1,MarkerTN); 
    ConTrackedFailed = zeros(1,MarkerTN);
    INSVNSMarkHC_Min = NaN(1,MarkerTN);               
end
persistent Crw
if isempty(Crw)
   Crw = eye(3); 
end
%% ������ٶ�
for k=CalStartIN:CalEndIN
    [ InertialVelocity_i,k_calV ] = CalVelocity( InertialPosition,k,inertialFre,INSVNSCalibSet.dT_CalV_Calib,INSVNSCalibSet.MinXYVNorm_CalAngle );
    if k_calV>0 
        InertialVelocity(:,k_calV) = InertialVelocity_i ;
    end
end
%% ����˵���� 
coder.extrinsic('waitbar');
coder.extrinsic('close');
%  wh = waitbar(0,'SearchDistanceK');
for k=CalStartVN:CalEndVN
    otherMakers_k = otherMakers(k) ;  
    inertial_k = otherMakers_k.inertial_k ;
        
    %  last_dT_k
    inertial_dT_k_last = inertial_k - dT_Ninertial ;
    inertial_dT_k_last = max(inertial_dT_k_last,1);        
        
    if k>1
        otherMakers_k_last = otherMakers(k-1) ; 
        if coder.target('MATLAB') && isnan(otherMakers_k_last.ContinuesFlag)
           fprintf('�ж���%0.0f����ʱ��ǰһ��otherMakers��û�н��\n',k); 
        end
        % otherMakers_k_last �����Ǹ������ж�����ģ����һ��
        
        
%         if k>2 && isnan(trackedMakerPosition(1,k-2))
%             if sum(otherMakers_k_last.ContinuesFlag==1)~=0
%                disp('err') 
%             end
%         end
    else
        otherMakers_k_last = GetEmpty_otherMakers(otherMakers_k) ;
    end

    [ trackedMakerPosition(:,k),otherMakersNew_k,TrackFlag(k),JudgeIndex  ] = JudgeMaker...
        ( otherMakers_k,otherMakers_k_last,k,inertial_k,trackedMakerPosition,InertialPosition,inertial_dT_k_last,...
        makerTrackThreshold ) ;
        
    if coder.target('MATLAB')
        dPi_ConJudge(k) = JudgeIndex.dPi_ConJudge  ;
        dPError_dT_xy(k) = JudgeIndex.dPError_dT_xy ;
        dPError_dT_z(k) = JudgeIndex.dPError_dT_z ;
        dPError_dS_xyNorm(k) = JudgeIndex.dPError_dS_xyNorm ;
        dP_Inertial_xyNorm(k) = JudgeIndex.dP_Inertial_xyNorm ;
        angleErr_dT_Min(k) = JudgeIndex.angleErr_dT_Min ;
        angleErr_dS(k) = JudgeIndex.angleErr_dS ;
        INSVNSMarkHC_Min(k) = JudgeIndex.INSVNSMarkHC_Min ;
    end
       
    if sum(otherMakersNew_k.ContinuesFlag==1)~=0 && isnan(trackedMakerPosition(1,k))
        ConTrackedFailed(k) = 1 ;
    else
        ConTrackedFailed(k) = 0 ;
    end
    
    %% ��  INSMarkH0  VNSMarkH0
    if isnan(makerTrackThreshold.INSMarkH0) && ~isnan(trackedMakerPosition(1,k))
        fprintf( '��һ�������سɹ� time = %0.1f sec, TrackFlag(%d) = %0.1f ,',k/visionFre,k,TrackFlag(k) );
        % ���Hip�ĸ����ͺ��С��ȡֵ����������������������������������������������������������������������������������
        makerTrackThreshold.INSMarkH0 = - InertialPosition(3,inertial_k);
        makerTrackThreshold.VNSMarkH0 = - trackedMakerPosition(3,k) ;
        
 
%         HipQuaternion_k = HipQuaternion( :,inertial_k );
%         HipAttitude = GetHipAttitude( HipQuaternion_k );
%         
%         HipQuaternion_k = Qinv( HipQuaternion_k ) ; % ��Ԫ�������� ˳ʱ�� ��Ϊ ��ʱ�롣
%         
%         CHip_k = Q2C(HipQuaternion_k);
%         
%         C_HipLUF_NED0 = RotateX(pi/2) * RotateY(-pi/2);  % Hip ������ǰϵ �� NED��0��̬ϵ
%         C_NED_HipNED0 = C_HipLUF_NED0 * CHip_k ;               
%         Attitude = C2Euler( C_NED_HipNED0,'ZYX' )*180/pi
        
        
        %% ��һ�θ�����˵�ɹ�
        % �궨�Ӿ����ѧ��ԭ�㣨�����Ƿ���
%         Xrw_r = trackedMakerPosition(1:2,k) - InertialPosition(1:2,inertial_k);
%         Xrw_r = [Xrw_r;0];
%         N_otherMakers = length( otherMakers );
%         for i=1:N_otherMakers
%             if ~isempty(otherMakers(i).Position)
%                 m = size( otherMakers(i).Position,2 );
%                 otherMakers(i).Position = otherMakers(i).Position - repmat(Xrw_r,1,m) ;
%                 trackedMakerPosition(:,i) = trackedMakerPosition(:,i) - Xrw_r ;
%             end
%         end
    end
    %% ���Ӿ��ٶ�
    [ trackedMarkerVelocity_k,k_calV ] = CalVelocity...
        ( trackedMakerPosition,k,visionFre,INSVNSCalibSet.dT_CalV_Calib,INSVNSCalibSet.MinXYVNorm_CalAngle );
    if k_calV>0 
        trackedMarkerVelocity(:,k_calV) = trackedMarkerVelocity_k ;
        if IsCalibDataEnough==0   % ֻ����һ��
        %% ���������ڱ궨������
    %         dbstop in SearchCalibData
            Calib_N_Last = Calib_N_New;
            [ INSVNSCalib_VS_k,Calib_N_New,IsCalibDataEnough,dX_Vision ] = SearchCalibData...
                ( INSVNSCalib_VS_k,Calib_N_Last,trackedMarkerVelocity,trackedMakerPosition,k_calV,INSVNSCalibSet ) ;
            if IsCalibDataEnough==1
                fprintf( '��һ����������ϵӳ�����ĵ�OK��time = %0.1f sec \n',k/visionFre );
                Crw = INSVNSCalib( INSVNSCalib_VS_k,Calib_N_New,dX_Vision,InertialPosition );                 
            end
        end        
    end
    otherMakersNew_k = CompensateSecond( otherMakersNew_k,Crw  );
    otherMakers(k)=otherMakersNew_k;     % ���� otherMakers(k)
    %% ת�ɹ�����˵��ʱ��
    
    trackedMakerPosition_InertialTime(:,inertial_k) = trackedMakerPosition(:,k) ;
%     
%     if mod(k,fix(MarkerTN/10))==0
%         waitbar(k/MarkerTN);
%     end
end
%  close(wh);
 %% Output
trackedMakerPosition_InertialTime_Out = trackedMakerPosition_InertialTime ;
 
 %% result analyse

if coder.target('MATLAB') && CalEndVN == MarkerTN
     trackedMaker.trackedMakerPosition = trackedMakerPosition ;
%      trackedMaker.time = otherMakersTime ;
     trackedMaker.MarkerSet = otherMakers(1).MarkerSet ;
     N = length(trackedMakerPosition) ;
    for k=1:N
        otherMakers(k).trackedMakerPosition = trackedMakerPosition(:,k) ;
    end
    for k=1:N
        i = N-k+1;
        if ~isnan(trackedMakerPosition(1,i))
            trackedMaker.LastMakerPosition = trackedMakerPosition(:,i);
            trackedMaker.LastMakerTime = otherMakers(i).time ;
            break;
        end
    end
    
    DrawTracedINSVNS( TrackFlag,trackedMaker,InertialPosition,trackedMarkerVelocity,InertialVelocity,INSVNSCalib_VS_k,INSVNSCalibSet ) ;
    
end

if coder.target('MATLAB') && CalEndVN == MarkerTN
    otherMakersTime = ( 1:MarkerTN )/1;

    figure('name','trackFlag')
    plot(TrackFlag,'.')
    % plot(otherMakersTime,TrackFlag,'.')
    % xlabel('time sec')

    figure('name','dPi_ConJudge')
    plot(otherMakersTime,dPi_ConJudge)
    temp = makerTrackThreshold.MaxContinuesDisplacement ;
    line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' )

    xlabel('time sec')

    figure('name','INSVNSMarkHC_Min')
    plot(otherMakersTime,INSVNSMarkHC_Min)
    temp = makerTrackThreshold.MaxMarkHighChange ;
    line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' )
    temp = -makerTrackThreshold.MaxMarkHighChange ;
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

    figure('name','angleErr_dT_Min')
    plot(otherMakersTime,angleErr_dT_Min*180/pi)
    temp = makerTrackThreshold.Max_dPAngle_dS*180/pi ;
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
    temp = makerTrackThreshold.Max_dPAngle_dS*180/pi ;
    line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' )
    xlabel('time sec')

    figure('name','ConTrackedFailed')
    plot(ConTrackedFailed)



    FailTrackFlagNum = sum( TrackFlag<=0 );
    fprintf( 'FailTrackFlagNum=%d ( %0.3f ) \n',FailTrackFlagNum,FailTrackFlagNum/length(TrackFlag) );
end

%% ��ֵ��������
function [ makerTrackThreshold,INSVNSCalibSet ] = SetParameters(  )
global visionFre  

moveTime = 2 ;          % sec �켣�����ж�ʱ�䲽��
moveDistance = 0.5 ;      % m   �켣�����ж�λ�Ʋ���  ������ֵ����0.4m-0.7m��
MaxMoveSpeed = 1.5 ; % m/s  ��˵��˶����������ٶȣ���������ٶ�����Ϊ������
makerTrackThreshold.moveTime = moveTime ;
makerTrackThreshold.MaxMoveTime = 3 ;
makerTrackThreshold.moveDistance = moveDistance ;
makerTrackThreshold.MaxContinuesDisplacement = min( 1/visionFre*MaxMoveSpeed,0.1) ; % ��˵������ж����λ��ģ
makerTrackThreshold.PositionErrorBear_dT = 0.05*moveTime;   % �̶�ʱ�������˶���������һ������λ�Ʋ��������Χ�ڵģ�ֱ���ж�<У��1>ͨ��
makerTrackThreshold.ContinuesTrackedMagnifyRate = 1.3 ;      % �������ڸ��ٳɹ��ĵ�ʱ���Ŵ�PositionErrorBear_dT
MaxStaticSpeed = 0.1 ; % m/s ��ֹʱ������������������
makerTrackThreshold.MaxStaticDisp_dT = max(MaxStaticSpeed*moveTime,0.02) ;           % �̶�ʱ�������˶��������ڶ�����������һ����ͨ����λ�Ʋ�ĳ����ǹ���λ�Ƴ��ȵ�MaxPositionError_dT������
makerTrackThreshold.MaxPositionError_dS = moveDistance*0.7;     % �˶��̶�����λ�Ƶ�����˶��������˶������50% ����Ҫ�������Ƕ�Լ����
makerTrackThreshold.Max_dPAngle_dS = 20*pi/180 ;      % �˶��̶�����λ�Ƶ����λ�Ʒ���ǶȲ�

makerTrackThreshold.MaxMarkHighChange = 0.4 ;      % m �������Ӿ�Ŀ����˵�߶Ȳ�仯���Χ�������޳��߶����ϴ�ĵ�

makerTrackThreshold.MaxHighMoveErrRate = [ -0.3  0.5 ] ;  %  �߶ȷ���仯��ʱ�����仯����С�����ֵ��ֱ���϶�����OK
        % ���ָ߶ȷ�������ǳ�
makerTrackThreshold.BigHighMove = 0.18 ;         % m �������ֵ����Ϊ�߶ȷ���仯��
%% ����ϵ�궨����
INSVNSCalibSet.Min_xyNorm_Calib = 0.3 ; % m  ���ڱ궨�����ݵ���С�˶�λ�Ƴ���
INSVNSCalibSet.MaxTime_Calib = 2  ;  % sec  ���ڱ궨�����ݵ��ʱ��
INSVNSCalibSet.MaxVXY_DirectionChange_Calib = 30*pi/180 ;     % �� XYƽ���ٶȷ���仯���Χ
INSVNSCalibSet.MaxVZ_Calib = 0.1 ;     % m/s Z�����ٶ�������ֵ
INSVNSCalibSet.MinVXY_Calib = 0.2;   	% m/s XY ƽ���ٶ�ģ��С����ֵ
INSVNSCalibSet.angleUniformityErr = 10*pi/180 ; % �� λ��ʸ��������������
% �ٶȼ���
INSVNSCalibSet.dT_CalV_Calib = 0.1 ; % �����ٶ�ʱ�䲽�����궨λ������ѡ��
INSVNSCalibSet.MinXYVNorm_CalAngle = 0.1 ;  %  m/s xy�ٶ�ģ�������ֵ�ż����ٶȵķ���

makerTrackThreshold.INSMarkH0 = NaN ;
makerTrackThreshold.VNSMarkH0 = NaN ;

function otherMakersEmpty = GetEmpty_otherMakers(otherMakers_k)
otherMakersEmpty = otherMakers_k;
otherMakersEmpty.frequency = NaN;
otherMakersEmpty.Position = NaN(3,1);
otherMakersEmpty.otherMakersN = int32(-1);
%��otherMakers(k).time
%��otherMakers(k).MarkerSet

function otherMakersNew_k = CompensateSecond( otherMakersNew_k,Crw  )
M = otherMakersNew_k.otherMakersN ;

if ~isempty(otherMakersNew_k.Position)
    otherMakersNew_k.Position(:,1:M) = Crw*otherMakersNew_k.Position(:,1:M) ;
end


%% Judge which is the right maker
% 1) �̶��˶�ʱ��λ���жϣ�ֻ�ж�λ�Ʋ��
% 2���̶��˶�����λ���жϣ�ͬʱ�ж�λ�Ʋ�Ⱥͷ���

function [ trackedMakerPosition_k_OK,otherMakers_k,TrackFlag,JudgeIndex ] = JudgeMaker...
( otherMakers_k,otherMakers_k_last,k_vision,inertial_k,trackedMakerPosition,InertialPosition,inertial_dT_k_last,...
            makerTrackThreshold )
coder.extrinsic('fprintf');
global  visionFre   IsGetFirstMarker
global InertialData_visual_k  VisionData_inertial_k CalStartIN  CalEndIN

vision_dT_k_last = InertialData_visual_k(inertial_dT_k_last); % ��ʼֵ

moveDistance = makerTrackThreshold.moveDistance;
JudgeIndex.dPi_ConJudge = NaN ;
JudgeIndex.dPError_dT_xy = NaN ;
JudgeIndex.dPError_dT_z = NaN ;
JudgeIndex.dPError_dS_xyNorm = NaN ;
JudgeIndex.dP_Inertial_xyNorm = NaN ;
JudgeIndex.angleErr_dS = NaN  ;
JudgeIndex.angleErr_dT_Min = NaN  ;
JudgeIndex.INSVNSMarkHC_Min = NaN  ;


trackedMakerPosition_k_OK = NaN;  % ������˵�ʧ���� NaN
TrackFlag = 0;
        
% M = otherMakers_k.otherMakersN ;
otherMakersPosition_k = otherMakers_k.Position ;


if isnan(otherMakersPosition_k(1))
    return;
end
%% �߶��ж�
%  �� otherMakers_k �и߶ȱ仯��ĵ�ֱ���޳���
[ otherMakers_k,trackedMakerPosition_k_OK,TrackFlag,INSVNSMarkHC_Min ] = Track_High_Judge...
    ( otherMakers_k,inertial_k,InertialPosition,makerTrackThreshold ) ;
JudgeIndex.INSVNSMarkHC_Min = INSVNSMarkHC_Min  ;
M = otherMakers_k.otherMakersN ;  % ��ĸ������ܱ�������
if TrackFlag == -1
    return;
end
%% ��˵��������ж�
[ otherMakers_k,dPi_ConJudge ] = ContinuesJudge( otherMakers_k,otherMakers_k_last,trackedMakerPosition,k_vision,makerTrackThreshold );
JudgeIndex.dPi_ConJudge = dPi_ConJudge ;

%% dT ʱ��ε�λ�Ʋֻ����λ��ʸ����С
% ��� vision_dT_k_last û���ٳɹ�����ʱ����ǰ��ֱ���ҵ����ٳɹ��ĵ㡣���ǲ�����ǰ�Ƴ��� Max_dT ʱ�䡣������
% Max_dTʱ�仹û���ҵ��Ļ���
while vision_dT_k_last>1 && isnan( trackedMakerPosition(1,vision_dT_k_last) ) % trackedMakerPosition(1) ������֪����Ϊnan��
    vision_dT_k_last = vision_dT_k_last-1 ;
    inertial_dT_k_last = int32(VisionData_inertial_k(vision_dT_k_last));
    inertial_dT_k_last = max(inertial_dT_k_last,1);
    if (k_vision-vision_dT_k_last)/visionFre > makerTrackThreshold.MaxMoveTime
%         fprintf( '������������Ϊ�µ���������  k_vision = %d , vision_dT_k_last = %d \n',k_vision,vision_dT_k_last );
        break;
    end
end
if isnan( trackedMakerPosition(1,vision_dT_k_last) )
    %% Ѱ�ҵ�һ���㣨��һ���㣺��ô���Ҳ���֮ǰ���ٳɹ��ĵ㣩
    % ��������������㣬������ǰ��˵���ÿһ�������㣬���ĳ��������� dT �ж�ͨ��������Ϊ���ǵ�һ����
    IsSearchingFirst = 0;
    for i=1:M
        if  otherMakers_k.ContinuesFlag(i) == 2 || otherMakers_k.ContinuesFlag(i) == 1
            IsSearchingFirst = 1;
            % ��һ����˵������Ĺؼ����Ե�ǰ��˵��Ӧ�����������Ϊ���ٳɹ���
            trackedMakerPosition_last_k_dT = otherMakers_k.ContinuesLastPosition(:,i) ; 

            [ trackedMakerPosition_k_OK,TrackFlag,min_dT_k,dPError_dT_xy,dPError_dT_z,dP_Inertial_xyNorm,angleErr_dT_Min ] = Track_dT_Judge...
                ( otherMakers_k,InertialPosition,inertial_k,inertial_dT_k_last,trackedMakerPosition_last_k_dT,makerTrackThreshold );
            JudgeIndex.dPError_dT_xy = dPError_dT_xy ;
            JudgeIndex.dPError_dT_z = dPError_dT_z ;
            JudgeIndex.dP_Inertial_xyNorm = dP_Inertial_xyNorm ;
            JudgeIndex.angleErr_dT_Min = angleErr_dT_Min;
     
            if ~isnan(trackedMakerPosition_k_OK(1)) && IsGetFirstMarker == 0
                IsGetFirstMarker = 1 ;
                
                fprintf( '��һ�������سɹ� time = %0.1f sec, TrackFlag(%d) = %0.1f \n',k_vision/visionFre,k_vision,TrackFlag );
                fprintf(' dPError_dT_xy = %0.3f,  dPError_dT_z = %0.3f \n ',dPError_dT_xy,dPError_dT_z); 
               return;
            end       
        end        
    end
    if IsSearchingFirst==0
        % ���Ҳ���֮ǰ���ٳɹ��ĵ㣬���Ҳ��������ĵ㣬������
%         fprintf('������һ���㣺�ȴ��㹻�������Եĵ� k_vision = %d \n ',k_vision)
        return; 
    end
else
    % ֮ǰ�и��ٳɹ�������
    trackedMakerPosition_last_k_dT = trackedMakerPosition(:,vision_dT_k_last) ;
    [ trackedMakerPosition_k_OK,TrackFlag,min_dT_k,dPError_dT_xy,dPError_dT_z,dP_Inertial_xyNorm,angleErr_dT_Min ] = ...
        Track_dT_Judge( otherMakers_k,InertialPosition,inertial_k,inertial_dT_k_last,trackedMakerPosition_last_k_dT,makerTrackThreshold );
    JudgeIndex.dPError_dT_xy = dPError_dT_xy ;
    JudgeIndex.dPError_dT_z = dPError_dT_z ;
    JudgeIndex.dP_Inertial_xyNorm = dP_Inertial_xyNorm ;
    JudgeIndex.angleErr_dT_Min = angleErr_dT_Min;
end
if ~isnan(trackedMakerPosition_k_OK(1))    
   return;  % ����OK 
end
otherMakersPosition_k_min = otherMakersPosition_k(:,min_dT_k);
      
%% dS λ�Ƴ��ȶε�λ�Ʋͬʱ����λ�Ʋ��С�ͷ���
[ trackedMakerPosition_k_OK,TrackFlag,dPError_dS_xyNorm,angleErr_dS ] = Track_dS_Judge...
    ( InertialPosition,inertial_k,trackedMakerPosition,otherMakersPosition_k_min,TrackFlag,makerTrackThreshold ) ;
JudgeIndex.dPError_dS_xyNorm = dPError_dS_xyNorm  ;
JudgeIndex.angleErr_dS = angleErr_dS  ;
%% �߶��ж�
% ��1.1������Ŀ��ؽ����Ӿ�Ŀ����˵�߶ȲINSVNSMarkHC�� =  INSVNSMarkL *
% cos(thita)��INSVNSMarkL Ϊ�������ڳ�ʼʱ�̼̿���õ���
%  INSVNSMarkHC ���㷽������ǰ�߶�-ֱ��ʱ�ĸ߶�
function [ otherMakers_k,trackedMakerPosition_k_OK,TrackFlag,INSVNSMarkHC_Min ] = Track_High_Judge...
    ( otherMakers_k,inertial_k,InertialPosition,makerTrackThreshold )
 INSMarkH0  = makerTrackThreshold.INSMarkH0 ;
 VNSMarkH0 = makerTrackThreshold.VNSMarkH0;

trackedMakerPosition_k_OK = NaN;
INSVNSMarkHC_Min = NaN ;
TrackFlag = 0 ;    
if isnan(INSMarkH0)
       
    return ;
end

M = otherMakers_k.otherMakersN ;
otherMakersPosition_k = otherMakers_k.Position ;

INSVNSMarkHC = zeros(1,M);
for i=1:M
    INSVNSMarkHC(i) = ( -InertialPosition(3,inertial_k) + otherMakersPosition_k(3,i) )-( INSMarkH0-VNSMarkH0 ) ;   
end
% �߶Ȳ���С�ĵ�
[ INSVNSMarkHC_Min,min_i ] = min( abs(INSVNSMarkHC) );
% ���߶Ȳ�����ĵ��޳�
invalid_i = 0;
for i=1:M
    if abs(INSVNSMarkHC(i)) > makerTrackThreshold.MaxMarkHighChange
        % ���߶Ȳ�����ĵ��޳�       
        Position_Old = otherMakers_k.Position;
        otherMakers_k.Position = RemoveOtherMarkers_Position( Position_Old,i-invalid_i,otherMakers_k.otherMakersN );
        otherMakers_k.otherMakersN = otherMakers_k.otherMakersN-1 ;
        invalid_i = invalid_i+1 ;
    end
end

%% ͨ���߶��޳���������
if otherMakers_k.otherMakersN == 0
   TrackFlag = -1;
   trackedMakerPosition_k_OK = NaN;
   return;
end

%% �޳� otherMakers_k.Position �еĵ� i ����

function Position = RemoveOtherMarkers_Position( Position,i,otherMakersN_old )
for k=i:otherMakersN_old-1
    Position(:,k) = Position(:,k+1);
end
Position(:,otherMakersN_old) = NaN(3,1);

%% ��˵��ж� 4) Ѱ�ҹ����˶� dS ����(���� moveDistance)������˵���ٳɹ�����ʱ�̣��ж� dP_Inertial �� dP_Vision��
function [ trackedMakerPosition_k_OK,TrackFlag,dPError_dS_Norm,angleErr_dS ] = Track_dS_Judge...
    ( InertialPosition,inertial_k,trackedMakerPosition,otherMakersPosition_k_min,TrackFlag,makerTrackThreshold )
global InertialData_visual_k

trackedMakerPosition_k_OK=  NaN ;
%% dS λ�Ƴ��ȶε�λ�Ʋͬʱ����λ�Ʋ��С�ͷ���
% find the point which moved moveDistance
moveDistance = makerTrackThreshold.moveDistance;
dS_Inertial_last_k = SearchDistanceK( InertialPosition,inertial_k,moveDistance,trackedMakerPosition ) ;  
if isnan(dS_Inertial_last_k)
    % �Ҳ����˶����� dS ������trackedMakerPosition�и��ٵ��ĵ�
%     fprintf('�Ҳ����˶��̶����ȵĵ㣬��������֤<2>������ʧ�ܡ�\n');
    dPError_dS_Norm = -0.2 ;    % ����ֵ��ʾû���ҵ�
    angleErr_dS = -10*pi/180;
    TrackFlag = -1.4 ;
    return; 
end
dS_Vision_last_k = InertialData_visual_k(dS_Inertial_last_k)  ;

dP_Inertial = InertialPosition(:,inertial_k) - InertialPosition(:,dS_Inertial_last_k);
dP_Vision = otherMakersPosition_k_min - trackedMakerPosition(:,dS_Vision_last_k);
dPError_dS = dP_Inertial-dP_Vision ;
dPError_dS_Norm = normest(dPError_dS) ;
temp = dP_Inertial'*dP_Vision / normest(dP_Inertial) / normest(dP_Vision) ;
angleErr_dS = acos(temp) ;

if dPError_dS_Norm < makerTrackThreshold.MaxPositionError_dS  && angleErr_dS < makerTrackThreshold.Max_dPAngle_dS
    % ����ͽǶ� ����
    trackedMakerPosition_k_OK = otherMakersPosition_k_min ;
    TrackFlag = 4+TrackFlag ;
%     fprintf('3.1��3.2�� ģ=%0.3f���ǶȲ�=%0.3f������OK \n',normest(dPError_dS),angleErr_dS*180/pi);
else
    TrackFlag = -TrackFlag ;
%     fprintf('3.1��3.2�� ģ=%0.3f���ǶȲ�=%0.3f������ʧ�� \n',normest(dPError_dS),angleErr_dS*180/pi);
end

%% ��˵��ж� 3) ��ʱ�䣨dT=3���˶��Ĺ��̣����Ժ��Ӿ�λ�Ʋ� dPError_dT �����ж��� dPError_dT(i) = normest(dP_Inertial-dP_Vision)

function [ trackedMakerPosition_k_OK,TrackFlag,min_dT_k,dPErrorNorm_dT_Min,dPError_dT_z_Min,dP_Inertial_xyNorm_Min,angleErr_dT_Min ]...
    = Track_dT_Judge( otherMakers_k,InertialPosition,inertial_k,inertial_dT_k_last,trackedMakerPosition_last_k_dT,makerTrackThreshold )

% global InertialData
trackedMakerPosition_k_OK = NaN ;
otherMakersPosition_k = otherMakers_k.Position ;
TrackFlag = 0;

M = size(otherMakersPosition_k,2) ;
dP_Inertial = InertialPosition(:,inertial_k) - InertialPosition(:,inertial_dT_k_last);
dP_Inertial_xy = dP_Inertial(1:2);
dP_Inertial_z = dP_Inertial(3);  % ����Ϊ��
dPErrorNorm_dT  = zeros(1,M);
dPError_dT_xy  = zeros(1,M);
dPError_dT_z  = zeros(1,M);
dP_Vision = zeros(3,M);
angleErr_dT  = NaN(1,M);
angleErr_dT_Min = NaN;
%% λ�Ʋ� ģ�� �ǶȲ�
for i=1:M
    otherMakersPosition_k_i = otherMakersPosition_k(:,i);
    dP_Vision(:,i) = otherMakersPosition_k_i - trackedMakerPosition_last_k_dT;
    % λ�Ʋ�
    dPErrorNorm_dT(i) = normest(dP_Inertial-dP_Vision(:,i)) ;
    dPError_dT_xy(i) = normest(dP_Inertial_xy-dP_Vision(1:2,i)) ;
    dPError_dT_z(i) = dP_Inertial_z-dP_Vision(3,i);  
    % ��ͷʱ��dP_Inertial_z��dP_Vision(3,i)��Ϊ����dP_Vision(3,i)��ģ����dPError_dT_z(i)Ϊ��
    
    % �ǶȲ�
    temp = dP_Inertial'*dP_Vision(:,i) / normest(dP_Inertial) / normest(dP_Vision(:,i)) ;
    angleErr_dT(i) = acos(temp) ;
end



[dPErrorNorm_dT_Min,min_dT_k] = min(dPErrorNorm_dT,[],2);  % ȡλ�Ʋ���С�ĵ��ж�
dPError_dT_z_Min = dPError_dT_z(min_dT_k);
% ����λ�ƴ�С �� ���۾�ֹ�����˶�
otherMakersPosition_k_min = otherMakersPosition_k(:,min_dT_k);
dP_Inertial_Norm = normest(dP_Inertial) ;  
dP_Inertial_xyNorm_Min = normest(dP_Inertial(1:2)) ;
dP_Inertial_z_Min = dP_Inertial(3) ;
if dP_Inertial_Norm < makerTrackThreshold.MaxStaticDisp_dT  
    %% ׼��ֹ״̬����dSλ���ж�
    if dPErrorNorm_dT_Min > makerTrackThreshold.PositionErrorBear_dT
        % ��˵������˶����޳�
        TrackFlag = -3.1 ;
    else
        % �����Ӿ��˶�λ�Ʋ�С���������ڸ���OK����˵㣬�����OK��
        %% �����жϳ���ʱ������
        if otherMakers_k.ContinuesFlag(min_dT_k)==1
            trackedMakerPosition_k_OK = otherMakersPosition_k(:,min_dT_k) ;
            TrackFlag = 3.1;
            return;
        else
            % �����Ӿ��˶�λ�Ʋ�С����������������4���ж�
            TrackFlag = 1.31;
            return;
        end
    end
    
else
    %% �˶�״̬��
    if otherMakers_k.ContinuesFlag(min_dT_k)==1
       %% ��ǰһʱ�̸��ٳɹ��ĵ�������ſ�Ҫ��
       PositionErrorBear_dT = makerTrackThreshold.PositionErrorBear_dT*makerTrackThreshold.ContinuesTrackedMagnifyRate ;
       Max_dPAngle_dS=  makerTrackThreshold.Max_dPAngle_dS*makerTrackThreshold.ContinuesTrackedMagnifyRate ;
       MaxHighMoveErrRate = makerTrackThreshold.MaxHighMoveErrRate*makerTrackThreshold.ContinuesTrackedMagnifyRate ;
    else
        PositionErrorBear_dT = makerTrackThreshold.PositionErrorBear_dT ;
       Max_dPAngle_dS=  makerTrackThreshold.Max_dPAngle_dS ;
       MaxHighMoveErrRate = makerTrackThreshold.MaxHighMoveErrRate ;
    end
    % ��ֹ��ֱ���޳�
    if normest( dP_Vision(:,min_dT_k) )<makerTrackThreshold.MaxStaticDisp_dT
        TrackFlag=1.35;
        return;
    end
    %% �߶ȱ仯��ˮƽ���򲻿��ţ�ֱ��ͨ���߶��ж�
    if normest(dP_Inertial_z_Min) > makerTrackThreshold.BigHighMove
       HighMoveErr = dPError_dT_z(min_dT_k) / dP_Inertial_z_Min ;
       if HighMoveErr>MaxHighMoveErrRate(1) && HighMoveErr < MaxHighMoveErrRate(2)
           %% �߶ȷ���λ��������С������OK
           TrackFlag = 3.9 ;
           trackedMakerPosition_k_OK = otherMakersPosition_k(:,min_dT_k) ;
           return;
       end
    end
    %% ���ǶȲ��ж�Ϊ�������˶����볬�� moveDistance ʱ���жϽǶȲ���ſ�λ�Ʋ�����
    if dP_Inertial_Norm > makerTrackThreshold.moveDistance
       if angleErr_dT(min_dT_k) <  makerTrackThreshold.Max_dPAngle_dS && dPErrorNorm_dT_Min < makerTrackThreshold.MaxPositionError_dS
            trackedMakerPosition_k_OK = otherMakersPosition_k_min ;
            TrackFlag = 3.7;
            angleErr_dT_Min = angleErr_dT(min_dT_k) ;
            return;
       end
    end
    %% λ�Ʋ��ж�Ϊ��
    if dPErrorNorm_dT_Min < PositionErrorBear_dT  && angleErr_dT(min_dT_k) <  Max_dPAngle_dS*2
        trackedMakerPosition_k_OK = otherMakersPosition_k_min ;
        TrackFlag = 3.5;
    %     fprintf( '3.5�������Ӿ�λ�Ʋ��=%0.4f ������OK\n',normest(dPError_dT) );
        return;
    end
    TrackFlag=1.37;
end

if TrackFlag==0
   disp('error')  
end

%% ��˵��������ж�
% dPi_ConJudge �� �������ж�ָ��Ĵ�С��ǰ����֡��λ��ģ
% ContinuesFlag = 0   ������
%               =1    ��������������ٳɹ���˵�����
%               =2   �������͸���ʧ�ܵĵ�����
function [ otherMakers_k,dPi_ConJudge ] = ContinuesJudge( otherMakers_k,otherMakers_k_last,trackedMakerPosition,k_vision,makerTrackThreshold )


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

dPi_ConJudge=nan;

if k_vision>1 
    
    if ~isnan(trackedMakerPosition(1,k_vision-1))
        %% ֻ�жϵ�ǰ��˵��Ƿ���ǰʱ�̸��ٳɹ�����˵�����
        trackedMakerPosition_kLast = trackedMakerPosition(:,k_vision-1) ;
        otherMakersPosition_k_Dis = otherMakersPosition_k(:,1:M)-repmat(trackedMakerPosition_kLast,1,M) ;
        otherMakersPosition_k_Dis_Norm = zeros(1,M);
        for j=1:M
            otherMakersPosition_k_Dis_Norm(j) = normest(otherMakersPosition_k_Dis(:,j));
        end
        [dPi_ConJudge,minCon_k] = min(otherMakersPosition_k_Dis_Norm);  
        if dPi_ConJudge < makerTrackThreshold.MaxContinuesDisplacement
    %         trackedMakerPosition_k_OK = otherMakersPosition_k(:,m) ;
    %         TrackFlag = 1;
    %         fprintf('��˵�������λ��=%0.4f������OK \n',Min_otherMakersPosition_k_Dis_Norm);
            
            otherMakers_k.ContinuesFlag(minCon_k) = 1 ; % ��������������ٳɹ���˵�����
            otherMakers_k.ContinuesLastPosition(:,minCon_k) = trackedMakerPosition_kLast ;
            otherMakers_k.ContinuesLastTime(minCon_k) = otherMakers_k_last.time ;
            otherMakers_k.ContinuesLastK(minCon_k) = k_vision-1 ;
        end
        
    else
        %% �жϵ�ǰ��˵��Ƿ�Ϊ������˵㣬��¼ÿ�����Ӧ�����磨��������dT��������
        M_last = otherMakers_k_last.otherMakersN ;
        if M_last==0
            % ��ʱ������˵�
            for i=1:M
                otherMakers_k.ContinuesFlag(i) = 0 ; % ������
                otherMakers_k.ContinuesLastPosition(:,i) = NaN ;
                otherMakers_k.ContinuesLastTime(i) = NaN ;
                otherMakers_k.ContinuesLastK(i) = NaN ;
            end
            dPi_ConJudge=nan;
            return;
        end
        % һ���� M*M_last �����
        for i=1:M
            dPi = repmat(otherMakers_k.Position( :,i ),1,M_last)- otherMakers_k_last.Position ;
            dPiNorm = zeros(1,M_last);
            for j=1:M_last
                dPiNorm(j) = normest(dPi(:,j));
            end
            
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
                    otherMakers_k.ContinuesLastTime(i) = otherMakers_k_last.time ;                    
                elseif otherMakers_k_last.ContinuesFlag(min_i) == 1 
                    % ����ٳɹ����������ɹ���������ʶ��ʧ�ܵ���������ݵ����ڡ��������ʱ�䳬��2�룬���ٴ��ݡ�
                    if (otherMakers_k_last.ContinuesLastTime(min_i)-otherMakers_k.time) > 20
                        otherMakers_k.ContinuesFlag(i) = 2 ;
                    else
                        otherMakers_k.ContinuesFlag(i) = 1 ;
                    end                    
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
global inertialFre InertialData_visual_k
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
%         kCurrent_Vision = InertialK_to_VisionK(kCurrent-i);
        kCurrent_Vision = InertialData_visual_k(kCurrent-i);
        if ~isnan(trackedMakerPosition(1,kCurrent_Vision))            
            % �������㣬�� trackedMakerPosition ���ٳɹ�
            dS_Inertial_last_k = double(kCurrent-i) ;
            break;
        end
    end
 %   waitbar(i/kCurrent);
end
%close(wh)
disp('')

