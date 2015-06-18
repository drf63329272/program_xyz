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


%% �õ����� Hip λ�ò����� InertialPositionCompensate
% InertialPositionCompensate [ 3*N ]  m  NEDϵ
% CalStartVN_in �� �Ӿ�������㣨��
% CalEndVN_in �������յ㣨�Ӿ���
% IsHandledVisual IsHandledInerital ��¼ÿ�����Ĵ������ �� 0��ʾû����1��ʾ1��-������2�����ظ�����
 
function [ InertialPositionCompensate,HipDisplacementNew,otherMakers ] = GetINSCompensateFromVNS...
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
otherMakers = PreProcess( otherMakers,InertialData.BodyDirection );
% fprintf('PreProcess OK \n');
%       DrawAllINSVNS( otherMakers,InertialData ) ;
%    return;

%% ����˵����
%       dbstop in GetRightOtherMaker
%% load data
% inertialTime = InertialData.time ;
inertialFre = InertialData.frequency ;
InertialData_visual_k = double(InertialData.visual_k) ;
visionFre = otherMakers(1).frequency ;
MarkerSet= otherMakers(1).MarkerSet ;

switch MarkerSet   % ���м����ݹ������
    case 16   % 'Head'
        InertialPosition = InertialData.HeadPosition ;
        
    case 1 %  'Hip'
        InertialPosition = InertialData.HipPosition ;
    otherwise
        InertialPosition = InertialData.HeadPosition ;
end
HipQuaternion = InertialData.HipQuaternion ;
HeadQuaternion = InertialData.HeadQuaternion ;


[ trackedMakerPosition_InertialTime,otherMakers ] =  GetRightOtherMaker( otherMakers,InertialPosition ) ;

%% λ�ò���

[ InertialPositionCompensate,HipDisplacementNew ] = VNSCompensateINS...
    ( compensateRate,trackedMakerPosition_InertialTime,InertialData.HipPosition,InertialPosition ) ;

    

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

%% BVH ��ȡ�ĸ��� N_BVH ���ܻ�� N1 �༸��
N_BVH = size(HipDisplacement,2);
N1 = size(trackedMakerPosition_InertialTime,2);
for k=N1+1:N_BVH
    trackedMakerPosition_InertialTime(:,k) = trackedMakerPosition_InertialTime(:,N1);
    InertialPosition(:,k) = InertialPosition(:,N1);
end

%% �Ȳ��� InertialPositionNew
persistent InertialPositionCompensate  InertialPositionNew HipDisplacementNew
if isempty(InertialPositionCompensate)
    InertialPositionCompensate = NaN(3,N_BVH); % ÿһ�����ۻ�λ�Ʋ����� ��¼
    InertialPositionCompensate(:,1)=zeros(3,1);
    InertialPositionNew = NaN(3,N_BVH);
    InertialPositionNew(3,:) = InertialPosition(3,:); % �߶Ȳ�����
    InertialPositionNew(1:2,1) = InertialPosition(1:2,1) ;  % ��ʼ��ѡ�����
    
    HipDisplacementNew = NaN(3,N_BVH); 
    HipDisplacementNew(3,:) = HipDisplacement(3,:);
    HipDisplacementNew(:,1) = HipDisplacement(:,1);
end
persistent  InertialErr StepCompensate
if isempty(StepCompensate)
    InertialErr = zeros(2,N_BVH);       % ʵʱ��¼����������
    StepCompensate = zeros(2,N_BVH);  % ����������
end

for k = max(2,CalStartIN) : CalEndIN 
    % ���ô����Ե���
    InertialPositionNew(1:2,k) = InertialPositionNew(1:2,k-1)+( InertialPosition(1:2,k)-InertialPosition(1:2,k-1) );
    % ���󴿹���Ϊ���
    if ~isnan(trackedMakerPosition_InertialTime(1,k))
        InertialErr(:,k) = trackedMakerPosition_InertialTime(1:2,k) - InertialPositionNew(1:2,k) ;
        % �������
        InertialPositionNew(1:2,k) = InertialPositionNew(1:2,k) + InertialErr(:,k)*compensateRate ; 
        StepCompensate(:,k) = InertialErr(:,k)*compensateRate ;
    end
    InertialPositionCompensate(1:2,k) = InertialPositionNew(1:2,k) - InertialPosition(1:2,k) ;  % �ۻ�λ�Ʋ�����
end

%% ͨ�� InertialPositionNew ���� HipDisplacementNew
% ��Headλ�ô���Hip��������ͷ��head�����λ��

for k=CalStartIN:CalEndIN    
    HipDisplacementNew( 1:2,k ) = HipDisplacement(1:2,k) + InertialPositionCompensate(1:2,k) ;
    HipDisplacementNew( 1:3,k ) = HipDisplacement( 1:3,k );
end

InertialPositionCompensate_out = InertialPositionCompensate ;
HipDisplacementNew_out = HipDisplacementNew;
if CalEndIN >= size(trackedMakerPosition_InertialTime,2)-10
    DrawCompensate( InertialErr,StepCompensate,trackedMakerPosition_InertialTime,...
        InertialPosition,InertialPositionNew,InertialPositionCompensate,compensateRate,N_BVH ) ;
end

%% �Ӿ�λ��Ԥ����
% 1�����Ӿ�����  ���Ӿ���������ϵ ת�� ����������ϵ
function otherMakers = PreProcess( otherMakers,BodyDirection  )
coder.inline('never');
global CalStartVN CalEndVN 
persistent VisualP_t0  % 0ʱ�̵��Ӿ�λ��
if isempty(VisualP_t0)
   VisualP_t0 = zeros(3,1); 
end
%% ��ת�������ص�ͬ������ϵ
Cv_r1 = [ 0 0 1; -1 0 0; 0 -1 0 ];
% dbstop in BodyDirection2Cr_r1
Cr_r1 = BodyDirection2Cr_r1( BodyDirection );   %   ����1��    Ҫ���˳��Ӿ��궨�궨����������ϵ���ж�׼
Cvr = Cr_r1' * Cv_r1 ;
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


%% ���� BodyDirection ����̬
% �����д���֤������������������������������������������������������������������
%   BodyDirection  �˳���Ϊ [1 0 0]
function Cr_r1 = BodyDirection2Cr_r1( BodyDirection )
coder.inline('never');

V = [1 0 0];   % ����
thita = acos( V*BodyDirection / normest(BodyDirection)   );
% ͨ����˿��жϽǶȷ���
temp = cross(V,BodyDirection) ;  % �� V �� BodyDirection ��ʱ��180������ʱ��temp���ϣ�temp(3)<0
if temp(3)>0
        % �� V �� BodyDirection ��ʱ��ת������180��
      thita = -thita ;
end
    
Cr_r1 = RotateZ( thita ) ;


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
