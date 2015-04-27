%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              xyz
%                           2014.3.20
%                         ��������У��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function yawerror_new = YawErrorAdjust(yawerror_old,unit)
%% 
%   ����ĺ������λΪ ����  / rad
%   �� ���ֵ�� 360*3600 / 2*pi ����ʱ��ʾ��ҪУ��

%%
if isempty(unit) 
   warndlg('δ���뵥λ��YawErrorAdjust��'); 
   yawerror_new=[];
   return ;
else
    switch unit
        case 'ArcSec'
            peak = 360*3600 ;
        case 'rad'
            peak = 2*pi ;
        otherwise
            yawerror_new=[];
            warndlg('����ĵ�λ��Ч(YawErrorAdjust)');
            return;
    end
end
if ( abs(yawerror_old)/(peak) )>0.5
   %% ��ҪУ��
   yawerror_new = yawerror_old - sign(yawerror_old)*peak ;
else
    yawerror_new = yawerror_old ;
end
