%% xyz 2015.6.28
%% ���� ���η������
% k_End �� data ���һλ����ԭʼ�����е���š�  �����Ӿ����߶β��������ģ�ͨ�����ͳһʱ��
function DrawWaveSearchResult( data,fre,dataV,data_WaveFlag,data_Acc_waveFront,data_Acc_waveBack,dataName,k_End )
global dataFolder
dataA_V_SubRate = 1/5;  % �ɱ�����С HeadA_V ����ͼʱ��

N = size(data,2);
time = ((1:N)+k_End-N) /fre;
%% data 
figure('name',[dataName,' - WaveFlag'])

subplot( 3,1,1 );
plot(time,data(1,:))
title(get(gcf,'name'))
hold on
plot( time,dataV(1,:)*dataA_V_SubRate,'g' )
plot( time,data_WaveFlag(1,:),'*r' )
ylabel('x')

subplot( 3,1,2 );
plot(time,data(2,:))
hold on
plot( time,dataV(2,:)*dataA_V_SubRate,'g' )
plot( time,data_WaveFlag(2,:),'*r' )
ylabel('y')

subplot( 3,1,3 );
plot(time,data(3,:))
hold on
plot( time,dataV(3,:)*dataA_V_SubRate,'g' )
plot( time,data_WaveFlag(3,:),'*r' )
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

