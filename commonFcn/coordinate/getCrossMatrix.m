% buaa xyz 2014.1.10

% �������õ� x�˾���:
% ����V�����һ��������T ��Ч�ھ���˷���VxT=V_crossMatrix*T 

function V_crossMatrix = getCrossMatrix( V )

V_crossMatrix = [	0       -V(3)   V(2);
                	V(3)    0       -V(1)
                    -V(2)   V(1)    0   ];

