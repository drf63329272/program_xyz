//		2015 7 14  Noitom xyz
//		���η�������

#pragma once

/*���η�������*/
class CWaveThresholdPS
{
public:
	CWaveThresholdPS();
	CWaveThresholdPS(char DataFlag);
	~CWaveThresholdPS();

	// ���岨���ж��ӳ�ʱ�䣨�����ٶ�б�ʼ������䣬ȡԽ���ٶ�б�ʵĶ�ƽ���̶�Խ�󣬲����ֵ���ֵҲԽС��
	float m_adjacentT;
	// ����/���� data_V ��б�ʣ���data�ļ��ٶȣ���Сֵ
	float m_waveThreshold_Min_dataA;
	// ���岨�ȴ� abs(data) ��Сֵ
	float m_MinWaveData;
	// �ٶȼ���Ĳ���ʱ��
	float m_dT_CalV;
	// ����xy�ٶȷ���Ҫ�����Сxy�ٶ�ģֵ
	float m_MinXYVNorm_CalAngle;
	// 100% ��ǿ��ʱ�� data ��Χ
	float m_FullWaveDataScope;

private:

};

CWaveThresholdPS::CWaveThresholdPS()
{}
CWaveThresholdPS::CWaveThresholdPS(char DataFlag)
{
	switch (DataFlag)
	{
	case 'I':
		m_adjacentT = 0.15;
		m_waveThreshold_Min_dataA = 6;
		m_MinWaveData = 0.1;
		m_dT_CalV = 0.1;
		m_MinXYVNorm_CalAngle = 0.5;
		m_FullWaveDataScope = 1;
		break;

	case 'V':
		m_adjacentT = 0.15;
		m_waveThreshold_Min_dataA = 15;
		m_MinWaveData = 0.4;
		m_dT_CalV = 0.1;
		m_MinXYVNorm_CalAngle = 2;
		m_FullWaveDataScope = 5;
		break;

	default:
		break;
	}
}

CWaveThresholdPS::~CWaveThresholdPS()
{
}