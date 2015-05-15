%% 2015.4.23


 %% ƽ�����ɸĽ�Ϊʵʱ���У�
 % Ŀ�ģ���������������һ�ξ�ֹʱ�����JudgeData�Ĳ���������β�ƽ
 % ˼·��1�� ��ʱ���Ϊ��λ����ƽ����ר���������������ν���ƽ����1>ǰ����� ����stepN/4 ��1���ŵ�0ʱ���  2>0ʱ���ʱ�䳤��С�� stepN
 %       2�������ʱ�������ĳ��ָ��ʱ����Ϊ���ʱ����ھ�Ϊ 1������������д���
 % ָ�꣺����ж�����γ���Ϊ M ������һ����������Ϊ�Ǿ�ֹ״̬������Ϊ1
 %  1������ǰ M ��Ϊ1
 %  2�������M��Ϊ1
 %  3������1����2������ΪOK���������������������4���ж�
 %  4��������ǰ2M+����+�����M�����г��� 70% Ϊ1  
 %  5)  �����M����50%Ϊ1
 %  ����4����5�� ����Ϊ ������ ��Ϊ1
 %%
 % JudgeData�� [1*N]  ����Ϊ1��������Ϊ0
 % stepN :�ƽ������
function JudgeData = SmoothJudgeData( JudgeData,stepN,SmoothRate )
Nframes = length(JudgeData) ;
stepN = max(stepN,4);
clipN = max(fix(stepN/6),2);     % ��Ч�����ж�������С����1�ĸ���

if SmoothRate>0.75
    SmoothRate = 0.74;  % ���0.75
elseif SmoothRate<0.6
    SmoothRate = 0.6;
end

fillNum = 0;
%% ʵʱ������ƽ�������� NeedSmoothWin

winStart = 0;
for k=clipN+1:Nframes-clipN+1
    % ��¼���е�0�������䣬�����䳤��<=stepNʱ������ϸ�ж�
    if JudgeData(k)==0
        if JudgeData(k-1) == 1
            if sum(JudgeData(k-clipN:k-1))==clipN   % ǰ clipN ����Ϊ1
                %% 1...1->0 
                winStart = k;   % ��¼0�������ʼλ
            end
        end
    else
        if JudgeData(k-1) == 0
            if sum(JudgeData(k:k+clipN-1))==clipN   % �� clipN ����Ϊ1
                %% 0...0->1 
                if winStart==0 
                    continue;       % ��һ�����ҵ� 0...0->1 ����
                end
                winEnd = k-1;   % ��¼0����Ľ���λ
                M = winEnd-winStart+1 ;
                if M < stepN                
                   %% ����һ����Ч�Ĵ�ƽ������ 
                   IsDoSmooth = 0;
                    % 1������ǰ M ��Ϊ1
                    if sum( JudgeData(winStart-M:winStart-1) )==M && sum( JudgeData(winEnd+1:winEnd+M) )==M
                       %%% �ж��������OK������Ϊ1  (��)
                       IsDoSmooth = 1;
                    elseif winStart-M*2+1>1 && winEnd+M<Nframes
                        if sum( JudgeData(winStart-M*2+1:winEnd+M) ) >= M*3*SmoothRate && sum( JudgeData(winEnd+1:winEnd+M) )>=M*0.5
                            %%% �ж��������OK������Ϊ1  (����)
                            IsDoSmooth = 1;
                        end
                    end
                    %%% �ж��������OK������Ϊ1
                    if IsDoSmooth == 1
                        JudgeData(winStart:winEnd) = 1 ;
                        fillNum = fillNum + M;
                    end
                end
            end
        end
    end
end


% display( sprintf('fillNum = %0.0f',fillNum) );
