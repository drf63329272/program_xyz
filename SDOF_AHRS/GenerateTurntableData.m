%% xyz 2015.4.24

%% ����ת̨�Ƕ���������

% ʵ�����̣�
% ��1����λʱ���־�ֹ1S����
% ��2����20��/s���ٶ��ٶ��˶���30�㣬��-20��/s���ٶ��ٶ��˶���-30�㣬��20��/s���ٶ��ٶ��˶���20�㣬��ֹ0.5S��
% ��3����20����2��/s���ٶ��ٶ��˶���30�㱣�־�ֹ0.5S����-20��/s���ٶ��ٶ��˶���0�㣬���־�ֹ0.5S��
% ��4����0.1HZ  30���ֵ���������˶���ÿ�˶�3�����ڱ��־�ֹ1S���˶�2���Ӻ�ֹͣ��

function GenerateTurntableData(  )

%%
dataFre = 1000 ;            % �������Ƶ��

ZeroStaticTime = 1 ;        % ��λ��ֹʱ��
FastRotateW = 20 ;          % ����ת�����ٶ�
MaxRotateAmplitude = 30 ;  % ����ת����ֵ
FastToSlowTime = 0.5 ;      % ��������ת�����
SlowRotateW = 2 ;           % ����ת�����ٶ�
SlowRotateMin = 20 ;        % ����ת����Сֵ   �� SlowRotateMin �� MaxRotateAmplitude
BeforeSinStaticTime = 0.5 ;       % ��������ǰ�ľ�ֹʱ��
SinAmplitude = 30;          % ����ת����ֵ
SinFrequency = 0.1;         % ����ת��Ƶ��
SinStaticTime = 0.5 ;         % ÿ3����������ת�����־�ֹ��ʱ��

ThreeSinNum = 4 ;           % ����ת�������� = ThreeSinNum*3


%% (1)
N1 = ZeroStaticTime*dataFre ;
data1_Static = zeros( 1,N1 );

%% (2)
FastRotateStep = FastRotateW / dataFre ;
data2_1 = 0:FastRotateStep:MaxRotateAmplitude ;
data2_2 = MaxRotateAmplitude:-FastRotateStep:-MaxRotateAmplitude ;
data2_3 = -MaxRotateAmplitude:FastRotateStep:SlowRotateMin ;
data2_4 = ones( 1,FastToSlowTime*dataFre )*SlowRotateMin ;

data2 = [ data2_1 data2_2 data2_3 data2_4 ];

%% (3)
SlowRotateStep = SlowRotateW / dataFre ;
data3_1 = SlowRotateMin:SlowRotateStep:MaxRotateAmplitude ;
data3_2 = MaxRotateAmplitude:-FastRotateStep:0 ;
data3_3 = zeros( 1,BeforeSinStaticTime*dataFre ) ;

data3 = [ data3_1 data3_2 data3_3  ];

%% (4)
sinStep = 2*pi/ ( dataFre/SinFrequency ) ;
sinTime = (0:sinStep:6*pi) ;
data4_sin = sin( sinTime )*SinAmplitude;

data4_Static = zeros( 1,SinStaticTime*dataFre );
data4 = [ data4_sin data4_Static ];
data4 = repmat( data4,1,ThreeSinNum );
%%
data = [ data1_Static data2  data3 data4 ];

dataNumber  = length(data) ;
sprintf('%0.0f',dataNumber)
sprintf('%0.2f',dataNumber/60/1000)

dataFolder = [ pwd,'\TurntableData1' ];
if ~isdir(dataFolder)
    mkdir(dataFolder)
else
   delete([dataFolder,'\*']) 
end
fid = fopen( [dataFolder,'\TurntableData.txt'],'w' );

fprintf( fid,'%0.3f\n',data );
fclose(fid);


save data data


%%
time = (1:length(data))/dataFre ;
figure 
plot(time,data)

disp('')
