% buaa xyz 2014.1.16

% ״̬����F->״̬ת�ƾ���Fai
% cycleTΪ�˲�����

function Fai = FtoFai(F,cycleT)
format long
step = 1;
Fai = eye(size(F));
for i = 1:10
    step = step*i;
    Fai = Fai + (F * cycleT)^i/step;
end