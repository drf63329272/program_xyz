%% xyz 2015.6.24

%% �������Լ��ٶ�

function AnalyzeINSAcc(  )

clc
clear all
% close all
global dataFolder 
 dataFolder = 'E:\data_xyz\Hybrid Motion Capture Data\6.25\ˤͷ1';
% dataFolder = 'E:\data_xyz\Hybrid Motion Capture Data\6.25\ͷ-�ۺ�';
dataName = 'CalculationData';
% dataName = 'GlobalAcc';

%% load data
CalStruct = ReadCalData ( dataFolder,dataName ) ;

HeadA = CalStruct.Head.A ;
LeftHandA = CalStruct.LeftHand.A ;
LeftFoot = CalStruct.LeftFoot.A;

HeadA(3,:) = HeadA(3,:)-1 ;
LeftHandA(3,:) = LeftHandA(3,:)-1 ;
LeftFoot(3,:) = LeftFoot(3,:)-1 ;

inertialFre = 96;
inertialN = size(HeadA,2);



%% ����ͷ�Ĳ���Ͳ���
    %% ��������
waveThreshold_INSAcc = SetWaveThresholdParameters( 'INSAcc' );
    %% HeadA ���Ԥ��
HeadA_V = NaN(5,inertialN);  
HeadA_WaveFlag = NaN(3,inertialN); 
HeadA_Acc_waveFront = NaN(3,inertialN);
HeadA_Acc_waveBack = NaN(3,inertialN);
HeadA_k_waves_OKLast = zeros(3,1);  % ��¼��һʱ���жϳɹ��ĵ㣨��ֹ�жϳɹ��ĵ㱻���ǣ�

    %% LeftHandA ���Ԥ��
LeftHandA_V = NaN(5,inertialN);  
LeftHandA_WaveFlag = NaN(3,inertialN); 
LeftHandA_Acc_waveFront = NaN(3,inertialN);
LeftHandA_Acc_waveBack = NaN(3,inertialN);
LeftHandA_k_waves_OKLast = zeros(3,1);  % ��¼��һʱ���жϳɹ��ĵ㣨��ֹ�жϳɹ��ĵ㱻���ǣ�

    %% ��������
for j=1:inertialN
    [ HeadA_WaveFlag,HeadA_V,HeadA_Acc_waveFront,HeadA_Acc_waveBack,HeadA_k_waves_OKLast ] = AnalyzeWave...
    ( HeadA,j,inertialFre,HeadA_V,HeadA_WaveFlag,HeadA_k_waves_OKLast,HeadA_Acc_waveFront,HeadA_Acc_waveBack,waveThreshold_INSAcc );

    [ LeftHandA_WaveFlag,LeftHandA_V,LeftHandA_Acc_waveFront,LeftHandA_Acc_waveBack,LeftHandA_k_waves_OKLast ] = AnalyzeWave...
    ( LeftHandA,j,inertialFre,LeftHandA_V,LeftHandA_WaveFlag,LeftHandA_k_waves_OKLast,LeftHandA_Acc_waveFront,LeftHandA_Acc_waveBack,waveThreshold_INSAcc );

%     %% �����ٶ�
%    [ Velocity_k,k_calV ] = CalVelocity( HeadA,j,inertialFre,0.15,0.1,2 ) ;
%    if k_calV>0  && ~isnan(Velocity_k(1))
%         HeadA_V(:,k_calV) = Velocity_k ;
%    end
%    %% �ж� �� k_wave_i = k_calV - adjacentN; ����� ���岨������
%    [ WaveFlag_k,k_waves,data_Acc_k_wave ] = FindCrestThrough( HeadA,inertialFre,HeadA_V,k_calV,adjacentN,...
%        waveThreshold_Min_dataA,MinWaveData );
%    % �� k_waves(i) �����жϳɹ��󣬺����� adjacentN ����Ͳ����жϣ���Ȼ���ܻ�������з������ǵ�����
%    for i=1:3       
%        if k_waves(i)>0 && k_waves(i)~=k_waves_OKLast(i)
%            HeadA_WaveFlag(i,k_waves(i)) = WaveFlag_k(i);
%            data_Acc_wave(i,k_waves(i)) = data_Acc_k_wave(i);
%        end
%        % ��¼��һʱ�� �жϳɹ���λ��
%        if ~isnan(WaveFlag_k(i))
%            k_waves_OKLast(i) = k_waves(i);
%        end
%    end
end

if coder.target('MATLAB')
    DrawWaveSearchResult( HeadA,inertialFre,HeadA_V,HeadA_WaveFlag,HeadA_Acc_waveFront,HeadA_Acc_waveBack,'HeadA',inertialN );
    DrawWaveSearchResult( LeftHandA,inertialFre,LeftHandA_V,LeftHandA_WaveFlag,LeftHandA_Acc_waveFront,LeftHandA_Acc_waveBack,'LeftHandA',inertialN );
end


