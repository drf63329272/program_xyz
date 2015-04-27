%% IMU ����
% �� ��̬���ٶ� ΢�� �õ����Ƶ�IMU�����м�ֵ
% ���� trueTrace ���Ѽ�����ʵ��IMU���м������dif_wrbb,dif_arbr�����浽 ��trueTrae
%   ִ����˺����� ��ִ�� newGetTrueTrace �ɵõ� ��ʵIMU

function [trueTrace,dif_wrbb,dif_arbr] = get_trueIMU_wr(trueTrace)

% close all
if ~exist('trueTrace','var')
    raw_data_dir = 'E:\�����Ӿ�����\NAVIGATION\data_kitVO\';
    pro_name = '2011_09_30_drive_0028';
    prodir = [raw_data_dir,pro_name];
    trueTrace = importdata([prodir,'\trueTrace.mat']);
else
    prodir = pwd;
end

position_w = trueTrace.position ;
attitude_w = trueTrace.attitude ;
velocity_w = trueTrace.velocity ;
runTime = trueTrace.runTime_IMU ;

stepTime = runTime_to_setpTime(runTime) ;

dif_wrbb = get_differential(attitude_w,runTime) ;% ΢�ֵõ��Ľ��ٶ� wrbb
dif_arbr = get_differential(velocity_w,runTime) ;% ΢�ֵõ��ļ��ٶ� arbr

trueTrace.dif_wrbb = dif_wrbb ;
trueTrace.dif_arbr = dif_arbr ;

save([prodir,'\dif_wrbb'],'dif_wrbb')
save([prodir,'\dif_arbr'],'dif_arbr')
save([prodir,'\trueTrace'],'trueTrace')
%% �Ա� ΢�ֵõ����ٶ���ʵ�ʵ��ٶ�
dif_velocity_w = get_differential(position_w,runTime) ;% ΢�ֵõ����ٶ�
N_dif = length(dif_velocity_w) ;
figure
hold on
plot(runTime(1:N_dif)',dif_velocity_w(1,:),'r')
plot(runTime',velocity_w(1,:),'b')
legend('dif_v','v')
% saveas(gcf,'v1')

figure
hold on
plot(runTime(1:N_dif)',dif_velocity_w(2,:),'r')
plot(runTime',velocity_w(2,:),'b')
legend('dif_v','v')
% saveas(gcf,'v2')

figure
hold on
plot(runTime(1:N_dif)',dif_velocity_w(3,:),'r')
plot(runTime',velocity_w(3,:),'b')
legend('dif_v','v')
% saveas(gcf,'v3')
%% �Ա� ΢�ֵõ�����̬�����»��ֵ���̬
attitude_w_from_dif = zeros(size(attitude_w)) ;
attitude_w_from_dif(:,1) = attitude_w(:,1);
for k=2:length(attitude_w)
    attitude_w_from_dif(:,k) = attitude_w_from_dif(:,k-1)+dif_wrbb(:,k-1)*stepTime(k-1);
end
figure
hold on
plot(runTime',attitude_w_from_dif(1,:),'r')
plot(runTime',attitude_w(1,:),'b')
legend('from\_dif\_pitch','true\_pitch')
% saveas(gcf,'v1')

figure
hold on
plot(runTime',attitude_w_from_dif(2,:),'r')
plot(runTime',attitude_w(2,:),'b')
legend('from\_dif\_roll','true\_roll')
% saveas(gcf,'v2')

figure
hold on
plot(runTime',attitude_w_from_dif(3,:),'r')
plot(runTime',attitude_w(3,:),'b')
legend('from\_dif\_yaw','true\_yaw')
% saveas(gcf,'v3')
%% �Ա� ΢�ֵõ����ٶ������»��ֵ��ٶ�
velocity_w_from_dif = zeros(size(velocity_w)) ;
velocity_w_from_dif(:,1) = velocity_w(:,1);
for k=2:length(attitude_w)
    velocity_w_from_dif(:,k) = velocity_w_from_dif(:,k-1)+dif_arbr(:,k-1)*stepTime(k-1);
end
figure
hold on
plot(runTime',velocity_w_from_dif(1,:),'r')
plot(runTime',velocity_w(1,:),'b')
legend('from\_dif\_vx','true\_vx')
% saveas(gcf,'v1')

figure
hold on
plot(runTime',velocity_w_from_dif(2,:),'r')
plot(runTime',velocity_w(2,:),'b')
legend('from\_dif\_vy','true\_vy')
% saveas(gcf,'v2')

figure
hold on
plot(runTime',velocity_w_from_dif(3,:),'r')
plot(runTime',velocity_w(3,:),'b')
legend('from\_dif\_vz','true\_vz')
% saveas(gcf,'v3')

disp('')

%% ȡ��ֵ΢��
% ȡÿ���㸽����5�������2�ζ���ʽ��ϣ�ȡ��������ڸõ��б��Ϊ΢��ֵ
function difData = get_differential(data,runTime)

fitNum = 13;         % data ��ϲ���
fitDegree = 4;      % data ��Ͻ״�
smoothSpan = 5;     % difData ƽ������
method = 'rloess'; % difData ƽ���״� 2
%method = 'rlowess'; % difData ƽ���״� 1

smoothSpan_data = 50 ;
method_data = 'sgolay' ;
degree_data = 3 ;
smooth_data = zeros(size(data)) ;
smooth_data(1,:) = smooth(data(1,:),smoothSpan_data,method_data,degree_data);
smooth_data(2,:) = smooth(data(2,:),smoothSpan_data,method_data,degree_data);
smooth_data(3,:) = smooth(data(3,:),smoothSpan_data,method_data,degree_data);

%% �Ա� ƽ��ǰ��� data
% figure
% hold on
% plot(runTime',smooth_data(1,:),'r')
% plot(runTime',data(1,:),'b')
% legend('smooth\_data\_x','data\_x')
% % saveas(gcf,'v1')
% 
% figure
% hold on
% plot(runTime',smooth_data(2,:),'r')
% plot(runTime',data(2,:),'b')
% legend('smooth\_data\_y','data\_y')
% % saveas(gcf,'v2')
% 
% figure
% hold on
% plot(runTime',smooth_data(3,:),'r')
% plot(runTime',data(3,:),'b')
% legend('smooth\_data\_z','data\_z')
% % saveas(gcf,'v3')

data = smooth_data ;
N = length(data) ;
difData = zeros(3,N-1);
P = zeros(3,fitDegree+1,N);        %  data ����ʽ��ϲ���
dif_P = zeros(3,fitDegree,N);    %  difData ����ʽ ��ϲ���
for n=1:N-1
    if n<5 || N-n<5
        fitNum_n = 30 ;
        fitDegree_n = 4 ;
    else
        fitNum_n = fitNum ;
        fitDegree_n = fitDegree ;
    end
   nStart = max(n-2,1) ;
   nEnd = nStart+fitNum_n-1 ;
   if nEnd>N
       nEnd = N ;
       nStart = nEnd-fitNum_n+1 ;
   end
   P(1,:,n) = [zeros(1,fitDegree-fitDegree_n),polyfit(runTime(nStart:nEnd)',data(1,nStart:nEnd),fitDegree_n)];
   P(2,:,n) = [zeros(1,fitDegree-fitDegree_n),polyfit(runTime(nStart:nEnd)',data(2,nStart:nEnd),fitDegree_n)];
   P(3,:,n) = [zeros(1,fitDegree-fitDegree_n),polyfit(runTime(nStart:nEnd)',data(3,nStart:nEnd),fitDegree_n)];
   % ���� dif_P 
   dif_P(:,:,n) = P(:,1:fitDegree,n) ;
   for i=1:fitDegree
       dif_P(:,i,n) = dif_P(:,i,n)*(fitDegree-i+1) ;
   end
end
for n=1:N-1
    difData(1,n) = polyval(dif_P(1,:,n),runTime(n));
    difData(2,n) = polyval(dif_P(2,:,n),runTime(n));
    difData(3,n) = polyval(dif_P(3,:,n),runTime(n));
end

% % �� difData�������ƽ��
% difData(1,:) = smooth(difData(1,:),smoothSpan,method);
% difData(2,:) = smooth(difData(2,:),smoothSpan,method);
% difData(3,:) = smooth(difData(3,:),smoothSpan,method);
