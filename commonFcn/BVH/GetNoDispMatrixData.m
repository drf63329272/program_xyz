%% xyz  2015.6.2

%% �� MatrixData -> MatrixDataNoDisp


function MatrixDataNoDisp = GetNoDispMatrixData( MatrixData,isContainDisp )
MatrixDataNoDisp = MatrixData ;
if isContainDisp==0
    return;
end

k=12 ;  % ��һ����Ҫɾ����λ���� [10 11 12]
while k<=size(MatrixDataNoDisp,2)
    MatrixDataNoDisp( :,k-2:k ) =[] ;   % ÿ��ɾ����
    
    k = k+3;  % ע�⣺����ÿ�ν�6���������ϴ�ɾ��3��ֻ��3
end