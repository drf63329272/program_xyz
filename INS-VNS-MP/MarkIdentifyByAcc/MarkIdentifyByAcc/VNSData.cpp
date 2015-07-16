// 2015.7.13  Noitom  xyz
// Optitract �� OtherMarker ����

#include "stdafx.h"

#include "VNSData.h"
#include <fstream>
#include <iostream>
#include <valarray>

#define ISPRINT 1

using namespace std;

CVNSData::CVNSData(double MaxLengthT) :
m_frequency(120),	// Ԥ�Ȱ�������Ƶ�ʿ����ڴ�
m_TxtDataL(0)
{
	m_MaxLengthN = (int)MaxLengthT*m_frequency;
	m_Marker.clear();
	m_WaveThresholdPS.SetData(DT_VNS);
}

/// <summary>
/// ����һ��ʱ�̵��������ж�
/// �˺����и��£� MarkerCur.m_ContinuesLasti(m)   MarkerCur.m_ContinuesNum(m)
/// <param name="MarkerTrackPS">��˵����ݷ�����ز�������</param>
/// </summary>
void CVNSData::ContinuesJudge_t( )
{
	using namespace std;

	CMarker_t& MarkerCur = m_Marker.back();	// ��ǰ�� ��������������������Ϣ��
	unsigned int MarkerN = MarkerCur.m_MarkerN;
	if (m_Marker.size() < 2)	// ��һ��ʱ��
	{
		MarkerCur.SetUnContinues();
		UpdateContinuesMarker();
		return;
	}		
	
	CMarker_t& MarkerLast = m_Marker.at(m_Marker.size()-2);	// ǰʱ�̵�s  ��ע��Ҫ-2��
	unsigned int LastMarkerN = MarkerLast.m_MarkerN;
	
	if (LastMarkerN < 1 || MarkerN < 1)
	{
		MarkerCur.SetUnContinues();
		UpdateContinuesMarker();
		return;	// ��ʱ�� �� ��ǰʱ�� ����˵㣬�������
	}		
	Matrix3Xd& PositionCur = MarkerCur.m_Position;
	Matrix3Xd& PositionLast = MarkerLast.m_Position;
	Matrix3Xd PositionErr;		// ÿ����ǰ�� �� ����ǰʱ�̵�֮���λ�����
	PositionErr.resizeLike(PositionLast);
	VectorXd PositionErrNorm;	// PositionErr��ģ
	PositionErrNorm.resize(LastMarkerN);
	int indexMin[MaxMarkN];		// ��Ӧǰʱ����˵����
	double minErr[MaxMarkN];

	for (int m = 0; m < MarkerN; m++)
	{
		/// ������ǰ��m���� �� ��ʱ�����е�ĵ�λ�ò�		
		for (int n = 0; n < LastMarkerN; n++)
		{
			PositionErr.col(n) = PositionCur.col(m) - PositionLast.col(n);	
			PositionErrNorm(n) = PositionErr.col(n).norm();
		}
		
		minErr [m]= PositionErrNorm.minCoeff(&indexMin[m]);
		if (minErr[m] < m_MarkerTrackPS.m_MaxContinuesDisplacement)
		{
			// MarkerCur ��m���� �� MarkerLast ��indexMin��������
			MarkerCur.m_ContinuesLasti(m) = indexMin[m];
			// �������ȼ�1
			MarkerCur.m_ContinuesNum(m) = MarkerLast.m_ContinuesNum(indexMin[m]) + 1;

			// ��indexMin[m] ��֮ǰ�Ѿ�����⵽����ȡ�����һ��
			for (int j = 0; j < m; j++)
			{
				if (indexMin[m] == indexMin[j])
				{
					if (minErr[m] < minErr[j])
					{
						// ��ǰ����������������Ϊ�¿�ʼ
						MarkerCur.m_ContinuesLasti(j) = NAN;
						MarkerCur.m_ContinuesNum(j) = 1;
					}
					else
					{
						// ��ǰ���Զ����Ч����Ϊ�¿�ʼ
						MarkerCur.m_ContinuesLasti(m) = NAN;
						MarkerCur.m_ContinuesNum(m) = 1;
					}
				}
			}						
		}
		else
		{
			MarkerCur.m_ContinuesNum(m) = 1;	// �ж�Ϊ��������
		}
		
		// OUTPUT 
		
		//printf("Position");
		//cout << endl << PositionLast << endl << PositionCur<<endl;
		//printf("Position err");
		//std::cout << std::endl << PositionErr << std::endl << PositionErrNorm << std::endl;

		

	}
	//printf("Continues  %d  \n", m_Marker.size());
	//cout << MarkerCur.m_ContinuesNum << endl;
	//cout << MarkerCur.m_ContinuesLasti << endl;

	UpdateContinuesMarker();
}

/*
�������µ�������˵�����
m_ContinuesLasti��m�� ���������
	1�������ӵ� NAN		���½�һ������Ϊ1����
	2��0.1...���ֲ���	��m_pContinuesMarkerP(m)˳�򲻱�	��ԭ������1����
	3��0.1...��			��m_pContinuesMarkerP(m)˳���
m_pContinuesMarkerP[m] �豻���ǵ������
	
*/

void CVNSData::UpdateContinuesMarker()
{
	using namespace std;


	CMarker_t& MarkerCur = m_Marker.back();			// ���µ���˵�
	unsigned int m_MarkerN = MarkerCur.m_MarkerN;	// ���µ���˵����
	unsigned int m_LastMarkerN = GetLastMarkerN();	// ��ʱ����˵����
	
	VectorXi& ContinuesLastiCur = MarkerCur.m_ContinuesLasti;
	Matrix3Xd ContinuesMarkerP_Old[30];			
	for (int i = 0; i < m_MarkerN; i++)
	{
		int Lasti = ContinuesLastiCur(i);
		if (Lasti != (int)NAN && Lasti != i)	// ��������£�ǰʱ�̵����߻ᷢ��˳���������������
			ContinuesMarkerP_Old[i] = m_ContinuesMarkerP[i];
	}


	// ��ն�ʧ�ĵ�
	bool IsLost;
	for (int m = 0; m < m_LastMarkerN; m++)
	{
		IsLost = true;	// ǰʱ�̵�m�����Ƿ�ʧ
		for (int i = 0; i < m_MarkerN; i++)
		{
			if (ContinuesLastiCur(i) == m)
				IsLost = false;	// �� m ������ ContinuesLastiCur ��ʱ����ʾû�ж�ʧ
		}
		if (IsLost)
		{
			m_ContinuesMarkerP[m].resize(3,0);	// ����ʧ���������
			if (ISPRINT) printf("��%dʱ�̶�ʧǰʱ�̵�%d����\n", m_Marker.size(), m);
		}
	}
	// ���� m_ContinuesMarkerP ˳��
	for (int i = 0; i < m_MarkerN; i++)
	{
		int Lasti = ContinuesLastiCur(i);
		if (Lasti == (int)NAN)		// 1�������ӵ�
		{
			m_ContinuesMarkerP[i].resize(3,0);
			if (ISPRINT) printf("��%dʱ��������%d����\n", m_Marker.size(), i);
		}
		else if (Lasti!=i) 		   // 3��0.1...��
		{
			m_ContinuesMarkerP[i] = ContinuesMarkerP_Old[Lasti];
			if (ISPRINT) printf("��%dʱ��,ǰʱ�� %d ��Ϊ�� %d ����\n", m_Marker.size(), Lasti, i);
		//	cout << ContinuesLastiCur << endl;
		}
	}
	// �������ݣ�ÿ��������һ���㣩����������е��˳�������֮��
	for (int i = 0; i < m_MarkerN; i++)
	{
		// ����1��

		int new_cols = m_ContinuesMarkerP[i].cols() + 1;	// ������ʾ���������
		m_ContinuesMarkerP[i].conservativeResize(3, new_cols);
		m_ContinuesMarkerP[i].col(new_cols - 1) = MarkerCur.m_Position.col(i);		
	}

	//	PrintfContinuesMarker(5);

	UpdateVA();
}

// ��λ�ü����ٶȺͼ��ٶ� ������һ��ʱ�̣�
void CVNSData::UpdateVA()
{
	CMarker_t& MarkerCur = m_Marker.back();			// ���µ���˵�
	unsigned int MarkerN = MarkerCur.m_MarkerN;	// ���µ���˵����
	for (int m = 0; m < MarkerN; m++)
	{
		DataAnalyze.CalVelocity3D_t(&m_ContinuesMarkerP[m], &m_ContinuesMarkerV[m], m_frequency, m_VelocityCalPS.dT_VnsV, 1);
//		DataAnalyze.CalVelocity3D_t(&m_ContinuesMarkerV[m], &m_ContinuesMarkerA[m], m_frequency, m_VelocityCalPS.dT_VnsA, 1);

		if (m_ContinuesMarkerV[m].cols()>2)
		{
		
			printf("Vns P \n ");
			cout << endl << m_ContinuesMarkerP[m].rightCols(3) << endl;
			printf("Vns V \n ");
			cout << endl << m_ContinuesMarkerV[m].rightCols(3) << endl;
//			printf("Vns A \n ");
//			cout << endl << m_ContinuesMarkerA[m] << endl;
		}
		
	}
	
}

void CVNSData::PrintfContinuesMarker(int rightCols)
{
	
	
	for (int i = 0; i < m_Marker.back().m_MarkerN; i++)
	{
		if (ISPRINT) printf("time %d continues line %d \n", m_Marker.size(), i);
		printf("Length = %d    \n", m_ContinuesMarkerP[i].cols());
		if (rightCols<m_ContinuesMarkerP[i].cols())
			cout << m_ContinuesMarkerP[i].rightCols(rightCols) << endl;
		else
			cout << m_ContinuesMarkerP[i] << endl;
		
	}
}

unsigned int CVNSData::GetLastMarkerN()
{
	if (m_Marker.size() > 1)
		return m_Marker.at(m_Marker.size() - 2).m_MarkerN;
	else
		return 0;
	
}

/// <summary>
/// ����һ��ʱ�̵��Ӿ�����
/// <param name="time_t">���ʱ�̵�ʱ�䣨ֱ����OptiaTrack�����</param>
/// <param name="MarkerN_t">��˵����</param>
/// <param name="Position_tP">��˵�λ�õ�ַ</param>
/// </summary>
void CVNSData::UpdateOneInstant(double time_t, double MarkerN_t, double* Position_tP, double INSfrequency)
{
	CMarker_t Marker_t(MarkerN_t);
	Marker_t.m_time = time_t;	
	Marker_t.UpdatePosition(Position_tP, MarkerN_t);
	m_Marker.push_back(Marker_t);

	UpdateFre();
	m_Marker.back().UpdateMappingInertialK(m_Marker.front().m_time, INSfrequency);
	ContinuesJudge_t();
}

/// <summary>
/// ��txt�ļ��ж� OtherMarkers ����
/// <param name="FilePath">txt�ļ�·��</param>
/// <param name="MaxReadT">����ȡʱ�䳤��</param>
/// </summary>
void CVNSData::ReadOtherMarkersTxt(const char* FilePath, int MaxReadT)
{
	char buffer[1000];		// ��һ���ַ�
	int bufferByte;			// һ���ַ����ֽ���
	double lineData[100];	// ��һ�е�����
	int lineN = 0;		// �ַ����ȹ� �� ����������ͷ��
	int lineDataN;	// һ�е����ָ���  336+2	
	std::ifstream OptFile(FilePath);
	double timeRead0=0,timeRead = 0;	// ֱ�Ӵ� Optitrack �õ���ʱ�� sec

	memset(buffer,'\0',sizeof(buffer));
	memset(lineData, NAN, sizeof(lineData));

	if (!OptFile)
	{
		printf("failing open %s \n", FilePath);
	}
	while (!OptFile.eof())
	{
		memset(buffer, 0, sizeof(buffer));
		OptFile.getline(buffer, sizeof(buffer) / sizeof(char)-1);

		bufferByte = strlen(buffer);
		if (bufferByte > 10)  
		{
			lineN++;
			if (lineN > 1) // Ϊ����
			{
				char* token = NULL;
				token = strtok(buffer, " ");
				int i = 0;
				while (token) // ��һ��
				{
					lineData[i] = (double)atof(token);
					//	printf("%0.3f ", lineData[i]);
					token = strtok(NULL, " ");
					i++;
					lineDataN = i;
				}
				
				timeRead = lineData[0] ;
				int MarkerN = lineData[1];
				CMarker_t Marker_k(MarkerN); // һ��ʱ�̵��м�����

				Marker_k.UpdatePosition( lineData + 2, MarkerN);		//�õ�һ��ʱ�̵Ľ��				
				Marker_k.m_time = timeRead;
				
				if (m_Marker.size() > m_MaxLengthN)
				{
					m_Marker.pop_front();		// ����̫�󣬵���ǰ�������
				}
				m_Marker.push_back(Marker_k);	// ���µ��б�
				if (m_Marker.size() == 1)
					timeRead0 = timeRead;
				// �鿴����
				m_TxtDataL++;
				if (timeRead - timeRead0 > MaxReadT)
					break;

				double timeTemp, fraction;
				fraction = modf(timeRead/10, &timeTemp);
				timeTemp *= 10;
				if (fraction == 0.0 && timeTemp>0)
				{
			//		printf("%0.0f sec \n", timeRead);
				}
			}

		}
		//	printf("\n");
	}

	printf("read optitrack data %0.2f sec,Length = %d \n", timeRead, m_TxtDataL);

}

// ���� Ƶ��
void CVNSData::UpdateFre()
{
	if (m_Marker.size() == 1)
	{
		m_frequency = 120;
	}
	else
	{
		m_frequency = (m_Marker.size()-1) / (m_Marker.back().m_time - m_Marker.front().m_time);

	}
}


CVNSData::~CVNSData()
{
	m_Marker.clear();
}
