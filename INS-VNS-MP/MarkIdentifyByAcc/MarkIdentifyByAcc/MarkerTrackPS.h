// 2015.7.14	Noitom	xyz
// ��˵������Է�����ʶ�𡢸��� ��ز�������

#pragma once

class CMarkerTrackPS
{
public:
	CMarkerTrackPS();
	~CMarkerTrackPS();
	void UpdateFre(float VnsFrequency);
	void SetData();

	float m_frequency;	// Ƶ�� HZ
	float m_MaxMoveSpeed;	// ����ƶ��ٶ� m/s
	float m_MaxContinuesDisplacement;	// ������˵� ��֡���λ��

private:

};

