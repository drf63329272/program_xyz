%% buaa xyz 2014.1.17 -> 2015.4.9

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intput
% C: [3*3*N]  from n to b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
% Q: quaternion from n to b
%       [ Nframes,4 ]

function Q = C2Q( C )
coder.inline('never');

CheckError( C ) ;
Nframes = size(C,3);
Q = zeros( Nframes,4 );
for k=1:Nframes
   Q(k,:)  = C2Q_One_1( C(:,:,k) );
   % һ�� C2Q_One_1 �� C2Q_One_2 ��������ͬ
end

%% ���÷ǶԽ��ߵ�6�����ķ���
function Q = C2Q_One_1(Cnb)
coder.extrinsic('format');
format long
% ���ݳ�ʼ��̬����Cnb�����ʼ��̬��Ԫ��
% �ο�������عP17��

q0 = 1/2*sqrt( 1+Cnb(1,1)+Cnb(2,2)+Cnb(3,3) ) ;
q1 = 1/(4*q0)*(Cnb(2,3)-Cnb(3,2));
q2 = 1/(4*q0)*(Cnb(3,1)-Cnb(1,3));
q3 = 1/(4*q0)*(Cnb(1,2)-Cnb(2,1));

Q=[q0;q1;q2;q3];
Q=Q/norm(Q);


%% ֻ���öԽ��ߵķ���
function Q = C2Q_One_2(Cnb)
%% �����2014.4.17֮ǰ
format long
% ���ݳ�ʼ��̬����Cnb�����ʼ��̬��Ԫ��
q1=1/2*sqrt(abs(1+Cnb(1,1)-Cnb(2,2)-Cnb(3,3)));
q2=1/2*sqrt(abs(1-Cnb(1,1)+Cnb(2,2)-Cnb(3,3)));
q3=1/2*sqrt(abs(1-Cnb(1,1)-Cnb(2,2)+Cnb(3,3)));


q0=1/2*sqrt(abs(1+Cnb(1,1)+Cnb(2,2)+Cnb(3,3)));     % xyz
%q0=sqrt(abs(1-q1^2-q2^2-q3^2));                    % ning


if Cnb(2,3)-Cnb(3,2)<0
    q1=-q1;
end
if Cnb(3,1)-Cnb(1,3)<0
    q2=-q2;
end
if Cnb(1,2)-Cnb(2,1)<0
    q3=-q3;
end
Q=[q0;q1;q2;q3];
Q=Q/norm(Q);


function CheckError( C )
if size(C,1)~=3 || size(C,2)~=3
   errordlg('C2Euler:size(C) error'); 
end