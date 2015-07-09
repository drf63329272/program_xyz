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
% WaveFlag_k  �洢 ������ǿ��ָ�� 1��<0Ϊ���壬>0Ϊ���� 2) =0 Ϊ����  3��  NaN Ϊ�ǲ�����; 
% data_Acc_k_wave [3*2] ��һ���¼ k_waves ǰ��� dataV ƽ��б�ʣ� �ڶ��м�¼�����
% data ����Ч����
% FullWaveDataScope ��  % 100% ��ǿ��ʱ�� data ��Χ

%% ͨ�� WaveFlag_k �Ƿ�Ϊ NaN �ж��Ƿ񲨷�/����
%% ������ǿ��ָ��
%   1�� data ���ٶȴ�С
%   2�� ������ǰ�������ʱ�䳤��
%   3�� ������ data ��Χ


function [ WaveFlag_k,k_waves,data_Acc_k_wave ] = FindCrestThrough...
    ( data,fre,data_V,k_calV,waveThreshold,dataValidN )
%% Input
adjacentT = waveThreshold.adjacentT; % ����Χ�������ֵ��ͬʱ�޶� dataV б�ʼ������䣩
adjacentN = fix(adjacentT*fre);
waveThreshold_Min_dataA = waveThreshold.waveThreshold_Min_dataA;
MinWaveData = waveThreshold.MinWaveData;

step_calT = min(adjacentT,0.15);  % dataV б�ʼ������� 
step_calN = fix(step_calT*fre);
% dT_CalV = waveThreshold.dT_CalV;
% MinXYVNorm_CalAngle = waveThreshold.MinXYVNorm_CalAngle;
FullWaveDataScope = waveThreshold.FullWaveDataScope;

%% 
WaveFlag_k = NaN(3,1);    % ���Բ���Ͳ��ȵļ��ٶ�ֵ

k_wave = k_calV - adjacentN;  % ���жϵĵ�
k_waves = ones(3,1)*k_wave;  % ÿһά�Ƚ���ϸ���󲨵�λ�ÿ��ܲ�һ��
data_Acc_k_wave = NaN(3,2);


if k_wave < adjacentN
    return;
end

for i=1:3
    k_wave_i = k_wave;
        
    % 1.1)  data �븽��10����ƽ��ֵ �Ĳ� ����ֵ���� MinWaveData  
    if abs( data(i,k_wave_i) )< MinWaveData
        continue;
    end
    % 1.2) �ж� data_V(:,k_calV) �ǲ��Ǹո�Խ�� 0 �ߣ�������һ��
    if sign( data_V(i,k_wave_i) )*sign( data_V(i,k_wave_i-1) ) < 1  
        

        
        if( abs(data_V(i,k_wave_i)) > abs(data_V(i,k_wave_i-1)) )  % ��2��ֵ�е�С��
            k_wave_i = k_wave_i-1;
        end
        % ���� k_wave_i �� ǰ�� adjacentN �������� ��ƽ��б��
        data_V_k_wave = data_V(i,k_wave_i);
        
        % ���� data_V б�ʼ�������  [ front_k_calA  k_wave_i  back_k_calA   ]
        step_calA = min( k_calV-k_wave_i,step_calN );
        % ��������б�ʼ�������  [ front_k_calA  k_wave_i  back_k_calA   ]�ڳ����ٶȹյ�
        [ front_k_calA,back_k_calA ] = CheckCalAStep( data_V,k_wave_i,step_calA,i );         
        if isempty(front_k_calA) || isempty(back_k_calA)
            return;
        end
        
        data_V_Back = data_V(i,back_k_calA);     % б�ʼ������� ���һ����
        data_V_Front = data_V(i,front_k_calA);  % б�ʼ������� ��ǰһ����
        if isnan(data_V_Back) || isnan(data_V_Front) || isnan(data_V_k_wave)
            return;
        end
        data_Acc_Back = (data_V_Back-data_V_k_wave)/(k_calV-k_wave_i)*fre ;  % ����һ�ε�б��
        data_Acc_Front = (data_V_k_wave-data_V_Front)/(k_wave_i-k_calV+adjacentN*2)*fre ;  % ǰ��һ�ε�б��
        
        data_Acc_k_wave(i,1) = data_Acc_Front;   % ��¼��ǰ��� data_V б��
        data_Acc_k_wave(i,2) = data_Acc_Back;
        k_waves(i) = k_wave_i;
        
        %% ͨ��������ָ���ж� �Ƿ� Ϊ��Ч�Ĳ�����
        % 1�� data ���� ���ٶ� data_Acc ������
        % 2�� �����ǵ�ʱ�䷶Χ timeScope ����
        % 3�� �����ǵ�dataֵ��Χ dataScope ����
        if sign(data_Acc_Front)*sign(data_Acc_Back) > 0    % ����Ҫ��ͬ�ţ�<0Ϊ���壬>0Ϊ����
            waveSign = sign(data_Acc_Front);  % -1 Ϊ���壬1Ϊ����
                       
            data_Acc_k_absMax = max( abs(data_Acc_Back),abs(data_Acc_Front) );
            data_Acc_k_absMin = min( abs(data_Acc_Back),abs(data_Acc_Front) );
            data_Acc_k_absMean = ( abs(data_Acc_Back)+abs(data_Acc_Front) )/2;
           if data_Acc_k_absMax > waveThreshold_Min_dataA &&  data_Acc_k_absMin > waveThreshold_Min_dataA/3
               
                % �������������ֵ
                MaxSearchN = 5;
                dataAbsMax = abs(data(i,k_wave_i));
                k_wave_i_Final =  k_wave_i;
                for k = k_wave_i-MaxSearchN:min(k_wave_i+MaxSearchN,dataValidN)
                    dataCur = data(i,k);
                    if abs(dataCur) > dataAbsMax
                        dataAbsMax = abs(dataCur);
                        k_wave_i_Final = k;
                    end
                end
                k_wave_i =  k_wave_i_Final;
                
            %% ����������ǿ��
            waveDegree = CalWaveFeatureDegree...
                ( data,data_V,k_wave_i,i,fre,k_calV,dataValidN,adjacentT,FullWaveDataScope,waveThreshold_Min_dataA,data_Acc_k_absMean,waveSign );
            
%             % ���� ǰ���ٶ�=0�ĵ㣨���Ŀ�ʼ���������ٶ�Ϊ0�ĵ㣨���Ľ�����
%                FullSearchT = 0.6;   % 100% ��ǿ��ʱ�� time ��Χ
%                MaxSearchN = fix(FullSearchT/2*fre);  % ���������Χ
%                k_wave_Start = k_wave_i-3;
%                step = 1;
%                for s = 3:MaxSearchN
%                    k = k_wave_i-s;
%                    
%                    if ~isnan(data_V(i,k-1))  % ������ dataV �����������ٶ��������� data ������
%                        %% dataV���������ŵ㣺�ɲ���INS����Ӱ�죬��Ϊ�ٶ��Ǳ�ƽ���ġ�ȱ�㣺�Ӿ����������߱Ƚ϶̣������ٶ�û����ֵ��
%                        if k-1 < 1  % û�����ݣ���������
%                            break;
%                        end
%                        dataVk1 = data_V(i,k);
%                        dataVk2 = data_V(i,k-1);
%                        if sign( dataVk1 ) * sign( dataVk2 ) < 1 % �ٶȱ��                                             
%                             break;% �����Ĳ����� ���   
%                        end
%                        k_wave_Start = k; 
%                    else
%                        %% data���������ŵ㣺��data����Ӱ�죬�����Ӿ��������ⲻ�� 
%                        if k-2*step < 1  % û�����ݣ���������
%                            break;
%                        end
%                        datak1 = data(i,k);
%                        datak2 = data(i,k-1*step);
%                        datak3 = data(i,k-2*step);
% 
%                        WaveStartFlag = sign( datak1-datak2 ) * sign( datak2-datak3 );
%                        if WaveStartFlag ~= 1                         
%                           break; % ������ data �յ�
%                        end
%                        k_wave_Start = k;
%                    end
%                end
%                % �������Ľ���
%                k_wave_Stop = k_wave_i+3;
%                step = 1;
%                for s = 6:MaxSearchN
%                    k = k_wave_i+s;
%                    if ~isnan(data_V(i,k-1))   % ������ dataV �����������ٶ��������� data ������
%                        %% dataV������
%                        if k>k_calV
%                           continue; 
%                        end
%                        dataVk1 = data_V(i,k);
%                        dataVk2 = data_V(i,k-1);
%                        if sign( dataVk1 ) * sign( dataVk2 ) < 1 % �ٶ������յ�                                       
%                             break;% �����Ĳ����� ������        
%                        end
%                        k_wave_Stop = k; 
%                    else
%                        %% data ������
%                        if k+2*step > dataValidN  % û�����ݣ���������
%                            break;
%                        end                   
%                        datak1 = data(i,k);
%                        datak2 = data(i,k+1*step);
%                        datak3 = data(i,k+2*step);                   
%                        WaveStartFlag = sign( datak1-datak2 ) * sign( datak2-datak3 );
%                        if WaveStartFlag ~= 1                         
%                           break; % ������ data �յ�
%                        end
%                        k_wave_Stop = k;
%                    end
%                end
%                %% ��������Χ
%                waveTimeScope = (k_wave_Stop-k_wave_Start)/fre ;
%                waveDataScopeFront = data(i,k_wave_i)-data(i,k_wave_Start) ;
%                waveDataScopeBack = data(i,k_wave_i)-data(i,k_wave_Stop) ;
%                waveDataScopeMean = (abs(waveDataScopeFront)+abs(waveDataScopeBack))/2;
%                % �ۺ�3��ָ�������������ǿ��
%                waveDegree1 = waveTimeScope/(adjacentT*2) ;
%                waveDegree2 = waveDataScopeMean/FullWaveDataScope ;
%                waveDegree3 = data_Acc_k_absMean/(waveThreshold_Min_dataA*4); % ��Ϊ��Сֵ�� 3 ����Ϊ 100% ˮƽ
%                waveDegree = waveSign * ( waveDegree1*0.2 + waveDegree2*0.6 + waveDegree3*0.2 )  ;
               %% ����ǿ�ȴ�����ֵ���ж���Ч
               if abs(waveDegree) > 0.1
                    k_waves(i) = k_wave_i;
                    WaveFlag_k(i) = waveDegree; 
               end
           end
        end
        
%         % Ҫ�� ǰ��ͺ���һ��data_V��б�� ͬ�� �Ҷ��Ƚϴ�
%         if sign(data_Acc_Front)*sign(data_Acc_Back) > 0  % ����Ҫ��ͬ�ţ�<0Ϊ���壬>0Ϊ����
%             % 1�� data ���� ���ٶ� data_Acc ������
%             % 2�� �����ǵ�ʱ�䷶Χ timeScope ����
%             % 3�� �����ǵ�dataֵ��Χ dataScope ����
%             WaveSign = sign(data_Acc_Front);  % <0Ϊ���壬>0Ϊ����
%             
%             data_Acc_k_absMax = max( abs(data_Acc_Back),abs(data_Acc_Front) );
%             data_Acc_k_absMin = min( abs(data_Acc_Back),abs(data_Acc_Front) );
%            if data_Acc_k_absMax > waveThreshold_Min_dataA &&  data_Acc_k_absMin > waveThreshold_Min_dataA/3
%                               
%                % 2) ����/�� ���� �����ж� OK�� ���� 3) �� k_wave_i ����3������ ϸ��λ��
%                % 3��������㸽�� 5 ���� �ҵ�������С��data����Ϊ����/�ȡ�����Ϊ�ٶȵļ�������ӳٻ��ͺ�
%               data_temp = data(i,k_wave_i-2:k_wave_i+2) ;   
%               if isnan( sum(data_temp) )
%                   return;
%               end
%               if data(i,k_wave_i)>0
%                   % ���� ϸ��
%                   [ data_max,k_max ] = max(data_temp,[],2);
%                   data_m = data_max;
%                   k_wave_i = k_wave_i+(k_max-3);                  
%               else
%                   % ���� ϸ��
%                   [ data_min,k_min ] = min(data_temp,[],2);
%                   data_m = data_min;
%                   k_wave_i = k_wave_i+(k_min-3);
%               end
%               
%               % ���� ǰ���ٶ�=0�ĵ㣨���Ŀ�ʼ���������ٶ�Ϊ0�ĵ㣨���Ľ�����
%                MaxSearchN = fix(0.2*fre);  % ���������Χ
%                for k=3:MaxSearchN
%                    k_waveStart =  k_wave_i-k;
%                    dataV_Temp = data_V(i,k_waveStart) ;
%                    
%                end
%                
%               %% 1) 2) 3) �ж�OK
%                   %% ����OK ��¼����/���ȵ� data
%                     k_waves(i) = k_wave_i;
%                     WaveFlag_k(i,1) = data(i,k_wave_i); 
%               
%            end
%         end
        
    end    
end


function  waveDegree = CalWaveFeatureDegree...
    ( data,data_V,k_wave_i,i,fre,k_calV,dataValidN,adjacentT,FullWaveDataScope,waveThreshold_Min_dataA,data_Acc_k_absMean,waveSign )

%% ����������ǿ��
% ���� ǰ���ٶ�=0�ĵ㣨���Ŀ�ʼ���������ٶ�Ϊ0�ĵ㣨���Ľ�����
FullSearchT = 0.6;   % 100% ��ǿ��ʱ�� time ��Χ
MaxSearchN = fix(FullSearchT/2*fre);  % ���������Χ
k_wave_Start = k_wave_i-3;
step = 1;
for s = 3:MaxSearchN
   k = k_wave_i-s;

   if ~isnan(data_V(i,k-1))  % ������ dataV �����������ٶ��������� data ������
       %% dataV���������ŵ㣺�ɲ���INS����Ӱ�죬��Ϊ�ٶ��Ǳ�ƽ���ġ�ȱ�㣺�Ӿ����������߱Ƚ϶̣������ٶ�û����ֵ��
       if k-1 < 1  % û�����ݣ���������
           break;
       end
       dataVk1 = data_V(i,k);
       dataVk2 = data_V(i,k-1);
       if sign( dataVk1 ) * sign( dataVk2 ) < 1 % �ٶȱ��                                             
            break;% �����Ĳ����� ���   
       end
       k_wave_Start = k; 
   else
       %% data���������ŵ㣺��data����Ӱ�죬�����Ӿ��������ⲻ�� 
       if k-2*step < 1  % û�����ݣ���������
           break;
       end
       datak1 = data(i,k);
       datak2 = data(i,k-1*step);
       datak3 = data(i,k-2*step);

       WaveStartFlag = sign( datak1-datak2 ) * sign( datak2-datak3 );
       if WaveStartFlag ~= 1                         
          break; % ������ data �յ�
       end
       k_wave_Start = k;
   end
end
% �������Ľ���
k_wave_Stop = k_wave_i+3;
step = 1;
for s = 6:MaxSearchN
   k = k_wave_i+s;
   if ~isnan(data_V(i,k-1))   % ������ dataV �����������ٶ��������� data ������
       %% dataV������
       if k>k_calV
          continue; 
       end
       dataVk1 = data_V(i,k);
       dataVk2 = data_V(i,k-1);
       if sign( dataVk1 ) * sign( dataVk2 ) < 1 % �ٶ������յ�                                       
            break;% �����Ĳ����� ������        
       end
       k_wave_Stop = k; 
   else
       %% data ������
       if k+2*step > dataValidN  % û�����ݣ���������
           break;
       end                   
       datak1 = data(i,k);
       datak2 = data(i,k+1*step);
       datak3 = data(i,k+2*step);                   
       WaveStartFlag = sign( datak1-datak2 ) * sign( datak2-datak3 );
       if WaveStartFlag ~= 1                         
          break; % ������ data �յ�
       end
       k_wave_Stop = k;
   end
end
%% ��������Χ
waveTimeScope = (k_wave_Stop-k_wave_Start)/fre ;
waveDataScopeFront = data(i,k_wave_i)-data(i,k_wave_Start) ;
waveDataScopeBack = data(i,k_wave_i)-data(i,k_wave_Stop) ;
waveDataScopeMean = (abs(waveDataScopeFront)+abs(waveDataScopeBack))/2;
% �ۺ�3��ָ�������������ǿ��
waveDegree1 = waveTimeScope/(adjacentT*2) ;
waveDegree2 = waveDataScopeMean/FullWaveDataScope ;
waveDegree3 = data_Acc_k_absMean/(waveThreshold_Min_dataA*4); % ��Ϊ��Сֵ�� 3 ����Ϊ 100% ˮƽ
waveDegree = waveSign * ( waveDegree1*0.2 + waveDegree2*0.6 + waveDegree3*0.2 )  ;               

%% ��������б�ʼ�������  [ front_k_calA  k_wave_i  back_k_calA   ]�ڳ����ٶȹյ�
function [ front_k_calA,back_k_calA ] = CheckCalAStep( data_V,k_wave_i,step_calA,i )

front_k_calA=[];
back_k_calA=[];

for s = 3:step_calA
    fk = k_wave_i-s;    
    dataCur = data_V(i,fk);      
    dataFront = data_V(i,fk-1);
    dataBack = data_V(i,fk+1);
    if isnan( dataCur ) || isnan( dataFront )  || isnan( dataBack ) 
       break ;  % û���㹻����
    end
    IsExtremum = sign( dataCur-dataFront ) * sign(dataBack-dataCur);  % �����෴��Ϊ��ֵ��                
    if IsExtremum == -1 || IsExtremum==0 % ��ֵ��                     
        break;
    end
    
    front_k_calA = fk;
end

for s = 3:step_calA
    bk = k_wave_i+s;    
    dataCur = data_V(i,bk);    
    dataFront = data_V(i,bk-1);
    dataBack = data_V(i,bk+1);
    if isnan( dataCur ) || isnan( dataFront )  || isnan( dataBack ) 
       break ;  % û���㹻����
    end
    IsExtremum = sign( dataCur-dataFront ) * sign(dataBack-dataCur);  % �����෴��Ϊ��ֵ��                
    if IsExtremum == -1 || IsExtremum==0 % ��ֵ��                     
        break;
    end
    back_k_calA = bk;
end


               

function DrawCurWave( data,fre,data_V,dataValidN,WaveFlag_k,k_waves,k_wave_Start,k_wave_Stop )
ftime = 0.05;
figure
time = (1:dataValidN);
dataValid = data(:,1:dataValidN);
data_V_Valid = data_V(:,1:dataValidN);

for i=1:3
    subplot(3,1,i)
    hold on
    plot( time,dataValid(i,:) )
    plot( time,data_V_Valid(i,:),'g' )
    if ~isnan(WaveFlag_k(i))
       plot(time(k_waves(i)),dataValid(i,k_waves(i)),'*r') 
       plot( time(k_wave_Start),dataValid(i,k_wave_Start),'or' )
       plot( time(k_wave_Stop),dataValid(i,k_wave_Stop),'or' )
       text( time(k_waves(i))-ftime,dataValid(i,k_waves(i)),sprintf('%0.2f',WaveFlag_k(i)) )
    end
end
