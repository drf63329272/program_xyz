%% ������ƽ�ƺ���ת���
% �ο� kitti ������
% rTerror: ���ƽ��ʸ�����(%)  rAerror�������ת�Ƕ���deg/m��  stepLength���������г�
% nav_method='ins'/'vns'/'int'
function [errorRTStr,gh,rTerror,rAerror,pathLength] = CalError_TR( position_true,attitude_true,position_nav,attitude_nav,step,nav_method,dataName )

% step = 100 ;        %  λ����̬�������ָ�� ���� ���� m
 rTbais = 'T�����·��';
%rTbais = 'T����ھ���';
rAbais = 'R�����·��';
% rAbais = 'R����ھ���';

%  method='��μ���';  % ��ÿ��T ��RΪ INS_VNS
method = '��ԭ����'; % ÿ��T�� position

pos = [position_nav;attitude_nav];
truePos = [position_true;attitude_true];
[T,R,trueT,trueR,stepLength] = PosToTR(truePos,pos,step,method) ;   % ���㵼������� T R
N = size(T,2);
if strcmp(method,'��μ���') 
    pathLength = zeros(1,N);
    pathLength(1) = stepLength(1);
    for k=2:N
        pathLength(k) = pathLength(k-1)+stepLength(k);
    end
else
    pathLength=stepLength;
end
% �������
Terror = T-trueT ;              % �õ����Ե� ת�� ʸ�� ��� 

EulerAngleError = zeros(3,N);   % ����ŷ�������
RotAngleError = zeros(1,N);     % ������ά��ת����� ����Ԫ����ʽ�õ���
opintions.headingScope = 180 ;
for k=1:N
    dR=R(:,:,k)*trueR(:,:,k)';
    EulerAngleError(:,k) = GetAttitude(dR,'rad',opintions) ;
    dQ = FCnbtoQ(dR) ;
    RotAngleError(k)=2*acos(dQ(1));
end
% ��������
rTerror = zeros(5,N) ;  % ��4���Ƕ�άƽ�������� ��5������άάƽ��������
L = zeros(1,N);
for k=1:N
   if strcmp(method,'��μ���') 
       % ��ν���
       if strcmp(rTbais,'T�����·��')
            L(k) = stepLength(k) ;        % ����� ·��
        else
            L(k) = GetLength(trueT(:,k));  % �����ֱ�߾���
        end
   else
       % ��ԭ����
       if strcmp(rTbais,'T�����·��')
            L(k) = stepLength(k) ;        % ����� ·��
        else
            L(k) = GetLength(trueT(:,k));  % �����ֱ�߾���
        end
   end
end
for k=1:N
    
    rTerror(1:3,k) = abs(Terror(1:3,k))/L(k) ;       % ȡ����ֵ
    rTerror(4,k) = GetLength(Terror(1:2,k))/L(k) ;
    rTerror(5,k) = GetLength(Terror(1:3,k))/L(k) ;
end
rAerror = zeros(4,N);   % ��4������ά��ת������
% �Ƕȵ������ �Ƕ����/��ʵ·�� deg/m
for k=1:N
    rAerror(1:3,k) = EulerAngleError(:,k)/L(k)*180/pi ;
    rAerror(4,k) = RotAngleError(k)/L(k)*180/pi ;
end

%% ������
% ƽ��ƽ�����
ave_rTerror = mean(rTerror,2)*100 ;
Terror_str = sprintf('[%s] step=%dm ʱ��ƽ�� ƽ�������� ����ֵ��ȥ���ţ�(%s)(%s)��\n',nav_method,step,rTbais,method );
Terror_str = sprintf('%s\tx,y,z���������%0.5g, %0.5g, %0.5g (%%)\n',Terror_str,ave_rTerror(1),ave_rTerror(2),ave_rTerror(3));
Terror_str = sprintf('%s\t��άƽ�棺%0.5g%%\t��άƽ�棺%0.5g%%',Terror_str,ave_rTerror(4),ave_rTerror(5));
%ƽ����ת�����
% ave_rAerror = mean(abs(rAerror),2) ;
% Aerror_str = sprintf('[%s] step=%dm ʱ��ƽ�� ��ת����� ����ֵ��ȥ���ţ�(%s)(%s)��\n',nav_method,step,rAbais,method );
% Aerror_str = sprintf('%s\t�����������ƫ������%0.5g, %0.5g, %0.5g (deg/m)\n',Aerror_str,ave_rAerror(1),ave_rAerror(2),ave_rAerror(3));
% Aerror_str = sprintf('%s\t��ά��ת�ǣ�%0.5g deg/m ',Aerror_str,ave_rAerror(4) );

ave_rAerror = mean(abs(rAerror),2)*3600 ;
Aerror_str = sprintf('[%s] step=%dm ʱ��ƽ�� ��ת����� ����ֵ��ȥ���ţ�(%s)(%s)��\n',nav_method,step,rAbais,method );
Aerror_str = sprintf('%s\t�����������ƫ������%0.5g, %0.5g, %0.5g (��/m)\n',Aerror_str,ave_rAerror(1),ave_rAerror(2),ave_rAerror(3));
Aerror_str = sprintf('%s\t��ά��ת�ǣ�%0.5g ��/m ',Aerror_str,ave_rAerror(4) );

errorRTStr = sprintf('%s\n%s',Terror_str,Aerror_str);
display(errorRTStr);

lineWidth=2.5;
labelFontSize = 16;
axesFontsize = 13;
maker='-s';

ghk=1;
gh(ghk)=figure;
set(cla,'fontsize',axesFontsize)
plot(pathLength,rTerror(1:3,:)*100,maker,'linewidth',lineWidth)
title([nav_method,' Tanslation error'],'fontsize',labelFontSize)
xlabel('Path length (m)','fontsize',labelFontSize)
ylabel('Tanslation error (%)','fontsize',labelFontSize)
legend('x','y','z');
saveas(gcf,[dataName,'\',nav_method,' Tanslation error xyz.fig'])

ghk=ghk+1;
gh(ghk)=figure;
set(cla,'fontsize',axesFontsize)
plot(pathLength,rTerror(5,:)*100,maker,'linewidth',lineWidth)
title([nav_method,' Tanslation error'],'fontsize',labelFontSize)
xlabel('Path length (m)','fontsize',labelFontSize)
ylabel('Tanslation error (%)','fontsize',labelFontSize)
saveas(gcf,[dataName,'\',nav_method,' Tanslation error 3D.fig'])

% ghk=ghk+1;
% gh(ghk)=figure;
% set(cla,'fontsize',axesFontsize)
% plot(pathLength,rTerror(4,:)*100,maker,'linewidth',lineWidth)
% title([nav_method,'Tanslation error'],'fontsize',labelFontSize)
% xlabel('Path length (m)','fontsize',labelFontSize)
% ylabel('Tanslation error (%)','fontsize',labelFontSize)
% saveas(gcf,[dataName,'\',nav_method,' Tanslation error 2D.fig'])

ghk=ghk+1;
gh(ghk)=figure;
set(cla,'fontsize',axesFontsize)
plot(pathLength,rAerror(4,:),maker,'linewidth',lineWidth)
title([nav_method,' Rotation error'],'fontsize',labelFontSize)
xlabel('Path length (m)','fontsize',labelFontSize)
ylabel('Rotation error (deg/m)','fontsize',labelFontSize)
saveas(gcf,[dataName,'\',nav_method,' Rotation error 3D.fig'])

ghk=ghk+1;
gh(ghk)=figure;
set(cla,'fontsize',axesFontsize)
plot(pathLength,abs(rAerror(1:3,:)),maker,'linewidth',lineWidth)
title([nav_method,' Rotation error'],'fontsize',labelFontSize)
xlabel('Path length (m)','fontsize',labelFontSize)
ylabel('Rotation error (deg/m)','fontsize',labelFontSize)
legend('pitch','roll','head');
saveas(gcf,[dataName,'\',nav_method,' Rotation error.fig'])

% ghk=ghk+1;
% gh(ghk)=figure;
% subplot(3,1,1)
% set(cla,'fontsize',axesFontsize)
% plot(pathLength,abs(rAerror(1,:)),maker,'linewidth',lineWidth)
% title([nav_method,' Rotation error(deg/m)'],'fontsize',labelFontSize)
% xlabel('Path length (m)','fontsize',labelFontSize)
% ylabel('pitch error','fontsize',labelFontSize)
% subplot(3,1,2)
% set(cla,'fontsize',axesFontsize)
% plot(pathLength,abs(rAerror(2,:)),maker,'linewidth',lineWidth)
% xlabel('Path length (m)','fontsize',labelFontSize)
% ylabel('roll error','fontsize',labelFontSize)
% subplot(3,1,3)
% set(cla,'fontsize',axesFontsize)
% plot(pathLength,abs(rAerror(3,:)),maker,'linewidth',lineWidth)
% xlabel('Path length (m)','fontsize',labelFontSize)
% ylabel('head error','fontsize',labelFontSize)
% saveas(gcf,[dataName,'\',nav_method,' Rotation error xyz.fig'])

function TL=GetLength(T)
if length(T)==2
    TL=sqrt(T(1)^2+T(2)^2);
elseif length(T)==3
    TL=sqrt(T(1)^2+T(2)^2+T(3)^2);
else
    TL=nan;
end

%% ����λ�� ��̬���->ת�ƺ���ת��
% ÿ step m ����һ��
% pos =[λ��;��̬]
% stepLength: ʵ�ʼ����·�̲���
%  method='��μ���' ��ÿ��T ��RΪ ��μ���
%  method = '��ԭ����' ÿ��T�� position
function [T,R,trueT,trueR,stepLength] = PosToTR(truePos,pos,step,method)
N = length(pos);
R = zeros(3,3,N);
T = zeros(3,N);
trueR = zeros(3,3,N);
trueT = zeros(3,N);
stepLength = zeros(1,N);
[~,routeLength,~] = CalRouteLength( truePos );
if step>routeLength(length(routeLength)-1)
    step=routeLength(length(routeLength)-1) ;
end
k_sr_last = 1 ; 
k_TR = 0;   % �����T R ���
for k_sr=2:N
   if  routeLength(k_sr)-routeLength(k_sr_last) >= step 
       if routeLength(N)-routeLength(k_sr_last)<2*step && k_sr~=N
           % �������һ�β����� step ʱ��������
          continue;  
       end       
       
        % ��ǰ�� step m �ͼ���һ�� ת�ƺ���ת
        k_TR = k_TR+1 ;
        if strcmp(method,'��μ���')
            base_k = k_sr_last ;
        else
            base_k = 1;
        end
        stepLength(k_TR) = routeLength(k_sr)-routeLength(base_k) ;
      	trueT(:,k_TR) = truePos(1:3,k_sr)-truePos(1:3,base_k);
        T(:,k_TR) = pos(1:3,k_sr)-pos(1:3,base_k);
        R1 = pos(4:6,k_sr);
        R2 = pos(4:6,base_k);
        R(:,:,k_TR) = FCbn(R1)' * FCbn(R2) ;
        R1 = truePos(4:6,k_sr);
        R2 = truePos(4:6,base_k);
        trueR(:,:,k_TR) = FCbn(R1)' * FCbn(R2) ;

        k_sr_last = k_sr ;
   end
end
T = T(:,1:k_TR) ;
trueT = trueT(:,1:k_TR) ;
R = R(:,:,1:k_TR) ;
trueR = trueR(:,:,1:k_TR) ;
stepLength = stepLength(1:k_TR);