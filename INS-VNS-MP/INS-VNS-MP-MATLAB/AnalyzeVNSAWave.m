
%% ʵʱ ������˵�� ���� λ�����ߡ� �ٶ����ߡ� ���ٶ����ߡ� ���ٶ����ߵĲ���
% ֻ����һ��ʱ��

function [ otherMakersContinues,A_k_waves_OKLast ] = AnalyzeVNSAWave( otherMakers,k_vision,i_marker,otherMakersContinues,...
    parametersSet,visionFre,A_k_waves_OKLast )

% persistent A_k_waves_OKLast
% if isempty(A_k_waves_OKLast)
%     A_k_waves_OKLast = zeros(3,1);  % ��¼��һʱ���жϳɹ��ĵ㣨��ֹ�жϳɹ��ĵ㱻���ǣ�
% end

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
    [ Velocity_k,k_calV ] = CalVelocity( ConPosition_i,dataN_i_P_new,visionFre,INSVNSCalibSet.dT_CalV_Calib,INSVNSCalibSet.MinXYVNorm_CalAngle,1 ) ;
    if k_calV>0  && ~isnan(Velocity_k(1))
        ConVelocity_i(:,k_calV) = Velocity_k ;
        
        otherMakersContinues = Write_otherMakersContinues_i( otherMakersContinues,i_marker,ConVelocity_i,2,k_calV );
        
         %% ������˵���ٶ�
        [ acc_k,k_calA ] = CalVelocity( ConVelocity_i(1:3,:),k_calV,visionFre,INSVNSCalibSet.dT_CalV_Calib,INSVNSCalibSet.MinXYVNorm_CalAngle,1 ) ;
                
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
            otherMakersContinues = Write_otherMakersContinues_i( otherMakersContinues,i_marker,AWave,4,A_k_waves_OKLast );
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
if dataN_i_P_new ~= ConN_i && dataN_i_P_new < size(ConPosition_i,2)
    disp('wrong-2 in GetContinuesPosition_2') 
end

