%% xyz 2015 3.20
% �� ePoly ת��Ϊ�� ��Բ���α��ʽ ��Ӧ�ı�׼ ePolyNormalized

% eStand_Fitting.cx  .cy  .thita  .a  .b  .e  .f

function [ ePolyNormalized,eStand ] = EPolyNorm_Geometry( ePoly )

[ A,B,C,D,E,F ] = deal( ePoly(1),ePoly(2),ePoly(3),ePoly(4),ePoly(5),ePoly(6) ) ;
ePoly_First = [ A;B;C;D;E;F ] ;
%% calculate the multiply rate
% ����ʽ��﷽��ePoly���ڿ������������Ե�Ч�����ԣ�����ֱ��תΪ��Բ�������ӵ�����������Ψһ�ġ�
% ���ȼ�������� rate �� ePoly ת��Ϊ ePolyNormalized��
% ���������ô� ePoly��eStand �ķ���A�ͷ���B��ֻ�е�����Ϊ rate ʱ����һ�µĽ��м��㡣

%% 
K = [ -2*A,  -B
      -B,   -2*C ] ;
center = K \ [D;E];
cx = center(1) ;
cy = center(2) ;

G = A*cx^2+B*cx*cy+C*cy^2-F ;

thita = zeros(1,2);
solutionFlag = {'a>b','a<b'};
%%% a>b��
thita(1) = 0.5*atan2(-B,C-A) ;
sin_2thita = sin( 2*thita(1) );
%%% a<b��
thita(2) = 0.5*atan2(B,A-C) ;

rateNew = calMultipleRate( A,B,C,G,sin_2thita ) ;
ePolyNormalized = ePoly*rateNew ;
[ A,B,C,D,E,F ] = deal( ePolyNormalized(1),ePolyNormalized(2),ePolyNormalized(3),ePolyNormalized(4),ePolyNormalized(5),ePolyNormalized(6) ) ;

abMin_s = ( A+C-sqrt( (A+C)^2-4*G ) )/2 ;
abMax_s = G/abMin_s ;
abMin = sqrt(abMin_s);
abMax = sqrt(abMax_s);

%%% a<b
a1 = abMin ;
b1 = abMax ;
thita1 = asin( B/(b1^2-a1^2) )/2 ;
%%% a>b
a2 = abMax ;
b2 = abMin ;
thita2 = asin( B/(b2^2-a2^2) )/2 ;

a = [ a1 a2 ];
b = [ b1 b2 ];
thita = [ thita1 thita2 ];

for k=1:length(cx)   
   f(1,k) = sqrt( abs(a(1,k)^2-b(1,k)^2) ) ;
   e(1,k) = f(1,k)/max(a(1,k),b(1,k)) ;
end

soluN = length(a);
eStand = struct;
for k=1:soluN
   eStand(k).cx = cx(1) ;
   eStand(k).cy = cy(1) ;
   eStand(k).a = a(k) ;
   eStand(k).b = b(k) ;
   eStand(k).thita = thita(k) ;
   eStand(k).e = e(1) ;
   eStand(k).f = f(1) ;
end

return
%%  NOTE������һ���ܱ��ܵ�Ч����ʱ�Խ��������
% dbstop in ellipsePolyToStand
[ cx,cy,thita,a,b,e,f,solutionFlagA ] = ellipsePolyToStand( ePoly ) ;
n_s = length(cx);
rate = zeros(n_s,1);
for k=1:n_s
    rate(k) = calMultiple( A,B,C,F,cx(k),cy(k),thita(k) );
end
i=2;
while i<=length(rate) && abs(rate(i)-rate(1))<1e-3
    rate(i) = [];
    i = i+1 ;
end
n_s = length(rate);        
ePolyNormalized = zeros(6,n_s);
for k=1:n_s
    ePolyNormalized(:,k) = ePoly*rate(k) ;
end

%% change to the stand model
stand_Num = 0;
eStand = zeros(7,1);
solutionFlagB = [];
for k=1:n_s
    [ cx,cy,thita,a,b,e,f,solutionFlagB_k ] = ellipsePolyToStand( ePolyNormalized(:,k) ) ;
    solutionFlagB = [solutionFlagB_k solutionFlagB];
    for i=1:length(cx)
        stand_Num = stand_Num+1 ;
        eStand(:,stand_Num) = [ cx(i);cy(i);thita(i);a(i);b(i);e(i);f(i) ];        
    end    
end
%% check eStand
% ��������4�� eStand 
% ͨ�������� eStand ���ƻ�ȥ����õ�����Ƿ�һ��ȥ�޳�����2��
%% ��Ҳ��ܱ�����ʱ�Է���������
eSN = size(eStand,2) ;
ePoly_S = zeros(6,eSN) ;
rateS = zeros(eSN,1);
for k = 1:size(eStand,2)
    [ Ak, Bk, Ck, Dk, Ek, Fk ] = ellipseStandToPoly( eStand(1,k),eStand(2,k),eStand(3,k),eStand(4,k),eStand(5,k) );
    ePoly_S(:,k) = [ Ak; Bk; Ck; Dk; Ek; Fk ] ;
    rateS(k) = isMultipleRelation( ePoly_S(:,k),ePoly_First ) ;
end
if size(eStand,2)==4
    if rateS(1)==-1 && rateS(2)==-1  
        ePolyNormalized = ePolyNormalized(:,2); % ePolyNormalized(:,1);��Ч ������rate(1)��Ч, a<b����ȷ��
        eStand = eStand(:,3:4); % ȡ����ת����Ϊ a<b �Ľ��
    end
    if rateS(3)==-1 && rateS(4)==-1
        ePolyNormalized = ePolyNormalized(:,1); % ePolyNormalized(:,2); ��Ч ������rate(2)��Ч��a>b����ȷ��
        eStand = eStand(:,1:2); % ȡ����ת����Ϊ a>b �Ľ��        
    end
end

% ePolyStandard = EllipseStandToPoly( eStand ) ;

disp('')

function rate = calMultiple( A,B,C,F,cx,cy,thita )
if abs(sin(thita*2))<1e-3
    rate = 1 ;
    return;
end
t = A*cx^2+B*cx*cy+C*cy^2-F ;
rate = 4*t/( (A+C)^2-B^2/sin(thita*2)^2 );

function rate = isMultipleRelation( ePoly,ePoly_First )
rate = max(abs(ePoly))/max(abs(ePoly_First)) ;
err = ePoly-ePoly_First*rate ; 
if max(abs(err./ePoly))>1e-5
   rate = -1; 
end



function rate = calMultipleRate( A,B,C,G,sin_2thita )
temp = ( A+C-B/sin_2thita )*( A+C+B/sin_2thita );
rate = 4*G/temp ;

