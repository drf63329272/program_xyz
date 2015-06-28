%% xyz 2015.6.26

%% Ѱ�Ҳ��岨�� �� ��ȵ��м�� (ʵʱ)
% �ո����� �� k_calV ������ٶ�
% �ж� �� k_wave_i = k_calV - adjacentN; ����� ���岨������
        % 1) �ж� data_V(:,k_calV) �ǲ��Ǹո�Խ�� 0 �ߣ�������һ��
        % 2���ж���������5����� data_V б�� ���ұ�5����� data_V б�� �Ƿ�ͬ�����㹻�󣬹�������Ϊ��Ӧһ������/�ȡ�
        % 3��������㸽�� 5 ���� �ҵ�������С��data����Ϊ����/�ȡ�����Ϊ�ٶȵļ�������ӳٻ��ͺ�
        % 4) Ҫ�󲨷�򲨹ȴ��� data ����ֵ���� MinWaveData

% data [3*N]  ԭʼ����
% data_V [5*N]  �ٶ���Ϣ
% fre  Ƶ�� HZ
% waveThreshold_Min_dataA  ����/���� data_V ��б�ʣ���data�ļ��ٶȣ���Сֵ
%  adjacentN = 4;  %  ���岨���ж��ӳٸ���
% MinWaveData % ���岨�ȴ� abs(data) ��Сֵ

% k_waves  Ѱ�ҵĲ���/���� λ�� 
% WaveFlag_k Ѱ��ʧ��Ϊ NaN,�ɹ��򷵻ظõ�� data��WaveFlag_k>0�ǲ��壬<0�ǲ��ȣ�

%% ͨ�� WaveFlag_k �Ƿ�Ϊ NaN �ж��Ƿ񲨷�/����


function [ WaveFlag_k,k_waves,data_Acc_k_wave ] = FindCrestThrough( data,fre,data_V,k_calV,adjacentN,waveThreshold_Min_dataA,MinWaveData )

% data_V = NaN(5,N);  
% 
% for j=1:N
%     %% �����ٶ�
%    [ Velocity_k,k_calV ] = CalVelocity( data,j,fre,dT_CalV,MinXYVNorm_CalAngle,2 ) ;
%    if k_calV>0  && ~isnan(Velocity_k(1))
%         data_V(:,k_calV) = Velocity_k ;
%    end
% end

WaveFlag_k = NaN(3,1);    % ���Բ���Ͳ��ȵļ��ٶ�ֵ

k_wave = k_calV - adjacentN;  % ���жϵĵ�
k_waves = ones(3,1)*k_wave;  % ÿһά�Ƚ���ϸ���󲨵�λ�ÿ��ܲ�һ��
data_Acc_k_wave = NaN(3,1);

if k_wave<2 || isnan(data(1,k_wave)) || isnan(data_V(1,k_wave)) || isnan(data_V(1,k_wave-1))
   return; 
end

if k_wave==403
   disp(''); 
end

for i=1:3
    k_wave_i = k_wave;
    % 1) �ж� data_V(:,k_calV) �ǲ��Ǹո�Խ�� 0 �ߣ�������һ��
    if sign( data_V(i,k_wave_i) )*sign( data_V(i,k_wave_i-1) ) < 1  
        if( abs(data_V(i,k_wave_i)) > abs(data_V(i,k_wave_i-1)) )  % ��2��ֵ�е�С��
            k_wave_i = k_wave_i-1;
        end
        % ���� k_wave_i �� ǰ�� adjacentN �������� ��ƽ��б��
        data_V_k_wave = data_V(i,k_wave_i);
        data_V_Back = data_V(i,k_calV);     % б�ʼ������� ���һ����
        data_V_Front = data_V(i,k_calV-adjacentN*2);  % б�ʼ������� ��ǰһ����
        if isnan(data_V_Back) || isnan(data_V_Front) || isnan(data_V_k_wave)
            return;
        end
        data_Acc1 = (data_V_Back-data_V_k_wave)/(k_calV-k_wave_i)*fre ;  % ����һ�ε�б��
        data_Acc2 = (data_V_k_wave-data_V_Front)/(k_wave_i-k_calV+adjacentN*2)*fre ;  % ǰ��һ�ε�б��
        % Ҫ�� ǰ��ͺ���һ��data_V��б�� ͬ�� �Ҷ��Ƚϴ�
        if sign(data_Acc1)*sign(data_Acc2) > 0
            % 2) ����/�� ���� �ж� OK�� ���� 3) �� k_wave_i ����3������ ϸ��λ��
            data_Acc_k_wave(i) = (data_Acc1+data_Acc2)/2;  % ��������鿴
           if abs(data_Acc1) > waveThreshold_Min_dataA && abs(data_Acc2) > waveThreshold_Min_dataA              
              % 3��������㸽�� 5 ���� �ҵ�������С��data����Ϊ����/�ȡ�����Ϊ�ٶȵļ�������ӳٻ��ͺ�
              data_temp = data(i,k_wave_i-2:k_wave_i+2) ;   
              if isnan( sum(data_temp) )
                  return;
              end
              if data(i,k_wave_i)>0
                  % ���� ϸ��
                  [ data_max,k_max ] = max(data_temp,[],2);
                  data_m = data_max;
                  k_wave_i = k_wave_i+(k_max-3);                  
              else
                  % ���� ϸ��
                  [ data_min,k_min ] = min(data_temp,[],2);
                  data_m = data_min;
                  k_wave_i = k_wave_i+(k_min-3);
              end
              %% 1) 2) 3) �ж�OK
              %% 4) Ҫ�󲨷�򲨹ȴ��� data ����ֵ���� MinWaveData
              if abs(data_m)>MinWaveData
                  %% ����OK ��¼����/���ȵ� data
                    k_waves(i) = k_wave_i;
                    WaveFlag_k(i,1) = data(i,k_wave_i); 
              end              
           end
        end
        
    end    
end
        



