
function Oiga_nbb = GetdCnbdtK(Wrbb)
%% �ɽ����ʼ�����̬ת�ƾ���仯������
Oiga_nbb = [        0       -Wrbb(3)    Wrbb(2)
            Wrbb(3)         0       -Wrbb(1)
            -Wrbb(2)    Wrbb(1)        0   ];