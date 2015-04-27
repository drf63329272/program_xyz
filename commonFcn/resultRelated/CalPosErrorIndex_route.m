%%  ����λ�����ָ��
% 6.12�ģ� �ۺ����Ϊ �����г�/��ʵ�г�
% ���/�յ�λ�������·�̵�������
% ��̬�����յ����
function errorStr = CalPosErrorIndex_route( true_position,PosError,AttitudeError,position_nav )

%% ����ռ��άλ�������ֵ
%% ƽ���г����
routeLong_2dim_true = 0; % ƽ�����г�
for k=1:length(true_position)-1
    routeLong_2dim_true = routeLong_2dim_true + sqrt( (true_position(1,k+1)-true_position(1,k))^2 + (true_position(2,k+1)-true_position(2,k))^2 );
end
routeLong_2dim_nav = 0; % ƽ�����г�
for k=1:length(position_nav)-1
    routeLong_2dim_nav = routeLong_2dim_nav + sqrt( (position_nav(1,k+1)-position_nav(1,k))^2 + (position_nav(2,k+1)-position_nav(2,k))^2 );
end
routeError = routeLong_2dim_nav-routeLong_2dim_true ;
errorStr = sprintf('\tƽ�棺\t��ʵ�г̣�%0.5g m\t�����г�:%0.5g m\t�г���%0.5g m (%0.5g%%)\n',...
    routeLong_2dim_true,routeLong_2dim_nav,routeError,routeError/routeLong_2dim_true*100);
%% ����������
PosErrorLength = length(PosError);
maxAbsError_2dim = 0;   % ƽ�����������ֵ
for k=1:PosErrorLength
    error = sqrt( (PosError(1,k))^2+(PosError(2,k))^2 ) ;
    if error>maxAbsError_2dim
       maxAbsError_2dim = error ; 
    end
end
maxRelError_2dim = maxAbsError_2dim/routeLong_2dim_true ;    % ƽ�����������ֵ

errorStr = sprintf('%s\t\tƽ���ԭ�������%0.5g m (%0.5g%%)\n',...
            errorStr,maxAbsError_2dim,maxRelError_2dim*100);
%% �����յ����
endAbsError_2dim = sqrt( (PosError(1,PosErrorLength))^2+(PosError(2,PosErrorLength))^2 ) ;  % ƽ���յ�������ֵ
endRelError_2dim = endAbsError_2dim/routeLong_2dim_true ;    % ƽ���յ�������ֵ
errorStr = sprintf('%s\t\tƽ���յ�λ����%0.5g m  (%0.5g%%) \n',...
            errorStr,endAbsError_2dim,endRelError_2dim*100 );
%% ����ռ���άλ�������ֵ
routeLong_3dim_true = 0; % �ռ����г�
for k=1:length(true_position)-1
    routeLong_3dim_true = routeLong_3dim_true + sqrt( (true_position(1,k+1)-true_position(1,k))^2 + (true_position(2,k+1)-true_position(2,k))^2 + (true_position(3,k+1)-true_position(3,k))^2 );
end
routeLong_3dim_nav = 0; % �ռ����г�
for k=1:length(position_nav)-1
    routeLong_3dim_nav = routeLong_3dim_nav + sqrt( (position_nav(1,k+1)-position_nav(1,k))^2 + (position_nav(2,k+1)-position_nav(2,k))^2 + (position_nav(3,k+1)-position_nav(3,k))^2 );
end
routeError = routeLong_3dim_nav-routeLong_3dim_true ;
errorStr = sprintf('%s\t�ռ䣺\t��ʵ�г̣�%0.5g m\t�����г�:%0.5g m\t�г���%0.5g m (%0.5g%%)\n',...
        errorStr,routeLong_3dim_true,routeLong_3dim_nav,routeError,routeError/routeLong_3dim_true*100);
%% �����յ����
PosErrorLength = length(PosError);
endAbsError_3dim = sqrt( (PosError(1,PosErrorLength))^2+(PosError(2,PosErrorLength))^2+(PosError(3,PosErrorLength))^2 ) ;  % �ռ��յ�������ֵ
endRelError_3dim = endAbsError_3dim/routeLong_3dim_true ;    % �ռ��յ�������ֵ
errorStr = sprintf('%s\t\t�ռ��յ�λ����%0.5g m  (%0.5g%%) \n',...
            errorStr,endAbsError_3dim,endRelError_3dim*100 );
%% ����������
maxAbsError_3dim = 0;   % �ռ����������ֵ
for k=1:PosErrorLength
    error = sqrt( (PosError(1,k))^2+(PosError(2,k))^2+(PosError(3,k))^2 ) ;
    if error>maxAbsError_3dim
       maxAbsError_3dim = error ; 
    end
end
maxRelError_3dim = maxAbsError_3dim/routeLong_3dim_true ;    % �ռ����������ֵ
% 
errorStr = sprintf('%s\t\t�ռ� ����Զ�������%0.5g m (%0.5g%%)\n',errorStr,...
    maxAbsError_3dim,maxRelError_3dim*100);

% ��ά�����
xyzLength_true = CalRouteLength( true_position ) ; % �õ���ά���г�
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
errorStr = sprintf('%s\t��ά ��� λ�����(x��y��z)��(%0.5g,%0.5g,%0.5g)m\t(%0.5g%%,%0.5g%%,%0.5g%%)\n',...
                errorStr,maxPosError_x,maxPosError_y,maxPosError_z,maxPosError_x/xyzLength_true(1)*100,maxPosError_y/xyzLength_true(2)*100,maxPosError_z/xyzLength_true(3)*100);
endPosError_x = PosError(1,PosErrorLength) ;
endPosError_y = PosError(2,PosErrorLength) ;
endPosError_z = PosError(3,PosErrorLength) ;
errorStr = sprintf('%s\t��ά �յ� λ�����(x��y��z)��(%0.5g,%0.5g,%0.5g)m\t(%0.5g%%,%0.5g%%,%0.5g%%)\n',...
                errorStr,endPosError_x,endPosError_y,endPosError_z,endPosError_x/xyzLength_true(1)*100,endPosError_y/xyzLength_true(2)*100,endPosError_z/xyzLength_true(3)*100);

%% ��̬��ά������
% if exist('AttitudeError','var')
%     maxAtdError_x = 0;
%     maxAtdError_y = 0;
%     maxAtdError_z = 0;
%     for k=1:PosErrorLength
%         if abs(AttitudeError(1,k))>abs(maxAtdError_x)
%            maxAtdError_x =  AttitudeError(1,k) ;
%         end
%         if abs(AttitudeError(2,k))>abs(maxAtdError_y)
%            maxAtdError_y =  AttitudeError(2,k) ;
%         end
%         if abs(AttitudeError(3,k))>abs(maxAtdError_z)
%            maxAtdError_z =  AttitudeError(3,k) ;
%         end
%     end
%     errorStr = sprintf('%s\t��̬������ (���������������):(%0.5g,%0.5g,%0.5g)��\n',...
%         errorStr,maxAtdError_x,maxAtdError_y,maxAtdError_z);
%     %% ��̬�յ����
%     finalAttitudeError = AttitudeError(:,length(AttitudeError));
%     errorStr = sprintf('%s\t��̬�յ���� (���������������):(%0.5g,%0.5g,%0.5g)��\n',...
%             errorStr,finalAttitudeError(1),finalAttitudeError(2),finalAttitudeError(3));
% end


if exist('AttitudeError','var') && ~isempty(AttitudeError)
    AttitudeError = AttitudeError/3600 ;
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
    errorStr = sprintf('%s\t��̬������ (���������������):(%0.5g,%0.5g,%0.5g)deg\n',...
        errorStr,maxAtdError_x,maxAtdError_y,maxAtdError_z);
    %% ��̬�յ����
    finalAttitudeError = AttitudeError(:,length(AttitudeError));
    errorStr = sprintf('%s\t��̬�յ���� (���������������):(%0.5g,%0.5g,%0.5g)deg\n',...
            errorStr,finalAttitudeError(1),finalAttitudeError(2),finalAttitudeError(3));
end

