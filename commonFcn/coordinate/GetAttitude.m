% ���ߣ�xyz
% ���ڣ�2013.12.23
% ���ܣ��� Cn2b����̬��
% �����unit='rad'/'degree'��Ĭ��rad�� ���������������
function Attitude = GetAttitude(Cn2b,unit,opintions)
%% ����
% Cn2b : ����ϵ������ϵ��ת�ƾ���
% uint : �����λ 'rad'/'degree'
% opintions ����������
%   ����Ƕ��壺 opintions.headingScope = 'anticlockwise'/'clockwise   '��'��ʱ��'/'˳ʱ��'Ϊ����
%               opintions.headingScope = 360 /180��[0 360]��[-180 180])  
% Ĭ�ϣ���ʱ�룬[-180 180]�� rad
format long
%% Ԥ�� unit
if ~exist('unit','var')
    unit='rad' ;
end
if isempty(unit) 
    unit='rad' ;
end
% û������unit ���� unit������� �� unit='rad' 
if ~strcmp(unit,'degree') && ~strcmp(unit,'rad')
  errordlg('unit�������') ;
  unit='rad' ;
end
%% Ԥ��opintinous
if ~exist('opintions','var')
    opintions.headingScope=180;
    %disp('Ĭ��ʹ��180�ȷ�Χ����ʱ�뺽����')
end
if ~isfield(opintions,'headingScope')
    opintions.headingScope='anticlockwise';
end
if ~isfield(opintions,'headingScope')
    opintions.headingScope=360;
end
%%
%Attitude=[fy��������,hg�������,hx�������]
%% ������[-90,90]���޶�ֵ����
fy = asin( Cn2b(2,3) ) ;      
hg = atan( -Cn2b(1,3)/Cn2b(3,3) ) ;
%% ����Ƕ�����[-180,180],���ڶ�ֵ����
if hg<0&&Cn2b(1,3)<0            %��ʵ���䣺[90,180]
    hg = hg+pi ;
end
if hg>0&&Cn2b(1,3)>0            %[-180,90]
    hg = hg-pi ;
end

%% �����Ĭ�϶��壨��ʱ��Ϊ����������[0,360],���ڶ�ֵ����
hx = atan( -Cn2b(2,1)/Cn2b(2,2) ) ;
if strcmp(opintions.headingScope,'clockwise')        % ˳ʱ��
    hx = -hx ;
end
if opintions.headingScope==180
    % ��Χ��[-180 180]    
    if hx<=0
        if Cn2b(2,2)<0
            hx = hx+pi;    
        end
    else
        if Cn2b(2,2)<0
            hx = hx-pi;
        end
    end
else    
    % ��Χ��[0 360]
    if hx<=0  % ��׼λ<0 Ϊ�˷�ֹ����0��360�ľ��ұ䶯 �ɸ��� <-1e-3
        if Cn2b(2,2)<0              %��ʵ���䣺[90,180]
            hx = hx+pi ;
        else
            if hx~=0
                hx = hx+2*pi ;          %[270,360]
            end
        end
    elseif hx>0 && Cn2b(2,2)<0        %[180,270]
            hx = hx+pi ;
    end
end


%%
Attitude = [fy;hg;hx] ; % ���ȵ�λ
if strcmp(unit,'degree')
    Attitude = Attitude*180/pi ;  %���Ƕȴ洢
end
