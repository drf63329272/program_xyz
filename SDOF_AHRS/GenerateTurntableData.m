%% xyz 2015.4.24

%% ����ת̨�Ƕ���������

% ʵ�����̣�
% ��1����λʱ���־�ֹ1S����
% ��2����20��/s���ٶ��ٶ��˶���30�㣬��-20��/s���ٶ��ٶ��˶���-30�㣬��ֹ0.5S��
% ��3����2��/s���ٶ��ٶ��˶���-20�㣬��ֹ0.5S����20��/s���ٶ��ٶ��˶���20�㣬��ֹ0.5S��
% ��4����20����2��/s���ٶ��ٶ��˶���30�㱣�־�ֹ0.5S����-20��/s���ٶ��ٶ��˶���0�㣬���־�ֹ0.5S��
% ��5����0.1HZ  30���ֵ���������˶���ÿ�˶�3�����ڱ��־�ֹ1S���˶�2���Ӻ�ֹͣ��

function GenerateTurntableData(  )

%%
dataFre = 1000 ;            % �������Ƶ��

staticT =1 ;

ZeroStaticTime = 1+5 ;        % ��λ��ֹʱ��
FastRotateW = 20 ;          % ����ת�����ٶ�
MaxRotateAmplitude = 30 ;  % ����ת����ֵ
FastToSlowTime = staticT ;      % ��������ת�����
SlowRotateW = 2 ;           % ����ת�����ٶ�
SlowRotateMin = 20 ;        % ����ת����Сֵ   �� SlowRotateMin �� MaxRotateAmplitude
AccCalRovStaticT = staticT ;
BeforeSinStaticTime = staticT ;       % ��������ǰ�ľ�ֹʱ��
SinAmplitude = 30;          % ����ת����ֵ
SinFrequency = 0.1;         % ����ת��Ƶ��
SinStaticTime = staticT ;         % ÿ3����������ת�����־�ֹ��ʱ��

ThreeSinNum = 4 ;           % ����ת�������� = ThreeSinNum*3


%% (1)
N1 = ZeroStaticTime*dataFre ;
data1_Static = zeros( 1,N1 );

%% (2)
FastRotateStep = FastRotateW / dataFre ;
data2_1 = 0:FastRotateStep:MaxRotateAmplitude ;
data2_2 = MaxRotateAmplitude:-FastRotateStep:-MaxRotateAmplitude ;
% data2_3 = -MaxRotateAmplitude:FastRotateStep:SlowRotateMin ;
data2_3 = ones( 1,FastToSlowTime*dataFre )*(-MaxRotateAmplitude) ;

data2 = [ data2_1 data2_2 data2_3  ];
time2 = length(data2)/dataFre
%% (3)
SlowRotateStep = SlowRotateW / dataFre ;
data3_1 = -MaxRotateAmplitude:SlowRotateStep:-SlowRotateMin ;
data3_2 = ones( 1,AccCalRovStaticT*dataFre )*(-SlowRotateMin );  % static
data3_3 = -SlowRotateMin:FastRotateStep:SlowRotateMin ;
data3_4 = ones( 1,AccCalRovStaticT*dataFre )*(SlowRotateMin ); % static
data3_5 = SlowRotateMin:SlowRotateStep:MaxRotateAmplitude ;
data3_6 = ones( 1,AccCalRovStaticT*dataFre )*(MaxRotateAmplitude ); % static
data3_7 = MaxRotateAmplitude:-FastRotateStep:0 ;
data3_8 = zeros( 1,BeforeSinStaticTime*dataFre ) ; % static

data3 = [ data3_1 data3_2 data3_3  data3_4 data3_5 data3_6 data3_7 data3_8 ];
time3 = length(data3)/dataFre
%% (4)
sinStep = 2*pi/ ( dataFre/SinFrequency ) ;
sinTime = (0:sinStep:6*pi) ;
data4_sin = sin( sinTime )*SinAmplitude;

data4_Static = zeros( 1,SinStaticTime*dataFre );
data4 = [ data4_sin data4_Static ];
data4 = repmat( data4,1,ThreeSinNum );
time4 = length(data4)/dataFre
%%
data = [ data1_Static data2  data3  data4 ];

dataNumber  = length(data) ;
sprintf('%0.0f',dataNumber)
sprintf('%0.2f',dataNumber/60/1000)

dataFolder = [ pwd,'\TurntableData_5.4' ];
% if ~isdir(dataFolder)
%     mkdir(dataFolder)
% else
%    delete([dataFolder,'\*']) 
% end
fid = fopen( [dataFolder,'\TurntableData_1.txt'],'w' );

fprintf( fid,'%0.3f\n',data );
fclose(fid);


save data data


%%
time = (1:length(data))/dataFre ;
figure 
plot(time,data)
saveas(gcf,[dataFolder,'\TurntableData_1.fig'])
disp('')
