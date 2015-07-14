// 2015.7.9 xyz NOITOM
#include "stdafx.h"
#include "INSData_Hybid.h"
#include <iostream>
/*
JointN�� ʵ������Ĺ��Թؽڵ����
frequency���������ݵ�Ƶ��
*/
CINSData_Hybid::CINSData_Hybid(double frequency, int JointN)
{
	if (JointN > MaxJointN)
	{
		printf("input joint num is to large");
		return;
	}
	m_frequency = frequency;
	m_JointN = JointN;
	Acc.clear();
	m_BufferN = m_frequency*m_BufferTime;
}

/*
���� һ��ʱ�� ���йؽڵ�ļ��ٶ�
Acc_k_Arry����˳��洢���йؽڵļ��ٶ�
*/
void CINSData_Hybid::UpdateAcc(double* Acc_k_Arry, int JointN)
{
	AllJoints_k Acc_k;  
	Acc_k = Map<AllJoints_k>(Acc_k_Arry);

	if (Acc.size()>m_BufferN)
	{
		Acc.pop_front();	// ���ƻ����С
	}
	Acc.push_back(Acc_k);

//	std::cout << endl << Acc_k << endl;
}

CINSData_Hybid::~CINSData_Hybid()
{
	Acc.clear();
}

