
%% ���� BodyDirection ����̬
% �����д���֤������������������������������������������������������������������
%   BodyDirection  �˳���Ϊ [1 0 0]
function Cr_r1 = BodyDirection2Cr_r1( BodyDirection )
coder.inline('never');

V = [1 0 0];   % ����
thita = acos( V*BodyDirection / normest(BodyDirection)   );
% ͨ����˿��жϽǶȷ���
temp = cross(V,BodyDirection) ;  % �� V �� BodyDirection ��ʱ��180������ʱ��temp���ϣ�temp(3)<0
if temp(3)>0
        % �� V �� BodyDirection ��ʱ��ת������180��
      thita = -thita ;
end
    
Cr_r1 = RotateZ( thita ) ;