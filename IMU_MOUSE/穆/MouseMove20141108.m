%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ָ��λ���㷨��֤
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ������ʼ��

DataLength = length(data(:,1));
dt = 1/96;
% �Ӽ���ƫ
% Acc0Matrix = [0  0  0];
Acc0Matrix = [0  0  0];
% Acc0Matrix = [0.02723  -0.04825  0.00432];
AttiMatrix = zeros(DataLength,3); % ˳��Ϊx��y��z���������������λ��
AccXYMatrix = zeros(DataLength,2); % ͶӰ��X��Yƽ��ļ��ٶ�
VxyMatrix = zeros(DataLength,2); % ͶӰ��X��Yƽ����ٶ�
PxyMatrix = zeros(DataLength,2); % ͶӰ��X��Yƽ���λ��
GxyzMatrix = zeros(DataLength,3); % ����g������ͶӰ����
% ��Ҫ��ʼ��1��
for i = 1:1:DataLength
	    
    % ����Ԫ�ؽ�����̬����
%     AttiMatrix(i,1) = asin(-2*data(i,4)*data(i,6) + 2*data(i,3)*data(i,5)) *180/pi; % Pitch
% 	AttiMatrix(i,2) = atan2(2*data(i,5)*data(i,6) + 2*data(i,3)*data(i,4), -2*data(i,4)*data(i,4) - 2*data(i,5)*data(i,5) + 1) *180/pi; 
% 	AttiMatrix(i,3) = atan2(2*(data(i,4)*data(i,5) + data(i,3)*data(i,6)), data(i,3)*data(i,3) + data(i,4)*data(i,4) - data(i,5)*data(i,5) - data(i,6)*data(i,6)) *180/pi;
    
    AttiMatrix(i,1) = asin(-2*data(i,4)*data(i,6) + 2*data(i,3)*data(i,5)); % Pitch
	AttiMatrix(i,2) = atan2(2*data(i,5)*data(i,6) + 2*data(i,3)*data(i,4), -2*data(i,4)*data(i,4) - 2*data(i,5)*data(i,5) + 1);
	AttiMatrix(i,3) = atan2(2*(data(i,4)*data(i,5) + data(i,3)*data(i,6)),    data(i,3)*data(i,3) + data(i,4)*data(i,4) - data(i,5)*data(i,5) - data(i,6)*data(i,6));
%     Pitch  = asin(-2 * q1 * q3 + 2 * q0* q2)* 57.3; // pitch
%   	Roll = atan2(2 * q2 * q3 + 2 * q0 * q1, -2 * q1 * q1 - 2 * q2* q2 + 1)* 57.3; // roll
% 	Yaw = 	atan2(2*(q1*q2 + q0*q3),q0*q0+q1*q1-q2*q2-q3*q3) * 57.3;
    
    % ����g������ͶӰ����
    GxyzMatrix(i,1) = cos(AttiMatrix(i,1)) * sin(AttiMatrix(i,2));
	GxyzMatrix(i,2) = sin(AttiMatrix(i,1));
    GxyzMatrix(i,3) = cos(AttiMatrix(i,1)) * cos(AttiMatrix(i,2));
	
    % ͶӰ��X��Yƽ��ļ��ٶȣ��ٶȣ�λ�ü���
	% Ax = ax * cos(Angle2) + az * sin(Angle2);
	% Ay = ax * sin(Angle1) * sin(Angle2) + ay * cos(Angle1) - az * sin(Angle1) * cos(Angle2);
	AccXYMatrix(i,1) = (data(i,10)-Acc0Matrix(1)) * cos(AttiMatrix(i,2)) + (data(i,12)-Acc0Matrix(3)) * sin(AttiMatrix(i,2)) + 0.075-0.025;%+0.002;
	AccXYMatrix(i,2) = (data(i,10)-Acc0Matrix(1)) * sin(AttiMatrix(i,1)) * sin(AttiMatrix(i,2)) + (data(i,11)-Acc0Matrix(2)) * cos(AttiMatrix(i,1)) - (data(i,12)-Acc0Matrix(3)) * sin(AttiMatrix(i,1)) * cos(AttiMatrix(i,2)) + 0.053-0.01865;%-0.003;
%     AccXYMatrix(i,1) = (data(i,10)-Acc0Matrix(1)) * cos(AttiMatrix(i,2)) + (data(i,12)-Acc0Matrix(3)) * sin(AttiMatrix(i,2));% + 0.075;
% 	AccXYMatrix(i,2) = (data(i,10)-Acc0Matrix(1)) * sin(AttiMatrix(i,1)) * sin(AttiMatrix(i,2)) + (data(i,11)-Acc0Matrix(2)) * cos(AttiMatrix(i,1)) - (data(i,12)-Acc0Matrix(3)) * sin(AttiMatrix(i,1)) * cos(AttiMatrix(i,2));% + 0.053;
%     AccXYMatrix(i,1) = (data(i,10)-Acc0Matrix(1)) * cos(AttiMatrix(i,2)) + (data(i,12)-Acc0Matrix(3)) * sin(AttiMatrix(i,2)) + 0.0843+0.0012;
% 	AccXYMatrix(i,2) = (data(i,10)-Acc0Matrix(1)) * sin(AttiMatrix(i,1)) * sin(AttiMatrix(i,2)) + (data(i,11)-Acc0Matrix(2)) * cos(AttiMatrix(i,1)) - (data(i,12)-Acc0Matrix(3)) * sin(AttiMatrix(i,1)) * cos(AttiMatrix(i,2)) -0.016+0.00129;	

% V(k) = V(k-1) + a(k) * dt;
	% P(k) = P(k-1) + V(k) * dt;
	if(i<=1)
		VxyMatrix(i,1) = AccXYMatrix(i,1) * dt;
		VxyMatrix(i,2) = AccXYMatrix(i,2) * dt;
		
%         if(abs(VxyMatrix(i,1)) < 0.002)
%             VxyMatrix(i,1) = 0;
%         end
%         if(abs(VxyMatrix(i,2)) < 0.002)
%             VxyMatrix(i,2) = 0;
%         end
        
%         if(abs(VxyMatrix(i,1) ) < 0.003)
%             VxyMatrix(i,1) = 0;
%         end
%         if(abs(VxyMatrix(i,2) ) < 0.003)
%             VxyMatrix(i,2) = 0;
%         end

		PxyMatrix(i,1) = 0.5 * VxyMatrix(i,1) * dt;
		PxyMatrix(i,2) = 0.5 * VxyMatrix(i,2) * dt;
	else
		VxyMatrix(i,1) = VxyMatrix(i-1,1) + AccXYMatrix(i,1) * dt;
		VxyMatrix(i,2) = VxyMatrix(i-1,2) + AccXYMatrix(i,2) * dt;
		
%         if(abs(VxyMatrix(i,1) ) < 0.003)
%             VxyMatrix(i,1) = 0;
%         end
%         if(abs(VxyMatrix(i,2) ) < 0.003)
%             VxyMatrix(i,2) = 0;
%         end
        
		PxyMatrix(i,1) = PxyMatrix(i-1,1) + VxyMatrix(i,1) * dt;
		PxyMatrix(i,2) = PxyMatrix(i-1,2) + VxyMatrix(i,2) * dt;
    end
    
    
    
end


%% ��Ԫ�������̬��ͼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
for j = 1:1:3
    subplot(3,1,j);
    plot(AttiMatrix(:,j)*180/pi,'b');
    
    switch j
        case 1
            title('Attix');
            ylabel('Pitch(��)');
        case 2
            title('Attiy');
            ylabel('Roll(��)');
        case 3
            title('Attiz');
            ylabel('Yaw(��)');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
subplot(4,1,1);
plot(VxyMatrix(:,1),'b');
title('Vx');

subplot(4,1,2);
plot(VxyMatrix(:,2),'b');
title('Vy');

subplot(4,1,3);
plot(PxyMatrix(:,1),'b');
title('Px');

subplot(4,1,4);
plot(PxyMatrix(:,2),'b');
title('Py');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot(PxyMatrix(:,1),PxyMatrix(:,2),'b');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
for j = 1:1:3
    subplot(3,1,j);
    plot(GxyzMatrix(:,j),'b');
end
