// 2015.7.10  Noitom xyz  
// �����������
#include "stdafx.h"
#include "INSData.h"
#include <fstream>
//#include <stdlib.h>
//#include <stdio.h>
#include <iostream>

// m_MaxLengthT����󻺴�ʱ�� sec
INSData::INSData(double m_MaxLengthT, double frequency)
{
	m_frequency = frequency;
	m_CalData.clear();
	m_MaxLengthN = m_frequency * m_MaxLengthT;	// 10min
	m_TxtDataL = 0;
}

INSData::~INSData()
{
	m_CalData.clear();
}

/// <summary>
/// ��INSData�ж�ȡ��϶������ض��ؽڵ�ļ��ٶ�
/// <param name="deque_k">���ʱ���������б��׿�ʼ������ţ�0��ʾ��ͷ��������ݣ�</param>
/// <param name="INSJointAcc">������Թؽڵļ��ٶȵ�ַ</param>
/// <param name="INSJointN">INSJointAcc�Ĺؽ���</param>
/// <param name="INSJointOrder">������Թؽڵ����</param>
/// </summary>
void INSData::GenerateHybid(int deque_k, double *INSJointAcc, int INSJointN, int *INSJointOrder)
{
	if (deque_k < m_CalData.size())
	{
		CCalData& CalDataOut = m_CalData.at(deque_k);
		CalDataOut.GenerateHybidAcc(INSJointAcc, INSJointN, INSJointOrder);
	}
	

}

/// <summary>
/// ��txt�ļ��ж��м�����
/// <param name="CalFilePath">�м�����·��</param>
/// <param name="MaxReadT">����ȡʱ�䳤��</param>
/// </summary>
void INSData::ReadCalData(const char* CalFilePath, int MaxReadT)
{
	using namespace std;

	char buffer[5000];		// ��һ���ַ�
	int bufferByte;			// һ���ַ����ֽ���
	double lineData[400];	// ��һ�е�����
	int lineN=0;		// �ַ����ȹ� �� ����������ͷ��
	int lineDataN;	// һ�е����ָ���  336+2
	
	ifstream CalFile(CalFilePath);
	CCalData CalData_k; // һ��ʱ�̵��м�����
	double time,fraction;

	if (!CalFile)
	{
		printf("failing open %s \n", CalFilePath);
	}
	while (!CalFile.eof())
	{
		memset(buffer, 0, sizeof(buffer));
		CalFile.getline(buffer, sizeof(buffer) / sizeof(char)-1);

		bufferByte = strlen(buffer);
		if (bufferByte > 2300)  // ���������� 2396
		{
			lineN++;
			if (lineN > 1) // Ϊ����
			{
				char* token = NULL;
				token = strtok(buffer, "\t");
				int i = 0;
				while (token) // ��һ��
				{
					lineData[i] = atof(token);
				//	printf("%0.3f ", lineData[i]);
					token = strtok(NULL, "\t");
					i++;
					lineDataN = i;
				}
				CalData_k.Update(lineData);		//�õ�һ��ʱ�̵Ľ��

				if (m_CalData.size() > m_MaxLengthN)
				{
					m_CalData.pop_front();		// ����̫�󣬵���ǰ�������
				}					
				m_CalData.push_back(CalData_k);	// ���µ��б�
				m_TxtDataL++;
				if (m_TxtDataL / m_frequency > MaxReadT)
					break;
				fraction = modf(m_TxtDataL / 1200.0, &time);
				time *= 10;
				if (fraction == 0.0 && time>0)
				{
					printf("%0.0f sec \n", time);
				}
			}
			
		}
	//	printf("\n");
	}

	printf("read calculation data %0.2f sec,Length = %d \n", m_TxtDataL / 120.0, m_TxtDataL);
}
/*
�м����ݵĴ洢˳��Ϊ��
01-X-x	01-X-y	01-X-z	01-V-x	01-V-y	01-V-z	01-Q-s	01-Q-x	01-Q-y	01-Q-z
	01-A-x	01-A-y	01-A-z	01-W-x	01-W-y	01-W-z
*/
void CJointCalData::Update(double JointCalDataArray[16])
{
	Matrix<double, 16, 1>JointVec(JointCalDataArray);
	X = JointVec.head(3);			// [0 1 2]
	V = JointVec.segment(3,3);		// [3 4 5]
	Q = JointVec.segment(6,4);		// [6 7 8 9]
	A = JointVec.segment(10,3);		// [10 11 12]
	W = JointVec.segment(13,3);		// [13 14 15]


//	Print();
}

void CJointCalData::Print()
{
	using namespace std;
	printf("X:");
	cout << endl << X << endl;
	printf("V:");
	cout << endl << V << endl;
	printf("Q:");
	cout << endl << Q << endl;
	printf("A:");
	cout << endl << A << endl;
	printf("W:");
	cout << endl << W << endl;
}

void CCalData::Update(double CalDataArray[336])
{
	for (int n = 0; n < 21; n++)
	{
		JointCals[n].Update(CalDataArray + 16 * n);
	}

}

/// <summary>
/// ���м����� ��ȡ ��϶����Ĺ߼��ٶ�����
/// <param name="INSJointAcc">����ض����Լ��ٶȵ������������Ч�ڴ�ռ� double [3*INSJointN]</param>
/// <param name="INSJointN">�ؽڸ���</param>
/// <param name="INSJointOrder">��װ��˵�Ĺ��Թؽڵ㣬���м������е����</param>
/// </summary>
void CCalData::GenerateHybidAcc(double *INSJointAcc, const int INSJointN, int *INSJointOrder)
{
	Vector3d V_i;
	double *Pdata_i;
	for (int i = 0; i < INSJointN; i++)
	{
		V_i = JointCals[INSJointOrder[i]].A;
		Pdata_i = JointCals[INSJointOrder[i]].A.data();
		INSJointAcc[0+i*3] = Pdata_i[0];
		INSJointAcc[1 + i * 3] = Pdata_i[1];
		INSJointAcc[2 + i * 3] = Pdata_i[2];
	}

}