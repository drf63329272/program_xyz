
%% otherMakersContinues  �� Initial_otherMakersContinues
% otherMakersContinues.data_i [*N]  (1:3,:)��λ�ã�(4:8,:)���ٶȣ�(9:13,:)�Ǽ��ٶȣ�
    %  AWave = data_i( 14:27,: ); 
        %  (14:16,:)�Ǽ��ٶȲ��β��� VNSA_WaveFlag�� (17:21,:) ��VNSA_V��
        % (22:24,:)��VNSA_Acc_waveFront��(25:27,:) ��VNSA_Acc_waveBack
%% �� �� i_marker ����˵�������߶�д�� otherMakersContinues
        
% dataWrite�� ��д�������
% dataN_i_j: [1,1] �� [3,1]  �� i_marker ����˵� ��dataWrite ���ݵ���Ч���ȡ�dataN(1,i_marker)�ǵ�ǰ��i��˵��λ��
% dataFlag�� dataWrite ����������
function otherMakersContinues = Write_otherMakersContinues_i...
    ( otherMakersContinues,i_marker,dataWrite,dataFlag,dataN_i_j )

switch dataFlag
    case 0  % dataWrite  Ϊ data_i
        data_i  = dataWrite;
    case {1,2,3,4} % dataWrite Ϊ ConPosition_i   
        
        data_i = Read_otherMakersContinues_i( otherMakersContinues,i_marker );        
        % ��������
        switch dataFlag
            case 1
                M1 = 1;        % ConPosition_i
                M2 = 3; 
                %  ���� dataN
                otherMakersContinues.dataN(M1:M2,i_marker) = repmat(dataN_i_j,3,1) ;
            case 2
                M1 = 4;        % ConVelocity_i
                M2 = 8; 
                %  ���� dataN
                otherMakersContinues.dataN(M1:M2,i_marker) = repmat(dataN_i_j,5,1) ;
            case 3
                M1 = 9;        % ConAcc_i
                M2 = 13; 
                %  ���� dataN
                otherMakersContinues.dataN(M1:M2,i_marker) = repmat(dataN_i_j,5,1) ;
            case 4
                M1 = 14;        % ConAccWaveFlag_i
                M2 = 27; 
                %  ���� dataN
                otherMakersContinues.dataN(14:16,i_marker) = dataN_i_j ;
                otherMakersContinues.dataN(17:27,i_marker) = repmat(max(dataN_i_j),11,1)  ;
                
           	otherwise
                disp('error-1 in Write_otherMakersContinues_i');
                otherMakersContinues = NaN;
                return;
        end
        
        %  ���� data_i
        data_i( M1:M2,1:size(dataWrite,2) ) = dataWrite;  
    otherwise
        disp('error-2 in Write_otherMakersContinues_i');
        otherMakersContinues = NaN;
        return;
end

switch i_marker
    case 1
        otherMakersContinues.data1 = data_i;
    case 2
        otherMakersContinues.data2 = data_i;
    case 3
        otherMakersContinues.data3 = data_i;
	case 4
        otherMakersContinues.data4 = data_i;
    case 5
        otherMakersContinues.data5 = data_i;
    case 6
        otherMakersContinues.data6 = data_i;
	case 7
        otherMakersContinues.data7 = data_i;
    case 8
        otherMakersContinues.data8 = data_i;
    case 9
        otherMakersContinues.data9 = data_i;
	case 10
        otherMakersContinues.data10 = data_i;
    case 11
        otherMakersContinues.data11 = data_i;
    case 12
        otherMakersContinues.data12 = data_i;
    case 13
        otherMakersContinues.data13 = data_i;
	case 14
        otherMakersContinues.data14 = data_i;
    case 15
        otherMakersContinues.data15 = data_i;
    case 16
        otherMakersContinues.data16 = data_i;
	case 17
        otherMakersContinues.data17 = data_i;
    case 18
        otherMakersContinues.data18 = data_i;
    case 19
        otherMakersContinues.data19 = data_i;
	case 20
        otherMakersContinues.data20 = data_i;
    otherwise
        otherMakersContinues.data1 = data_i;
end