%%  ��λ��sec
%  runTime(k): �ӿ�ʼ�����ڵ�ʱ��
%  stepTime(k): ��k��k+1ʱ�̵�ʱ��
function stepTime = runTime_to_setpTime(runTime)

stepTime = zeros(size(runTime));
for k=1:length(runTime)-1
    stepTime(k) = runTime(k+1)-runTime(k) ;
end
stepTime(length(runTime)) = [];
