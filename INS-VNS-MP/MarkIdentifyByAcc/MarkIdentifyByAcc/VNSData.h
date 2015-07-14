// 2015.7.13  Noitom  xyz
// Optitract �� OtherMarker ����

#pragma once
#include <iostream>
#include "Marker_t.h"
#include "MarkerTrackPS.h"

class CVNSData
{
public:
	CVNSData(double m_MaxLengthT);
	~CVNSData();

	
	double m_frequency;		// Ƶ�� HZ

	/*�洢����ʱ�̵���˵���Ϣ*/
	std::deque<CMarker_t, Eigen::aligned_allocator<CMarker_t>> m_Marker;	

	void ReadOtherMarkersTxt(const char* FilePath, int MaxReadT);	/// �����ݶ�ȡ����1����txt�ļ��ж� OtherMarkers ����ʱ������
	void UpdateOneInstant(double time_t, double MarkerN_t, 
		double* Position_tP, double INSfrequency);			/// �����ݶ�ȡ����2������һ��ʱ�̵��Ӿ�����
	void ContinuesJudge_t(CMarkerTrackPS* MarkerTrackPS);	/// ����һ��ʱ�̵��������ж�
private:
	unsigned int m_MaxLengthN;
	unsigned int m_TxtDataL;	// ��ȡ��txt�ļ������ݳ��ȣ������Ѿ������Ĳ��֣�

	void UpdateFre();
};

