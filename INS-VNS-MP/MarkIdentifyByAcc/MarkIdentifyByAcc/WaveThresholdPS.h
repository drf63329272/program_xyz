//		2015 7 14  Noitom xyz
//		���η�������

#pragma once

enum DataType 
{
	DT_INS,
	DT_VNS
};

/*���η�������*/
class CWaveThresholdPS
{
public:

	CWaveThresholdPS();
	void SetData(DataType DataFlag);
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
	DataType dataFlag;
private:

};

