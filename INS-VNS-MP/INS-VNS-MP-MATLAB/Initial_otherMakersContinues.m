%% ��ʼ�� otherMakersContinues
%  otherMakersContinues ���洢��ǰ���µ������߶Σ������뵱ǰ�ġ�otherMakers(k).Position������һ��
% otherMakersContinues.data_i [*N]  (1:3,:)��λ�ã�(4:8,:)���ٶȣ�(9:13,:)�Ǽ��ٶȣ�
    %  AWave = data_i( 14:27,: ); 
        %  (14:16,:)�Ǽ��ٶȲ��β��� VNSA_WaveFlag�� (17:21,:) ��VNSA_V��
        % (22:24,:)��VNSA_Acc_waveFront��(25:27,:) ��VNSA_Acc_waveBack
function otherMakersContinues = Initial_otherMakersContinues( visualN )

otherMakersContinues = struct;      % ���10�����10sec����������
otherMakersContinues.otherMakersN = 0;
M = 27;
otherMakersContinues.dataN = zeros(M,20);  % dataN( m,i_marker ) ��ʾ�� i_marker ����˵�ĵ� m ������ ����Ч����


otherMakersContinues.data1 = NaN( M,visualN );
otherMakersContinues.data2 = NaN( M,visualN );
otherMakersContinues.data3 = NaN( M,visualN );
otherMakersContinues.data4 = NaN( M,visualN );
otherMakersContinues.data5 = NaN( M,visualN );
otherMakersContinues.data6 = NaN( M,visualN );
otherMakersContinues.data7 = NaN( M,visualN );
otherMakersContinues.data8 = NaN( M,visualN );
otherMakersContinues.data9 = NaN( M,visualN );
otherMakersContinues.data10 = NaN( M,visualN );
otherMakersContinues.data11 = NaN( M,visualN );
otherMakersContinues.data12 = NaN( M,visualN );
otherMakersContinues.data13 = NaN( M,visualN );
otherMakersContinues.data14 = NaN( M,visualN );
otherMakersContinues.data15 = NaN( M,visualN );
otherMakersContinues.data16 = NaN( M,visualN );
otherMakersContinues.data17 = NaN( M,visualN );
otherMakersContinues.data18 = NaN( M,visualN );
otherMakersContinues.data19 = NaN( M,visualN );
otherMakersContinues.data20 = NaN( M,visualN );