// 2015.7.13  Noitom  xyz
// Optitract �� OtherMarker ����

#pragma once
#include <iostream>
#include "Marker_t.h"
#include "MarkerTrackPS.h"
#include "VelocityCalPS.h"
#include "WaveThresholdPS.h"
#include "DataAnalyze.h"

#define MaxMarkN 10
typedef Matrix<double, 5, -1, 0, 5, -1> Matrix5Xd;

class CVNSData
{
public:
	CVNSData(double m_MaxLengthT);
	~CVNSData();

	CVelocityCalPS m_VelocityCalPS;
	CMarkerTrackPS m_MarkerTrackPS;
	CWaveThresholdPS m_WaveThresholdPS;

	double m_frequency;		// Ƶ�� HZ

	/*�洢����ʱ�̵���˵���Ϣ*/
	std::deque<CMarker_t, Eigen::aligned_allocator<CMarker_t>> m_Marker;	
	/* 
	m_Marker �б������µ�������˵�λ�����ߣ�һ��VectorXd*ָ���Ӧһ����˵��������ߣ�
	ÿ�� *m_pContinuesMarkerP �ĳ��ȶ�Ӧ�������ߵĳ��ȣ�1����Ҳ��¼��
	*/
	Matrix3Xd m_ContinuesMarkerP[MaxMarkN];	// ���洢30����˵��Ӧ�����ߵ�ַ,һ��һ����
	Matrix3Xd m_ContinuesMarkerV[MaxMarkN];	//�ٶ�
	Matrix3Xd m_ContinuesMarkerA[MaxMarkN];	//���ٶ�

	CDataAnalyze DataAnalyze;

	void ReadOtherMarkersTxt(const char* FilePath, int MaxReadT);	/// �����ݶ�ȡ����1����txt�ļ��ж� OtherMarkers ����ʱ������
	void UpdateOneInstant(double time_t, double MarkerN_t, 
		double* Position_tP, double INSfrequency);			/// �����ݶ�ȡ����2������һ��ʱ�̵��Ӿ�����
	void ContinuesJudge_t();	/// ����һ��ʱ�̵��������ж�
	
	unsigned int GetLastMarkerN();
	void PrintfContinuesMarker(int rightColsMax);
						//   ��λ�ü����ٶȺͼ��ٶ� ������һ��ʱ�̣�

private:
	unsigned int m_MaxLengthN;
	unsigned int m_TxtDataL;	// ��ȡ��txt�ļ������ݳ��ȣ������Ѿ������Ĳ��֣�

	void UpdateFre();

	void UpdateContinuesMarker();
	void UpdateVA();
};

