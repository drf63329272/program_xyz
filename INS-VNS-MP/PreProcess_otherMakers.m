



%% �Ӿ�λ��Ԥ����
% 1�����Ӿ�����  ���Ӿ���������ϵ ת�� ����������ϵ
function otherMakers_k = PreProcess_otherMakers( otherMakers_k  )
coder.inline('never');

%% ��ת�������ص�ͬ������ϵ
Cv_r1 = [ 0 0 1; -1 0 0; 0 -1 0 ];
% dbstop in BodyDirection2Cr_r1
% Cr_r1 = BodyDirection2Cr_r1( BodyDirection );   %   ����1��    Ҫ���˳��Ӿ��궨�궨����������ϵ���ж�׼
% Cvr = Cr_r1' * Cv_r1 ;
Cvr = Cv_r1 ;         %   ����2��    Ҫ���Ӿ���������ϵ��Z�ᳯ������




if ~isempty(otherMakers_k.Position)
    otherMakers_k.Position = Cvr*otherMakers_k.Position;    
end




