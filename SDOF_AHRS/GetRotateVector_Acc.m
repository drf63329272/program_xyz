%% xyz 2015.4.27
% 2015.4.30 �� ����ת�����κ�ʱ�̱���ϵ�±��һ�µ��ص㣬�Ż�ת����㡣
% ���Լ����ת���ǶȺ���תת���Ƕ���С�ĵ���Ϊ�µ� r ϵ��ʹ�µ�rϵ��ת�Ǹ���

%% Calculate Rotate Vector only by Acc 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Input
% Qnb_RVCal�� ת�����ʱ��ε� Qnb
% Qwr�� ��ʼʱ�̵ĵ���ϵ �� ��ʼʱ�̵ı���ϵ
% AHRSThreshod�� ����ж�ָ��
% AccelerationZeroJudge�� Qnb_ZeroCal���Ƿ�0���ٶ��жϽ��

function [ Ypr_Acc,RecordStr ] = GetRotateVector_Acc( Qnb_RVCal,Qwr,AHRSThreshod,AccelerationZeroJudge,frequency )
RoateVectorCalMinAngleFirst = AHRSThreshod.RoateVectorCalMinAngleFirst ;
RoateVectorCalMinAngleSecond = AHRSThreshod.RoateVectorCalMinAngleSecond ;
RoateVectorCalMinAngleScope = AHRSThreshod.RoateVectorCalMinAngleScope ;
RoateVectorCalMinAngleScopeSub = AHRSThreshod.RoateVectorCalMinAngleScopeSub ;
%%% ����ת�᣺ ���躽��Ϊ0������ѡ������ת���������ݣ�ת�ǽϴ�
% dbstop in SelectRotateVectorCalcualteData_Second
[ Qnb_RCD,Qwr_RCD,RecordStr1 ] = SelectRotateVectorCalcualteData_First( Qnb_RVCal,Qwr,RoateVectorCalMinAngleFirst,AccelerationZeroJudge,RoateVectorCalMinAngleScope,RoateVectorCalMinAngleScopeSub ) ;
% dbstop in CalculateRotateVector_Acc
Ypr_Acc1 = CalculateRotateVector_Acc( Qnb_RCD,Qwr_RCD ) ;
%%% ����ת�᣺ 
% dbstop in SelectRotateVectorCalcualteData_Second
[ Qnb_RCD,Qwr_RCD,RecordStr2 ] = SelectRotateVectorCalcualteData_Second...
    ( Qnb_RVCal,Qwr,Ypr_Acc1,RoateVectorCalMinAngleSecond,RoateVectorCalMinAngleScope,RoateVectorCalMinAngleScopeSub,AccelerationZeroJudge ) ;
Ypr_Acc = CalculateRotateVector_Acc( Qnb_RCD,Qwr_RCD ) ;

Ypr1Str = sprintf( '%0.5f  ',Ypr_Acc1 );
Ypr2Str = sprintf( '%0.5f  ',Ypr_Acc );
RecordStr = sprintf( '%s Ypr_Acc1 = %s  \n %s Ypr_Acc2 = %s (ת�����ݼ���ʱ��=%0.2f s)\n',RecordStr1,Ypr1Str,RecordStr2,Ypr2Str,length(Qnb_RCD)/frequency );
disp( RecordStr );

%% �����ʺ�ת�Ǽ������Ԫ�� Qnb_RCD �� Qwr_RCD ����ת�� Ypr_Acc
function  [ Ypr_Acc,RotateAngle_RCD ] = CalculateRotateVector_Acc( Qnb_RCD,Qwr_RCD )
if isempty(Qnb_RCD)
    Ypr_Acc = NaN;
    RotateAngle_RCD = NaN;
    return;
end
D = CalculateD( Qnb_RCD,Qwr_RCD ) ;

DTD = D'*D ;
[ eigV,eigD ] = eig( DTD );
eigValue = diag(eigD);
[ minEigValue,minEig_k ] = min( eigValue );
X = eigV( :,minEig_k );
X = X/normest(X( 1:3 )) ;
Ypr_Acc = X( 1:3 );
Ypr_Acc = MakeVectorDirectionSame( Ypr_Acc ) ;

RotateAngle_RCD= (acot(X(4:length(X))))*180/pi*2 ;


%% check
K = size(D,2)-3;
As = zeros( 2,K );
for i=1:K
    As(:,i) = D( i*2-1:i*2,3+i );
end

DX = D*X ;
DTDX = DTD*eigV( :,1 ) ;

function D = CalculateD( Qnb,Qwr )
Nframes = size(Qnb,2);
D = zeros( 2*Nframes,3+Nframes );
for i=1:Nframes
    Ai = CalculateA_One( Qnb(:,i),Qwr ) ;
    As_i = Ai(2:3,1);
    Av_i = Ai(2:3,2:4);
    D( 2*i-1:2*i,1:3 ) = Av_i ;
    D( 2*i-1:2*i,3+i ) = As_i ;
end
disp('')

function A = CalculateA_One( Qnb,Qwr ) 
if length(Qnb)==4
    Qbn = [ Qnb(1);-Qnb(2:4) ] ;
    LQMwr = LeftQMultiplyMatrix( Qwr ) ;
    RQMbn = RightQMultiplyMatrix( Qbn ) ;
    A = RQMbn * LQMwr ;
else
    A = NaN;
end



function [ IsAngleBigStatic,RotateAngleSecond_AccZero,RotateAngleSecond_Big ] = AngleBigStatic( IsSDOFAccelerationZero,Qnb_RVCal,Qwr,Ypr_Acc,RoateVectorCalMinAngleSecond )
% ֻ����0���ٶ�ʱ�������
K_AccZero = find(IsSDOFAccelerationZero == 1) ;  % 0���ٶȵ����
N_AccZero = length(K_AccZero);

RotateAngleSecond_AccZero = CalculateRotateAngle_Acc( Qnb_RVCal,Qwr,Ypr_Acc,K_AccZero ) ;

%% �ڶ�������ѡ�����
% 1�� ת�Ǵ��� RoateVectorCalMinAngleSecond
% 2�� ��ֹ״̬
% 3�� �Ƕȷ�Χ���� 

temp1 = find(abs(RotateAngleSecond_AccZero)>RoateVectorCalMinAngleSecond) ;
IsAngleBigStatic = K_AccZero(temp1);

RotateAngleSecond_Big = RotateAngleSecond_AccZero(temp1);


%% Second : select data be suitable for rotate vector calculating
%%% ���ݵ�һ�μ���Ĵ���ת�� Ypr_Acc������ת���Ƕȣ� ���� RoateVectorCalMinAngleSecond
%%% ��������Ϊ����Ч�ģ����ڽ��еڶ���ת�����
function [ Qnb_RCD,Qwr_RCD,RecordStr ] = SelectRotateVectorCalcualteData_Second...
    ( Qnb_RVCal,Qwr,Ypr_Acc,RoateVectorCalMinAngleSecond,RoateVectorCalMinAngleScope,RoateVectorCalMinAngleScopeSub,AccelerationZeroJudge )
N = size(Qnb_RVCal,2);
IsSDOFAccelerationZero = AccelerationZeroJudge.IsSDOFAccelerationZero(1:N);
K_AccZero = find(IsSDOFAccelerationZero == 1) ;  % 0���ٶȵ����
RotateAngleSecond_AccZero = CalculateRotateAngle_Acc( Qnb_RVCal,Qwr,Ypr_Acc,K_AccZero ) ;

temp = find(abs(RotateAngleSecond_AccZero)>RoateVectorCalMinAngleSecond) ;
RotateAngleSecond_AccZeroBig = RotateAngleSecond_AccZero(temp);

[ AngleScope1,AngleScopeSub1 ] = GetAngleScope( RotateAngleSecond_AccZeroBig ) ;
if AngleScope1 < RoateVectorCalMinAngleScope || AngleScopeSub1 < RoateVectorCalMinAngleScopeSub
    IsSDOFAccelerationZero = AccelerationZeroJudge.IsSDOFAccelerationToHeartZero(1:N);
    K_AccZero = find(IsSDOFAccelerationZero == 1) ; 
    RotateAngleSecond_AccZero = CalculateRotateAngle_Acc( Qnb_RVCal,Qwr,Ypr_Acc,K_AccZero ) ;
    disp('ת����㣺0���ٶ�=0�����ݲ��㣬��Ϊ���ļ��ٶ�=0')
end

%% ѡ����ת�Ƕ�����˵��������Ϊ�µĲο�ϵ rNew�������Ż�ת��ļ���
% ͬʱҪ�������������ǿ�� 0 ���ٶ��ж�����
%  dbstop in GetQwrNew
QwrNew = GetQwrNew( Qnb_RVCal,RotateAngleSecond_AccZero,IsSDOFAccelerationZero );
if QwrNew==0
    Qwr_RCD = Qwr;
else
    Qwr_RCD = QwrNew ;
    % ���µ� Qwr����ת��
    RotateAngleSecond_AccZero = CalculateRotateAngle_Acc( Qnb_RVCal,QwrNew,Ypr_Acc,K_AccZero ) ;
end

%% ���µ� Qwr����ת��
% ��ת�ǵ���� IsAngleBigStatic
temp1 = find(abs(RotateAngleSecond_AccZero)>RoateVectorCalMinAngleSecond) ;
IsAngleBigStatic = K_AccZero(temp1);
RotateAngleSecond_Big = RotateAngleSecond_AccZero(temp1);

Qnb_RCD = Qnb_RVCal( :,IsAngleBigStatic );
RecordStr = '';
return;

%%

[IsAngleBigStatic1,RotateAngleSecond_AccZero1,RotateAngleSecond_Big1 ]  = AngleBigStatic( AccelerationZeroJudge.IsSDOFAccelerationZero(1:N),Qnb_RVCal,Qwr,Ypr_Acc,RoateVectorCalMinAngleSecond );
[IsAngleBigStatic2,RotateAngleSecond_AccZero2,RotateAngleSecond_Big2 ] = AngleBigStatic( AccelerationZeroJudge.IsSDOFAccelerationToHeartZero(1:N),Qnb_RVCal,Qwr,Ypr_Acc,RoateVectorCalMinAngleSecond );
[IsAngleBigStatic3,RotateAngleSecond_AccZero3,RotateAngleSecond_Big3 ] = AngleBigStatic( AccelerationZeroJudge.IsAccNormZero(1:N),Qnb_RVCal,Qwr,Ypr_Acc,RoateVectorCalMinAngleSecond );

%% ����ѡ���ϸ�� 0 ���ٶ��ж�

IsAngleBigStatic_SeclectFlag = 0 ;
if ~isempty(IsAngleBigStatic1>0)
    [ AngleScope1,AngleScopeSub1 ] = GetAngleScope( RotateAngleSecond_Big1 ) ;
    if AngleScope1 > RoateVectorCalMinAngleScope
        if AngleScopeSub1 > RoateVectorCalMinAngleScopeSub
            %%% ѡ���ϸ��0���ٶȱ�׼ʱ��������
            IsAngleBigStatic = IsAngleBigStatic1 ;
            IsAngleBigStatic_SeclectFlag = 1 ;
            RotateAngleSecond_AccZero = RotateAngleSecond_AccZero1 ;
            disp('ת���������ѡ�񣨵ڶ��Σ����ϸ��0���ٶ�');
        end
    end
end
%% ���ѡ�����ļ��ٺ�ģ���ж�����  IsSDOFAccelerationToHeartZero
if IsAngleBigStatic_SeclectFlag == 0
    if ~isempty( IsAngleBigStatic2>0 )
        [ AngleScope2,AngleScopeSub2 ] = GetAngleScope( RotateAngleSecond_Big2 ) ;
        if AngleScope2 > RoateVectorCalMinAngleScope
            if AngleScopeSub2 > RoateVectorCalMinAngleScopeSub
                IsAngleBigStatic = IsAngleBigStatic2 ;
                IsAngleBigStatic_SeclectFlag = 2 ;
                disp('ת���������ѡ�񣨵ڶ��Σ��������ļ��ٶ�=0');
            end
        end
    end
end
%% �����ѡ��ģ���ж�����  IsAccNormZero
% if IsAngleBigStatic_SeclectFlag == 0
%     if ~isempty( IsAngleBigStatic3>0 )
%         [ AngleScope3,AngleScopeSub3 ] = GetAngleScope( RotateAngleSecond(IsAngleBigStatic3) ) ;
%         if AngleScope3 > RoateVectorCalMinAngleScope
%             if AngleScopeSub3 > RoateVectorCalMinAngleScopeSub
%                 IsAngleBigStatic = IsAngleBigStatic3 ;
%                 IsAngleBigStatic_SeclectFlag = 3 ;    
%                 disp('ת���������ѡ�񣨵ڶ��Σ������Ӽ�ģ=g');                
%             end
%         end
%     end
% end
RecordStr = sprintf( 'SelectRotateVectorCalcualteData_Second ת������ѡ���־ IsAngleBigStatic_SeclectFlag = %0.0f \n',IsAngleBigStatic_SeclectFlag );
%% ���Ͼ�������ʱ˵���Ҳ�����ת�������
if IsAngleBigStatic_SeclectFlag == 0
   errordlg( '�Ҳ���ת��������ݣ�SelectRotateVectorCalcualteData_First��' ); 
   Qnb_RCD = [];
   Qwr_RCD = [];
   return;
end

Qnb_RCD = Qnb_RVCal( :,IsAngleBigStatic );
Qwr_RCD = Qwr;
% return;




%% ѡ����ת�Ƕ�����˵��������Ϊ�µĲο�ϵ rNew�������Ż�ת��ļ���
% ͬʱҪ�������������ǿ�� 0 ���ٶ��ж�����
% �ӽǶ���С�ĵ㿪ʼ�������ҵ�һ����� IsLongAccelerationZeroFlag Ϊ1����ǰ�� 0.1 S ��ʱ���

% IsLongAccelerationZeroFlag(k)����k���Ƿ���������0���ٶ�״̬
function QwrNew = GetQwrNew( Qnb,RotateAngle_AccZero,IsSDOFAccelerationZero )

% ����Сת�Ƕ�Ӧ�����
[ RotateAngleSorted,Index ] = sort( RotateAngle_AccZero,'ascend' );
% ֻ�е�����ת�Ǿ����� 10�� ʱ���б�Ҫ�ù������λ
if abs( min(RotateAngle_AccZero) )<10*pi/180 || abs( max(RotateAngle_AccZero) )<10*pi/180   
    QwrNew = 0;% �Ҳ���
    disp('��û��Ҫ������ο���λ�Ż�ת�����');
    return;
end    
N_AccZero = find(IsSDOFAccelerationZero==1);
QwrNew_k = N_AccZero(Index(1)) ;
%%% ȡ��Сת�����������ֵΪ�µ� Qwr
% ��ǰ���� startNew_r_k
N = length(Qnb) ;
startNew_r_k = QwrNew_k ;
for k=1:QwrNew_k-1
    i = QwrNew_k-k+1 ;
    if IsSDOFAccelerationZero(i)==0
        startNew_r_k = i ;
        break;
    end
end
    
% �������� endNew_r_k
N = length(Qnb) ;
endNew_r_k = QwrNew_k ;
for k=QwrNew_k:N
    if IsSDOFAccelerationZero(k)==0
        endNew_r_k = k ;
        break;
    end
end

Qnb_New_r = Qnb( :,startNew_r_k:endNew_r_k );
QwrNew = mean(Qnb_New_r,2) ;
QwrNew = QwrNew/normest(QwrNew) ;


QwrNewStr = sprintf( '%0.3f ',QwrNew );
fprintf('QwrNew = %s \n',QwrNewStr);


% AngleScope��ת�Ǹ��ǵķ�Χ
% AngleScopeSub�����͸�ת�Ǹ��ǵķ�Χ�����ֵ
function [ AngleScope,AngleScopeSub ] = GetAngleScope( RotateAngleSeclected )
AngleScope = max( RotateAngleSeclected ) - min( RotateAngleSeclected ) ;
% ��ֵ�ĸ��Ƿ�Χ
RotateAngleSeclectedPos = RotateAngleSeclected(RotateAngleSeclected>0) ;
if ~isempty( RotateAngleSeclectedPos  )
    AngleScopePositive = max( RotateAngleSeclectedPos ) - min( RotateAngleSeclectedPos ) ;
else
    AngleScopePositive = 0 ;
end
% ��ֵ�ĸ��Ƿ�Χ
RotateAngleSeclectedNeg = RotateAngleSeclected(RotateAngleSeclected<0) ;
if ~isempty( RotateAngleSeclectedNeg  )
    AngleScopeNegtive = min( RotateAngleSeclectedNeg ) - max( RotateAngleSeclectedNeg ) ;
else
    AngleScopeNegtive = 0;
end

AngleScopeSub = max( AngleScopePositive,AngleScopeNegtive );

%% Firts : select data be suitable for rotate vector calculating
%%% ���躽�򱣳�0ʱ�������ͺ��ת����Ԫ����ת�Ǵ��� RoateVectorCalMinAngleFirst �Ƕ�ʱ��������ת��ĵ�һ�μ���
function [ Qnb_RCD,Qwr_RCD,RecordStr ] = SelectRotateVectorCalcualteData_First( Qnb,Qwr,RoateVectorCalMinAngleFirst,AccelerationZeroJudge,RoateVectorCalMinAngleScope,RoateVectorCalMinAngleScopeSub )

Qrw = Qinv( Qwr );
N = size(Qnb,2);
Qrb_PreFirst = QuaternionMultiply( repmat(Qrw,1,N),Qnb );       % ����Qrb�����躽�򲻱�
angleFirst = GetQAngle( Qrb_PreFirst ) ;

IsAngleBig =  angleFirst > RoateVectorCalMinAngleFirst | angleFirst < -RoateVectorCalMinAngleFirst ;

IsAngleBigStatic1 = IsAngleBig & AccelerationZeroJudge.IsSDOFAccelerationZero(1:length(IsAngleBig)) ;
IsAngleBigStatic2 = IsAngleBig & AccelerationZeroJudge.IsSDOFAccelerationToHeartZero(1:length(IsAngleBig)) ;
IsAngleBigStatic3 = IsAngleBig & AccelerationZeroJudge.IsAccNormZero(1:length(IsAngleBig)) ;

K_AccZero = find(AccelerationZeroJudge.IsSDOFAccelerationZero == 1) ;  % 0���ٶȵ����
N_AccZero = length(K_AccZero);
Qnb_AccZero = Qnb( :,K_AccZero );
Qrb_AccZero_PreFirst = QuaternionMultiply( repmat(Qrw,1,N_AccZero),Qnb_AccZero );       % ����Qrb�����躽�򲻱�
angleFirst_AccZero = GetQAngle( Qrb_AccZero_PreFirst ) ;

% figure('name','SelectRotateVectorCalcualteData_First')
% plot(K_AccZero,angleFirst_AccZero*180/pi,'.');
% hold on
% plot(1:N,angleFirst*180/pi,'ro');
%% ����ѡ���ϸ�� 0 ���ٶ��ж�

IsAngleBigStatic_SeclectFlag = 0 ;
if ~isempty(IsAngleBigStatic1>0)
    [ AngleScope1,AngleScopeSub1 ]  = GetAngleScope( angleFirst(IsAngleBigStatic1) ) ;
    if AngleScope1 > RoateVectorCalMinAngleScope 
        if AngleScopeSub1 > RoateVectorCalMinAngleScopeSub
            %%% ѡ���ϸ��0���ٶȱ�׼ʱ��������
            IsAngleBigStatic = IsAngleBigStatic1 ;
            IsAngleBigStatic_SeclectFlag = 1 ;
            disp('ת���������ѡ�񣨵�һ�Σ����ϸ��0���ٶ�');
        end
    end
end
%% ���ѡ�����ļ��ٺ�ģ���ж�����  IsSDOFAccelerationToHeartZero
if IsAngleBigStatic_SeclectFlag == 0
    if ~isempty( IsAngleBigStatic2>0 )
        [ AngleScope2,AngleScopeSub2 ]  = GetAngleScope( angleFirst(IsAngleBigStatic2) ) ;
        if AngleScope2 > RoateVectorCalMinAngleScope
            if AngleScopeSub2 > RoateVectorCalMinAngleScopeSub
                IsAngleBigStatic = IsAngleBigStatic2 ;
                IsAngleBigStatic_SeclectFlag = 2 ;
                disp('ת���������ѡ�񣨵�һ�Σ��������ļ��ٶ�=0');
            end
        end
    end
end
%% �����ѡ��ģ���ж�����  IsAccNormZero
% if IsAngleBigStatic_SeclectFlag == 0
%     if ~isempty( IsAngleBigStatic3>0 )
%         [ AngleScope3,AngleScopeSub3 ]  = GetAngleScope( angleFirst(IsAngleBigStatic3) ) ;
%         if AngleScope3 > RoateVectorCalMinAngleScope
%             if AngleScopeSub3 > RoateVectorCalMinAngleScopeSub
%                 IsAngleBigStatic = IsAngleBigStatic3 ;
%                 IsAngleBigStatic_SeclectFlag = 3 ;
%                 disp('ת���������ѡ�񣨵ڶ��Σ������Ӽ�ģ=g');
%             end
%         end
%     end
% end
RecordStr = sprintf( 'SelectRotateVectorCalcualteData_First ת������ѡ���־ IsAngleBigStatic_SeclectFlag = %0.0f \n',IsAngleBigStatic_SeclectFlag );
%% ���Ͼ�������ʱ˵���Ҳ�����ת�������
if IsAngleBigStatic_SeclectFlag == 0
   errordlg( '�Ҳ���ת��������ݣ����RoateVectorCalMinAngleFirst������SelectRotateVectorCalcualteData_First��' ); 
   Qnb_RCD = [];
   Qwr_RCD = [];
   return;
end

Qnb_RCD = Qnb( :,IsAngleBigStatic );

Qwr_RCD = Qwr;
return;
%% ѡ����ת�Ƕ�����˵��������Ϊ�µĲο�ϵ rNew�������Ż�ת��ļ���
% ͬʱҪ�������������ǿ�� 0 ���ٶ��ж�����
% dbstop in GetQwrNew
angleFirst_d =  angleFirst*180/pi;
QwrNew = GetQwrNew( Qnb,angleFirst,AccelerationZeroJudge.IsLongSDOFAccelerationZero );
if QwrNew==0
    Qwr_RCD = Qwr;
else
    Qwr_RCD = QwrNew ;
end
%% check
angleFirst_RCD = angleFirst(IsAngleBigStatic);
time = 1:N;
figure('name','IsAngleBigStatic-Second')
plot( angleFirst*180/pi )
hold on
plot( time(IsAngleBigStatic),angleFirst_RCD*180/pi,'r.' )





