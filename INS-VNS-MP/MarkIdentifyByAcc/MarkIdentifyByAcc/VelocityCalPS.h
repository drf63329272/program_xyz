// 2015 7.15  Noitom xyz
// �ٶȼ����������

#pragma once

class CVelocityCalPS
{
public:
	CVelocityCalPS();
	~CVelocityCalPS();

	float dT_VnsV;		// �����Ӿ� �ٶ� �õ�ʱ�䲽�� sec
	float dT_VnsA;		// �����Ӿ� ���ٶ� �õ�ʱ�䲽�� sec
	float dT_VnsA_V;	// �����Ӿ� ���ٶȵ��ٶ� �õ�ʱ�䲽�� sec

	float dT_InsA_V;	// ������� ���ٶȵ��ٶ� �õ�ʱ�䲽�� sec

	int VCalMethod;
	
private:

};

