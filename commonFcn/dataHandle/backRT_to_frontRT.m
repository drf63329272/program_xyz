%% �� �ں�һʱ�̷ֽ�� RT �� ��ǰһʱ�̷ֽ�� RT 

function visualRbbTbb = backRT_to_frontRT(visualInputData,savePath)

VisualRT = visualInputData.VisualRT ;
Rbb = VisualRT.Rbb;
Tbb = VisualRT.Tbb; % ��һʱ�̷ֽ��
trueTbb = VisualRT.trueTbb ;
trueRbb = VisualRT.trueRbb;

Tbb_front = zeros(size(Tbb));
trueTbb_front = zeros(size(trueTbb));

for k=1:length(Tbb)
    Tbb_front(:,k) = Rbb(:,:,k)'*Tbb(:,k) ;
    trueTbb_front(:,k) = trueRbb(:,:,k)'*trueTbb(:,k) ;
end

visualRbbTbb = VisualRT ;
visualRbbTbb.Tbb_front = Tbb_front ;
visualRbbTbb.trueTbb_front = trueTbb_front ;
visualRbbTbb.frequency = visualInputData.frequency ;

save visualRbbTbb visualRbbTbb
save([savePath,'\visualRbbTbb.mat'],'visualRbbTbb')
