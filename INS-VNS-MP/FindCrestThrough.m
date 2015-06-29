%% xyz 2015.6.26

%% Ѱ�Ҳ��岨�� �� ��ȵ��м�� (ʵʱ)
% �ո����� �� k_calV ������ٶ�
% �ж� �� k_wave_i = k_calV - adjacentN; ����� ���岨������
        % 1.1)  data ����ֵ���� MinWaveData  
        % 1.2) �ж� data_V(:,k_calV) �ǲ��Ǹո�Խ�� 0 �ߣ�������һ��
        % 2���ж���������5����� data_V б�� ���ұ�5����� data_V б�� �Ƿ�ͬ�����㹻�󣬹�������Ϊ��Ӧһ������/�ȡ�
            %    б���㹻���˼·�кü��֣�����ѡ��ֻҪ�������һ���㹻���OK��
        % 3��������㸽�� 5 ���� �ҵ�������С��data����Ϊ����/�ȡ�����Ϊ�ٶȵļ�������ӳٻ��ͺ�

% data [3*N]  ԭʼ����
% data_V [5*N]  �ٶ���Ϣ
% fre  Ƶ�� HZ
% waveThreshold_Min_dataA  ����/���� data_V ��б�ʣ���data�ļ��ٶȣ���Сֵ
%  adjacentN = 4;  % �����µ��ٶ� k_calV �����ϣ����岨���ж��ӳٸ����� [k_calV-adjacentN:k_calV+adjacentN]�����ж� dataV ��б���Ƿ񹻡�
% MinWaveData % ���岨�ȴ� abs(data) ��Сֵ

% k_waves  Ѱ�ҵĲ���/���� λ�� 
% WaveFlag_k 1) Ѱ��ʧ��Ϊ NaN;  2) ����/���� �򷵻ظõ�� data��WaveFlag_k>0�ǲ��壬<0�ǲ��ȣ�  
    %   3) �����벨��֮���0�� �� 0
% data_Acc_k_wave [3*2] ��һ���¼ k_waves ǰ��� dataV ƽ��б�ʣ� �ڶ��м�¼�����

%% ͨ�� WaveFlag_k �Ƿ�Ϊ NaN �ж��Ƿ񲨷�/����


function [ WaveFlag_k,k_waves,data_Acc_k_wave ] = FindCrestThrough...
    ( data,fre,data_V,k_calV,adjacentN,waveThreshold_Min_dataA,MinWaveData )

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
data_Acc_k_wave = NaN(3,2);

if k_wave<2 || isnan(data(1,k_wave)) || isnan(data_V(1,k_wave)) || isnan(data_V(1,k_wave-1))
   return; 
end

for i=1:3
    k_wave_i = k_wave;
    % 1.1)  data ����ֵ���� MinWaveData  
    if abs(data(i,k_wave_i)) < MinWaveData
        continue;
    end
    % 1.2) �ж� data_V(:,k_calV) �ǲ��Ǹո�Խ�� 0 �ߣ�������һ��
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
        data_Acc_Back = (data_V_Back-data_V_k_wave)/(k_calV-k_wave_i)*fre ;  % ����һ�ε�б��
        data_Acc_Front = (data_V_k_wave-data_V_Front)/(k_wave_i-k_calV+adjacentN*2)*fre ;  % ǰ��һ�ε�б��
        
        data_Acc_k_wave(:,1) = data_Acc_Front;   % ��¼��ǰ��� data_V б��
        data_Acc_k_wave(:,2) = data_Acc_Back;
        
        % Ҫ�� ǰ��ͺ���һ��data_V��б�� ͬ�� �Ҷ��Ƚϴ�
        if sign(data_Acc_Front)*sign(data_Acc_Back) > 0  % ����Ҫ��ͬ��
            % б���㹻���˼·�кü��֣�����ѡ��ֻҪ�������һ���㹻���OK��
            data_Acc_k_absMax = max( abs(data_Acc_Back),abs(data_Acc_Front) );
            data_Acc_k_Mean = (data_Acc_Back+data_Acc_Front)/2;  
           if data_Acc_k_absMax > waveThreshold_Min_dataA &&  abs(data_Acc_k_Mean) > waveThreshold_Min_dataA/4
               % 2) ����/�� ���� �ж� OK�� ���� 3) �� k_wave_i ����3������ ϸ��λ��
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
                  %% ����OK ��¼����/���ȵ� data
                    k_waves(i) = k_wave_i;
                    WaveFlag_k(i,1) = data(i,k_wave_i); 
              
           end
        end
        
    end    
end
        



