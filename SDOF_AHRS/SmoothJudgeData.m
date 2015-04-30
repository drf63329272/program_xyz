%% 2015.4.23


 %% ƽ��
 % JudgeData�� [1*N]
 % stepN :ƽ������
% 1001 -> 1111
% ���ڣ� ǰ�� stepN �� ���� stepN/3 ��
% �������У�
% 1����βminNum����1�� 2�������е�1��������һ��(SmoothRate)����Ϊ��һ�ξ�Ϊ1
function JudgeData = SmoothJudgeData( JudgeData,stepN,SmoothRate )
Nframes = length(JudgeData) ;
stepN = max(stepN,4);
minNum = fix(stepN/8) ;  % ��β minNum ��Ҫ����1
minNum = max( minNum,1 );
fillNum = 0;

for k=1:Nframes-stepN+1
    end_k = k+stepN-1 ;
    sumHead = sum( JudgeData( k:k+minNum-1 ) );
    sumEnd = sum( JudgeData( end_k-minNum+1:end_k ) );
    if sumHead == minNum && sumEnd == minNum   % ��β��1
        staticSum = sum( JudgeData( k:end_k ) );
        if staticSum>=stepN*SmoothRate       % �����е�1��������һ��
            JudgeData( k:end_k ) = ones( stepN,1 );
            fillNum = fillNum + stepN - staticSum ;
        end 
    end
end
% display( sprintf('fillNum = %0.0f',fillNum) );



