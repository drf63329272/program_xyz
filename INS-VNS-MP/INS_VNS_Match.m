%% xyz 2015.6.30

%% ��˵�ʶ����
% 1) ��������һ֡֡������Լ��ٶ� ���Ӿ�����˵�λ�ã�����otherMakers��
%  �Թ��Ժ��Ӿ��������м��ٶȲ��η���
    % ÿ����һ֡���Լ��ٶȣ��Թ��Լ��ٶȽ���һ�β��η���
    % û����һ֡�Ӿ���˵�λ�ã���������ٶȺ���м��ٶȲ��η���
% ÿ�����Ժ��Ӿ����ٶȲ��ζ���������һ֡ʱ������һ֡��˵����

%% Input ��һ��ʱ�̵�ֵ��
% INS_Joint_N�� ���Խڵ����
% INSA_All_k [ INS_Joint_N , 3 ]  : ĳһ��ʱ�� INS_Joint_N ���� �� ���ٶ� 
% inertialFre ����Ƶ��
% ins_k_g  ����ʱ��

% otherMakersPosition_k  [3*20] : ���� 20  ����˵��λ��
% otherMakersN_k �� ��Ч��˵����
% vns_k_g : �Ӿ��� ���
% visionFre �� �Ӿ���Ƶ��

% MinMatchDegree = 0.6; % ��Сƥ���

%% �����������
% 1�� INSA_All_k [ INS_Joint_N , 3 ] INS_Joint_N Ϊ���Խڵ������Ҫ��ʼ�ձ��� ���� �� ˳�� ����

%% otherMakers
% otherMakers(k).frequency [1]
% otherMakers(k).Position  [3*M]
% otherMakers(k).otherMakersN [1]
%��otherMakers(k).time [1]
%��otherMakers(k).inertial_k [1]
%��otherMakers(k).MarkerSet ""

        % ��¼ÿ����˵����������
% otherMakers(k).trackedMakerPosition  = NaN(3,1);   

% otherMakers(k).ContinuesFlag = zeros(1,M) ; % ������
% otherMakers(k).ContinuesLastPosition = NaN(3,M)  ;
% otherMakers(k).ContinuesLastTime = NaN[1*M] ; 
% otherMakers(k).ContinuesLastK = NaN[1*M];


function [ MatchedVNSP,INSA_TestOut,otherMakersContinuesTestOut,vns_kTestOut,VNSWaveResultOut,INSWaveResultOut,otherMakers_kNew ]  = INS_VNS_Match...
    ( INSA_All_k,inertialFre,otherMakersPosition_k,otherMakersN_k,visionFre,MinMatchDegreeIn )
global  MinMatchDegree     
%% ��������
MinMatchDegree = MinMatchDegreeIn;
BufferTime = 5; % sec  ���ݻ���ʱ�䳤��
IBN  = fix(BufferTime*120);
VBN = fix(BufferTime*120);
Max_otherMakersN = 20;  % ���� 20  ����˵��λ��
IsOnlyLost = 0;     % 1�������

INS_Joint_N = 6;

%% ����Ԥ����
IsINSReceived = ~ isempty( INSA_All_k ) ;
IsVNSReceived = ~ isempty( otherMakersN_k );

%% OUT
INSA_TestOut = [];
vns_kTestOut=[];
otherMakersContinuesTestOut=[];
VNSWaveResultOut=[];
INSWaveResultOut=[];
otherMakers_kNew=[];
%% ʱ��ͬ������
persistent ins_k_g  vns_k_g    % ȫ�ֵ���ţ��ӵ�һ֡��һֱ��ǰ����
if IsINSReceived
    if isempty( ins_k_g )
        ins_k_g = 0;  % ��һ֡����ǰ
    end
    ins_k_g = ins_k_g+1;
end
if IsVNSReceived
    if isempty( vns_k_g )
        vns_k_g = 0;  % ��һ֡����ǰ
    end
    vns_k_g = vns_k_g+1;
end

persistent ins_k  vns_k  %  �ڻ������ڲ������

if IsINSReceived
    if isempty( ins_k )
        ins_k = 0;  % ��һ֡����ǰ
    end
end
if IsVNSReceived
    if isempty( vns_k )
        vns_k = 0;  % ��һ֡����ǰ
    end
end

%% �洢���Լ��ٶ�
persistent INSA_All   INSWaveResult INSA_WaveFlag_All
% INSA_All [INS_Joint_N * 3 * IBN]  ���Լ��ٶȻ���
if IsINSReceived    
    if isempty(INSA_All)
%         INS_Joint_N = size(INSA_All_k,1)/3;  % ���Խڵ������Ҫ��ʼ�ձ��� ���� �� ˳�� ����
%         if mod(INS_Joint_N,1)~=0
%            disp('error INS_Joint_N'); 
%         end
        INSA_All = NaN( INS_Joint_N*3,IBN );  
        INSA_WaveFlag_All = NaN( INS_Joint_N*3,IBN ); 
    end
    [ INSA_All,ins_k,removeN ] = AddListData( INSA_All,ins_k,INSA_All_k(1:INS_Joint_N*3,:) );
    %% ���Լ��ٶ� ���η���
    [INSA_WaveFlag_All,INSA_TestOut] = INSA_Wave_Analyze...
        ( INSA_All, INS_Joint_N,ins_k,IBN,inertialFre,removeN ) ;
    INSA_ValidN = ones( size(INSA_WaveFlag_All,1),1 )*ins_k;
    INSWaveResult = GetWaveResult( INSA_WaveFlag_All,INSA_ValidN,ins_k_g,inertialFre,INSA_All );
    
    
    if coder.target('MATLAB')
        INSWaveResultOut = INSWaveResult;
        INSA_TestOut.validN = ins_k;
        INSA_TestOut.timeN = ins_k_g;
    end
    
    IsLostMark=0;  % �����ܵ����ݣ��Ӿ�û�е�����£���ƥ��
end

%% �洢�Ӿ���˵�
persistent otherMakers  otherMakers_k_new VNSWaveResult
if IsVNSReceived
    if isempty(otherMakers)
        otherMakers = otherMakersInitial( VBN,visionFre,Max_otherMakersN );  % Ƶ��ֻ����һ��
        otherMakers_k_new = otherMakers(1);
    end
    
    otherMakers_k_new.otherMakersN = double(otherMakersN_k);
    otherMakers_k_new.Position = double(otherMakersPosition_k);
    otherMakers_k_new.time = double(vns_k_g/visionFre) ;       % ���㷨��ʱ��ͬ��Ҫ���ʱ������ͨ��Ƶ�ʼ���ʱ��

    [ otherMakers,vns_k ] = AddListotherMakers( otherMakers,vns_k,otherMakers_k_new );
    
    %% �����Է���
    if vns_k>1
        [ otherMakers,IsLostMark ] = ContinuesAnalyze( otherMakers,vns_k,INS_Joint_N,visionFre,VBN );
    end
    %% �Ӿ���˵㲨�η���
    if vns_k>1 && IsLostMark
        [ otherMakers,VNSA_WaveFlag_All,VNSP_ValidN_All,VNSA_All,otherMakersContinuesTestOut ] = VNSP_AWave_Analyze...
            ( otherMakers,vns_k,vns_k_g,VBN,IsOnlyLost );
        
        VNSWaveResult = GetWaveResult( VNSA_WaveFlag_All,VNSP_ValidN_All,vns_k_g,visionFre,VNSA_All );
        if coder.target('MATLAB')
            VNSWaveResultOut = VNSWaveResult;
            
        end
    end
    vns_kTestOut = vns_k_g;   
    
 %   DrawotherMakersContinuesRealTime( otherMakersContinuesTestOut,otherMakers,vns_k );
end

if isempty(vns_k) || isempty(ins_k) || vns_k<2 || ins_k<2
    MatchedVNSP = NaN(INS_Joint_N*3,1);
    return;
end
%% ���й��Ե� �� �����Ӿ��� ����ƥ��

if  IsLostMark
    [ MarkerMatchingINSk,matchedDegreeSyn ] = WaveMatch( INSWaveResult,VNSWaveResult,IsOnlyLost,otherMakers(vns_k).InitialJointK,vns_k_g );
    
else
    MarkerMatchingINSk=[];
end

%%  �� MarkerMatchingINSk ����  otherMakers(vns_k).InitialJointK
if  IsLostMark
    
    otherMakersN_k = otherMakers(vns_k).otherMakersN;
    for i=1:otherMakersN_k
        MarkerMatchingINSk_i  = MarkerMatchingINSk(i,1);
        if ~isnan(MarkerMatchingINSk_i)   &&  MarkerMatchingINSk(i,2) > MinMatchDegree
            % �õ���ƥ����
            InitialJointK_old = otherMakers(vns_k).InitialJointK(i) ;  % ͨ���������жϵĽ��
            if isnan( InitialJointK_old )
                % ֮ǰ��ʧ
                otherMakers(vns_k).InitialJointK(i) = MarkerMatchingINSk_i ;
                fprintf('�״�ʶ��: mark(%d)-INS(%d)[%0.4f] , ins_k_g=%d t=%0.3f sec \n',i,MarkerMatchingINSk_i,MarkerMatchingINSk(i,2),ins_k_g,ins_k_g/inertialFre );
            else
          %      fprintf('     ��ʶ��: mark(%d)-INS(%d)[%0.4f] , ins_k_g=%d t=%0.3f sec \n',i,MarkerMatchingINSk_i,MarkerMatchingINSk(i,2),ins_k_g,ins_k_g/inertialFre );
                % ͨ���������Ѿ��õ����
                if InitialJointK_old~=MarkerMatchingINSk_i
                   fprintf('�����Լ�¼��ǰʱ���жϺ͵�ǰ�жϲ�һ�£� \n'); 
                   fprintf( '   mark(%d)��֮ǰ��Ӧ INS(%d)�����ڶ�Ӧ INS(%d), vns_k_g=%d \n',i,InitialJointK_old,MarkerMatchingINSk_i,vns_k_g );
                end
            end
        end        
    end     
    
    InitialJointK_k = otherMakers(vns_k).InitialJointK(1:INS_Joint_N) ;
    IsMatchOK =  ~sum(isnan(InitialJointK_k)) ;
    if IsMatchOK 
        disp('ȫ��ƥ��OK')
    end  
    
    otherMakers_kNew = otherMakers(vns_k);
end
% ����ƥ��ɹ�������
%  dbstop in DrawMatchedResult at 568
%     DrawMatchedResult( otherMakers,otherMakersContinuesTestOut,vns_k,vns_k_g,visionFre,INSA_All,ins_k,ins_k_g,INSA_WaveFlag_All,inertialFre );  
    
%% MatchedVNSP �� ������˳��洢����˵�λ��
%  [3*20] ����Խڵ�ƥ�����˵�λ�ã�˳���� INSA_All_k һ��
MatchedVNSP = NaN(INS_Joint_N*3,1);
if ~isempty(vns_k) && ~isempty(ins_k) && vns_k>1 && ins_k>1
    otherMakersN_k = otherMakers(vns_k).otherMakersN;
    Position_k = otherMakers(vns_k).Position;
    for i=1:otherMakersN_k
        InitialJointK_i = otherMakers(vns_k).InitialJointK(i); % �� i ����˵��Ӧ�Ĺ��Խڵ����
        if InitialJointK_i > 0
            MatchedVNSP( InitialJointK_i*3-2:InitialJointK_i*3 ,: ) = Position_k(:,i) ;
        end
    end
end


%% �����ٶ�ʸ�� ���ӽǶ���Ϣ
% Acc [M*3,1]  M ���㣬һ��ʱ��
function AccAngle = GetAccAngle( Acc )
[M1,N] = size(Acc);
M = M1/3;
AccAngle = NaN(M*2,N);

for k=1:N
    for i=1:M
        Acc_k = Acc(i*3-2:i*3,k);
        Acc_xyzNorm_k = normest( Acc_k(1:3) );
        if Acc_xyzNorm_k > 0.1
            Acc_xyNorm_k = normest( Acc_k(1:2) );
            % ˮƽ���ٶ� �� ����֮��ļн�
            temp1 = atan2( Acc_k(1),Acc_k(2) );
            AccAngle(i*2-1,k) = temp1;
            % 3D ���ٶ������ļн�
            temp = atan2( Acc_xyNorm_k,Acc_k(3) );
            AccAngle(i*2,k)  = temp;
        end
    end
end


%%  ���й��Ե� �� �����Ӿ��� ����ƥ��
% WaveResult 
% M = 3*PointN  �������3��  
    % WaveResult.wave  [ M*100 ] ֱ�ӱ��沨������ �����100����   ÿһ�д洢һ����˵��һά�Ĳ�������ֵ
    % WaveResult.time  [M*100]  ÿ�����������Ӧ��ʱ��
    % WaveResult.waveN  [M*1]  ���ĸ���
    % WaveResult.waveReadedN  [M*1]  �ѶȲ�����
%% MarkerMatchINSk
% [ otherMakersN,2 ] 
%   MarkerMatchINSk(i_marker,1)Ϊ��˵�ƥ��Ĺ��Թؽ���ţ�
%   MarkerMatchINSk(i_marker,2)Ϊ��Ӧ��ƥ���

function [ MarkerMatchingINSk,matchedDegreeSyn ] = WaveMatch( INSWaveResult,VNSWaveResult,IsOnlyLost,InitialJointK,vns_k_g )

VNS_M = size( VNSWaveResult.wave,1 );
otherMakersN = VNS_M/3; % �Ӿ���˵����

INS_M = size( INSWaveResult.wave,1 );
INS_Joint_N = INS_M/3;  % ���Թؽڵ����

matchedDegreeSyn = NaN( otherMakersN,INS_Joint_N );  % �ۺ�ƥ���
matchedDegree = NaN( otherMakersN,INS_Joint_N,4 );

%% ����������ϵ�ƥ���
for i=1:otherMakersN
    if IsOnlyLost && ~isnan( InitialJointK(i) ) 
       continue;  % ��������û�ж��Ͳ����� 
    end
    
    VNS_WaveFetureN = VNSWaveResult.waveN( i*3-2:i*3,: );
    if sum(VNS_WaveFetureN) < 2
       continue; 
    end
    VNS_WaveFeture = VNSWaveResult.wave( i*3-2:i*3,: );    
    VNS_WaveFetureT = VNSWaveResult.time( i*3-2:i*3,: );
    VNS_Acc5D = VNSWaveResult.Acc5D( i*3-2:i*3,:,: );
    
   for j=1:INS_Joint_N        
        INS_WaveFetureN = INSWaveResult.waveN( j*3-2:j*3,: );
        if sum(INS_WaveFetureN) < 2
           continue; 
        end
        INS_WaveFeture = INSWaveResult.wave( j*3-2:j*3,: );
        INS_WaveFetureT = INSWaveResult.time( j*3-2:j*3,: );
        INS_Acc5D = INSWaveResult.Acc5D( j*3-2:j*3,:,: );    
        
       [ matchedDegree_i_j ] =  WaveMatch_OnePoint( INS_WaveFeture,INS_WaveFetureN,INS_WaveFetureT,INS_Acc5D, ...
           VNS_WaveFeture,VNS_WaveFetureN,VNS_WaveFetureT,VNS_Acc5D );
       matchedDegreeSyn(i,j) = matchedDegree_i_j(4);    % �ۺ�ƥ���
       matchedDegree(i,j,:) = matchedDegree_i_j;
       
   end
end

%% �� matchedDegreeSyn ����ÿ����˵�ƥ��Ĺ��Թؽڵ� MarkerMatchINSk
MarkerMatchingINSk = ExtractMatchDegree( matchedDegreeSyn,otherMakersN,INS_Joint_N,InitialJointK ) ;

% MarkerMatchingINSk = NaN( otherMakersN,2 ); % MarkerMatchINSk(i_marker,1)Ϊ��˵�ƥ��Ĺ��Թؽ���ţ�MarkerMatchINSk(i_marker,2)Ϊ��Ӧ��ƥ���
% for i=1:otherMakersN
%     if IsOnlyLost && ~isnan( InitialJointK(i) ) 
%        continue;  % ��������û�ж��Ͳ����� 
%     end
%     
%     matchedDegreeSyn_i = matchedDegreeSyn(i,:);
%     [ minMatchedDegree,matchINSk ] = max( matchedDegreeSyn_i,[],2 );
%     if minMatchedDegree>0
%         MarkerMatchingINSk(i,1)  = matchINSk;
%     else
%         MarkerMatchingINSk(i,1)  = NaN;
%     end
%     MarkerMatchingINSk(i,2) = minMatchedDegree;
% end


%% ��ƥ�������� ��ȡ ��˵� �� �ؽڵ��ƥ���ϵ
%% MarkerMatchINSk
% [ otherMakersN,2 ] 
%   MarkerMatchINSk(i_marker,1)Ϊ��˵�ƥ��Ĺ��Թؽ���ţ�
%   MarkerMatchINSk(i_marker,2)Ϊ��Ӧ��ƥ���
function MarkerMatchingINSk = ExtractMatchDegree( matchedDegreeSyn,otherMakersN,INS_Joint_N,InitialJointK )
MinContrast = 0.6;  % ��Чƥ��� �� �ڶ�ƥ��� ����С�Աȶ�

for i=1:numel(matchedDegreeSyn)
   if isnan( matchedDegreeSyn(i) )
       matchedDegreeSyn(i) = 0;
   end
end

MarkerMatchingINSk = NaN( otherMakersN,2 );
INSJoint_M_VK = NaN(1,INS_Joint_N);  % INSJoint_M_VK(k) Ϊ��k���ؽڶ�Ӧ����˵����
% ������ȡ������ĵ�
for i=1:otherMakersN
    matchedDegreeSyn_i = matchedDegreeSyn(i,:); % mark i ��Ӧ������ƥ���
    [ matchedDegreeSyn_i_sorted,I ] = sort(matchedDegreeSyn_i,'descend');
    if matchedDegreeSyn_i_sorted(2) / matchedDegreeSyn_i_sorted(1)  < MinContrast
       % ����ƥ��� �� �ڶ����ƥ��� �� 1 ������, ��Ч
       MarkerMatchingINSk( i,1 ) = I(1);  % ���iƥ�� ���Թؽ���� I(1)
       MarkerMatchingINSk( i,2 ) = matchedDegreeSyn_i_sorted(1); % ƥ���
       INSJoint_M_VK(I(1)) = i;
    end
end
% ����ȡģ����
for i=1:otherMakersN
    matchedDegreeSyn_i = matchedDegreeSyn(i,:); % mark i ��Ӧ������ƥ���
    [ matchedDegreeSyn_i_sorted,I ] = sort(matchedDegreeSyn_i,'descend');
    if matchedDegreeSyn_i_sorted(2) / matchedDegreeSyn_i_sorted(1)  > MinContrast
       % ����ƥ��� �� �ڶ����ƥ��� �ȽϽ�
       % �ų����Ѿ���ʶ��Ĺ��Թؽں����������ģ�����⣬��Ȼ��Ч
       if ~isnan(INSJoint_M_VK(I(1))) || ~isnan(InitialJointK(I(1)))  % ��1�����ѱ��ų��� �˴μ��ٶ�ʶ�� || ֮ǰ�������ų� ��
           if matchedDegreeSyn_i_sorted(3) / matchedDegreeSyn_i_sorted(2)  < MinContrast
               
                fprintf('������Ч��*0.7���� [%0.2f��%0.2f��%0.2f]����1�����ѱ��ų� \n',matchedDegreeSyn_i_sorted(1),matchedDegreeSyn_i_sorted(2),matchedDegreeSyn_i_sorted(3));
                MarkerMatchingINSk( i,1 ) = I(2);  % ���iƥ�� ���Թؽ���� I(1)
             	MarkerMatchingINSk( i,2 ) = matchedDegreeSyn_i_sorted(2)*0.7; % ƥ���
                INSJoint_M_VK(I(2)) = i;
           end
       end
       
       if ~isnan(INSJoint_M_VK(I(2))) || ~isnan(InitialJointK(I(2))) % ��2�����ѱ��ų�
           if matchedDegreeSyn_i_sorted(3) / matchedDegreeSyn_i_sorted(1)  < MinContrast
                MarkerMatchingINSk( i,1 ) = I(1);  % ���iƥ�� ���Թؽ���� I(1)
                MarkerMatchingINSk( i,2 ) = matchedDegreeSyn_i_sorted(1)*0.9; % ƥ���
                INSJoint_M_VK(I(1)) = i;
                fprintf('������Ч��*0.9���� [%0.2f��%0.2f��%0.2f]����2�����ѱ��ų� \n',matchedDegreeSyn_i_sorted(1),matchedDegreeSyn_i_sorted(2),matchedDegreeSyn_i_sorted(3));
           end
       end
       
    end
end

%% ���� ��������ƥ��ȼ���
% INS_WaveFeture [3*N]  ����������
% INS_WaveFetureN����3*1�� ������
% INS_WaveFetureT  [3*1] ��ʱ��

% VNS_WaveFeture [3*N]  ����������
% VNS_WaveFetureN����3*1�� ������
% VNS_WaveFetureT  [3*1] ��ʱ��

% matchedDegree = zeros(4,1) ;    % ǰ��ά�� x��y��z ��ƥ��ȣ���4ά���ۺ�ƥ���

function  [ matchedDegree ] =  WaveMatch_OnePoint( INS_WaveFeture,INS_WaveFetureN,INS_WaveFetureT,INS_Acc5D,...
           VNS_WaveFeture,VNS_WaveFetureN,VNS_WaveFetureT,VNS_Acc5D )

matchedDegree = zeros(4,1) ;    % ǰ��ά�� x��y��z ��ƥ��ȣ���4ά���ۺ�ƥ���
waveTimeErr = NaN(3,max(VNS_WaveFetureN));
INS_WaveV = InitialWaveV(3,1);
VNS_WaveV = InitialWaveV(3,1);

for i=1:3    
      [ matchedDegree(i),waveTimeErr(i,1:VNS_WaveFetureN(i,1)),INS_WaveV(i),VNS_WaveV(i) ] = WaveMatch_OneDim...
          ( INS_WaveFeture(i,:),INS_WaveFetureN(i,:),INS_WaveFetureT(i,:),INS_Acc5D(i,:,:),...
              VNS_WaveFeture(i,:),VNS_WaveFetureN(i,1),VNS_WaveFetureT(i,:),VNS_Acc5D(i,:,:) );      
end
matchedDegree(4) = sum( matchedDegree(1:3) );

return;
global  MinMatchDegree 
if coder.target('MATLAB') && matchedDegree(4)>MinMatchDegree
    Name='XYZ';
    for i=1:3 
        DrawMatchedWave( Name(i),INS_WaveFeture(i,:),INS_WaveFetureT(i,:),INS_WaveFetureN(i,:),...
            VNS_WaveFeture(i,:),VNS_WaveFetureT(i,:),VNS_WaveFetureN(i,:),INS_WaveV(i),VNS_WaveV(i),waveTimeErr(i,:) );
    end
end

function WaveV = InitialWaveV( Dim1N,Dim2N )
WaveV(Dim1N,Dim2N).N = 0;
WaveV(Dim1N,Dim2N).Sign = NaN(1,10);   %����һ����ķ���
WaveV(Dim1N,Dim2N).T1 = NaN(1,10);     % ��һ�ε�ʱ��
WaveV(Dim1N,Dim2N).T2 = NaN(1,10);     % �ڶ��ε�ʱ��
WaveV(Dim1N,Dim2N).PointT = NaN(3,10); % 4�����ʱ�䣨��¼��������
WaveV(Dim1N,Dim2N).PointK = NaN(3,10);
WaveV(Dim1N,Dim2N).T1Err = NaN(1,10);
WaveV(Dim1N,Dim2N).T2Err = NaN(1,10);

%% һά ���� �Ӿ�����ƥ��
% INS_WaveFeture [1*N]  ����������
% INS_WaveFetureN����1*1�� ������
% INS_WaveFetureT  [1*1] ��ʱ��

% VNS_WaveFeture [1*N]  ����������
% VNS_WaveFetureN����1*1�� ������
% VNS_WaveFetureT  [1*1] ��ʱ��

% ƥ������
% 1���������ʱ������ͬ����Ĳ���/����  ����������ʱ�䣩
    %  ����� matchedDegree = matchedDegree + 0.21;
    %  �Ƚ���� matchedDegree = matchedDegree + 0.101;

% 2) ����  V �� ��V �β� �����Ƶ� ������������ʱ�䣩
    % �����ƣ������벨�ȵ�ʱ����С�� matchedDegree = matchedDegree + 0.6002;
    % �Ƚ����ƣ������벨�ȵ�ʱ����Դ� matchedDegree = matchedDegree + 0.30002;


function [ matchedDegree,waveTimeErr,INS_WaveV,VNS_WaveV ] = WaveMatch_OneDim...
    ( INS_WaveFeture,INS_WaveFetureN,INS_WaveFetureT,INS_Acc5D,...
           VNS_WaveFeture,VNS_WaveFetureN,VNS_WaveFetureT,VNS_Acc5D )
 IsUseWaveV = 0;
       
matchedDegree = 0;       

%% ��������ʱ��ķ���
% �������ڵĲ�����ֵ�ʱ���һ��Ϊ 0.4 sec ����
absTimeErr_Small = 0.1; % sec  �ܽӽ��� �����Ӿ� �Ӿ� ����ʱ��� 
absTimeErr_Big = 0.15 ;   % sec  ������ܵ� �����Ӿ� �Ӿ� ����ʱ��� 
MaxAngleErr = 30;

waveTimeErr = NaN(1,VNS_WaveFetureN);

INS_Angle = INS_Acc5D( 1,:,4:5 );
VNS_Angle = VNS_Acc5D( 1,:,4:5 );
         
for i=1:VNS_WaveFetureN
   for j=1:INS_WaveFetureN
      if sign( VNS_WaveFeture(i) ) == sign( INS_WaveFeture(j) )
          if sign( VNS_WaveFeture(i) )==0
                continue;   % ��ʱ�����ǲ���
          end
         timeErr_i_j =  VNS_WaveFetureT(i) - INS_WaveFetureT(j);
         
         AngleErr1 = abs(INS_Angle(1,j,1)-VNS_Angle(1,i,1))*180/pi;
         AngleErr2 = abs(INS_Angle(1,j,2)-VNS_Angle(1,i,2))*180/pi;
         if AngleErr1>180
            AngleErr1 = AngleErr1-180; 
         end
         if AngleErr2>180
            AngleErr2 = AngleErr2-180; 
         end
         
         if ~isnan(waveTimeErr(i)) && abs(timeErr_i_j) < abs(waveTimeErr(i))             
 %            disp('error 1 WaveMatch_OneDim ͬһ���Ӿ���ƥ��ɹ���2�����Ե㣬absTimeErr_Big ����̫��')
             waveTimeErr(i) = timeErr_i_j;
             waveTimeErr(i) = NaN;
             continue;
         end
         
         if abs(timeErr_i_j) < absTimeErr_Big % �ҵ�һ��������ͬ��ʱ��ȽϽ��ĵ�
             % �жϼ��ٶȷ���
            if AngleErr1 > MaxAngleErr || AngleErr2 > MaxAngleErr   
               break;
            end
     %       fprintf( '���� AngleErr = %0.2f \n',AngleErr );
            
             if abs(timeErr_i_j) < absTimeErr_Small % �ҵ�һ��������ͬ��ʱ��ܽ��ĵ�
                 matchedDegree = matchedDegree + 0.21;   %�����壯����
             else
                 matchedDegree = matchedDegree + 0.101;    %�����壯����
             end
             waveTimeErr(i) = timeErr_i_j;
         end
         
      end
   end
end

%% ����������ʱ��ķ���
% һ�����ڲ���Ͳ��ȳ��ֵ�ʱ���Ϊ 0.2sec  
reTimeErr_Small = 0.08; % sec  �ܽӽ��� ���ڲ���Ͳ��ȳ��ֵ����ʱ��� �����Ӿ����
reTimeErr_Big = 0.15;    % sec  ������ܵ� ���ڲ���Ͳ��ȳ��ֵ����ʱ��� �����Ӿ����
absTimeErr_Large = 0.7; % ����ϴ�ľ���ʱ�����

% ����  V �� ��V �β�    N �� ��N �β�
[ INS_WaveV,INS_WaveN ] = SearchWave_V_N( INS_WaveFeture,INS_WaveFetureN,INS_WaveFetureT );
[ VNS_WaveV,VNS_WaveN ] = SearchWave_V_N( VNS_WaveFeture,VNS_WaveFetureN,VNS_WaveFetureT );
if IsUseWaveV==0
   return; 
end
for i=1:INS_WaveV.N
   for j=1:VNS_WaveV.N
       if INS_WaveV.Sign(i) == VNS_WaveV.Sign(j)  % 1����ΪV  -1����Ϊ��V
           T1Err_i_j = INS_WaveV.T1(i) - VNS_WaveV.T1(j) ;
           T2Err_i_j = INS_WaveV.T2(i) - VNS_WaveV.T2(j) ;
           EndTErr_i_j = INS_WaveV.PointT(3,i) - VNS_WaveV.PointT(3,j) ;
           
            AngleErr = abs(INS_Angle(1,INS_WaveV.PointK(3,i),:)-VNS_Angle(1,VNS_WaveV.PointK(3,j),:))*180/pi;
           if AngleErr>180
                AngleErr = AngleErr-180; 
            end
           
           if  abs(EndTErr_i_j)<absTimeErr_Large &&  ~isnan(VNS_WaveV.T1Err(j)) && abs(T1Err_i_j) < reTimeErr_Big && abs(T2Err_i_j) < reTimeErr_Big              
  %           disp('error 2 WaveMatch_OneDim ͬһ���Ӿ���ƥ��ɹ���2�����Ե㣬reTimeErr_Big ����̫��')
             VNS_WaveV.T1Err(j) = T1Err_i_j;
             VNS_WaveV.T2Err(j) = T2Err_i_j; 
             continue;
           end
           
           
           if abs(EndTErr_i_j)<absTimeErr_Large &&  abs(T1Err_i_j) < reTimeErr_Big && abs(T2Err_i_j) < reTimeErr_Big 
               % �õ�һ���Ƚ������ V ����
               if AngleErr(1) > MaxAngleErr || AngleErr(2) > MaxAngleErr                
                   
                   break;
               end
    %           fprintf( 'V Wave AngleErr = %0.2f \n',AngleErr );
               
               if abs(EndTErr_i_j)<absTimeErr_Large && abs(T1Err_i_j) < reTimeErr_Small && abs(T2Err_i_j) < reTimeErr_Small 
                    % �õ�һ��������� V ����
                    matchedDegree = matchedDegree + 0.6002;
                    VNS_WaveV.T1Err(j) = T1Err_i_j;
                    VNS_WaveV.T2Err(j) = T2Err_i_j; 
               else
                   matchedDegree = matchedDegree + 0.30002;
                   VNS_WaveV.T1Err(j) = T1Err_i_j;
                   VNS_WaveV.T2Err(j) = T2Err_i_j;  
               end
           end
                               
       end
   end
end

%% 
% matchedDegree = NaN( otherMakersN,INS_Joint_N,4 );
% MarkerMatchingINSk = NaN( otherMakersN,2 ); % MarkerMatchINSk(i_marker,1)Ϊ��˵�ƥ��Ĺ��Թؽ���ţ�MarkerMatchINSk(i_marker,2)Ϊ��Ӧ��ƥ���
function DrawMatchedResult( otherMakers,otherMakersContinues,vns_k,vns_k_g,visionFre,INSA_All,...
    ins_k,ins_k_g,INSA_WaveFlag_All,inertialFre )
% global INS_WAVE_MATCH

if isempty(otherMakersContinues)
   return; 
end
otherMakersN = otherMakers.otherMakersN;
InitialJointK = otherMakers(vns_k).InitialJointK;
InitialJointK_last = otherMakers(vns_k-1).InitialJointK;
for i=1:otherMakersN
    if ~isnan(InitialJointK(i)) && isnan(InitialJointK_last(i))
        % �ո�ʶ���һ���㣬����λ�úͼ��ٶ�����
        [~,ConPosition_i,ConVelocity_i,ConAcc_i,AWave] = Read_otherMakersContinues_i( otherMakersContinues,i );
        dataN_P =  otherMakersContinues.dataN( 1,i ) ;
        ConPosition_i = ConPosition_i( 1:3,1:dataN_P );
        ConAcc_i = ConAcc_i( 1:3,1:dataN_P );
        ConVelocity_i  = ConVelocity_i( 1:3,1:dataN_P );
        AWave = AWave( 1:3,1:dataN_P );
        
        vN = size(ConPosition_i,2);
        timeVNS = (vns_k_g-vN+1:vns_k_g)/visionFre ;
        timeINS = (ins_k_g-vN+1 :ins_k_g)/inertialFre ;
        
        dataFolder = 'E:\data_xyz\Hybrid Motion Capture Data\7.2 dataB\T2';
        INSPosition = importdata([dataFolder,'\INSPosition.mat']);
        INSPosition_i  =INSPosition( 3*InitialJointK(i)-2:3*InitialJointK(i),ins_k_g-vN+1:ins_k_g );
        figure('name','ʶ��ɹ���λ��-xy')
        plot( ConPosition_i(1,:),ConPosition_i(2,:),'r' )   % �Ӿ����λ��
        hold on
        plot( INSPosition_i(1,:),INSPosition_i(2,:),'b' )   % ���Ե��λ��
        legend('VNS','INS');
        
        figure('name','ʶ��ɹ���λ��-z')
        
        subplot( 3,1,1 )
        plot( timeVNS, ConPosition_i(1,:)+1.1,'r' )   % �Ӿ����λ��
        hold on
        plot( timeINS, INSPosition_i(1,:),'b' )   % ���Ե��λ��
        subplot( 3,1,2 )
        plot( timeVNS, ConPosition_i(2,:)+1.1,'r' )   % �Ӿ����λ��
        hold on
        plot( timeINS, INSPosition_i(2,:),'b' )   % ���Ե��λ��
        subplot( 3,1,3 )
        plot( timeVNS, ConPosition_i(3,:)+1.1,'r' )   % �Ӿ����λ��
        hold on
        plot( timeINS, INSPosition_i(3,:),'b' )   % ���Ե��λ��
        legend('VNS','INS');
        
        figure('name','ʶ��ɹ���ļ��ٶ�-VNS')        
        subplot(3,1,1)
        plot( timeVNS, ConAcc_i(1,:)' )
        hold on
        plot( timeVNS, AWave(1,:)','*r' )
        subplot(3,1,2)
        plot( timeVNS, ConAcc_i(2,:)' )
        hold on
        plot( timeVNS, AWave(2,:)','*r' )
        subplot(3,1,3)
        plot( timeVNS, ConAcc_i(3,:)' )
        hold on
        plot( timeVNS, AWave(3,:)','*r' )
        
        figure('name','ʶ��ɹ�����ٶ�-VNS')        
        subplot(3,1,1)
        plot( timeVNS, ConVelocity_i(1,:)' )
        subplot(3,1,2)
        plot( timeVNS, ConVelocity_i(2,:)' )
        subplot(3,1,3)
        plot( timeVNS, ConVelocity_i(3,:)' )
        
%         INS_WaveFetureT = INS_WAVE_MATCH.INS_WaveFetureT;
%         INS_WaveFetureN = INS_WAVE_MATCH.INS_WaveFetureN;
%         INS_WaveFeture = INS_WAVE_MATCH.INS_WaveFeture;
        
        figure('name','ʶ��ɹ���ļ��ٶ�-INS')
        INSA_All_i = INSA_All( InitialJointK(i)*3-2:InitialJointK(i)*3,ins_k-vN+1:ins_k );
        INSA_WaveFlag_All_i = INSA_WaveFlag_All( InitialJointK(i)*3-2:InitialJointK(i)*3,ins_k-vN+1:ins_k );
        
        subplot(3,1,1)
        plot( timeINS, INSA_All_i(1,:)' )
        hold on
        plot( timeINS, INSA_WaveFlag_All_i(1,:)','*r' )   
        subplot(3,1,2)
        plot( timeINS, INSA_All_i(2,:)' )        
        hold on
        plot( timeINS, INSA_WaveFlag_All_i(2,:)','*r' )
        subplot(3,1,3)
        plot( timeINS, INSA_All_i(3,:)' )
        hold on
        plot( timeINS,INSA_WaveFlag_All_i(3,:)','*r' )
    end
end


%% ʵʱ���� �Ӿ� λ������
function DrawotherMakersContinuesRealTime( otherMakersContinues,otherMakers,vns_k )
IsDrawNon = 0;
if isempty(otherMakersContinues)
   return; 
end
persistent vnsPh vnsAOK_h

if coder.target('MATLAB') 
    if isempty(vnsAOK_h)
        if IsDrawNon
            vnsPh = figure('name','δʶ����˵�λ��');
        end
        vnsAOK_h = figure('name','��ʶ����˵�λ��');
    end
    if IsDrawNon
        for k=1:8
            figure(vnsPh)
            subplot( 4,2,k );
            delete(cla)
        end
    end
    
    InitialJointK = otherMakers(vns_k).InitialJointK;
    otherMakersN = otherMakers(vns_k).otherMakersN ;
    InitialJoint_IsOK = zeros(1,6);
    for i_marker=1:otherMakersN
        InitialJointK_i = InitialJointK(i_marker);
        [~,ConPosition_i,ConVelocity_i,ConAcc_i,AWave] = Read_otherMakersContinues_i( otherMakersContinues,i_marker );
        ConPosition_i = ConPosition_i( 1:3,1:otherMakersContinues.dataN( 1,i_marker ) );
        ConAcc_i = ConAcc_i( 1:3,1:otherMakersContinues.dataN( 9,i_marker ) );
        AWave = AWave( 1:3,1:otherMakersContinues.dataN( 9,i_marker ) );
        
        if ~isnan(InitialJointK_i)
            %% ʶ��ɹ��ĵ�
            InitialJoint_IsOK( InitialJointK_i ) = 1;
            figure(vnsAOK_h)
            subplot( 3,2,InitialJointK_i );              
                plot( ConPosition_i(1,:),ConPosition_i(2,:) )
                
        elseif IsDrawNon
            %% δʶ��ɹ��ĵ�
            if i_marker>8
               continue; 
            end
            figure(vnsPh)
            subplot( 4,2,i_marker );
                plot( ConPosition_i(1,:),ConPosition_i(2,:) )
        end
    end
    for k=1:6
       if  InitialJoint_IsOK(k)==0  % ����㶪��
           figure(vnsAOK_h)
           subplot( 3,2,k );   
           delete(cla)
       end
    end
end

%% һά ����������
function DrawMatchedWave( Name,INS_WaveFeture,INS_WaveFetureT,INS_WaveFetureN,VNS_WaveFeture,...
    VNS_WaveFetureT,VNS_WaveFetureN,INS_WaveV,VNS_WaveV,waveTimeErr )

% INS_WaveFeture = INS_WAVE.INS_WaveFeture;
% INS_WaveFetureT = INS_WAVE.INS_WaveFetureT;
% INS_WaveFetureN = INS_WAVE.INS_WaveFetureN;
% INS_WaveV = INS_WAVE.INS_WaveV;
% 
% VNS_WaveFeture = VNS_WAVE.VNS_WaveFeture;
% VNS_WaveFetureT = VNS_WAVE.VNS_WaveFetureT;
% VNS_WaveFetureN = VNS_WAVE.VNS_WaveFetureN;
% VNS_WaveV = VNS_WAVE.VNS_WaveV;
% waveTimeErr = VNS_WAVE.waveTimeErr;
 

    T1Err  = VNS_WaveV.T1Err ;
    T2Err = VNS_WaveV.T2Err ;

    figure( 'name',[Name,'-������'] )
    plot( INS_WaveFetureT(1:INS_WaveFetureN),INS_WaveFeture(1:INS_WaveFetureN),'*r' )
    hold on
    plot( VNS_WaveFetureT(1:VNS_WaveFetureN),VNS_WaveFeture(1:VNS_WaveFetureN),'*b' )
    for i=1:VNS_WaveFetureN
        if ~isnan(waveTimeErr(i))
            text( VNS_WaveFetureT(i),VNS_WaveFeture(i),num2str(waveTimeErr(i)) ); 
        end
    end
    legend('INS','VNS')
    
    figure( 'name',[Name,'-�������'] )
    plot( INS_WaveFetureT(1:INS_WaveFetureN),INS_WaveFeture(1:INS_WaveFetureN),'*r' )
    hold on
    plot( VNS_WaveFetureT(1:VNS_WaveFetureN),VNS_WaveFeture(1:VNS_WaveFetureN),'*b' )
    legend('INS','VNS')
    
    for i=1:INS_WaveV.N
        plot( INS_WaveFetureT(INS_WaveV.PointK(:,i)),INS_WaveFeture(INS_WaveV.PointK(:,i)),'--r' )
    end
    for i=1:VNS_WaveV.N
        plot( VNS_WaveFetureT(VNS_WaveV.PointK(:,i)),VNS_WaveFeture(VNS_WaveV.PointK(:,i)),'--b' )
        if ~isnan( T1Err(i) )
            text( VNS_WaveFetureT(VNS_WaveV.PointK(1,i)),VNS_WaveFeture(VNS_WaveV.PointK(1,i)),num2str(T1Err(i)) );
            text( VNS_WaveFetureT(VNS_WaveV.PointK(3,i)),VNS_WaveFeture(VNS_WaveV.PointK(3,i)),num2str(T2Err(i)) );
      	end
    end



%% ����  V �� ��V �β�    N �� ��N �β�
function [ WaveV,WaveN ] = SearchWave_V_N( WaveFeture,WaveFetureN,WaveFetureT )


WaveN.N = 0;            %  N �в��ĸ���
WaveN.Sign = NaN(1,10);   %����һ����ķ���
WaveN.T1 = NaN(1,10);     % ��һ�ε�ʱ��
WaveN.T2 = NaN(1,10);     % ��һ�ε�ʱ��
WaveN.T3 = NaN(1,10);     % ��һ�ε�ʱ��
WaveN.PointT = NaN(4,10); % 3�����ʱ�䣨��¼��������
WaveN.PointK = NaN(4,10);
WaveN.T1Err = NaN(1,10);
WaveN.T2Err = NaN(1,10);

WaveV.N = 0;
WaveV.Sign = NaN(1,10);   %����һ����ķ���
WaveV.T1 = NaN(1,10);     % ��һ�ε�ʱ��
WaveV.T2 = NaN(1,10);     % �ڶ��ε�ʱ��
WaveV.PointT = NaN(3,10); % 4�����ʱ�䣨��¼��������
WaveV.PointK = NaN(3,10);
WaveV.T1Err = NaN(1,10);
WaveV.T2Err = NaN(1,10);

k1 = 0; 
for k=1:WaveFetureN-2
   % V ��
   if k<=k1
      continue; % ��ֹ�ظ� 
   end
   k1 = k;
   if WaveFeture(k1)==0  % ��������
        k1 = k1+1;
   end
   if k1 > WaveFetureN
      break; 
   end
   
   k2 = k1+1;
   if WaveFeture(k2)==0  % ��������
        k2 = k2+1;
   end
   if k2 > WaveFetureN
      break; 
   end
   
   k3 = k2+1;
   if WaveFeture(k3)==0  % ��������
        k3 = k3+1;
   end
   if k3 > WaveFetureN
      break; 
   end
   
   k4 = k3+1;
   if k4 <= WaveFetureN &&  WaveFeture(k4)==0  % ��������
        k4 = k4+1;
   end
   %% ������ N ��
   if k4 <= WaveFetureN 
       if sign( WaveFeture(k1) ) == -sign( WaveFeture(k2) ) == sign( WaveFeture(k3) )  == -sign( WaveFeture(k4) )
        % �ж�Ϊ  N �� ��N �β�
        WaveN.N = WaveN.N+1;
        WaveN.Sign(WaveN.N) = sign( WaveFeture(k1) );
        WaveN.T1(WaveN.N) = WaveFetureT(k2)-WaveFetureT(k1) ;     % ��һ�ε�ʱ��
        WaveN.T2(WaveN.N) = WaveFetureT(k3)-WaveFetureT(k2) ;     % �ڶ��ε�ʱ��
        WaveN.T3(WaveN.N) = WaveFetureT(k4)-WaveFetureT(k3) ;     % �����ε�ʱ��
        WaveN.PointT(:,WaveN.N) = [ WaveFetureT(k1); WaveFetureT(k2); WaveFetureT(k3); WaveFetureT(k4) ];            
        WaveN.PointK(:,WaveN.N) = [ k1;k2;k3;k4 ];
       end
   end
   %% ������ V ��
   if sign( WaveFeture(k1) ) == -sign( WaveFeture(k2) ) == sign( WaveFeture(k3) )
       % �ж�Ϊ  V �� ��V �β�
       WaveV.N = WaveV.N+1;
       WaveV.Sign(WaveV.N) = sign( WaveFeture(k1) );
       WaveV.T1(WaveV.N) = WaveFetureT(k2)-WaveFetureT(k1) ;     % ��һ�ε�ʱ��
       WaveV.T2(WaveV.N) = WaveFetureT(k3)-WaveFetureT(k2) ;     % �ڶ��ε�ʱ��
       WaveV.PointT(:,WaveV.N) = [ WaveFetureT(k1); WaveFetureT(k2); WaveFetureT(k3) ];  
       WaveV.PointK(:,WaveV.N) = [ k1;k2;k3 ];
   end
   
end

%% WaveFlag תΪ WaveResult
%����WaveFlag����(M)*BN��  M����˵����*3 ��BN�����ݻ��泤��
%  validN �� WaveFlag����Ч����
% k_global ��validN ��Ӧ�� �ӳ������еĵ�һ֡����ǰ��֡�������ܻ����СӰ�죩
% WaveResult 
    % WaveResult.wave  [ M*100 ] ֱ�ӱ��沨������ �����100����   ÿһ�д洢һ����˵��һά�Ĳ�������ֵ
    % WaveResult.Angle [ M/3*2,100 ]  (m*2-1,:) ��m����˵���ٶ�ˮƽ�����붫��ļнǣ�
        % (m*2,:) ��m����˵�3D���ٶ�ʸ�������ļн�
    % WaveResult.time  [M*100]  ÿ�����������Ӧ��ʱ��
    % WaveResult.waveN  [M*1]  ���ĸ���
    % WaveResult.waveReadedN  [M*1]  �ѶȲ�����
    
function WaveResult = GetWaveResult( WaveFlag,validN,k_global,fre,Acc )

M = size(WaveFlag,1);  % ����ά���� ��ĸ���*3

WaveResult = struct;
MaxWaveN = 20;   % ����������������
wave = NaN(M,MaxWaveN);
time = NaN(M,MaxWaveN);
waveN = zeros(M,1);
waveReadedN = zeros(M,1);
waveFlag_k = NaN(M,MaxWaveN);  % waveN �� WaveFlag �е�����
Acc5D = NaN( M,MaxWaveN,5 );  % �������㴦�� 3ά���ٶȺͷ���

for i=1:M  % �� i ������ά�ȣ�M/3����˵㣬����M������ά�ȣ�
    for j=1:validN(i)  % �� j ��ʱ��
        if ~isnan( WaveFlag(i,j) )
            waveN(i) = waveN(i)+1;
            wave(i,waveN(i)) = WaveFlag(i,j);  
            time(i,waveN(i)) = (k_global+j-validN(i))/fre;  % �ӳ������еĵ�һ֡����ǰ��ʱ��
            waveFlag_k(i,waveN(i)) = j;
            
            m = ceil(i/3);  % �� m����
            Acc_k = Acc(m*3-2:m*3,j);            
            AccAngle_k = GetAccAngle( Acc_k );
            Acc5D( i,waveN(i),: ) = [ Acc_k;AccAngle_k ];
        end
    end
end
WaveResult.wave = wave;
WaveResult.time = time;
WaveResult.waveFlag_k = waveFlag_k;
WaveResult.waveN = waveN;
WaveResult.Acc5D = Acc5D;
WaveResult.waveReadedN = waveReadedN;

%% һ��ʱ�̵������Է���

function [ otherMakers,IsLostMark ] = ContinuesAnalyze( otherMakers,k_vision,INS_Joint_N,visionFre,VBN )

persistent makerTrackThreshold
if isempty(makerTrackThreshold)
    [ makerTrackThreshold,~ ] = SetConstParameters( visionFre ); 
end

trackedMakerPosition = NaN(3,VBN);  % �޸�������µ�������

otherMakers(k_vision) = PreProcess_otherMakers( otherMakers(k_vision)  );
otherMakers_k_last = otherMakers(k_vision-1);
[ otherMakers(k_vision),dPi_ConJudge ] = ContinuesJudge( otherMakers(k_vision),otherMakers_k_last,...
    trackedMakerPosition,k_vision,makerTrackThreshold );

%% �ж��Ƿ�����˵㶪ʧ���
InitialJointK_k = otherMakers(k_vision).InitialJointK(1:INS_Joint_N) ;
if sum(isnan(InitialJointK_k)) == 0
    % û����˵㶪ʧ������Ҫʶ��
    IsLostMark = 0;
else
    IsLostMark = 1;
end

%% ��һ��ʱ�̣� ������˵�λ�ã� ������ٶȲ��β���
%% WaveResult
%   WaveResult.WaveFlag
function  [ otherMakers,VNSA_WaveFlag_All,VNSP_ValidN_All,VNSA_All,otherMakersContinuesTestOut ] = VNSP_AWave_Analyze...
    ( otherMakers,vns_k,vns_k_g,VBN,IsOnlyLost )

persistent parametersSet  otherMakersContinues  A_k_waves_OKLast_All
visionFre  = otherMakers(vns_k).frequency;
if isempty(parametersSet)
    [ ~,INSVNSCalibSet ] = SetConstParameters( visionFre );    
    waveThreshold_VNSAcc = SetWaveThresholdParameters( 'VNSAcc' );
    parametersSet.waveThreshold_VNSAcc = waveThreshold_VNSAcc;
    parametersSet.INSVNSCalibSet = INSVNSCalibSet;
    otherMakersContinues = Initial_otherMakersContinues( VBN );
    A_k_waves_OKLast_All = zeros( 3*20 ); %  ������˵㣨���20�� ��  % A_k_waves_OKLast_All(:,i_marker)��¼��һʱ���жϳɹ��ĵ㣨��ֹ�жϳɹ��ĵ㱻���ǣ�
end

    % ���ϸ����� k_vision ʱ�̵���˵���������Ϣ��
    %% ���� otherMakers(k_vision) ���� ��ǰ���������� 
    % ÿ��ʱ�̽� otherMakersContinues �����µ� otherMakers ��Ž������򣬲�����˳����·���
ContinuesLasti_All = otherMakers(vns_k).ContinuesLasti ;  % ��ǰʱ�� ������˵� ��Ӧ�� ��ʱ����˵����
%% �Ƚ� otherMakersContinues �����µ���˵���� ����
%% �� otherMakers(k_vision).Position �е���˵����Ϊ׼
[ otherMakersContinues,A_k_waves_OKLast_All ] = ReOrderContinues( ContinuesLasti_All,otherMakersContinues,A_k_waves_OKLast_All ) ;
otherMakersN = otherMakers(vns_k).otherMakersN ;

VNSA_All = NaN(3*otherMakersN,VBN) ;
VNSA_WaveFlag_All = NaN(3*otherMakersN,VBN) ;
VNSP_ValidN_All = zeros(3*otherMakersN,1) ;  

% WaveResult [ MaxotherMakersN*3,1 ]

otherMakersContinuesTestOut=[];

for i_marker=1:otherMakersN
    if IsOnlyLost && ~isnan( otherMakers(vns_k).InitialJointK(i_marker) ) 
       continue;  % ��������û�ж��Ͳ����� 
    end

    [ otherMakersContinues,A_k_waves_OKLast_All( :,i_marker ) ] = AnalyzeVNSAWave( otherMakers,vns_k,i_marker,...
        otherMakersContinues,parametersSet,visionFre,A_k_waves_OKLast_All( :,i_marker ) ) ;
    otherMakersContinues.otherMakersN = otherMakers(vns_k).otherMakersN;
    otherMakersContinues.InitialJointK = otherMakers(vns_k).InitialJointK;
    % ���� otherMakersContinues ���� WaveResult
    
    [~,ConPosition_i,ConVelocity_i,ConAcc_i,AWave] = Read_otherMakersContinues_i( otherMakersContinues,i_marker );
    VNSA_WaveFlag_All( i_marker*3-2:i_marker*3,: )  = AWave( (14:16)-13,:);  
    VNSP_ValidN_All( i_marker*3-2:i_marker*3,1 ) = otherMakersContinues.dataN( 1:3,i_marker );  % λ�õ���Ч���ȣ���vns_k_g ��ֵ���ܵõ�����ʱ�䣩
    VNSA_All( i_marker*3-2:i_marker*3,: ) = ConAcc_i( 1:3,: );
    
    if coder.target('MATLAB') 
        otherMakersContinuesTestOut = otherMakersContinues;
    end
end



%% ���Լ��ٶȲ��η��� ��һ��ʱ�̣�

function [INSA_WaveFlag_All_Out,INSA_TestOut] = INSA_Wave_Analyze...
    ( INSA_All, INS_Joint_N,ins_k,IBN,inertialFre,removeN )
persistent waveThreshold_INSAcc
if isempty(waveThreshold_INSAcc)
    waveThreshold_INSAcc = SetWaveThresholdParameters( 'INSAcc' );
end
%% ���й��Ծ�̬����
persistent  INSA_WaveFlag_All  INSA_V_All   INSA_waveFront_All  INSA_waveBack_All  INSA_k_waves_OKLast_All
if isempty( INSA_WaveFlag_All )
    INSA_WaveFlag_All = NaN( 3*INS_Joint_N,IBN );
    INSA_V_All = NaN( 5*INS_Joint_N,IBN );
    INSA_waveFront_All = NaN( 3*INS_Joint_N,IBN );
    INSA_waveBack_All = NaN( 3*INS_Joint_N,IBN );
    INSA_k_waves_OKLast_All = zeros(3*INS_Joint_N,1);
end
if removeN>0
    INSA_WaveFlag_All = RemoveLastN( INSA_WaveFlag_All,removeN );
    INSA_V_All = RemoveLastN( INSA_V_All,removeN );
    INSA_waveFront_All = RemoveLastN( INSA_waveFront_All,removeN );
    INSA_waveBack_All = RemoveLastN( INSA_waveBack_All,removeN );
    INSA_k_waves_OKLast_All = RemoveLastN( INSA_k_waves_OKLast_All,removeN );
end
%% �� INS_Joint_N ������в��η���
for n = 1:INS_Joint_N
    data_WaveFlag = INSA_WaveFlag_All( n*3-2:n*3,: );
    dataV  = INSA_V_All( n*5-4:n*5,: );
    dataA_waveFront = INSA_waveFront_All( n*3-2:n*3,: );
    dataA_waveBack = INSA_waveBack_All( n*3-2:n*3,: );
    k_waves_OKLast = INSA_k_waves_OKLast_All( n*3-2:n*3,: );  % ��¼��һʱ���жϳɹ��ĵ㣨��ֹ�жϳɹ��ĵ㱻���ǣ�
    
    [ data_WaveFlag,dataV,dataA_waveFront,dataA_waveBack,k_waves_OKLast ] = AnalyzeWave...
    ( INSA_All( n*3-2:n*3,: ),ins_k,inertialFre,dataV,data_WaveFlag,k_waves_OKLast,dataA_waveFront,dataA_waveBack,waveThreshold_INSAcc );

    INSA_WaveFlag_All( n*3-2:n*3,: ) = data_WaveFlag;
    
    INSA_V_All( n*5-4:n*5,: ) = dataV;
    INSA_waveFront_All( n*3-2:n*3,: ) = dataA_waveFront;
    INSA_waveBack_All( n*3-2:n*3,: ) = dataA_waveBack;
    INSA_k_waves_OKLast_All( n*3-2:n*3,: ) = k_waves_OKLast;
end

if coder.target('MATLAB')
    INSA_TestOut.INSA = INSA_All;
    INSA_TestOut.INSA_WaveFlag_All = INSA_WaveFlag_All;
    INSA_TestOut.INSA_V_All = INSA_V_All ;
    INSA_TestOut.INSA_waveFront_All = INSA_waveFront_All ;
    INSA_TestOut.INSA_waveBack_All = INSA_waveBack_All ;
else
    INSA_TestOut = [];
end
INSA_WaveFlag_All_Out = INSA_WaveFlag_All;

%% ȥ����ǰ removeN ��ʱ�̣�������NaN
function data = RemoveLastN( data,removeN )
if removeN<1
   return; 
end
dataN = size( data,2 );
valid_N = dataN-removeN;
for i=1:valid_N
    data( :,i ) = data(:,removeN+i);
end

% dataBack = data(:,removeN+1:dataN);
% data( :,1:dataN-removeN )  =dataBack ;

for i=1:removeN
    data( :,valid_N+i ) = NaN ; 
end
% data( :,dataN-removeN+1:dataN ) = NaN ; 




%% ��ʼ�� otherMakersContinues
%  otherMakersContinues ���洢��ǰ���µ������߶Σ������뵱ǰ�ġ�otherMakers(k).Position������һ��
% otherMakersContinues.data_i [*N]  (1:3,:)��λ�ã�(4:8,:)���ٶȣ�(9:13,:)�Ǽ��ٶȣ�
    %  AWave = data_i( 14:27,: ); 
        %  (14:16,:)�Ǽ��ٶȲ��β��� VNSA_WaveFlag�� (17:21,:) ��VNSA_V��
        % (22:24,:)��VNSA_Acc_waveFront��(25:27,:) ��VNSA_Acc_waveBack
% visualN �� �������ߵ���󳤶�        
function otherMakersContinues = Initial_otherMakersContinues( visualN )

otherMakersContinues = struct;      % ���10�����10sec����������
otherMakersContinues.otherMakersN = 0;
otherMakersContinues.dataN = zeros(5,20);

M = 27;
otherMakersContinues.data1 = NaN( M,visualN );  % �� 1 ����˵�
otherMakersContinues.data2 = NaN( M,visualN );  % �� 2 ����˵�
otherMakersContinues.data3 = NaN( M,visualN );  % �� 3 ����˵�
otherMakersContinues.data4 = NaN( M,visualN );
otherMakersContinues.data5 = NaN( M,visualN );
otherMakersContinues.data6 = NaN( M,visualN );
otherMakersContinues.data7 = NaN( M,visualN );
otherMakersContinues.data8 = NaN( M,visualN );
otherMakersContinues.data9 = NaN( M,visualN );
otherMakersContinues.data10 = NaN( M,visualN );
otherMakersContinues.data11 = NaN( M,visualN );
otherMakersContinues.data12 = NaN( M,visualN );
otherMakersContinues.data13 = NaN( M,visualN );
otherMakersContinues.data14 = NaN( M,visualN );
otherMakersContinues.data15 = NaN( M,visualN );
otherMakersContinues.data16 = NaN( M,visualN );
otherMakersContinues.data17 = NaN( M,visualN );
otherMakersContinues.data18 = NaN( M,visualN );
otherMakersContinues.data19 = NaN( M,visualN );
otherMakersContinues.data20 = NaN( M,visualN );
