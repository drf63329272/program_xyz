//		2015 7 14  Noitom xyz
//		�����Ӿ���ز������� �����һ������

#pragma once
#include "WaveThresholdPS.h"
#include "MarkerTrackPS.h"

class CIV_ParametersSet
{
public:
	CIV_ParametersSet();
	~CIV_ParametersSet();
	void UpdateVnsFre(float VnsFrequency);


	CWaveThresholdPS *m_pWaveThreshold_I, *m_pWaveThreshold_V;
	CMarkerTrackPS *m_pMarkerTrackPS;

	float m_VnsFrequency;

private:

};

void CIV_ParametersSet::UpdateVnsFre(float VnsFrequency)
{
	m_VnsFrequency = VnsFrequency;
	m_pMarkerTrackPS->UpdateFre(VnsFrequency); // �����Ӿ�Ƶ��
}

CIV_ParametersSet::CIV_ParametersSet( ):
m_VnsFrequency(120)	// Ĭ��ֵ
{

	m_pWaveThreshold_I = new CWaveThresholdPS('I');
	m_pWaveThreshold_V = new CWaveThresholdPS('V');
	m_pMarkerTrackPS = new CMarkerTrackPS();
}

CIV_ParametersSet::~CIV_ParametersSet()
{
	delete(m_pWaveThreshold_I);
	delete(m_pWaveThreshold_V);
	delete(m_pMarkerTrackPS);
}









