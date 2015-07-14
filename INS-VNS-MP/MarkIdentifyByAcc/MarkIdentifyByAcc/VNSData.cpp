// 2015.7.13  Noitom  xyz
// Optitract �� OtherMarker ����

#include "stdafx.h"

#include "VNSData.h"
#include <fstream>
#include <iostream>


CVNSData::CVNSData(double MaxLengthT) :
m_frequency(120),	// Ԥ�Ȱ�������Ƶ�ʿ����ڴ�
m_TxtDataL(0)
{
	m_MaxLengthN = (int)MaxLengthT*m_frequency;
	m_Marker.clear();
	
}

/// <summary>
/// ����һ��ʱ�̵��������ж�
/// �˺����и��£� MarkerCur.m_ContinuesLasti(m)   MarkerCur.m_ContinuesNum(m)
/// <param name="MarkerTrackPS">��˵����ݷ�����ز�������</param>
/// </summary>
void CVNSData::ContinuesJudge_t(CMarkerTrackPS* MarkerTrackPS )
{
	using namespace std;

	CMarker_t& MarkerCur = m_Marker.back();	// ��ǰ�� ��������������������Ϣ��
	unsigned int MarkerN = MarkerCur.m_MarkerN;
	if (m_Marker.size() < 2)	// ��һ��ʱ��
	{
		MarkerCur.SetUnContinues();
		return;
	}		
	
	CMarker_t& MarkerLast = m_Marker.at(m_Marker.size()-2);	// ǰʱ�̵�s  ��ע��Ҫ-2��
	unsigned int LastMarkerN = MarkerLast.m_MarkerN;
	
	if (LastMarkerN < 1 || MarkerN < 1)
	{
		MarkerCur.SetUnContinues();
		return;	// ��ʱ�� �� ��ǰʱ�� ����˵㣬�������
	}		
	Matrix3Xd& PositionCur = MarkerCur.m_Position;
	Matrix3Xd& PositionLast = MarkerLast.m_Position;
	Matrix3Xd PositionErr;		// ÿ����ǰ�� �� ����ǰʱ�̵�֮���λ�����
	PositionErr.resizeLike(PositionLast);
	VectorXd PositionErrNorm;	// PositionErr��ģ
	PositionErrNorm.resize(LastMarkerN);
	for (int m = 0; m < MarkerN; m++)
	{
		/// ������ǰ��m���� �� ��ʱ�����е�ĵ�λ�ò�		
		for (int n = 0; n < LastMarkerN; n++)
		{
			PositionErr.col(n) = PositionCur.col(m) - PositionLast.col(n);	
			PositionErrNorm(n) = PositionErr.col(n).norm();
		}
		int indexMin;
		double minErr = PositionErrNorm.minCoeff(&indexMin);
		if (minErr < MarkerTrackPS->m_MaxContinuesDisplacement)
		{
			// MarkerCur ��m���� �� MarkerLast ��indexMin��������
			MarkerCur.m_ContinuesLasti(m) = indexMin;
			// �������ȼ�1
			MarkerCur.m_ContinuesNum(m) = MarkerLast.m_ContinuesNum(indexMin) + 1;

	/*		if (isnan(MarkerLast.m_ContinuesNum(indexMin)))
			{
				printf("error in ContinuesJudge_t \n");
			}		*/	
		}
		else
		{
			MarkerCur.m_ContinuesNum(m) = 0;	// �ж�Ϊ��������
		}
		
		// OUTPUT 
		
		//printf("Position");
		//cout << endl << PositionLast << endl << PositionCur<<endl;
		//printf("Position err");
		//std::cout << std::endl << PositionErr << std::endl << PositionErrNorm << std::endl;

		

	}
	printf("Continues  %d  \n", m_Marker.size());
	cout << MarkerCur.m_ContinuesNum << endl;
	//cout << MarkerCur.m_ContinuesLasti << endl;
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
