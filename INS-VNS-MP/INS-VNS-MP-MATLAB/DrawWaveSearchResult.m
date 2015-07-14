%% xyz 2015.6.28
%% ���� ���η������ ��һ���㣩
% k_End �� data ���һλ����ԭʼ�����е���š�  �����Ӿ����߶β��������ģ�ͨ�����ͳһʱ��
% data [3*N]
function DrawWaveSearchResult( data,fre,dataV,data_WaveFlag,data_Acc_waveFront,data_Acc_waveBack,dataName,k_End )
global dataFolder
dataA_V_SubRate = 1/5;  % �ɱ�����С HeadA_V ����ͼʱ��

N = size(data,2);
time = ((1:N)+k_End-N) /fre;

dataWave = NaN(3,N);
for k=1:N
    for i=1:3
        dataWave(i,k) = data_WaveFlag(i,k)/data_WaveFlag(i,k)*data(i,k);
    end
end
%% data 
ftime = 0.06;
figure('name',[dataName,' - WaveFlag'])

subplot( 3,1,1 );
plot(time,data(1,:))
title(get(gcf,'name'))
hold on
plot( time,dataV(1,:)*dataA_V_SubRate,'g' )
plot( time,dataWave(1,:),'*r' )
i = 1;
for k=1:N
   if ~isnan(data_WaveFlag(i,k)) 
       text( time(k)-ftime,dataWave(i,k),sprintf('%0.2f',data_WaveFlag(i,k)) );
   end
end
ylabel('x')

subplot( 3,1,2 );
plot(time,data(2,:))
hold on
plot( time,dataV(2,:)*dataA_V_SubRate,'g' )
plot( time,dataWave(2,:),'*r' )
i = 2;
for k=1:N
   if ~isnan(data_WaveFlag(i,k)) 
       text( time(k)-ftime,dataWave(i,k),sprintf('%0.2f',data_WaveFlag(i,k)) );
   end
end
ylabel('y')

subplot( 3,1,3 );
plot(time,data(3,:))
hold on
plot( time,dataV(3,:)*dataA_V_SubRate,'g' )
plot( time,dataWave(3,:),'*r' )
i = 3;
for k=1:N
   if ~isnan(data_WaveFlag(i,k)) 
       text( time(k)-ftime,dataWave(i,k),sprintf('%0.2f',data_WaveFlag(i,k)) );
   end
end
ylabel('z')

saveas(gcf,[dataFolder,'\',get(gcf,'name'),'.fig'])

%% data_Acc_wave
figure('name',[dataName,' -Acc-wave'])
subplot( 3,1,1 );
plot(time,data_Acc_waveFront(1,:),'.r')
hold on
plot(time,data_Acc_waveBack(1,:),'.b')
legend('front','back')

subplot( 3,1,2 );
plot(time,data_Acc_waveFront(2,:),'.r')
hold on
plot(time,data_Acc_waveBack(2,:),'.b')

subplot( 3,1,3 );
plot(time,data_Acc_waveFront(3,:),'.r')
hold on
plot(time,data_Acc_waveBack(3,:),'.b')

