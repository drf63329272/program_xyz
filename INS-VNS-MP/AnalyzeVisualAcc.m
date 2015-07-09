%% xyz 2015.6.24

%% otherMakers
% otherMakers(k).Position
% otherMakers(k).otherMakersN
%��otherMakers(k).time

% otherMakers(k).frequency
% otherMakers(k).MarkerSet

%     otherMakers(k).ContinuesFlag = NaN;
%     otherMakers(k).ContinuesLastPosition = NaN(3,1);
%     otherMakers(k).ContinuesLastTime = NaN;
%     otherMakers(k).ContinuesLastK = NaN;
%                     ContinuesLasti

%     otherMakers(k).CalculatedTime  ������� ��ʼ=0



%% �����ѧ�ļ��ٶ�

function AnalyzeVisualAcc(  )
global dataFolder
%  dataFolder =  'E:\data_xyz\Hybrid Motion Capture Data\7.6data\1Person3Points_2';
dataFolder = 'E:\data_xyz\Hybrid Motion Capture Data\7.2 dataB\T2';
%��dataFolder = 'E:\data_xyz\Hybrid Motion Capture Data\5.28\5.28-head6';
otherMakers = ReadOptitrack( dataFolder,'\Opt.txt' );

otherMakers = FullotherMakersField( otherMakers );

BothCutT = 8;
INS_StartK = fix(( BothCutT+4.01 )*120);
VNSstartK = fix(BothCutT*120.0158);
otherMakers = CutData( otherMakers,VNSstartK );

visualN = size(otherMakers,2);
global visionFre   

%% ���������Ԥ��
trackedMakerPosition = NaN(3,visualN);  % �޸�������µ�������
visionFre = otherMakers(1).frequency;
otherMakersContinues = Initial_otherMakersContinues( visualN );
A_k_waves_OKLast_All = zeros(3,20);

[ makerTrackThreshold,INSVNSCalibSet ] = SetConstParameters( visionFre );
waveThreshold_VNSAcc = SetWaveThresholdParameters( 'VNSAcc' );

parametersSet.waveThreshold_VNSAcc = waveThreshold_VNSAcc;
parametersSet.INSVNSCalibSet = INSVNSCalibSet;

%%  ��ʼ
otherMakersN1 = otherMakers(1).otherMakersN ;
otherMakers(1).ContinuesFlag = zeros(1,otherMakersN1);

otherMakers(1) = PreProcess_otherMakers( otherMakers(1)  );

for k_vision=2:visualN

    
    otherMakers(k_vision) = PreProcess_otherMakers( otherMakers(k_vision)  );
    otherMakers_k_last = otherMakers(k_vision-1);
    [ otherMakers(k_vision),dPi_ConJudge ] = ContinuesJudge( otherMakers(k_vision),otherMakers_k_last,trackedMakerPosition,...
        k_vision,makerTrackThreshold );
    
        % ���ϸ����� k_vision ʱ�̵���˵���������Ϣ��
        %% ���� otherMakers(k_vision) ���� ��ǰ���������� 
        % ÿ��ʱ�̽� otherMakersContinues �����µ� otherMakers ��Ž������򣬲�����˳����·���
    ContinuesLasti_All = otherMakers(k_vision).ContinuesLasti ;  % ��ǰʱ�� ������˵� ��Ӧ�� ��ʱ����˵����
    % �Ƚ� otherMakersContinues �����µ���˵��������
    [otherMakersContinues,A_k_waves_OKLast_All] = ReOrderContinues( ContinuesLasti_All,otherMakersContinues,A_k_waves_OKLast_All ) ;
    otherMakersN = otherMakers(k_vision).otherMakersN ;
    for i_marker=1:otherMakersN
        if k_vision == 637 && i_marker==3   % 1290-VNSstartK
       %       DrawAllVNSPosition( otherMakersContinues,visionFre,otherMakersN,k_vision,dataFolder );
         Draw_otherMakersContinues( otherMakersContinues,i_marker,visionFre,k_vision );
        end
        
        [ otherMakersContinues,A_k_waves_OKLast_All(:,i_marker) ] = AnalyzeVNSAWave...
            ( otherMakers,k_vision,i_marker,otherMakersContinues,parametersSet,visionFre,A_k_waves_OKLast_All(:,i_marker) ) ;
        
    end

   
end

[ k_vision_L,maker_i_L,maxConN ] = FindLongestLine( otherMakers );
% GetContinues( otherMakers,k_vision_L,maker_i_L,INSVNSCalibSet );
k_vision_L
maker_i_L


disp('')



function data = CutData( data,startK )
[M,N] = size(data);
data = data(:,startK:N);

    
% % �������ӵĵ� NewPosition_i ���µ�  otherMakersContinues
% otherMakersContinues = Write_otherMakersContinues_i( otherMakersContinues,i_marker,ConPosition_i_new,1,dataN_i_P_new );
% ConPosition_i_new_Valid = ConPosition_i_new( :,1:ConN_i );

%%  (��ʵʱ)���� �� k_vision ��ʱ�� �� i_marker ����˵� ��Ӧ�������ߵ� �ٶ����� ���ٶ�����

function [ ConPosition_i,ConVelocity,ConAcc,ConN ] = GetContinues( otherMakers,k_vision,i_marker,INSVNSCalibSet )
global visionFre  
[ ConPosition_i,ConN] = GetContinuesPosition( otherMakers,k_vision,i_marker );

% [ otherMakersContinues,ConPosition_i,ConN] = GetContinuesPosition_2...
%     ( otherMakers,k_vision,i_marker,otherMakersContinues );

ConVelocity = NaN(5,ConN);           
for j=1:ConN
    %% ������˵��ٶ�
   [ Velocity_k,k_calV ] = CalVelocity( ConPosition_i,j,visionFre,INSVNSCalibSet.dT_CalV_Calib,INSVNSCalibSet.MinXYVNorm_CalAngle ) ;
   if k_calV>0  && ~isnan(Velocity_k(1))
        ConVelocity(:,k_calV) = Velocity_k ;
   end
end


ConAcc = NaN(5,ConN);
for j=1:ConN
    %% ������˵���ٶ�
   [ acc_k,k_calA ] = CalVelocity( ConVelocity(1:3,:),j,visionFre,INSVNSCalibSet.dT_CalV_Calib,INSVNSCalibSet.MinXYVNorm_CalAngle ) ;
   if k_calA>0  && ~isnan(acc_k(1))
        ConAcc(:,k_calA) = acc_k ;
   end
end
%% ���������������� ��֪�ʷ�����
ConAcc = -ConAcc;  


    %% ConAcc ���η���
waveThreshold_VNSAcc = SetWaveThresholdParameters( 'VNSAcc' );

VNSA_V = NaN(5,ConN);  
VNSA_WaveFlag = NaN(3,ConN); 
VNSA_Acc_waveFront = NaN(3,ConN);
VNSA_Acc_waveBack = NaN(3,ConN);
VNSA_k_waves_OKLast = zeros(3,1);  % ��¼��һʱ���жϳɹ��ĵ㣨��ֹ�жϳɹ��ĵ㱻���ǣ�

  %% ��������
for j=1:ConN
    [ VNSA_WaveFlag,VNSA_V,VNSA_Acc_waveFront,VNSA_Acc_waveBack,VNSA_k_waves_OKLast ] = AnalyzeWave...
    ( ConAcc(1:3,:),j,visionFre,VNSA_V,VNSA_WaveFlag,VNSA_k_waves_OKLast,VNSA_Acc_waveFront,VNSA_Acc_waveBack,waveThreshold_VNSAcc );
end

if coder.target('MATLAB')
    DrawPVA( ConPosition_i,ConVelocity,ConAcc,visionFre,k_vision );
    DrawWaveSearchResult( ConAcc,visionFre,VNSA_V,VNSA_WaveFlag,VNSA_Acc_waveFront,VNSA_Acc_waveBack,'VNSAcc',k_vision );
end

%% �ҵ���������߶�
function [ k_vision,i_marker,maxConN ] = FindLongestLine( otherMakers )
N = size(otherMakers,2);
k_vision = 0;
i_marker = 0;
maxConN = 0;
for k=1:N
    OtherMarkersN = otherMakers(k).otherMakersN;
    for i=1:OtherMarkersN
        if otherMakers(k).ContinuesFlag(i) >0        
            ConN = k-otherMakers(k).ContinuesLastK(i);
            if ConN > maxConN
               maxConN =  ConN;
               k_vision = k;
               i_marker = i;
            end
        end
    end
    
end

%% Ѱ�� otherMakers �е� k_vision ��ʱ�̣� �� i_marker ����˵� ��Ӧ�������߶Σ��������ң�
% ConPosition_i [3*ConN_i] ConN_i �Ǹ������߶εĳ���
function [ ConPosition_i,ConN_i] = GetContinuesPosition( otherMakers,k_vision,i_marker )
ContinuesFlag = otherMakers(k_vision).ContinuesFlag(i_marker) ;
ContinuesLasti_cur = otherMakers(k_vision).ContinuesLasti(i_marker) ;
if isnan(ContinuesFlag) || ContinuesFlag==0 || isnan(ContinuesLasti_cur) % ��2������������˵�
    ConPosition_i = NaN;
    ConN_i = 0;
    return;
end

ContinuesLastK = otherMakers(k_vision).ContinuesLastK(i_marker) ;  % �����߶�������ʱ��
ConN_i = k_vision-ContinuesLastK+1 ; % �����߶γ���

ConOrder_i = zeros(1,ConN_i);        % �����߶�ÿ�����Ӧ��
ConPosition_i = zeros(3,ConN_i);

ConOrder_i(ConN_i) = i_marker;  % ���һ�����Լ�
ConPosition_i(:,ConN_i) = otherMakers(k_vision).Position(:,i_marker);
for j=2:ConN_i
    k = k_vision-j+1;
    i = ConN_i-j+1;
    ConOrder_i(i) = otherMakers(k+1).ContinuesLasti(ConOrder_i(i+1));  % k ʱ�̼�¼��
    ConPosition_i(:,i) = otherMakers(k).Position(:,ConOrder_i(i));   
    %  last_k = otherMakers(k_vision-j+1).
end


