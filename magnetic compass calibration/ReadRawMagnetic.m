%%  xyz  2015.6.4

%% �� �´� �����̱궨��������ԭʼ����������
% ԭʼ���ݣ�  RawMagnetic.mat �� ��λ 0.15 uT
% �궨��Ĵ��������ݣ� CalibedMagnetic�� ��λ 1

function ReadRawMagnetic(  )


dataName = { '5Cleared_raw_data_calibrate','3_raw_data_calibrate','new_raw_data_calibrate' };
dataName = {'1clean_raw_data_calibrate','2clean_raw_data_calibrate'};
dataFolder = 'E:\data_xyz\magneticData\magnetic_raw_6.4';
dataFolder = 'E:\data_xyz\magneticData\magnetic_raw_6.4_B';

N = length( dataName );
for k=1:N
    RawMagnetic = importdata( [ dataFolder,'\',dataName{k},'.txt' ] );
    save( [ dataFolder,'\',dataName{k},'.mat' ],'RawMagnetic' );
end

