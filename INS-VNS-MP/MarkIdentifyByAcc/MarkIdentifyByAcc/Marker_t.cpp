// 2015.7.13  Noitom  xyz
// һ��ʱ����˵�����
#include "stdafx.h"
#include "Marker_t.h"

CMarker_t::CMarker_t(int MarkerN) :
m_MarkerN(MarkerN),
m_time(NAN),
m_MappingInertial_t(NAN)
{
	if (m_MarkerN<1 || m_MarkerN>10000)
	{
		printf("m_MarkerN ���� (in CMarker_t) \n");
		return;
	}
	m_Position.resize(3, m_MarkerN);
	m_Position.setConstant(NAN);
	m_MappingInertial_i.setConstant(NAN);
	m_ContinuesNum.resize(m_MarkerN, 1);
	m_ContinuesNum.setConstant(NAN);
	m_ContinuesLasti.resize(m_MarkerN, 1);
	m_ContinuesLasti.setConstant(NAN);
}


CMarker_t::~CMarker_t()
{
}

/// <summary>
/// ����һ��ʱ�̵���˵�λ��
/// <param name="PositionP">��˵�λ�� double[3*MarkerN]</param>
/// <param name="MarkerN">��˵����</param>
/// </summary>
void CMarker_t::UpdatePosition(double* PositionP, int MarkerN)
{
	m_MarkerN = MarkerN;
	m_Position = Map<Matrix3Xd, 0>(PositionP, 3, MarkerN);
	//	std::cout << std::endl << m_Position << std::endl;
	CoordinateChange();
	//	std::cout << std::endl << m_Position << std::endl;
}

// ���� �Ӿ���ӳ������������
void CMarker_t::UpdateMappingInertialK(double time0, double INSfrequency)
{
	double timeValid = m_time - time0;  // �Ӽ�¼���ݿ�ʼ����Чʱ�䣨�� 0 ��ʼ��
	m_MappingInertial_t = roundf(timeValid*INSfrequency);
}

/// �Ӿ�λ������ϵת��Ϊ����������ϵ
// 1�����Ӿ�����  ���Ӿ���������ϵ(v) ת�� ����������ϵ��r��
// �����泯��Ϊ0���򣬱����� Ϊ ָ�򶫵� �˵ġ���ǰ�¡�����ϵ
// r1�� �˵ġ���ǰ�¡�����ϵ���뱱����ֻ����
void  CMarker_t::CoordinateChange()
{
	Matrix3d Cv_r, Cv_r1;
	Cv_r1 << 0, 0, 1,
		-1, 0, 0,
		0, -1, 0;
	Cv_r = Cv_r1;		// Ҫ���Ӿ���������ϵ�궨ʱ����
	m_Position = Cv_r * m_Position;
}

// ���õ�m����Ϊ������
void CMarker_t::SetUnContinues(  )		
{
	for (int m = 0; m < m_MarkerN; m++)
	{
		m_ContinuesLasti(m) = NAN;
		m_ContinuesNum(m) = 0;	// ������
	}
}


