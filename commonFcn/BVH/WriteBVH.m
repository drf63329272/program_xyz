%% xyz 2015.4.1
%% дBVH����
% BVHStruct �� �ṹ��
% IsWriteDisp �� �Ƿ�дλ��

function WriteBVH( BVHStruct,dataFolder,dataName,IsWriteDisp )

Frames = BVHStruct.Frames ;
isContainDisp = BVHStruct.isContainDisp ;

if IsWriteDisp==1
    if isContainDisp==0
       errordlg('BVH��������λ����Ϣ��'); 
       return;
    end
    BVHHeadStr_Write  = BVHStruct.BVHHeadStr ;
    MatrixData_Write  = BVHStruct.MatrixData ;
    
else
    BVHHeadStr_Write  = BVHStruct.BVHHeadStr_NoDisp ;
    MatrixData_Write  = BVHStruct.MatrixDataNoDisp ;
    
end

fID = fopen( [dataFolder,'\',dataName,'.bvh'],'w' );
BVHHeadStr_Write(1)  =[];
fprintf( fID,'%s \n ',BVHHeadStr_Write );
% fprintf( fID,'\n' ); 

N = Frames;
for k=1:N    
    
    if k<N
        fprintf( fID,'%0.2f ',MatrixData_Write(k,:) );
    else
        fprintf( fID,'%0.2f ',MatrixData_Write(k,:) );
    end
    if k<N
        fprintf( fID,'\n' );
    end
end

fclose(fID);

fprintf( 'write %s OK \n',[dataFolder,'\',dataName,'.bvh'] );