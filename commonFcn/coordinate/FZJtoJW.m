% �ӵ���ֱ������ϵ������������ϵ����γ�ȣ��µ�ת��
% ֱ������ϵ -->  ��γ�ȼ�����ϵ

% ���� position (m) ��x,y,z
% ��� P
%   P(1)�����ȣ�rad��
%   P(2)��γ�ȣ�rad��
%   P(3)���߶�(m)

function P = FZJtoJW(position,planet)
format long
if ~exist('planet','var')
   errordlg('δ������������(Fdtoe)')
   P=[];
   return;
else
    if ~strcmp(planet,'e') && ~strcmp(planet,'m')
        errordlg('planet��������(Fdtoe)')
        P=[];
        return;
    end
end
if strcmp(planet,'e')
    earthConst = getEarthConst;
    e = earthConst.e ;
    Ra = earthConst.Re ;
else
    moonConst = getMoonConst;
    e = moonConst.e ;   % �������
    Ra = moonConst.Rm ;  % ����������뾶��m
end

x = position(1);
y = position(2);
z = position(3);
% a = 1737400;  % ����������뾶��m
% e = 0.006;  % �������
r = sqrt(x^2 + y^2 +z^2);

latitude = asin(z/r);

longitude = atan(y/x); %   ���ȶ�ֵ��
%% ���ȷ�Χ[0 360]
if longitude<0
    if  x<0
        longitude=longitude+pi;     % [90 180]
    else
        longitude=longitude+2*pi;   % [270 360]
    end
else
    if y<0 % [180 270]
        longitude=longitude+pi;
    end
end

% %% ���ȷ�Χ[-180 180]
% if longitude<0
%     if x<0 % [90 180]
%         longitude=longitude+pi;
%     end
% else
%     if y<0 % [-180 -90]
%         longitude=longitude-pi;
%     end
% end

%% ������
% RN = Ra*(1-e^2)/(1-e^2*sin(latitude)^2)^(3/2) ; % �����������ʰ뾶
% RE = Ra/(1-e^2*sin(latitude)^2)^(1/2) ; % ���������ʰ뾶
% R0 = sqrt(RE*RN) ;  % ƽ�������ʰ뾶

%% ����Ϊ����
R0 = Ra ;

h=r-R0;

P=[longitude;latitude;h];

% 
% B = atan(z/sqrt(x^2+y^2));
% longitude = atan(y/x);  % ���� 
% fai2 = 0;
% while 1
%     latitude = atan(tan(B)*(1+a*e^2/z*sin(fai2)/sqrt(1-e^2*sin(fai2)^2)));
%     h = r * cos(B) / cos(fai2) - a/sqrt(1-e^2*sin(fai2)^2);
%     if latitude-fai2<1e-18
%         break;
%     else
%         fai2=latitude;
%     end
% end
% if x < 0 && longitude < 0
% %     sym E
%     longitude = longitude + pi;
% elseif y < 0 && longitude < 0
%     longitude = longitude + 2*pi;
% end
% P=[longitude;latitude;h];
