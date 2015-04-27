%%  ����λ�����ָ��
function errorStr = CalPosErrorIndex( true_position,PosError,AttitudeError )

%% ����ռ��άλ�������ֵ
routeLong_2dim = 0; % ƽ�����г�
for k=1:length(true_position)-1
    routeLong_2dim = routeLong_2dim + sqrt( (true_position(1,k+1)-true_position(1,k))^2 + (true_position(2,k+1)-true_position(2,k))^2 );
end
% �����յ����
PosErrorLength = length(PosError);
endAbsError_2dim = sqrt( (PosError(1,PosErrorLength))^2+(PosError(2,PosErrorLength))^2 ) ;  % ƽ���յ�������ֵ
endRelError_2dim = endAbsError_2dim/routeLong_2dim ;    % ƽ���յ�������ֵ
% ����������
maxAbsError_2dim = 0;   % ƽ�����������ֵ
for k=1:PosErrorLength
    error = sqrt( (PosError(1,k))^2+(PosError(2,k))^2 ) ;
    if error>maxAbsError_2dim
       maxAbsError_2dim = error ; 
    end
end
maxRelError_2dim = maxAbsError_2dim/routeLong_2dim ;    % ƽ�����������ֵ

errorStr = sprintf('\tƽ�棺\t���г̣�%0.4g m\t\t�����%0.4g m (%0.4g%%)\n',...
    routeLong_2dim,maxAbsError_2dim,maxRelError_2dim*100);

%% ����ռ���άλ�������ֵ
routeLong_3dim = 0; % �ռ����г�
for k=1:length(true_position)-1
    routeLong_3dim = routeLong_3dim + sqrt( (true_position(1,k+1)-true_position(1,k))^2 + (true_position(2,k+1)-true_position(2,k))^2 + (true_position(3,k+1)-true_position(3,k))^2 );
end
% �����յ����
PosErrorLength = length(PosError);
endAbsError_3dim = sqrt( (PosError(1,PosErrorLength))^2+(PosError(2,PosErrorLength))^2+(PosError(3,PosErrorLength))^2 ) ;  % �ռ��յ�������ֵ
endRelError_3dim = endAbsError_3dim/routeLong_3dim ;    % �ռ��յ�������ֵ
% ����������
maxAbsError_3dim = 0;   % �ռ����������ֵ
for k=1:PosErrorLength
    error = sqrt( (PosError(1,k))^2+(PosError(2,k))^2+(PosError(3,k))^2 ) ;
    if error>maxAbsError_3dim
       maxAbsError_3dim = error ; 
    end
end
maxRelError_3dim = maxAbsError_3dim/routeLong_3dim ;    % �ռ����������ֵ

errorStr = sprintf('%s\t�ռ䣺\t���г̣�%0.4g m\t\t�����%0.4g m (%0.4g%%)\n',errorStr,...
    routeLong_3dim,maxAbsError_3dim,maxRelError_3dim*100);

% ��ά�����
xyzLength = CalRouteLength( true_position ) ; % �õ���ά���г�
maxPosError_x = 0;
maxPosError_y = 0;
maxPosError_z = 0;
for k=1:PosErrorLength
    if abs(PosError(1,k))>abs(maxPosError_x)
       maxPosError_x =  PosError(1,k) ;
    end
    if abs(PosError(2,k))>abs(maxPosError_y)
       maxPosError_y =  PosError(2,k) ;
    end
    if abs(PosError(3,k))>abs(maxPosError_z)
       maxPosError_z =  PosError(3,k) ;
    end
end
errorStr = sprintf('%s\tλ�����(x��y��z)��(%0.3g,%0.3g,%0.3g)m\t(%0.3g%%,%0.3g%%,%0.3g%%)\n',...
                errorStr,maxPosError_x,maxPosError_y,maxPosError_z,maxPosError_x/xyzLength(1)*100,maxPosError_y/xyzLength(2)*100,maxPosError_z/xyzLength(3)*100);
% ��̬��λ������
if exist('AttitudeError','var')
    maxAtdError_x = 0;
    maxAtdError_y = 0;
    maxAtdError_z = 0;
    for k=1:PosErrorLength
        if abs(AttitudeError(1,k))>abs(maxAtdError_x)
           maxAtdError_x =  AttitudeError(1,k) ;
        end
        if abs(AttitudeError(2,k))>abs(maxAtdError_y)
           maxAtdError_y =  AttitudeError(2,k) ;
        end
        if abs(AttitudeError(3,k))>abs(maxAtdError_z)
           maxAtdError_z =  AttitudeError(3,k) ;
        end
    end
    errorStr = sprintf('%s\t��̬��� (���������������):(%0.3g,%0.3g,%0.3g)��\n',...
        errorStr,maxAtdError_x,maxAtdError_y,maxAtdError_z);
end
