%% xyz 2015 ��ͯ���ع�

%% ���� trackedMarkerVelocity �Զ�ѡ�����ڱ궨���Ժ��Ӿ�����ϵ������
% INSVNSCalib_VS_k �� [2*N]
    % INSVNSCalib_VS_k(1,k)Ϊĳ��λ�Ƶ���ʼ��INSVNSCalib_VS_k(2,k)Ϊĳ��λ�ƵĽ���
function [ INSVNSCalib_VS_k,IsCalibDataEnough,dX_Vision ] = SearchCalibData...
            ( INSVNSCalib_VS_k,trackedMarkerVelocity,trackedMakerPosition,vision_k )

global  visionFre
IsCalibDataEnough = 0;
dX_Vision = [];
if isnan( trackedMarkerVelocity(1,vision_k) ) || isnan( trackedMakerPosition(1,vision_k) )
    return;
end
%% ��ֵ��������
global INSVNSCalibSet
MaxTime_Calib = INSVNSCalibSet.MaxTime_Calib ;  % sec  ���ڱ궨�����ݵ��ʱ��
MaxVXY_DirectionChange_Calib = INSVNSCalibSet.MaxVXY_DirectionChange_Calib ;     % �� XYƽ���ٶȷ���仯���Χ

MaxN_Calib = fix(MaxTime_Calib*visionFre) ;

%% ����һ��λ�Ʋ�����֮��ʼ����
Calib_N_Last = size(INSVNSCalib_VS_k,2);   % �����ɹ��ı궨λ�����ݸ���
if Calib_N_Last>0 
    LastEnd_k = INSVNSCalib_VS_k(2,Calib_N_Last) ;
else
    LastEnd_k = 0 ;  % ��һ������
end
% �� LastEnd_k+1 ������ vision_k
search_k = vision_k ;
%% ����ĩβ��

search_k_end = NaN;
while search_k > LastEnd_k   
    IsCalibDataVelocityOK = CalibDataVelocityJudge( trackedMarkerVelocity(:,vision_k) ) ;
    if IsCalibDataVelocityOK == 1
        search_k_end = search_k ; % �����µ����ݿ�ʼ�������õ���һ��OK�ĵ���Ϊĩβ��
%         fprintf('search_k_end = %d \n ',search_k_end)
        break; 
    end
    search_k = search_k-1 ;
end
if isnan(search_k_end)
    return; % ����ʧ��
end
%% �������
search_k_start = NaN ;
while search_k > LastEnd_k  &&  (search_k_end-search_k+1)<MaxN_Calib
    IsCalibDataVelocityOK = CalibDataVelocityJudge( trackedMarkerVelocity(:,vision_k) ) ;
    if IsCalibDataVelocityOK == 1
        search_k_start_temp = search_k+1 ; % �õ��ٶȴ�С���������� ��ʼ�㣬���ж�λ�Ƴ���
        [ IsCalibDataDistanceOK,dX_xyNorm_VS ] = CalibDataDistanceJudge( trackedMakerPosition,search_k_start_temp,search_k_end ) ;
        
        if IsCalibDataDistanceOK==1
            search_k_start = search_k_start_temp;
            break; 
        end         
    end
    search_k = search_k-1 ;
end
if isnan(search_k_start)
    return; % ����ʧ��
end
%% �ж���������ٶȵĽǶȱ仯�ǹ�С

VelocityDirection = trackedMarkerVelocity( 5,search_k_start:search_k_end );  % �ٶȷ���
VelocityDirectionRange = max(VelocityDirection) - min(VelocityDirection);
if VelocityDirectionRange > MaxVXY_DirectionChange_Calib
    return; % ����ʧ��  �ٶȷ���仯��Χ̫��
end

%% ����һ��λ�Ƴɹ�
INSVNSCalib_VS_k = [ INSVNSCalib_VS_k [search_k_start;search_k_end] ];
%% �жϵ�ǰ����������λ���Ƿ������������
[ IsCalibDataEnough,dX_Vision ] = JudgeIsCalibDataEnough( INSVNSCalib_VS_k,trackedMakerPosition );

searchT = (search_k_end-search_k_start)/visionFre ;
fprintf( '\n ��%d��λ�ƣ�[%d  %d]sec��  \n �Ƕȷ�Χ = %0.2f �㣬λ�Ƴ��� = %0.2f m��\n   ʱ��=%0.2f sec ��ƽ���ٶȣ� %0.2f m/s \n',...
    Calib_N_Last+1,search_k_start/visionFre,search_k_end/visionFre,VelocityDirectionRange*180/pi,dX_xyNorm_VS,searchT,dX_xyNorm_VS/searchT );

%% �ж������õ���λ�����ݹ������࣬�Ƿ��Ѿ����ȷֲ�
function [ IsCalibDataVelocityOK,dX_Vision ] = JudgeIsCalibDataEnough( INSVNSCalib_VS_k,trackedMakerPosition )
global INSVNSCalibSet
angleUniformityErr = INSVNSCalibSet.angleUniformityErr ;

M = size( INSVNSCalib_VS_k,2 );
dX_Vision = zeros(3,M);
dX_Angle = zeros(1,M);
HaveBiggerData = 0;
HaveSmallerData = 0;
IsCalibDataVelocityOK = 0;
for k=1:M
    dX_Vision(:,k) = trackedMakerPosition(:,INSVNSCalib_VS_k(2,k)) - trackedMakerPosition(:,INSVNSCalib_VS_k(1,k))  ;  % �� ��ʼ ָ�� ����
    %% ֻ����ƽ���ڵ�λ��
    dX_Vision(3,k) = 0; 
    %% ��������λ��ʸ�����һ��ʸ���ļн��ж��Ƿ�ֲ�����
    angle = acos( dX_Vision(:,1)'*dX_Vision(:,k)/normest(dX_Vision(:,1))/normest(dX_Vision(:,k)) );
    % ͨ����˿��жϽǶȷ���
    if cross(dX_Vision(:,1),dX_Vision(:,k))<0
        % �� dX_Vision(:,1) �� dX_Vision(:,k) ��ʱ��ת������180��
        angle = -angle ;
    end
    
    % ��dX_Vision(:,1)Ϊ���ģ������е�λ��ʸ��������dX_Vision(:,1)�нǴ���90���򷴺�
    if angle > pi/2
        angle = angle-pi ;
    end
    if angle < -pi/2
        angle = angle+pi ;
    end    
    
    dX_Angle(k) = angle ;
    % �� [60-angleUniformityErr,60+angleUniformityErr] ��
    % [-60-angleUniformityErr,-60+angleUniformityErr] ��Χ�ھ�����λ��ʸ��ʱ�ж��ֲ�����
    if dX_Angle(k) > pi/3-angleUniformityErr && dX_Angle(k) < pi/3+angleUniformityErr
       HaveBiggerData = 1 ; 
    end
    if dX_Angle(k) > -pi/3-angleUniformityErr && dX_Angle(k) < -pi/3+angleUniformityErr
       HaveSmallerData = 1 ; 
    end
    if HaveSmallerData==1 && HaveBiggerData==1
       %% �ж�λ��ʸ������ֲ���������
       IsCalibDataVelocityOK = 1 ;
    end
end
%% ��������������ʱ�����е�λ��ʸ�����Ƴ���
if IsCalibDataVelocityOK==1
   figure('name','dX_Vision') 
   hold on
   for k=1:M
       if k==1
            plot( [-dX_Vision(1,k) dX_Vision(1,k)],[-dX_Vision(2,k) dX_Vision(2,k)],'r' ); 
            hold on 
            plot(dX_Vision(1,k),dX_Vision(2,k),'.r')
       else
           plot( [-dX_Vision(1,k) dX_Vision(1,k)],[-dX_Vision(2,k) dX_Vision(2,k)] ); 
           hold on 
           plot(dX_Vision(1,k),dX_Vision(2,k),'.k')
       end
   end
   dX_Angle_Degree = dX_Angle*180/pi;
end


%% �жϴ� search_k_start �� search_k_end ����һ��λ�Ƴ����Ƿ񹻳�
function [ IsCalibDataDistanceOK,dX_xyNorm_VS ] = CalibDataDistanceJudge( trackedMakerPosition,search_k_start,search_k_end )
%% ��ֵ��������
global INSVNSCalibSet
Min_xyNorm_Calib = INSVNSCalibSet.Min_xyNorm_Calib ; % m  ���ڱ궨�����ݵ���С�˶�λ�Ƴ���

trackedMakerPosition_start = trackedMakerPosition( :,search_k_start );
trackedMakerPosition_end = trackedMakerPosition( :,search_k_end );
dX_VS = trackedMakerPosition_end-trackedMakerPosition_start ;
dX_xy_VS = dX_VS;
dX_xy_VS(3) = 0 ;
dX_xyNorm_VS = normest(dX_xy_VS);
if dX_xyNorm_VS > Min_xyNorm_Calib
    IsCalibDataDistanceOK = 1 ;
else
    % λ�Ƴ���̫��
    IsCalibDataDistanceOK = 0 ;
end

%% �жϴ� search_k_start �� search_k_end ����һ���ٶ��Ƿ���������
% 1�� �ٶ�zģС�� MaxVZ_Calib
% 2�� �ٶ�xyģ���� MinVXY_Calib
function IsCalibDataVelocityOK = CalibDataVelocityJudge( trackedMarkerVelocity_k )
%% ��ֵ��������
global INSVNSCalibSet
MaxVZ_Calib = INSVNSCalibSet.MaxVZ_Calib;     % m/s Z�����ٶ�������ֵ
MinVXY_Calib = INSVNSCalibSet.MinVXY_Calib ;   	% m/s XY ƽ���ٶ�ģ��С����ֵ

IsCalibDataVelocityOK = 0 ;
if isnan(trackedMarkerVelocity_k(1))
   return; 
end
if abs(trackedMarkerVelocity_k(3)) > MaxVZ_Calib
    return;
end
if trackedMarkerVelocity_k(4) < MinVXY_Calib
    return;    
end
IsCalibDataVelocityOK = 1 ;

