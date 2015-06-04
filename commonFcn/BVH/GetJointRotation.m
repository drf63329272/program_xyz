%% xyz 2015.6.2
%% ֱ�ӵõ��ؽڵ�λ��
% ����ϵ�� 

function JointRotation = GetJointRotation( BVHStruct,JointName_k )


JointData = BVHStruct.JointData ;
if ~isfield( JointData,JointName_k )
    errordlg(sprintf('BVHStruct�޳�Ա%s',JointName_k));
    JointRotation = NaN;
    return;
end
JointData_k = eval( sprintf('JointData.%s ;',JointName_k) );
if size(JointData_k,2)==3;
    JointRotation = JointData_k( :,1:3 );   
else
    JointRotation = JointData_k( :,4:6 );   % �����λ�����ں�����
end




