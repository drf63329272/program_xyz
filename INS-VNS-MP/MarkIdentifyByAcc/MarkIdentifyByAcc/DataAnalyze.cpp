// 2015 7 15	Noitom	xyz
// ���ݷ�������

#include "stdafx.h"
#include"DataAnalyze.h"
#include "Eigen\Dense"

using namespace Eigen;


CDataAnalyze::CDataAnalyze()
{
}

CDataAnalyze ::~CDataAnalyze()
{
}

/*
��������һ��ʱ�̵��ٶ�
*/
void CDataAnalyze::CalVelocity3D_t
(Matrix3Xd *X, Matrix3Xd *V, float fre, float dT, int VCalMethod)
{
	int dN = roundf(dT*fre);
	int t_X = X->cols()-1;		// ���µ�X֡������ 0 ��
	int t_CalV = V->cols() - 1 + 1;	// ֻ�����������ٶ�
	int t_Front = t_CalV - dN;	// ��Ҫ�õ�����������
	int t_Back = t_CalV + dN;	// ��Ҫ�õ������µ�����
	

	Vector3d Velocity_t;
	
	if (t_Front < 0 && t_Back > t_X)
	{
		return;
	}

	if (t_Front < 0 && t_Back <= t_X)	// ��������ݹ���
	{
			printf("����.��Ϊ%d��Ӧ��Ϊ%d (in CalVelocity3D_t) \n", V->cols(), t_CalV);
			if (V->cols() != t_CalV)
				printf("��������.��Ϊ%d��Ӧ��Ϊ%d (in CalVelocity3D_t) \n",V->cols(),t_CalV);
			V->conservativeResize(3, t_CalV + 1);
			Velocity_t.setConstant(NAN);
			V->col(t_CalV) = Velocity_t;
		return;					//���ݲ���
	}
		
	
	Vector3d XFront, XBack;
	switch (VCalMethod)
	{
	case 1:
		XFront = X->col(t_Front);
		XBack = X->col(t_X);
		break;
	case 2:
		XBack = X->middleCols(t_Front,dN).rowwise().mean();	// ȡǰ��һ��ʱ��ľ�ֵ
		XBack = X->rightCols(dN).rowwise().mean();
		break;
	default:
		XFront = X->col(t_Front);
		XBack = X->col(t_X);
		break;
	}

	Velocity_t = (XBack - XFront) / (dT*2);

	// �����ٶȵ�����
	if (V->cols() != t_CalV)
		printf("�ٶȵ���������(in CalVelocity3D_t) \n");
	V->conservativeResize(3, t_CalV + 1);
	V->col(t_CalV) = Velocity_t;	// �ٶ�

}



