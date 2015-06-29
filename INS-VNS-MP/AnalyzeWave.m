%% xyz  2015.6.28

%% ���岨������ ��ʵʱ��
%% ������data�ĵ� k_data ��ʱ������һ�����岨��
% data [3*N]  ������������
% k_data   % data ���¸������ݵ����
% inertialFre   % data ��Ƶ��
% dataV  data  % ��΢�ֽ��
% data_WaveFlag  %  ���Ĳ����жϽ����1>NaN �޲�������  2> �õ��dataֵ��Ϊ����Ϊ���壬Ϊ����Ϊ���ȡ�
% k_waves_OKLast  % ��¼��һʱ���жϳɹ��ĵ㣨��ֹ�жϳɹ��ĵ㱻���ǣ�
% dataA_waveFront   % ��¼dataVԽ0�ߵĵ�� �� ƽ��dataVб�ʣ�ΪwaveThreshold_Min_dataA��������߲ο���
% dataA_waveBack   % ��¼dataVԽ0�ߵĵ�� �� ƽ��dataVб�ʣ�ΪwaveThreshold_Min_dataA��������߲ο���
% waveThreshold �ж���������
        % .adjacentN  �����µ��ٶ� k_calV �����ϣ����岨���ж��ӳٸ����� [k_calV-adjacentN:k_calV+adjacentN]�����ж� dataV ��б���Ƿ񹻡�
        % .waveThreshold_Min_dataA  ����/���� data_V ��б�ʣ���data�ļ��ٶȣ���Сֵ
        % .MinWaveData  ���岨�ȴ� abs(data) ��Сֵ


function [ data_WaveFlag,dataV,dataA_waveFront,dataA_waveBack,k_waves_OKLast ] = AnalyzeWave...
    ( data,k_data,fre,dataV,data_WaveFlag,k_waves_OKLast,dataA_waveFront,dataA_waveBack,waveThreshold )

%% Ԥ�����

%% ����������
adjacentT = waveThreshold.adjacentT;
adjacentN = fix(adjacentT*fre);
waveThreshold_Min_dataA = waveThreshold.waveThreshold_Min_dataA;
MinWaveData = waveThreshold.MinWaveData;
dT_CalV = waveThreshold.dT_CalV;
MinXYVNorm_CalAngle = waveThreshold.MinXYVNorm_CalAngle;
 %% �����ٶ�
   [ Velocity_k,k_calV ] = CalVelocity( data,k_data,fre,dT_CalV,MinXYVNorm_CalAngle,2 ) ; % ���÷�2���ٶ�
   if k_calV>0  && ~isnan(Velocity_k(1))
        dataV(:,k_calV) = Velocity_k ;
   end
   %% �ж� �� k_wave_i = k_calV - adjacentN; ����� ���岨������
   [ WaveFlag_k,k_waves,data_Acc_k_wave ] = FindCrestThrough( data,fre,dataV,k_calV,adjacentN,...
       waveThreshold_Min_dataA,MinWaveData );
   % �� k_waves(i) �����жϳɹ��󣬺����� adjacentN ����Ͳ����жϣ���Ȼ���ܻ�������з������ǵ�����
   for i=1:3       
       if k_waves(i)>0 && k_waves(i)~=k_waves_OKLast(i)   % ����֮ǰ�ж�OK�ĵ�
           data_WaveFlag(i,k_waves(i)) = WaveFlag_k(i);
           dataA_waveFront(i,k_waves(i)) = data_Acc_k_wave(i,1);
           dataA_waveBack(i,k_waves(i)) = data_Acc_k_wave(i,2);
           %% Ѱ�Ҳ��岨���м��
           if ~isnan(WaveFlag_k(i)) && k_waves_OKLast(i)>0 
               % ���岨������
               k1 = k_waves_OKLast(i);
               k2 = k_waves(i);
              if  size(data,2)>=k1 && ~isnan(data(i,k1)) && sign(data(i,k1)) * sign( data(i,k2) ) == -1
                    % �� k_waves_OKLast(i) �� k_waves(i) �����м��                                   
                    dataV_Search = dataV(i,k1+1:k2-1);
                    % Ҫ�� dataV_Search ȫ����0  ��ȫС��0
                    if abs(sum(sign(dataV_Search))) >= k2-k1-2+1-2
                        dataSearch = abs(data(i,k1:k2));
                        [min_dataAbs,min_k] = min(dataSearch,[],2);
                        if i==3
                           disp('test') 
                        end
                        data_WaveFlag(i,min_k+k1-1) = 0;   %  �м�� ����OK
                    end
              end
           end
       end
       
       
       % ������һʱ�� �жϳɹ���λ��
       if ~isnan(WaveFlag_k(i))
           k_waves_OKLast(i) = k_waves(i);
       end
   end