// 2015.7.14	Noitom	xyz
// ��˵������Է�����ʶ�𡢸��� ��ز�������

#include "stdafx.h"
#include "MarkerTrackPS.h"

CMarkerTrackPS::CMarkerTrackPS()
{
	m_frequency = 120;	// Ĭ��Ƶ��
	SetData();
}


void CMarkerTrackPS::UpdateFre(float VnsFrequency)
{
	m_frequency = VnsFrequency;
	SetData();
}


void CMarkerTrackPS::SetData()
{
	m_MaxMoveSpeed = 6; // m / s  ��˵��˶����������ٶȣ���������ٶ�����Ϊ������
	m_MaxContinuesDisplacement = m_MaxMoveSpeed / m_frequency;
}

CMarkerTrackPS::~CMarkerTrackPS()
{
}

