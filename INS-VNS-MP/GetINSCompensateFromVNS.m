%% xyz 2015 5.25

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
% otherMakers(k).InitialJointK = NaN(1,MaxotherMakersN_k);  % ��Ӧ���Խڵ����

%% InertialData
% InertialData.frequency (k)
% InertialData.time (k)
% InertialData.visuak_k  (k)
% InertialData.HipQuaternion(k)  [4*N]
% InertialData.HipPosition (k)  [3*N]
% InertialData.HeadQuaternion (k)  [4*N]
% InertialData.HeadPosition (k)  [3*N]
% InertialData.BodyDirection(k)  [3*1]

%% CalculateOrder �������
% CalStartVN = CalculateOrder.CalStartVN ;  �Ӿ�������� int32[1] 
% CalEndVN = CalculateOrder.CalEndVN ;      �Ӿ������յ�
% CalStartIN = CalculateOrder.CalStartIN;   ���Լ������   
% CalEndIN = CalculateOrder.CalEndIN;       ���Լ����յ�
%% CalculateOrder �����ù���
%   CalStartVN �� CalStartIN ��1��ʼ��������һʱ�̱��������� CalStartIN = CalEndINSave+1; CalStartVN = CalStartVNSave+1;
%   CalEndIN ���ڻ���� CalStartVN ��  CalEndVN ���ڻ����CalStartVN

%% �� Optitrack �� OtherMarker ��������ϵͳ


%% �õ����� Hip λ�ò����� SingleFrameCompensate
% SingleFrameCompensate [ 3*N ]  m  NEDϵ
% CalStartVN_in �� �Ӿ�������㣨��
% CalEndVN_in �������յ㣨�Ӿ���
% IsHandledVisual IsHandledInerital ��¼ÿ�����Ĵ������ �� 0��ʾû����1��ʾ1��-������2�����ظ�����
 
function [ AccumulateCompensate_k_Out,otherMakers ] = GetINSCompensateFromVNS...
    ( InertialData,otherMakers,compensateRate,CalculateOrder )

coder.extrinsic('fprintf');
coder.inline('never');
coder.extrinsic('DrawTracedINSVNS');

global    visionFre inertialFre
global InertialData_visual_k  VisionData_inertial_k CalStartIN  CalEndIN
%% �������  ʵʱ�����ߵ��л� ʵ�� 
%   CalStartN �� ������ʼ�㣨�Ӿ���
%   CalEndN �� ��������㣨�Ӿ���
global CalStartVN CalEndVN  
visualN = length(otherMakers);
ineritalN = size(InertialData.HeadPosition,2);
CalStartVN = CalculateOrder.CalStartVN ;
CalEndVN = CalculateOrder.CalEndVN ;
CalStartIN = CalculateOrder.CalStartIN;
CalEndIN = CalculateOrder.CalEndIN;
   
% ���Ӿ��궨ʱ�����������������κ�Ҫ��ʱ����ͨ�� BodyDirection ���Ӿ��ĳ������������һ��
% inertialTime(CalStartVN:CalEndVN ) = InertialData.time(CalStartVN:CalEndVN ) ;
if isempty(VisionData_inertial_k)
    VisionData_inertial_k = NaN(1,visualN);
end
if CalStartVN<10
   temp = 1;
else
    temp = double(CalStartVN);
end
for k = temp:CalEndVN
    VisionData_inertial_k(k) = otherMakers(k).inertial_k;
end

%% otherMakers Ԥ����
otherMakers = PreProcess( otherMakers );
% fprintf('PreProcess OK \n');
%       DrawAllINSVNS( otherMakers,InertialData ) ;
%    return;

%% ����˵����
%       dbstop in GetRightOtherMaker
%% load data
% inertialTime = InertialData.time ;
inertialFre = InertialData.frequency ;
if isempty(InertialData_visual_k)
    InertialData_visual_k = double(InertialData.visual_k) ;
else
    InertialData_visual_k(CalStartIN:CalEndIN) = double(InertialData.visual_k(CalStartIN:CalEndIN)) ;
end

visionFre = otherMakers(1).frequency ;
MarkerSet= otherMakers(1).MarkerSet ;

persistent InertialPosition
if isempty(InertialPosition)
    InertialPosition = NaN(3,ineritalN);
end
switch MarkerSet   % ���м����ݹ������
    case 16   % 'Head'
        InertialPosition(:,CalStartIN:CalEndIN) = InertialData.HeadPosition(:,CalStartIN:CalEndIN) ;
        
    case 1 %  'Hip'
        InertialPosition(:,CalStartIN:CalEndIN) = InertialData.HipPosition(:,CalStartIN:CalEndIN) ;
    otherwise
        InertialPosition(:,CalStartIN:CalEndIN) = InertialData.HeadPosition(:,CalStartIN:CalEndIN) ;
end
% HipQuaternion = InertialData.HipQuaternion ;
% HeadQuaternion = InertialData.HeadQuaternion ;


[ trackedMakerPosition_InertialTime,otherMakers ] =  GetRightOtherMaker( otherMakers,InertialPosition ) ;

%% λ�ò���

% [ InertialPositionCompensate,HipDisplacementNew ] = VNSCompensateINS...
%     ( compensateRate,trackedMakerPosition_InertialTime,InertialData.HipPosition,InertialPosition ) ;

CalInertialN = CalEndIN - CalStartIN;

persistent InertialPositionNew_k AccumulateCompensate_k
if isempty(AccumulateCompensate_k)
   AccumulateCompensate_k = zeros(3,1); 
   InertialPositionNew_k = NaN(3,1); % �� k-1 ʱ�̲������������ϣ������Ե���һ��ʱ�̵� K ʱ�̽��
end

persistent  InertialPositionNew AccumulateCompensate
if isempty(InertialPositionNew)
   InertialPositionNew = NaN(3,ineritalN); 
   AccumulateCompensate = NaN(3,ineritalN); 
end

for k = CalStartIN : CalEndIN   
    if CalStartIN == 1
        InertialPositionNew_k = InertialPosition(:,1);
        AccumulateCompensate_k = zeros(3,1);
    else
        if isnan(trackedMakerPosition_InertialTime(1,k))   % ��һʱ��û�и��ٳɹ���ֱ�Ӵ����Ե���
            InertialPositionNew_k = InertialPositionNew_k+( InertialPosition(:,k)-InertialPosition(:,k-1) );
            
        else
            [ SingleFrameCompensate_k,AccumulateCompensate_k,InertialPositionNew_k ] = VNSCompensateINS_k...
                ( compensateRate,trackedMakerPosition_InertialTime(:,k),InertialPosition(:,k-1:k),InertialPositionNew_k );
        end
    end
    if coder.target('MATLAB')
        InertialPositionNew(:,k) = InertialPositionNew_k;
        AccumulateCompensate(:,k) = AccumulateCompensate_k;
    end
end

AccumulateCompensate_k_Out = AccumulateCompensate_k;

 

if coder.target('MATLAB')
    if CalEndIN >= ineritalN-2 || CalEndVN >= visualN-2
        DrawCompensated( compensateRate,trackedMakerPosition_InertialTime,InertialPosition,InertialPositionNew,...
            AccumulateCompensate,ineritalN );
    end
end


%% ��֡ λ�Ʋ��� kʱ��
%%% Input
% trackedMakerPosition_InertialTime �� ��˵��ѧλ�ã�������ʱ��洢
% HipDisplacement �� Hip�ڱ������µ�λ�� ���� BVH �õ���
% InertialPosition_k�� [3,2] k-1��kʱ��   ����ϵ����˵㰲װλ�ö�Ӧ�ؽڵ�λ�ã���װ��ͷ��ʱ��InertialPosition Ϊ����ͷ��λ�ã�
%%% Output
% InertialPositionNew �� ��������Ե�λ��
% HipDisplacementNew�� ������Hip��λ��
function [ SingleFrameCompensate_k,AccumulateCompensate_k,InertialPositionNew_k ] = VNSCompensateINS_k...
( compensateRate,trackedMakerPosition_InertialTime_k,InertialPosition_k,InertialPositionNew_k_last )
coder.inline('never');
% coder.extrinsic('fprintf');
% coder.extrinsic('DrawCompensate');
% global CalStartIN  CalEndIN     
% persistent InertialPositionNew_k  % ��k-1ʱ�̲�����λ�õĻ����ϣ�����һ�������Ե��Ƶõ���λ��
% ���ô����Ե��ƣ���ǰһʱ�̲���������ϣ����Ե���һ���õ���λ��
InertialPositionNew_k = InertialPositionNew_k_last+( InertialPosition_k(:,2)-InertialPosition_k(:,1) );
% ���󴿹������
InertialErr_k = trackedMakerPosition_InertialTime_k - InertialPositionNew_k ;  % ��ǰ��Թ�ѧ�����
InertialErr_k(3) = 0;   % �߶ȷ��򲻲���
SingleFrameCompensate_k = InertialErr_k*compensateRate ;  % ��֡������
InertialPositionNew_k = InertialPositionNew_k + SingleFrameCompensate_k;   % ���� �� ���ѧ����
AccumulateCompensate_k = InertialPositionNew_k-InertialPosition_k(:,2) ;  % �ۻ�������

 
%% λ�Ʋ���
%%% Input
% trackedMakerPosition_InertialTime �� ��˵��ѧλ�ã�������ʱ��洢
% HipDisplacement �� Hip�ڱ������µ�λ�� ���� BVH �õ���
% InertialPosition�� ����ϵ����˵㰲װλ�ö�Ӧ�ؽڵ�λ�ã���װ��ͷ��ʱ��InertialPosition Ϊ����ͷ��λ�ã�
%%% Output
% InertialPositionNew �� ��������Ե�λ��
% HipDisplacementNew�� ������Hip��λ��
function [ InertialPositionCompensate_out,HipDisplacementNew_out ] = VNSCompensateINS...
( compensateRate,trackedMakerPosition_InertialTime,HipDisplacement,InertialPosition )
coder.inline('never');
coder.extrinsic('fprintf');
coder.extrinsic('DrawCompensate');
global CalStartIN  CalEndIN 

% %% BVH ��ȡ�ĸ��� N_BVH ���ܻ�� N1 �༸��
N_BVH = size(HipDisplacement,2);
% N1 = size(trackedMakerPosition_InertialTime,2);
% for k=N1+1:N_BVH
%     trackedMakerPosition_InertialTime(:,k) = trackedMakerPosition_InertialTime(:,N1);
%     InertialPosition(:,k) = InertialPosition(:,N1);
% end

%% �Ȳ��� InertialPositionNew
persistent SingleFrameCompensate  InertialPositionNew HipDisplacementNew
if isempty(SingleFrameCompensate)
    SingleFrameCompensate = NaN(3,N_BVH); % ÿһ�����ۻ�λ�Ʋ����� ��¼
    SingleFrameCompensate(:,1)=zeros(3,1);
    InertialPositionNew = NaN(3,N_BVH);
    InertialPositionNew(3,:) = InertialPosition(3,:); % �߶Ȳ�����
    InertialPositionNew(1:2,1) = InertialPosition(1:2,1) ;  % ��ʼ��ѡ�����
    
    HipDisplacementNew = NaN(3,N_BVH); 
    HipDisplacementNew(3,:) = HipDisplacement(3,:);
    HipDisplacementNew(:,1) = HipDisplacement(:,1);
end
persistent   InertialErr
if isempty(InertialErr)
    InertialErr = NaN(2,N_BVH);       % ʵʱ��¼����������
end
CalN = CalEndIN-CalStartIN+1; % �漰���μ�������ݳ���
AccumulateCompensate_k = zeros(3,CalN);

for k = max(2,CalStartIN) : CalEndIN 
    i = k-CalStartIN+1;  % �ڱ��μ����е����
    % ���ô����Ե��ƣ���ǰһʱ�̲���������ϣ����Ե���һ���õ���λ��
    if coder.target('MATLAB')
        % MATLAB ���ߴ���ʱ���õ��� InertialPosition
        % ��һֱû�в�������ġ������ô��ߵ����Ƶõ�������һ��ʱ��û�в����Ľ��
        InertialPositionNew(1:2,k) = InertialPositionNew(1:2,k-1)+( InertialPosition(1:2,k)-InertialPosition(1:2,k-1) );
    else
        % ʵʱ����ʱ���õ��� InertialPosition ��ֻ�� CalStartIN: CalEndIN  ʱ��û�в�������ġ�
        InertialPositionNew(1:2,k) = InertialPositionNew(1:2,k-1)+( InertialPosition(1:2,k)-InertialPosition(1:2,k-1) );
    end
    % ���󴿹������
    if ~isnan(trackedMakerPosition_InertialTime(1,k))
        InertialErr(:,k) = trackedMakerPosition_InertialTime(1:2,k) - InertialPositionNew(1:2,k) ;  % ��ǰ��Թ�ѧ�����
        % �������
        SingleFrameCompensate(1:2,k) = InertialErr(:,k)*compensateRate ;  % ��֡������        
    else
        SingleFrameCompensate(1:2,k) = [0;0] ;  % ��֡������
    end
    InertialPositionNew(1:2,k) = InertialPositionNew(1:2,k) + SingleFrameCompensate(1:2,k) ;  % ���ѧ����
    InertialPositionNew(3,k) = InertialPosition(3,k);
    AccumulateCompensate_k(:,i) = InertialPositionNew(:,k)-InertialPosition(:,k) ;  % �ۻ�������
end

%% ͨ�� InertialPositionNew ���� HipDisplacementNew
% ��Headλ�ô���Hip��������ͷ��head�����λ��

for k=CalStartIN:CalEndIN    
    HipDisplacementNew( 1:2,k ) = HipDisplacement(1:2,k) + SingleFrameCompensate(1:2,k) ;
    HipDisplacementNew( 3,k ) = HipDisplacement( 3,k );
end

InertialPositionCompensate_out = SingleFrameCompensate ;

HipDisplacementNew_out = HipDisplacementNew;

if coder.target('MATLAB') &&  CalEndIN >= size(trackedMakerPosition_InertialTime,2)-1 
    DrawCompensate( InertialErr,SingleFrameCompensate,trackedMakerPosition_InertialTime,...
        InertialPosition,InertialPositionNew,SingleFrameCompensate,compensateRate,N_BVH ) ;
end



%% �Ӿ�λ��Ԥ����
% 1�����Ӿ�����  ���Ӿ���������ϵ ת�� ����������ϵ
function otherMakers = PreProcess( otherMakers  )
coder.inline('never');
global CalStartVN CalEndVN 
persistent VisualP_t0  % 0ʱ�̵��Ӿ�λ��
if isempty(VisualP_t0)
   VisualP_t0 = zeros(3,1); 
end
%% ��ת�������ص�ͬ������ϵ
Cv_r1 = [ 0 0 1; -1 0 0; 0 -1 0 ];
% dbstop in BodyDirection2Cr_r1
% Cr_r1 = BodyDirection2Cr_r1( BodyDirection );   %   ����1��    Ҫ���˳��Ӿ��궨�궨����������ϵ���ж�׼
% Cvr = Cr_r1' * Cv_r1 ;
Cvr = Cv_r1 ;         %   ����2��    Ҫ���Ӿ���������ϵ��Z�ᳯ������

%% ��ת�� ����ϵ �ı����أ������Ӿ��ĳ�ʼ��Ϊԭ�㣨������߶ȣ�

Position_1 = otherMakers(1).Position(:,1) ;
Position_1(2) = 0 ;      % ������߶ȷ���
if CalStartVN==1
    VisualP_t0 = Position_1;
end
for k=CalStartVN:CalEndVN
    Position_k = otherMakers(k).Position ;
    if ~isempty(Position_k)
%         m = size(Position_k,2);
%         position_offest = repmat(Position_1,1,m);     
%         Position_k_new = Cvr*(Position_k-position_offest) ;  % ���Ӿ���������ϵ ת�� ����������ϵ
          
        Position_k_new = Cvr*Position_k;
        otherMakers(k).Position = Position_k_new; 
    else
        otherMakers(k).Position = NaN(3,1); 
    end
    otherMakers(k).CalculatedTime = otherMakers(k).CalculatedTime+1 ;
    if coder.target('MATLAB') && otherMakers(k).CalculatedTime~=1
       fpritnf( 'otherMakers(%0.0f).CalculatedTime = %0.0f\n',k,otherMakers(k).CalculatedTime ); 
    end
end


%% InertialData  �� otherMakers �� NaN
%% ���ڸ� C++ �Զ����� ��ʼ�� ����

function [InertialData,otherMakers] = Set_InertialData_otherMakers_NaN( InertialData,otherMakers,I_N,V_N )
coder.inline('never');

InertialData.frequency = 96;
InertialData.time  = NaN;
InertialData.HipQuaternion  =  NaN(4,I_N);
InertialData.HipPosition =  NaN(3,I_N);
InertialData.HeadQuaternion  =  NaN(4,I_N);
InertialData.HeadPosition =  NaN(3,I_N);
InertialData.BodyDirection =  NaN(3,1);
% InertialData.DataStyle =  'GlobalBoneQuat';

for k=1:V_N
    otherMakers(k).frequency = 30;
    otherMakers(k).Position = NaN(3,1);
    otherMakers(k).otherMakersN = int32(NaN);
    otherMakers(k).time = NaN;
    otherMakers(k).MarkerSet = 16 ;  % 'head';
    otherMakers(k).trackedMakerPosition  = NaN(3,1);  
    otherMakers(k).ContinuesFlag = NaN;
    otherMakers(k).ContinuesLastPosition = NaN(3,1);
    otherMakers(k).ContinuesLastTime = NaN;
    otherMakers(k).ContinuesLastK = NaN;
end
