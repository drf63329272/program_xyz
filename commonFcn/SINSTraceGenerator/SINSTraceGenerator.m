%% xyz 2015.4.27 ������˶ʿ�汾 newGetTrueTrace
% ����������ϵ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ʼ���ڣ�2013.12.6
% 2014.5.5�޸ģ�
% ���ߣ�xyz
% ���ܣ��켣������
%   �ο�ϵΪ��������ϵ����ʼʱ�̶���������ϵ��
% 5.18�� velocity_t(:,1) = Cbt*initialVelocity_r ;velocity_r(:,1) =
%       Cbr*initialVelocity_r ; Ϊ velocity_t(:,1) =initialVelocity_r ; velocity_r(:,1) = initialVelocity_r ;
% 6.7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function trueTrace = SINSTraceGenerator(isPlotFigure,trueTrace)
format long
% ��������ϵ�켣������
if ~exist('isPlotFigure','var')
    isPlotFigure  = 1 ;
end
if ~exist('trueTrace','var')
    load('trueTrace.mat')
else
    trueTrace=[];
end
isUseOld=0;
if isfield(trueTrace,'trueTraceInput')
   button = questdlg('�Ƿ����trueTrace�еĹ켣�������ã�'); 
   if strcmp(button,'Yes');
        planet = trueTrace.planet ;
        trueTraceInput = trueTrace.trueTraceInput ;
        initialPosition_e = trueTraceInput.initialPosition_e;
        initialAttitude_r = trueTraceInput.initialAttitude_r ;
        initialVelocity_r = trueTraceInput.initialVelocity_r ;
        realTimefb = trueTraceInput.realTimefb ;
        realTimeWb = trueTraceInput.realTimeWb ;
        traceName = trueTraceInput.traceName ;
        frequency = trueTraceInput.frequency ;
        runTimeSec = trueTraceInput.runTimeSec ;
        runTimeNum=runTimeSec*frequency+1;
        T=1/frequency*ones(1,runTimeNum);     % sec
        isUseOld=1;
   end
end
isReverseIMU = 0 ;  % �Ƿ�ͨ���ٶȺ���̬���Ƴ�IMU
if isUseOld==0
    button = questdlg('�Ƿ�ͨ���ٶȺ���̬���Ƴ�IMU��'); 
   if strcmp(button,'Yes');
       trueTrace=[];
        isReverseIMU = 1 ;
        [FileName,PathName] = uigetfile('*.mat','��������켣���õ� trueTrace ');
        trueTrace_mesr = importdata([PathName,FileName]);
        
        initialPosition_e = trueTrace_mesr.initialPosition_e ;
        initialPosition_r = trueTrace_mesr.initialPosition_r ;
        initialVelocity_r = trueTrace_mesr.initialVelocity_r  ;
        initialAttitude_r=  trueTrace_mesr.initialAttitude_r  ;
        frequency = trueTrace_mesr.frequency  ;
        traceName = 'kitti';
        planet = 'e';
        
        dif_wrbb = trueTrace_mesr.dif_wrbb ;
        dif_arbr = trueTrace_mesr.dif_arbr ;
        runTime_IMU = trueTrace_mesr.runTime_IMU ;
        position_In = trueTrace_mesr.position ; 
        attitude_In = trueTrace_mesr.attitude ;
        velocity_In = trueTrace_mesr.velocity ;
        runTimeNum = length(attitude_In);
        
        T = runTime_to_setpTime(runTime_IMU) ;
        T = [T; T(runTimeNum-1)];
        realTimeWb = dif_wrbb ;
        realTimefb=[];
   end
end
%% ���� 5���������
% ���úţ�����19.5�ȣ�340.5�㣩,��γ44.1��
if isUseOld==0 && isReverseIMU==0
    prompt={'��ʼ���Դ��λ��(����/��γ��/��߶�/m)��            -','��ʼ��̬����ʼ����ϵ/����ϵ���������������ƫ����(��)��','��ʼ�ٶȣ�����ϵ�·ֽ⣩(m/s)��','ʵʱ���ٶȣ�����ϵ�·ֽ⣩(m/s^2)��','ʵʱ��̬�仯�ʣ�����ϵ�·ֽ⣩(��/s)��','����Ƶ��(HZ)','ʱ��(s)','�켣����','����(m)/����(e)'};

     defaultanswer={'116.35178 39.98057 53.44','0 0 0','0 0.5 0','0 0 0','0 0 -2','100','60*1','ƽ�����ٻ���','m'};
    %defaultanswer={'336.66 3 0','0 0 0','0 0.15 0','0 0 0','0 0 0.15','100','60*5','Բ��5min','m'};
    %defaultanswer={'116.35178 39.98057 53.44','0 0 0','0 0.5 0','0 0 0','0 0 -0.0','100','60*5','����ֱ��','m'};
    %defaultanswer={'116.35178 39.98057 53.44','0 0 0','0 0  0','0 0 -0.0','0.2 0.3 0.2','100','60*2','��̬����','m'};
    %defaultanswer={'336.66 3 0','0 0 0','0 0.03 0','0 0 0','0 0 0','100','60*60*5','��ǰ����ֱ��5h480m','m'};
    %defaultanswer={'336.66 3 0','0 0 0','0 0.03 0','0 0 0','s','100','60*60*5','��ǰ����5h480m','m'};
    %defaultanswer={'336.66 3 0','0 0 0','0 0.03 0','0 0 0','0 0 0.02','100','60*10','����Բ��10min','m'};
    %defaultanswer={'336.66 3 0','0 0 0','0 0.15 0','0 0 0','0 0 0.15','100','60*40','����Բ��360m','m'};
    %defaultanswer={'336.66 3 0','0 0 0','0 0.03 0','0 0  0','0 0 0','100','60*22','��ǰ����ֱ��_38m','m'};
    % defaultanswer={'340.5 44.1 0','-5 -5 0','0.3 0.3 0','0 0 0','2 2 2','10','5','�������','m'};
    
    %defaultanswer={'340.5 44.1 0','0 0 0','0 0.03 0','0 0 0','0 0 0','20','60*60*2','��ǰ216m_2h','m'};
    %defaultanswer={'340.5 44.1 0','0 0 0','0 0.03 0','rtg','0 0 0','10','0','������_������','m'};
    % defaultanswer={'340.5 44.1 0','0 0 0','0 0.03 0','A','0 0 0','10','0','����켣A','m'};
    % defaultanswer={'340.5 44.1 0','0 0 10','0 0.03 0','A','0 0 0','10','0','�켣A6ƽ��0��1HZ','m'};
    %defaultanswer={'340.5 44.1 0','0 0 0','0 0.03 0','s','0 0 0','10','60*60*0.2','S�켣','m'};
    
    name='����켣�������Ĳ�������';
    numlines=1;
    
    answer=inputdlg(prompt,name,numlines,defaultanswer);

    if isempty(answer)
        trueTrace = [];
        return; 
    end
    initialPosition_e = sscanf(answer{1},'%f');
    initialPosition_e(1:2) = initialPosition_e(1:2)*pi/180 ;
    initialAttitude_r = sscanf(answer{2},'%f')*pi/180;
    initialVelocity_r = sscanf(answer{3},'%f');
    realTimefb_const = sscanf(answer{4},'%f');   
    realTimeWb_const = sscanf(answer{5},'%f')*pi/180; 
    frequency = str2double(answer{6});
    runTimeSec = eval(answer{7});
    traceName = answer{8};
    planet = answer{9};
    if ~strcmp(planet,'m') && ~strcmp(planet,'e')
        errordlg('�������ô���Ĭ������')
        planet = 'm';
    end

    %��ʼ����
    runTimeNum=runTimeSec*frequency+1;
    T=1/frequency*ones(1,runTimeNum);     % sec
    %%%%% �����ʵʱ���ٶȡ���ʵʱ��̬�仯�ʡ����롰S��ʱ���ض�̬����,ʹ�ö��ζ���ʽ����

    switch answer{4}
        case 's' 
            % S������
            realTimefb = GetDynamicData_fb_s(runTimeNum,frequency) ; 
            [realTimeWb] = GetDynamicData_Wb_s(runTimeNum,frequency) ;
        case 'rtg'
            % ������
            [realTimefb,realTimeWb,runTimeNum] = GetDynamicData_Wb_rtg(initialVelocity_r(2),frequency) ;
            T=1/frequency*ones(1,runTimeNum);
            display(T)
        case 'A'
            [realTimefb,realTimeWb,runTimeNum] = GetDynamicData_Wb_A(initialVelocity_r(2),frequency) ;
            T=1/frequency*ones(1,runTimeNum);
            
        otherwise
            realTimefb = repmat(realTimefb_const,1,runTimeNum);
            realTimeWb = repmat(realTimeWb_const,1,runTimeNum);
    end
  % �� realTimefb realTimeWb ������
    bN = length(realTimeWb);
    realTimefb_Noise=zeros(3,bN);
    realTimeWb_Noise=zeros(3,bN);
    for i=1:3
        realTimefb_Noise(i,:) = normrnd(0,2e-5 ,1,bN) ;         
        realTimeWb_Noise(i,:) = normrnd(0,0.02*pi/180,1,bN) ; 
    end
    realTimefb_Noise(3,:) = normrnd(0,3e-7 ,1,bN) ;
    realTimeWb_Noise(3,:) = normrnd(0,0.03*pi/180,1,bN) ; 
% %     
    realTimefb = realTimefb+realTimefb_Noise ;
    realTimeWb = realTimeWb+realTimeWb_Noise ;
    
    
    trueTrace.planet = planet;
    trueTraceInput.initialPosition_e = initialPosition_e;
    trueTraceInput.initialAttitude_r = initialAttitude_r;
    trueTraceInput.initialVelocity_r = initialVelocity_r;
    trueTraceInput.realTimefb = realTimefb;
    trueTraceInput.realTimeWb = realTimeWb;
    trueTraceInput.traceName = traceName;
    trueTraceInput.frequency = frequency;
    trueTraceInput.runTimeSec = runTimeSec;
    trueTrace.trueTraceInput = trueTraceInput;  % ���켣��������Ϣ������trueTrace�б��ڲ鿴
    time_h = size(realTimeWb,2)/frequency / 3600 ;  % Сʱ��ʱ��
    % ���ַ�����¼�켣������������
    str = sprintf('�켣������:\t%s �����壺%s��\n',answer{8},planet);
    str = sprintf('%s��ʼ���Դ��λ��(����/��γ��/��߶�/m)��\t%s\n��ʼ�����̬������ϵ/����ϵ��(��)��\t%s\n��ʼ�ٶȣ�����ϵ�·ֽ⣩(m/s)��\t\t%s\n',str,answer{1},answer{2},answer{3});
    str = sprintf('%sʵʱ���ٶȣ�����ϵ�·ֽ⣩(m/s^2)��\t%s\nʵʱ��̬�仯�ʣ�����ϵ�·ֽ⣩(��/s)��\t%s\n����Ƶ��(HZ):%s\t\tʱ��(s):\t\t%0.2f h',str,answer{4},answer{5},answer{6},time_h);
    display(str)
    trueTrace.traceRecord = str;
end
%% ���峣��
if strcmp(planet,'m')
    moonConst = getMoonConst;   % �õ�������
    gp = moonConst.g0 ;     % ���ڵ�������
    wip = moonConst.wim ;
    Rp = moonConst.Rm ;
    e = moonConst.e;
    gk1 = moonConst.gk1;
    gk2 = moonConst.gk2;
    disp('�켣������������')
else
    earthConst = getEarthConst;   % �õ�������
    gp = earthConst.g0 ;     % ���ڵ�������
    wip = earthConst.wie ;
    Rp = earthConst.Re ;
    e = earthConst.e;
    gk1 = earthConst.gk1;
    gk2 = earthConst.gk2;
    disp('�켣������������')
end

% ��Ե���ϵ���˶�����
eul_vect = zeros(3,runTimeNum);
attitude_r=zeros(3,runTimeNum); % �������ϵ����̬
attitude_t=zeros(3,runTimeNum); % ��Ե���ϵ����̬
%Vn=zeros(3,runTimeNum);  % ��Ե���ϵ���ٶ�
head=zeros(1,runTimeNum); % ��ͳ����ĺ����

velocity_t =zeros(3,runTimeNum); % ��Ե���ϵ�ٶȣ��ڵ���ϵ�ֽ� Vet_t
velocity_r =zeros(3,runTimeNum); % �������ϵ�ٶȣ�������ϵ�ֽ� Vrt_r
                                    % velocity_r �� velocity_t ���һ��Ctr
position_r=zeros(3,runTimeNum); % �������ϵλ�ã�������ϵ�ֽ� ��x,y,z��
position_e = zeros(3,runTimeNum); % ���ϵλ�ã��ڵ���ϵ�ֽ⣨��γ�߶ȣ�
acc_r = zeros(3,runTimeNum-1);    % �������ϵ���ٶ�
%% �����õĳ�ʼ����
% ��Ҫ����/������ʼֵ�ñ���������֪����position_e,position_r,attitude_r,velocity_t,
% ��Ҫ�õ���ʼֵ�ı�����attitude_r��position_e,velocity_r,

% ���ó�ʼ��γ�Ⱥ͸߶ȣ����ڹߵ�����
position_e(1:2,1) = initialPosition_e(1:2);    % ��γ�� �� -> rad ���������ϵ�ľ��Գ�ʼλ�ã�
position_e(3,1) = initialPosition_e(3) ;
position_r(:,1)=[0;0;0];  % ��Գ�ʼλ����Ϊ0������ʼʱ�̵ĵ���ϵ��Ϊ��������ϵ    position_r(1): x��   position_r(2):y��  position_r(3):z��

attitude_r(:,1)=initialAttitude_r;    %��ʼ��̬ sita ,gama ,fai
Wrbb = realTimeWb;    % ��̬�仯��  ����/s �������������ϵ�Ľ��ٶ��ڱ���ϵ�µķֽ�  �� Wrbb
fb=realTimefb;      % ��ʻ���ٶ�  m/s/s
                        % initialVelocity_r Ϊ����ϵ�·ֽ����ʻ���ٶ�  m/s
Cbt=FCbn(attitude_r(:,1)); % ��ʼ����ϵ �� ����ϵ/����ϵ ��ת�ƾ���
Cbr=Cbt;

velocity_t(:,1) = initialVelocity_r ;
velocity_r(:,1) = initialVelocity_r ;

Crb=Cbr';
Crb_last = Crb; % ��¼��һʱ�̵�Crb�����ڼ���Rbb

Cer=FCen(position_e(1,1),position_e(2,1));
Cre=Cer';
position_ini_er = FJWtoZJ(position_e(:,1),planet);  %��ʼʱ�̵ع�����ϵ�е�λ��

wib_INSc=zeros(3,runTimeNum-1);
f_INSc=zeros(3,runTimeNum-1);

Q0 = FCnbtoQ(Crb);

Wiee=[0;0;wip];
Wirr=Cer*Wiee;

waitbar_h=waitbar(0,'�켣������');
for t=1:runTimeNum-1
    if mod(t,ceil(runTimeNum/100))==0
        waitbar(t/runTimeNum)
    end
                    
    wib_INSc(:,t) = Crb*Wirr + Wrbb(:,t);
%     Q0=Q0+0.5*T(t)*[    0    ,-Wrbb(1,t),-Wrbb(2,t),-Wrbb(3,t);
%                  Wrbb(1,t),     0    , Wrbb(3,t),-Wrbb(2,t);
%                  Wrbb(2,t),-Wrbb(3,t),     0    , Wrbb(1,t);
%                  Wrbb(3,t), Wrbb(2,t),-Wrbb(1,t),     0    ]*Q0;
%     Q0=Q0/norm(Q0);
    Q0  = QuaternionDifferential( Q0,Wrbb(:,t),T(t) ) ;
%             Crb = FQtoCnb(Q0);
%             Cbr=Crb';
%         %     
%         %     %output  attitude_r information
%         %     eul_vect(:,t) = dcm2eulr(Crb);
%             opintions.headingScope=180;
%             attitude_r(:,t+1) = GetAttitude(Crb,'rad',opintions);

    g = gp * (1+gk1*sin(position_e(2,t))^2-gk2*sin(2*position_e(2,t))^2);
    gn = [0;0;-g];
    Cen = FCen(position_e(1,t),position_e(2,t));
    Cnr = Cer * Cen';
    Cnb = Crb * Cnr;
    gb = Cnb * gn;
    gr = Cbr * gb;
    
    %%%%%%%%%%% �ٶȷ��� %%%%%%%%%%
    if isReverseIMU==0
        a_rbr = Cbr * fb(:,t)+getCrossMarix(  Cbr * Wrbb(:,t) ) * velocity_r(:,t) ;
    else
        a_rbr = dif_arbr(:,t);
    end
    %%%%%%%%%%% �������� %%%%%%%%%%
%    f_INSc(:,t) = fb(:,t) + getCrossMarix( 2*Crb*Wirr )* Crb*velocity_r(:,t) - gb; % ����������rϵ�µ�������fb��ֱ�������ڱ���ϵ��������
    f_INSc(:,t) = Crb * a_rbr + getCrossMarix( 2*Crb*Wirr )* Crb*velocity_r(:,t) - gb; 
%     %%%%%%%%%%% �ٶȷ��� %%%%%%%%%%
%    % a_rbr = Cbr * f_INSc(:,t) - getCrossMarix( 2*Wirr )*velocity_r(:,t) + gr;    % �����������ϵ�ļ��ٶȣ�������ϵ�µ�����
%     a_rbr = Cbr * fb(:,t) ;
    acc_r(:,t) = a_rbr ;
    
    Crb = FQtoCnb(Q0);
    Cbr=Crb';
%     
%     %output  attitude_r information
%     eul_vect(:,t) = dcm2eulr(Crb);
    opintions.headingScope=180;
    attitude_r(:,t+1) = GetAttitude(Crb,'rad',opintions);
    
    % ����Ե���ϵ����̬
    Cnb = Crb*Cnr ;
    attitude_t(:,t+1) = GetAttitude(Cnb,'rad',opintions);
    
    velocity_r(:,t+1) = velocity_r(:,t) + a_rbr * T(t);
    velocity_t(:,t+1) = Cnr' * velocity_r(:,t+1);   % �����������ϵ�͵���ϵ���ٶ� ת��
    position_r(:,t+1) = position_r(:,t) + velocity_r(:,t) * T(t);
    positione0 = Cre * position_r(:,t+1) + position_ini_er; % ����������ϵ�е�λ��ת������ʼʱ�̵ع�ϵ
    position_e(:,t+1) = FZJtoJW(positione0,planet);
    
end
close(waitbar_h)

%% ���

trueTrace.position = position_r ;
trueTrace.position_e = position_e ;

trueTrace.attitude = attitude_r ;
trueTrace.attitude_t = attitude_t;

trueTrace.velocity = velocity_r ;
trueTrace.f_IMU = f_INSc ;
trueTrace.wib_IMU = wib_INSc ;
trueTrace.frequency = frequency;
trueTrace.initialPosition_e = initialPosition_e;
trueTrace.initialVelocity_r = initialVelocity_r;
trueTrace.initialAttitude_r = initialAttitude_r;
trueTrace.acc_r=acc_r;

% ����
savePath = [pwd,'\',traceName];
if isdir(savePath)
    delete([savePath,'\*']);
else
    mkdir(savePath) ;
end
save([savePath,'\trueTrace.mat'],'trueTrace')
save( 'trueTrace','trueTrace')
if  isReverseIMU == 1 
    % ��IMU���ݱ��浽ԭ���� trueTrace ��
    trueTrace_mesr.f_IMU = f_INSc ;
    trueTrace_mesr.wib_IMU = wib_INSc ;
    save([PathName,'\trueTrace.mat'],'trueTrace_mesr')
end
%% ��ͼ

if isPlotFigure ==1
    if isReverseIMU==0
        time = (1:length(position_r))/frequency ;
    else        
        time = (1:runTimeNum)/frequency ;
    end
    
    figure,plot(time,position_r);
    legend('x','y','z')
    title('��ά���򳵹켣','fontsize',16);
    xlabel('ʱ��(sec)','fontsize',12);
    ylabel('λ��(m)','fontsize',12);
    saveas(gcf,[savePath,'\��ά���򳵹켣.fig'])
    
    figure,plot(position_r(1,:),position_r(2,:),'b');
    title('��ά���򳵹켣','fontsize',16);
    xlabel('x��(m)','fontsize',12);
    ylabel('y��(m)','fontsize',12);
    if isReverseIMU==1
        hold on
        plot(position_In(1,:),position_In(2,:),'-.r');
        legend('���ƽ���','ʵ�ʲ���')
    end
    saveas(gcf,[savePath,'\��ά���򳵹켣.fig'])
    
    figure,plot3(position_r(1,:),position_r(2,:),position_r(3,:));
    title('���򳵹켣','fontsize',16);
    xlabel('x��(m)','fontsize',12);
    ylabel('y��(m)','fontsize',12);
    zlabel('z��(m)','fontsize',12);

    figure,plot(time,velocity_r(1,:),'k:',time,velocity_r(2,:),'b',time,velocity_r(3,:),'r--');
    title('�����ٶ�','fontsize',16);
    xlabel('ʱ��(sec)','fontsize',12);
    ylabel('�ٶ�(m/s)','fontsize',12);
    legend('X','Y','Z');

    figure,plot(time(1:length(acc_r)),acc_r(1,:),'k:',time(1:length(acc_r)),acc_r(2,:),'b',time(1:length(acc_r)),acc_r(3,:),'r--');
    title('������ٶ�','fontsize',16);
    xlabel('ʱ��(sec)','fontsize',12);
    ylabel('���ٶ�(m/s^2)','fontsize',12);
    legend('X','Y','Z');
    
    figure,plot(time,attitude_r(1,:)*180/pi,'k:',time,attitude_r(2,:)*180/pi,'b',time,attitude_r(3,:)*180/pi,'r--');
    title('������̬','fontsize',16);
    xlabel('ʱ��(sec)','fontsize',12);
    ylabel('��̬(��)','fontsize',12);
    legend('������','�����','�����' );
    
    if isReverseIMU==1
        figure;
        plot(time,attitude_r(1,:)*180/pi,'--b');
        hold on
        plot(time,attitude_In(1,:)*180/pi,'-.r');
        title('pitch','fontsize',16);
        legend('���ƽ���','ʵ�ʲ���')
        
        figure;
        plot(time,attitude_r(2,:)*180/pi,'--b');
        hold on
        plot(time,attitude_In(2,:)*180/pi,'-.r');
        title('roll','fontsize',16);
        legend('���ƽ���','ʵ�ʲ���')
        
        figure;
        plot(time,attitude_r(3,:)*180/pi,'--b');
        hold on
        plot(time,attitude_In(3,:)*180/pi,'-.r');
        title('yaw','fontsize',16);
        legend('���ƽ���','ʵ�ʲ���')
    end
    
%     figure,plot(time,eul_vect(1,:)*180/pi,'k:',time,eul_vect(2,:)*180/pi,'b',time,eul_vect(3,:)*180/pi,'r--');
%     title('������̬','fontsize',16);
%     xlabel('ʱ��(sec)','fontsize',12);
%     ylabel('��̬(��)','fontsize',12);
%     legend('�����','������','�����' );
end

disp('�켣�������������')

