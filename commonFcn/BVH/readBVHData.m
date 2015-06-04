%% ��ȡ�£֣����ݵ��ṹ�塡BVHStruct
% MatrixData �� [ N*354 ]  ÿһ��Ϊһ֡
% MatrixDataNoDisp ��[N*180]  ֻ��Hip��λ��
% BVHHeadStr�� [1*N] char BVHͷ�ַ���
% isContainDisp�� 0/1 BVH�� Hip ֮��Ľڵ��Ƿ����λ����Ϣ
% JointName �� cell [N*1]   JointName{i,1}��ؽ���  
% JointRotation�� JointRotation.JointName{i} ��ŷ������ת˳��
% BVHStruct.JointData  ���ؽڴ洢���� [N*3]  ��  [N*6]
% Frames�� ֡��
% Frame_Time�� ���� ��
% BVHHeadStr_NoDisp�� [1*N] char ��Hip����Displacement�� BVH ͷ�ַ���
% BVHStruct.JointData  ���ؽڴ洢���� [N*3]  ��  [N*6](ǰ��ŷ���ǣ�����λ��)

% λ�Ƶ�λ�� cm
% �Ƕȵ�λ�� degree

%% BVH ���� ����ϵ
% reference hip �� ���춫 ����ϵ
% �����ڵ��� ����ǰ ����ϵ

% ���ʱ���� �� Ϊ��λ
function  BVHStruct = readBVHData ( dataFolder,dataName )

%  dataName = 'BVHData';
%  dataFolder = 'E:\data_xyz\Hybrid Motion Capture Data\5.28\5.28-head1';
BVHFilePath = [dataFolder,'\',dataName,'.bvh'] ;

if ~exist([dataFolder,'\',dataName,'.mat'],'file')
% if 1
    if ~exist(BVHFilePath,'file')
       errordlg(sprintf('������BVH�ļ� %s',BVHFilePath));
       return;
    end
    disp('read BVH')
    % dbstop in GetNumberStartLine
    [ BVHHeadStr,numberStartLine ] = GetNumberStartLine( BVHFilePath );
%  dbstop in readBVH_Format
    [ JointName,JointRotation,Frames,Frame_Time,isContainDisp ]  = readBVH_Format( BVHFilePath,numberStartLine ) ; 
    BVHHeadStr_NoDisp = GetBVHHeadStr_NoDisp( BVHHeadStr );
    
%     [ BVHHeadStr_NoDisp,isContainDisp ]  = readBVH_HeadStr( BVHFilePath,numberStartLine ) ;
    if strcmp(JointName{1,1},'ROOT Hips')
        JointName{1,1} = 'ROOT_Hips';
    else
        errordlg('JointName{1,1} not ROOT Hips');
    end
    disp('In reading BVH data...');
    MatrixData = readBVH_Data( BVHFilePath,numberStartLine ) ;  
    if size(MatrixData,1)~=Frames
       errordlg( sprintf(' Frames = %d, but read %d ',Frames,size(MatrixData,1)) ); 
    else
        display( sprintf( 'Frames = %d',Frames ));
    end
    MatrixDataNoDisp = GetNoDispMatrixData( MatrixData,isContainDisp ) ;

    
    BVHStruct.MatrixData = MatrixData ;
    BVHStruct.MatrixDataNoDisp = MatrixDataNoDisp ;
    BVHStruct.JointName = JointName ;
    BVHStruct.JointRotation = JointRotation ;
    BVHStruct.BVHHeadStr = BVHHeadStr ;
    BVHStruct.Frame_Time = Frame_Time ;
    BVHStruct.isContainDisp = isContainDisp ;
    BVHStruct.BVHHeadStr_NoDisp = BVHHeadStr_NoDisp ;
    BVHStruct.Frames = Frames ;
    
    BVHFormat_N = size(JointName,1);
    skeleten_n_sart = 1 ;
    %% BVHStruct.JointData  ���ؽڴ洢���� [N*3]  ��  [N*6]
    for k = 1:BVHFormat_N
        JointName_k = JointName{k,1};        
        
        if isContainDisp==1
            % ÿ���ؽڶ���λ��
            skeleten_n_end = skeleten_n_sart+5 ;
        else
            % �� Hip����λ����Ϣ
            if k==1            
                skeleten_n_end = skeleten_n_sart+5 ;       % ֻ��Hip����λ��       
            else            
                skeleten_n_end = skeleten_n_sart+2 ;           
            end
        end
        eval( sprintf('BVHStruct.JointData.%s = MatrixData( :,%d:%d ) ;',JointName_k,skeleten_n_sart,skeleten_n_end) );
        skeleten_n_sart = skeleten_n_end + 1 ;
    end
     
    save( [dataFolder,'\',dataName,'.mat'],'BVHStruct'  )    
else
    BVHStruct = importdata( [dataFolder,'\',dataName,'.mat'] );
    disp('û��BVH��ֱ�ӵ���mat����� import BVHStruct')
end



function BVHHeadStr_NoDisp = GetBVHHeadStr_NoDisp( BVHHeadStr )

BVHHeadStr_NoDisp = strrep( BVHHeadStr,'CHANNELS 6 Xposition Yposition Zposition','CHANNELS 3' );
k = strfind( BVHHeadStr_NoDisp,'CHANNELS 3');
k1 = k(1);
BVHHeadStr_NoDisp(k1:length('CHANNELS 3')+k1-1) = '';
BVHHeadStr_NoDisp = sprintf( '%s%s%s',BVHHeadStr_NoDisp(1:k1-1),...
    'CHANNELS 6 Xposition Yposition Zposition',BVHHeadStr_NoDisp(k1:length(BVHHeadStr_NoDisp)) );

function [ SkeletenBVH,SkeletenBVH_Order ] = SearchSkeletenBVH( skeleten,JointName,BVH )
N = size(JointName,1);
for k=1:N
    if strcmp( skeleten,JointName{k,1} )
        SkeletenBVH_Order = [ JointName{k,2},JointName{k,3} ];
        SkeletenBVH = BVH( :,SkeletenBVH_Order(1):SkeletenBVH_Order(2) );
    end
end

%% ֱ�Ӷ�ȡ�� BVH ����
% MatrixData �� [ N*354 ]  ÿһ��Ϊһ֡
function MatrixData = readBVH_Data( filePath,numberStartLine )


fid = fopen(filePath,'r' ) ;
MatrixData = [] ;  % N*3
n = 1 ;
k = 0 ;
while ~feof(fid)
   tline = fgetl(fid) ; 
   if n>=numberStartLine
       lineData = textscan( tline,'%f' ) ;
       k = k+1 ;
       MatrixData = [ MatrixData ; lineData{1}' ];
   end
   n = n+1 ;
   
end
fclose(fid);


function [ lineStrNew,spaceStr ] = FrontSpace( lineStr )
N = length(lineStr);
spaceN = 0;
for k=1:N
   if strcmp(lineStr(k),' ') 
       spaceN = spaceN+1 ;
   else
       break;
   end
end
spaceStr = lineStr(1:spaceN);
lineStrNew = lineStr( spaceN+1:N );

%% BVH���ݸ�ʽ
% JointName �� cell [N*1]   JointName{i}��ؽ���
% Frames�� ֡��
% Frame_Time�� ���� ��
function [ JointName,JointRotation,Frames,Frame_Time,isContainDisp ] = readBVH_Format( filePath,numberStartLine )
fid = fopen(filePath,'r' ) ;

JointName = cell(10,1);
JointRotation = struct;

k = 1 ;
JointName{k,1} = 'ROOT Hips';
line_n = 1 ;
isContainDisp=  0 ;
while ~feof(fid) && line_n < numberStartLine
   tline = fgetl(fid) ; 
   if ~isempty(tline)
       lineData = textscan( tline,'%s' ) ;
       if ~isempty(lineData{1}) && strcmp( lineData{1}{1},'JOINT' )
           k = k+1 ;
           JointName{k,1} =  lineData{1}{2} ;
       end
       if ~isempty(lineData{1}) && strcmp( lineData{1}{1},'CHANNELS' )
           % ��ȡ JointName{k,1} ����ת˳��
           if strcmp(JointName{k,1} ,'ROOT Hips')
               JointName_k = 'ROOT_Hips';
           else
               JointName_k = JointName{k,1} ;
           end
           order = [ lineData{1}{6}(1),lineData{1}{7}(1),lineData{1}{8}(1) ] ;
           eval( sprintf('JointRotation.%s = order; ',...
               JointName_k) )  ;
           if k>1 && length(lineData{1})==8
               isContainDisp = 1 ;
           end
       end
       if ~isempty(lineData{1}) && strcmp( lineData{1}{1},'Frames:' )
           Frames = str2double( lineData{1}{2} );
       end
       if ~isempty(lineData{1}) &&  strcmp( lineData{1}{1},'Frame' ) && strcmp( lineData{1}{2},'Time:' )
           Frame_Time = str2double( lineData{1}{3} );
       end
   end
   line_n = line_n+1 ;   
end
fclose(fid);
N_BVH = k ;
JointName = JointName( 1:N_BVH,: ) ;

%% ��һ�����ݵ������
% BVHHeadStr�� BVH ͷ�ַ���
% numberStartLine�� ��һ�����ֵ������
function [ BVHHeadStr,numberStartLine ] = GetNumberStartLine( BVHFilePath )
fid = fopen(BVHFilePath,'r' ) ;
line_n = 0 ;
numberStartLine = 0;
BVHHeadStr = '';
while ~feof(fid)  &&  line_n<360
    tline = fgetl(fid) ; 
    line_n = line_n+1 ;  
    if ~isempty(tline)
        lineData = textscan( tline,'%s' ) ;     
        if ~isempty(lineData{1}) && ~isnan( str2double( lineData{1}{1} ))
            % ������
            numberStartLine = line_n ;
            break;
        else
            % ��������
            BVHHeadStr = sprintf('%s\n%s',BVHHeadStr,tline);
        end
    else
        BVHHeadStr = sprintf('%s\n ',BVHHeadStr);
    end
    
end
