% buaa xyz 2014.1.8

% ��ȡ���ָ�꣬��� text ��ʽ

function text_error_xyz = GetErrorText( data,errorData )

routeLength = CalRouteLength(data);  % �ȼ�����ʵ�ۻ����߾���
%% ��������������������
max_x = max(abs(errorData(1,:))) ;  % x��������
max_y = max(abs(errorData(2,:)));
max_z = max(abs(errorData(3,:)));
text_max_x = sprintf('x��%0.3g/%0.1g',max_x,routeLength(1)) ;
text_max_y = sprintf('y��%0.3g/%0.1g',max_y,routeLength(2)) ;
text_max_z = sprintf('z��%0.3g/%0.1g',max_z,routeLength(3)) ;

maxRelativeError_x = max_x/routeLength(1) ;
maxRelativeError_y = max_y/routeLength(2) ;
maxRelativeError_z = max_z/routeLength(3) ;
% ������С��1ʱ��ʾ
if (maxRelativeError_x<1)
    text_relativeMax_x = sprintf('(%0.3g%%)',maxRelativeError_x*100) ;
else
    text_relativeMax_x = [];
end
if (maxRelativeError_y<1)
    text_relativeMax_y = sprintf('(%0.3g%%)',maxRelativeError_y*100) ;
else
    text_relativeMax_y = [];
end
if (maxRelativeError_z<1)
    text_relativeMax_z = sprintf('(%0.3g%%)',maxRelativeError_z*100) ;
else
    text_relativeMax_z = [];
end
text_maxError = { '������',[text_max_x,text_relativeMax_x],[text_max_y,text_relativeMax_y],[text_max_z,text_relativeMax_z] } ;
%% �����յ������յ�������
end_k = size(errorData,2) ;
end_x = abs(errorData(1,end_k)) ;  % x��������
end_y = abs(errorData(2,end_k));
end_z = abs(errorData(3,end_k));

text_end_x = sprintf('x��%0.3g/%0.1g',end_x,routeLength(1)) ;
text_end_y = sprintf('y��%0.3g/%0.1g',end_y,routeLength(2)) ;
text_end_z = sprintf('z��%0.3g/%0.1g',end_z,routeLength(3)) ;

endRelativeError_x = end_x/routeLength(1) ;
endRelativeError_y = end_y/routeLength(2) ;
endRelativeError_z = end_z/routeLength(3) ;
% ������С��1ʱ��ʾ
if (endRelativeError_x<1)
    text_relativeEnd_x = sprintf('(%0.3g%%)',endRelativeError_x*100) ;
else
    text_relativeEnd_x = [];
end
if (endRelativeError_y<1)
    text_relativeEnd_y = sprintf('(%0.3g%%)',endRelativeError_y*100) ;
else
    text_relativeEnd_y = [];
end
if (endRelativeError_z<1)
    text_relativeEnd_z = sprintf('(%0.3g%%)',endRelativeError_z*100) ;
else
    text_relativeEnd_z = [];
end
text_endError = { '�յ����',[text_end_x,text_relativeEnd_x],[text_end_y,text_relativeEnd_y],[text_end_z,text_relativeEnd_z] } ;
%% ���

text_error_xyz = [text_maxError,text_endError];
    