// MarkIdentifyByAcc.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include "INSData.h"
//#include "INSData_Hybid.h"
#include "VNSData.h"
#include "ParametersSetGroup.h"

void Test();

int _tmain(int argc, _TCHAR* argv[])
{
	//Test();

	int MaxReadT = 5;
	// Read optitrack data
	double MaxLengthT = 10 * 60;  // ��󻺴�ʱ�� sec
	CVNSData VNSData0(MaxLengthT);

	const char *OptFilePath = "E:\\data_xyz\\Hybrid Motion Capture Data\\7.2 dataB\\T2\\Opt.txt";
	VNSData0.ReadOtherMarkersTxt(OptFilePath, MaxReadT);


	// read calcualtion data
	const char *CalFilePath1 = "E:\\data_xyz\\Hybrid Motion Capture Data\\7.2 dataB\\T2\\CalData0.txt";
	const char *CalFilePath2 = "E:\\data_xyz\\Hybrid Motion Capture Data\\7.2 dataB\\T2\\CalData1.txt";

	double INSfrequency = 120;
	INSData INSData1(MaxLengthT,INSfrequency);
	INSData1.ReadCalData(CalFilePath1, MaxReadT);
	INSData INSData2(MaxLengthT,INSfrequency);
	INSData2.ReadCalData(CalFilePath2, MaxReadT);
	
	/// INS-VNS 
	double VnsFrequency = VNSData0.m_frequency;
	// extract INS acc from the calcualtion data
	const int INSJointN = 6;
	CINSData_Hybid INSData_Hybid(INSData1.m_frequency, INSJointN);

	CVNSData VNSData(MaxLengthT);	
	
	double INSJointAcc_t[3 * INSJointN];
	memset(INSJointAcc_t, 0, sizeof(INSJointAcc_t));
	int INSJointOrder[3]={10,14,15}; // { RightHand,LeftHand,Head } { 171-173,235-237,251-253 } 
	 
	int INSDataNum = __min(INSData1.m_CalData.size(), INSData2.m_CalData.size());
	int vStart_t = 0, vEnd_t;

	for (int t = 0; t < INSDataNum; t++)
	{
		// ����һ��ʱ�̵Ĺ�������
		INSData1.GenerateHybid(t, INSJointAcc_t, INSJointN/2, INSJointOrder);
		INSData2.GenerateHybid(t, INSJointAcc_t + 3 * INSJointN/2, INSJointN / 2, INSJointOrder);
		INSData_Hybid.UpdateAcc(INSJointAcc_t, INSJointN);

		// ���¶�Ӧ���Ӿ�����
		vEnd_t = roundf((t + 1) / INSfrequency*VnsFrequency) ;		
		for (int vt = vStart_t; vt < vEnd_t; vt++)
		{
			 CMarker_t Marker_t =  VNSData0.m_Marker.at(vt);
			 double MarkerN_t = Marker_t.m_MarkerN;
			 double time_t = Marker_t.m_time;
			 Matrix3Xd Position_t = Marker_t.m_Position;
			 double* Position_tP = Position_t.data();

			 // ���������ݸ��µ��Ӿ��첶������
			 VNSData.UpdateOneInstant(time_t, MarkerN_t, Position_tP, INSfrequency);
			 
			 
		}
		vStart_t = vEnd_t;
	}

	VNSData.PrintfContinuesMarker(5);
	printf("\n end \n");
	getchar();
	return 0;
}



void Test()
{
	using namespace std;

	MatrixXd M;
	M.resize(3,3);
	M(1, 1) = 2;
	cout << endl << M << endl;
	M.resize(2,6);
	M(1, 5) = 12;
	cout << endl << M << endl;
}

