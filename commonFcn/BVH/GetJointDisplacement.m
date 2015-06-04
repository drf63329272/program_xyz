%% xyz 2015.6.2
%% ֱ�ӵõ��ؽڵ�λ��
% ����ϵ�� 

function JointDisplacement = GetJointDisplacement( BVHStruct,JointName_k )


JointData = BVHStruct.JointData ;
if ~isfield( JointData,JointName_k )
    errordlg(sprintf('BVHStruct�޳�Ա%s',JointName_k));
    JointDisplacement = NaN;
    return;
end
if BVHStruct.isContainDisp ==0 && ~strcmp( JointName_k,'ROOT_Hips' )
    errordlg('δ�洢λ��');
end
JointData_k = eval( sprintf('JointData.%s ;',JointName_k) );
JointDisplacement = JointData_k( :,1:3 );   % �����λ����϶���ǰ����

