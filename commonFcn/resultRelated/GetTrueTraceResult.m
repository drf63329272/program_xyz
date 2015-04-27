% buaa xyz 2013.12.26

% ��trueTrace ��ȡ��ʵ�켣�Ļ�ͼ���

function trueTraceResult = GetTrueTraceResult(trueTrace)

true_position = trueTrace.position;
true_attitude = trueTrace.attitude;
% true_velocity = trueTrace.velocity;
if isfield(trueTrace,'velocity')
    true_velocity = trueTrace.velocity;
else
    true_velocity = [];
end
if isfield(trueTrace,'frequency')
    trueTraeFre = trueTrace.frequency;
end
if isfield(trueTrace,'runTime')
    runTime = trueTrace.runTime;    
end
if isfield(trueTrace,'dataSource')
    dataSource = trueTrace.dataSource; 
end
if isfield(trueTrace,'acc_r')
    acc_r = trueTrace.acc_r;
end


% �洢Ϊ�ض���ʽ��ÿ������һ��ϸ����������Ա��data��name,comment �� dataFlag,frequency,project,subName
resultNum = 6;
trueTraceResult = cell(1,resultNum);

% ��4����ͬ�ĳ�Ա
for j=1:resultNum
    trueTraceResult{j}.dataFlag = 'xyz result display format';    
    if isfield(trueTrace,'runTime')
        trueTraceResult{j}.runTime = runTime;    
    end
    trueTraceResult{j}.frequency = trueTraeFre ;
    trueTraceResult{j}.project = 'true';
    trueTraceResult{j}.subName = {'x','y','z'};
end

res_n = 1;
trueTraceResult{res_n}.data = true_position;
trueTraceResult{res_n}.name = 'position(m)';
trueTraceResult{res_n}.comment = 'λ��';

res_n = res_n+1;
trueTraceResult{res_n}.data = true_attitude*180/pi ;   % תΪ�Ƕȵ�λ
trueTraceResult{res_n}.name = 'attitude(��)';
trueTraceResult{res_n}.comment = '��̬';
trueTraceResult{res_n}.subName = {'����','���','����'};

res_n = res_n+1;
trueTraceResult{res_n}.data = true_velocity;
trueTraceResult{res_n}.name = 'velocity(m��s)';
trueTraceResult{res_n}.comment = '�ٶ�';

if exist('acc_r','var')
    res_n = res_n+1;
    trueTraceResult{res_n}.data = acc_r;
    trueTraceResult{res_n}.name =  'acc_r(m��s^2)';
    trueTraceResult{res_n}.comment = '���ٶ�';
end
trueTraceResult = trueTraceResult(1:res_n) ;