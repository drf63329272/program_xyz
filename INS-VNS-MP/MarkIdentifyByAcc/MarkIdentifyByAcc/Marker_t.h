// 2015.7.13  Noitom  xyz
// һ��ʱ����˵�����

#pragma once
#include <Eigen/Dense>
#include <Eigen/StdDeque>

using namespace Eigen;
class CMarker_t
{
public:
	CMarker_t(int MarkerN);
	~CMarker_t();
	void UpdatePosition(double* PositionP, int MarkerN);	/// ����һ��ʱ�̵���˵�λ��
	void UpdateMappingInertialK(double frequency, double INSfrequency); // ���� �Ӿ���ӳ������������
	void CoordinateChange();	/// �Ӿ�λ������ϵת��Ϊ����������ϵ
	void SetUnContinues();		//  �������е�Ϊ������

	int m_MarkerN;			// ��˵����
	Matrix3Xd m_Position;	// ��˵��λ�� m��һ�б�ʾһ����
	double m_time;			// �� Optitrack ��ʼ�ϵ� ��ʱ��

	int m_MappingInertial_t;	// ����Ӿ�ʱ�̶�Ӧ�Ĺ�������ʱ����ţ�0��Ӧ0��
	Vector3d m_MappingInertial_i;// ��˵�ʶ��������Ӧ�Ĺ��Խڵ����

	// ��������Ϣ
	VectorXi m_ContinuesNum;	// ÿ�����Ӧ���������߳��ȡ�NAN��δ�жϡ�1����������n����������n��
	// ������������ʱ����˵� �� ��ʱ��������˵㼯�е����
	// ����ǰʱ�̵���˵� ����ʱ�̲�����������˵�ʱ��Ϊ NAN������ʱΪ 0 1 2 ...
	VectorXi m_ContinuesLasti;

	EIGEN_MAKE_ALIGNED_OPERATOR_NEW
private:

};