%% ����ʵ�켣������ʵ�� Tbb Rbb
% isTbb_last=1 : Tbb ����һʱ�̷ֽ⣬
% isTbb_last=0 : Tbb �ں�һʱ�̷ֽ�
function [ trueTbb,trueRbb  ] = GetTrueTbbRbb(trueTrace,visualFre,isTbb_last)
format long

position = trueTrace.position ;
attitude = trueTrace.attitude ;
trueFre = trueTrace.frequency;

if isempty(visualFre)
    answer = inputdlg('�Ӿ���ϢƵ��');
    visualFre = str2double(answer);
end
visualNum = fix( (length(position)-1)*visualFre/trueFre);
Rbb = zeros(3,3,visualNum);
Tbb = zeros(3,visualNum);
% ������ʵ�켣������ʵ Tbb Rbb
for k=1:visualNum
    k_true_last = 1+fix((k-1)*trueFre/visualFre) ;
    k_true = 1+fix((k)*trueFre/visualFre) ;
    if isTbb_last==1    % �õ� Tbb_last ����һʱ�̷ֽ�
        Tbb(:,k) = FCbn(attitude(:,k_true_last))' * ( position(:,k_true)-position(:,k_true_last) ) ;
        
    else                % �õ� Tbb �ں�һʱ�̷ֽ�
        Tbb(:,k) = FCbn(attitude(:,k_true))' * ( position(:,k_true)-position(:,k_true_last) ) ;
    end
    Rbb(:,:,k) =  FCbn(attitude(:,k_true))' * FCbn(attitude(:,k_true_last)) ;     % R:b(k)->b(k+1)

end
trueTbb = Tbb ;
trueRbb = Rbb;