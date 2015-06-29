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

%% otherMakersContinues  �洢��ǰ���µ������߶Σ������뵱ǰ�ġ�otherMakers(k).Position������һ��
% otherMakersContinues.otherMakersN  ��˵����
% otherMakersContinues.dataN [5,20]  ��Ч���ݳ���  dataN [1,iMarker]
    % �ǵ�iMarker�����λ����Ч���ȣ� dataN [2,iMarker]���ٶ�
% otherMakersContinues.ConP1 2 3...

%% �����ѧ�ļ��ٶ�

function AnalyzeVisualAcc(  )
global dataFolder
dataFolder = 'E:\data_xyz\Hybrid Motion Capture Data\6.25\ˤͷ1';
%��dataFolder = 'E:\data_xyz\Hybrid Motion Capture Data\5.28\5.28-head6';
otherMakers = ReadOptitrack( dataFolder,'\Opt.txt' );

otherMakers = FullotherMakersField( otherMakers );

visualN = size(otherMakers,2);
global visionFre   

%% ���������Ԥ��
trackedMakerPosition = NaN(3,visualN);  % �޸�������µ�������
visionFre = otherMakers(1).frequency;
otherMakersContinues = Initial_otherMakersContinues( visualN );

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
    otherMakersContinues = ReOrderContinues( ContinuesLasti_All,otherMakersContinues ) ;
    otherMakersN = otherMakers(k_vision).otherMakersN ;
    for i_marker=1:otherMakersN
        
        [ otherMakersContinues ] = AnalyzeContinues( otherMakers,k_vision,i_marker,otherMakersContinues,parametersSet ) ;
        if k_vision==658
            Draw_otherMakersContinues( otherMakersContinues,i_marker,visionFre,k_vision );
        end
    end

   
end

[ k_vision_L,maker_i_L,maxConN ] = FindLongestLine( otherMakers );
% GetContinues( otherMakers,k_vision_L,maker_i_L,INSVNSCalibSet );

% Draw_otherMakersContinues( otherMakersContinues,maker_i_L,visionFre,k_vision_L );

disp('')

%% ʵʱ ������˵�� ���� λ�����ߡ� �ٶ����ߡ� ���ٶ����ߡ� ���ٶ����ߵĲ���
% ֻ����һ��ʱ��

function [ otherMakersContinues ] = AnalyzeContinues( otherMakers,k_vision,i_marker,otherMakersContinues,parametersSet )

global visionFre  
persistent A_k_waves_OKLast
if isempty(A_k_waves_OKLast)
    A_k_waves_OKLast = zeros(3,1);  % ��¼��һʱ���жϳɹ��ĵ㣨��ֹ�жϳɹ��ĵ㱻���ǣ�
end

waveThreshold_VNSAcc = parametersSet.waveThreshold_VNSAcc ;
INSVNSCalibSet = parametersSet.INSVNSCalibSet;
%% ���������߶� λ��

[~,ConPosition_i,ConVelocity_i,ConAcc_i,AWave] = Read_otherMakersContinues_i( otherMakersContinues,i_marker ); % ����ǰ�������߶�
dataN_i_PValid = otherMakersContinues.dataN( 1,i_marker );  % �� i_marker ��˵� λ����Ч����

[ ConPosition_i,dataN_i_P_new] = GetContinuesPosition_2...
    ( otherMakers,k_vision,i_marker,ConPosition_i,dataN_i_PValid );
% �������ӵĵ� NewPosition_i ���µ�  otherMakersContinues
otherMakersContinues = Write_otherMakersContinues_i( otherMakersContinues,i_marker,ConPosition_i,1,dataN_i_P_new );

if dataN_i_P_new>0
    %% ������˵��ٶ�
    [ Velocity_k,k_calV ] = CalVelocity( ConPosition_i,dataN_i_P_new,visionFre,INSVNSCalibSet.dT_CalV_Calib,INSVNSCalibSet.MinXYVNorm_CalAngle ) ;
    if k_calV>0  && ~isnan(Velocity_k(1))
        ConVelocity_i(:,k_calV) = Velocity_k ;
        
        otherMakersContinues = Write_otherMakersContinues_i( otherMakersContinues,i_marker,ConVelocity_i,2,k_calV );
        
         %% ������˵���ٶ�
        [ acc_k,k_calA ] = CalVelocity( ConVelocity_i(1:3,:),k_calV,visionFre,INSVNSCalibSet.dT_CalV_Calib,INSVNSCalibSet.MinXYVNorm_CalAngle ) ;
       if k_calA>0  && ~isnan(acc_k(1))
 %% ���������������� ��֪Ϊ�η����� ��������������������������������������������������
            acc_k = -acc_k;  
            ConAcc_i(:,k_calA) = acc_k ;
            otherMakersContinues = Write_otherMakersContinues_i( otherMakersContinues,i_marker,ConAcc_i,3,k_calA );
            
           %% ConAcc ���η���
            ConAcc_i_valid = ConAcc_i(1:3,1:k_calA) ;
            A_WaveFlag  = AWave( (14:16)-13,:);  
            A_V = AWave((17:21)-13,:); 
            A_Acc_waveFront = AWave((22:24)-13,:); 
            A_Acc_waveBack = AWave((25:27)-13,:);   
              %% ��������
            
             [ A_WaveFlag,A_V,A_Acc_waveFront,A_Acc_waveBack,A_k_waves_OKLast ] = AnalyzeWave...
                ( ConAcc_i_valid,k_calA,visionFre,A_V,A_WaveFlag,A_k_waves_OKLast,A_Acc_waveFront,A_Acc_waveBack,waveThreshold_VNSAcc );
            
            AWave = [  A_WaveFlag;A_V; A_Acc_waveFront; A_Acc_waveBack ];
            otherMakersContinues = Write_otherMakersContinues_i( otherMakersContinues,i_marker,AWave,4,max(A_k_waves_OKLast) );
       end
           
    end
      
end




%% Ѱ�� otherMakers �е� k_vision ��ʱ�̣� �� i_marker ����˵� ��Ӧ�������߶Σ���ǰʱ�̻����ϲ��ң�
% ConPosition_i [3*ConN_i] ConN_i �Ǹ������߶εĳ���
function [ ConPosition_i_new,dataN_i_P_new] = GetContinuesPosition_2...
    ( otherMakers,k_vision,i_marker,ConPosition_i,dataN_i_PValid )
ContinuesFlag = otherMakers(k_vision).ContinuesFlag(i_marker) ;
ContinuesLasti_All = otherMakers(k_vision).ContinuesLasti ;  % ��ǰʱ�� ������˵� ��Ӧ�� ��ʱ����˵����
ContinuesLasti_cur = ContinuesLasti_All(i_marker) ;  % ��ǰʱ�� ������˵� ��Ӧ�� ��ʱ����˵����
if isnan(ContinuesFlag) || ContinuesFlag==0 || isnan(ContinuesLasti_cur) % ��2������������˵�
    ConPosition_i_new = ConPosition_i;
    dataN_i_P_new = dataN_i_PValid;
    return;
end

% �Ƚ� otherMakersContinues �����µ���˵��������
% otherMakersContinues = ReOrderContinues( ContinuesLasti_All,otherMakersContinues ) ;

ContinuesLastK = otherMakers(k_vision).ContinuesLastK(i_marker) ;  % �����߶�������ʱ��
ConN_i = k_vision-ContinuesLastK+1 ; % �����߶γ���

NewPosition_i = otherMakers(k_vision).Position(:, i_marker );  % ���µĵ�
% [~,ConPosition_i] = Read_otherMakersContinues_i( otherMakersContinues,i_marker ); % ����ǰ�������߶�
% dataN_i_P = otherMakersContinues.dataN( 1,i_marker );  % �� i_marker ��˵� λ����Ч����
if ConN_i == 2
   %% �µ��߶ο�ʼ 2����
   NewPosition_i_2 = otherMakers(k_vision-1).Position(:, ContinuesLasti_cur );   % ǰһ������һ���㣩
   NewPosition_i = [ NewPosition_i_2 NewPosition_i ];
   ConPosition_i_new( :,1:2 ) = NewPosition_i;   % ���º�������߶�
   dataN_i_P_new = 2;
   if dataN_i_PValid ~=0  % ��ȷ������£�Ӧ�ò����ڣ����ؿ�
      disp('wrong-1 in GetContinuesPosition_2') 
   end
else
    %% ����ǰʱ�̵��߶� ����һ����
    
    [ ConPosition_i_new,dataN_i_P_new ] = AddListData( ConPosition_i,dataN_i_PValid,NewPosition_i );
end
% ��鳤��
if dataN_i_P_new ~= ConN_i
    disp('wrong-2 in GetContinuesPosition_2') 
end
    
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
        ConN = k-otherMakers(k).ContinuesLastK(i);
        if ConN > maxConN
           maxConN =  ConN;
           k_vision = k;
           i_marker = i;
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

%% ���� otherMakers(k).ContinuesLasti ����ʱ�̵������߶ν�����������
%% ���� �ٶ� ���ٶ� ���β��� ��
% ContinuesLasti ��ǰʱ�� ������˵� ��Ӧ�� ��ʱ����˵����
function otherMakersContinues_New = ReOrderContinues( ContinuesLasti,otherMakersContinues ) 
%% ����Ҫ����
otherMakersN_Last = otherMakersContinues.otherMakersN;
otherMakersN_new = length(ContinuesLasti);

if   otherMakersN_Last==otherMakersN_new
    if otherMakersN_Last == 0 
        otherMakersContinues_New = otherMakersContinues; % ����Ҫ����
        return;
    end

    err = sum(ContinuesLasti - (1:otherMakersN_Last));
    if err == 0
        otherMakersContinues_New = otherMakersContinues; % ����Ҫ����
        return;
    end
end

%% ��Ҫ����
visualN = size(otherMakersContinues.data1,2);
otherMakersContinues_New = Initial_otherMakersContinues( visualN );

otherMakersContinues_New.otherMakersN = otherMakersN_new;

for i=1:otherMakersN_new
    if ~isnan(ContinuesLasti(i)) && ContinuesLasti(i)>0    % otherMakersContinues ��ֵ     
        otherMakersContinues_New.dataN(:,i) = otherMakersContinues.dataN(:,ContinuesLasti(i));
        
        data_i = Read_otherMakersContinues_i( otherMakersContinues,ContinuesLasti(i) );
        otherMakersContinues_New = Write_otherMakersContinues_i( otherMakersContinues_New,i,data_i,0,Inf ); % ���һ��������Ч
    else
        otherMakersContinues_New.dataN(i) = 0;
    end
end

%% �� otherMakers �ĳ�Ա��������
function otherMakers = FullotherMakersField( otherMakers )

visualN = size(otherMakers,2);
if ~isfield(otherMakers(1),'frequency')
   frequency =  visualN/(otherMakers(visualN).time - otherMakers(1).time) ;
   otherMakers(1).frequency = frequency;
end
if ~isfield(otherMakers(1),'MarkerSet')
    otherMakers(1).MarkerSet = 6;
end
for k=1:visualN
    otherMakers(k).frequency = otherMakers(1).frequency;
    otherMakers(k).MarkerSet = otherMakers(1).MarkerSet;
    
    otherMakers(k).ContinuesFlag = NaN;
    otherMakers(k).ContinuesLastPosition = NaN(3,1);
    otherMakers(k).ContinuesLastTime = NaN;
    otherMakers(k).ContinuesLastK = NaN;    
    otherMakers(k).CalculatedTime = 0;
    otherMakers(k).ContinuesLasti = NaN;
    
    otherMakers(k).MarkerSet = 16 ; % head
    
end

function Draw_otherMakersContinues( otherMakersContinues,i_marker,visionFre,k_vision_End )
[~,ConPosition_i,ConVelocity_i,ConAcc_i,AWave] = Read_otherMakersContinues_i( otherMakersContinues,i_marker );
dataN_i_P = otherMakersContinues.dataN( 1,i_marker );
DrawPVA( ConPosition_i(:,1:dataN_i_P),ConVelocity_i(:,1:dataN_i_P),ConAcc_i(:,1:dataN_i_P),visionFre,k_vision_End );

A_WaveFlag  = AWave( (14:16)-13,1:dataN_i_P);  
A_V = AWave((17:21)-13,1:dataN_i_P); 
A_Acc_waveFront = AWave((22:24)-13,1:dataN_i_P); 
A_Acc_waveBack = AWave((25:27)-13,1:dataN_i_P);   
DrawWaveSearchResult( ConAcc_i(:,1:dataN_i_P),visionFre,A_V,A_WaveFlag,A_Acc_waveFront,A_Acc_waveBack,'VNSAcc',k_vision_End );

function DrawPVA( ConPosition_i,ConVelocity,ConAcc,visionFre,k_vision_End )
global dataFolder

visionN = size(ConPosition_i,2);
time = ((1:visionN)+k_vision_End-visionN) /visionFre;

%% x_PVA
figure('name','x-PVA')
subplot(3,1,1)
plot( time,ConPosition_i(1,:) )
title(get(gcf,'name'))
ylabel('x')

subplot(3,1,2)
plot( time,ConVelocity(1,:) )
ylabel('y')

subplot(3,1,3)
plot( time,ConAcc(1,:) )
ylabel('z')

saveas(gcf,[dataFolder,'\',get(gcf,'name'),'.fig'])


%% y_PVA
figure('name','y-PVA')
subplot(3,1,1)
plot( time,ConPosition_i(2,:) )
title(get(gcf,'name'))
ylabel('x')

subplot(3,1,2)
plot( time,ConVelocity(2,:) )
ylabel('y')

subplot(3,1,3)
plot( time,ConAcc(2,:) )
ylabel('z')

saveas(gcf,[dataFolder,'\',get(gcf,'name'),'.fig'])

%% z_PVA
figure('name','z-PVA')
subplot(3,1,1)
plot( time,ConPosition_i(3,:) )
title(get(gcf,'name'))
ylabel('x')

subplot(3,1,2)
plot( time,ConVelocity(3,:) )
ylabel('y')

subplot(3,1,3)
plot( time,ConAcc(3,:) )
ylabel('z')

saveas(gcf,[dataFolder,'\',get(gcf,'name'),'.fig'])

%% ��ʼ�� otherMakersContinues
%  otherMakersContinues ���洢��ǰ���µ������߶Σ������뵱ǰ�ġ�otherMakers(k).Position������һ��
% otherMakersContinues.data_i [*N]  (1:3,:)��λ�ã�(4:8,:)���ٶȣ�(9:13,:)�Ǽ��ٶȣ�
    % (14:16,:)�Ǽ��ٶȲ��β���
function otherMakersContinues = Initial_otherMakersContinues( visualN )

otherMakersContinues = struct;      % ���10�����10sec����������
otherMakersContinues.otherMakersN = 0;
otherMakersContinues.dataN = zeros(5,20);

M = 27;
otherMakersContinues.data1 = NaN( M,visualN );
otherMakersContinues.data2 = NaN( M,visualN );
otherMakersContinues.data3 = NaN( M,visualN );
otherMakersContinues.data4 = NaN( M,visualN );
otherMakersContinues.data5 = NaN( M,visualN );
otherMakersContinues.data6 = NaN( M,visualN );
otherMakersContinues.data7 = NaN( M,visualN );
otherMakersContinues.data8 = NaN( M,visualN );
otherMakersContinues.data9 = NaN( M,visualN );
otherMakersContinues.data10 = NaN( M,visualN );
otherMakersContinues.data11 = NaN( M,visualN );
otherMakersContinues.data12 = NaN( M,visualN );
otherMakersContinues.data13 = NaN( M,visualN );
otherMakersContinues.data14 = NaN( M,visualN );
otherMakersContinues.data15 = NaN( M,visualN );
otherMakersContinues.data16 = NaN( M,visualN );
otherMakersContinues.data17 = NaN( M,visualN );
otherMakersContinues.data18 = NaN( M,visualN );
otherMakersContinues.data19 = NaN( M,visualN );
otherMakersContinues.data20 = NaN( M,visualN );

%% �� �� i ����˵�������߶�д�� otherMakersContinues
% otherMakersContinues.data_i [*N]  (1:3,:)��λ�ã�(4:8,:)���ٶȣ�(9:13,:)�Ǽ��ٶȣ�
    %  AWave = data_i( 14:27,: ); 
        %  (14:16,:)�Ǽ��ٶȲ��β��� VNSA_WaveFlag�� (17:21,:) ��VNSA_V��
        % (22:24,:)��VNSA_Acc_waveFront��(25:27,:) ��VNSA_Acc_waveBack
        
% dataWrite�� ��д�������
% dataN_i_j: �� i ����˵� ��dataWrite ���ݵ���Ч���ȡ�dataN(1,i)�ǵ�ǰ��i��˵��λ��
% dataFlag�� dataWrite ����������
function otherMakersContinues = Write_otherMakersContinues_i( otherMakersContinues,i,dataWrite,dataFlag,dataN_i_j )

switch dataFlag
    case 0  % dataWrite  Ϊ data_i
        data_i  = dataWrite;
    case {1,2,3,4} % dataWrite Ϊ ConPosition_i   
        %  ���� dataN
        otherMakersContinues.dataN(dataFlag,i) = dataN_i_j;
        data_i = Read_otherMakersContinues_i( otherMakersContinues,i );        
        % ��������
        switch dataFlag
            case 1
                M1 = 1;        % ConPosition_i
                M2 = 3; 
            case 2
                M1 = 4;        % ConVelocity_i
                M2 = 8; 
            case 3
                M1 = 9;        % ConAcc_i
                M2 = 13; 
            case 4
                M1 = 14;        % ConAccWaveFlag_i
                M2 = 27; 
           	otherwise
                disp('error-1 in Write_otherMakersContinues_i');
                otherMakersContinues = NaN;
                return;
        end
        data_i( M1:M2,1:size(dataWrite,2) ) = dataWrite;  
    otherwise
        disp('error-2 in Write_otherMakersContinues_i');
        otherMakersContinues = NaN;
        return;
end

switch i
    case 1
        otherMakersContinues.data1 = data_i;
    case 2
        otherMakersContinues.data2 = data_i;
    case 3
        otherMakersContinues.data3 = data_i;
	case 4
        otherMakersContinues.data4 = data_i;
    case 5
        otherMakersContinues.data5 = data_i;
    case 6
        otherMakersContinues.data6 = data_i;
	case 7
        otherMakersContinues.data7 = data_i;
    case 8
        otherMakersContinues.data8 = data_i;
    case 9
        otherMakersContinues.data9 = data_i;
	case 10
        otherMakersContinues.data10 = data_i;
    case 11
        otherMakersContinues.data11 = data_i;
    case 12
        otherMakersContinues.data12 = data_i;
    case 13
        otherMakersContinues.data13 = data_i;
	case 14
        otherMakersContinues.data14 = data_i;
    case 15
        otherMakersContinues.data15 = data_i;
    case 16
        otherMakersContinues.data16 = data_i;
	case 17
        otherMakersContinues.data17 = data_i;
    case 18
        otherMakersContinues.data18 = data_i;
    case 19
        otherMakersContinues.data19 = data_i;
	case 20
        otherMakersContinues.data20 = data_i;
    otherwise
        otherMakersContinues.data1 = data_i;
end

%% �� ��i����˵�� otherMakersContinues ����
% otherMakersContinues.data_i [*N]  (1:3,:)��λ�ã�(4:8,:)���ٶȣ�(9:13,:)�Ǽ��ٶȣ�
    %  AWave = data_i( 14:27,: ); 
        %  (14:16,:)�Ǽ��ٶȲ��β��� VNSA_WaveFlag�� (17:21,:) ��VNSA_V��
        % (22:24,:)��VNSA_Acc_waveFront��(25:27,:) ��VNSA_Acc_waveBack

function [data_i,ConPosition_i,ConVelocity_i,ConAcc_i,AWave] = Read_otherMakersContinues_i( otherMakersContinues,i )

% if dataN_i==0
%     data_i = [];
% else
    switch i
        case 1
                data_i = otherMakersContinues.data1 ;
        case 2
                data_i = otherMakersContinues.data2 ;
        case 3
                data_i = otherMakersContinues.data3 ;
        case 4
                data_i = otherMakersContinues.data4 ;
        case 5
                data_i = otherMakersContinues.data5 ;
        case 6
                data_i = otherMakersContinues.data6 ;
        case 7
                data_i = otherMakersContinues.data7 ;
        case 8
                data_i = otherMakersContinues.data8 ;
        case 9
                data_i = otherMakersContinues.data9 ;
        case 10
                data_i = otherMakersContinues.data10 ;
        case 11
                data_i = otherMakersContinues.data11 ;
        case 12
                data_i = otherMakersContinues.data12 ;
        case 13
                data_i = otherMakersContinues.data1 ;
        case 14
                data_i = otherMakersContinues.data13 ;
        case 15
                data_i = otherMakersContinues.data14 ;
        case 16
                data_i = otherMakersContinues.data15 ;
        case 17
                data_i = otherMakersContinues.data16 ;
        case 18
                data_i = otherMakersContinues.data17 ;
        case 19
                data_i = otherMakersContinues.data18 ;
        case 20
                data_i = otherMakersContinues.data19 ;
        otherwise 
            disp('error in Write_otherMakersContinues_i');
            data_i = NaN;ConPosition_i = NaN;ConVelocity_i = NaN;ConAcc_i = NaN;
            return;
    end
% end

% otherMakersContinues.data_i [*N]  (1:3,:)��λ�ã�(4:8,:)���ٶȣ�(9:13,:)�Ǽ��ٶȣ�
    %  AWave = data_i( 14:27,: ); 
        %  (14:16,:)�Ǽ��ٶȲ��β��� VNSA_WaveFlag�� (17:21,:) ��VNSA_V��
        % (22:24,:)��VNSA_Acc_waveFront��(25:27,:) ��VNSA_Acc_waveBack
M = size(data_i,1);    
if isempty(data_i)
    ConPosition_i = [];
    ConVelocity_i = [];
    ConAcc_i = [];
else
    ConPosition_i = data_i(1:3,:);
    if M>=8
        ConVelocity_i = data_i(4:8,:);
    else
        ConVelocity_i=[];
    end
    if M>=13
        ConAcc_i = data_i(9:13,:);
    else
        ConAcc_i=[];
    end
    if M>=16
        AWave = data_i( 14:27,: );
        
%        AWave.A_WaveFlag = data_i(14:16,:); 
%        AWave.A_V = data_i(17:21,:); 
%        AWave.A_Acc_waveFront = data_i(22:24,:); 
%        AWave.A_Acc_waveBack = data_i(25:27,:); 
    else
        AWave = [];
        
%        AWave.A_WaveFlag = []; 
%        AWave.A_V = [];
%        AWave.A_Acc_waveFront = [];
%        AWave.A_Acc_waveBack = [];
    end
end