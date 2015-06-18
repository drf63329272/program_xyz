/*
xyz 2015.6.9
�����Ӿ���϶��������ںϺ���
*/

#include "stdafx.h"
#include "HybidTrack.h"
#include "GetINSCompensateFromVNS.h"



 // �� InertialData ��ȡ M_InertialData
 void CHybidTrack::Get_M_InertialData()
 {
	 /// ���µĹ�������

	 deque<CInertialData_t>::iterator CInertialData_t_Tter = InertialData.end();
	 CInertialData_t_Tter--;

	 CInertialData_t InertialData_t = *CInertialData_t_Tter;//  ĩβ ���� �Ĺ�������

	 
	 // �б��������ǰ�ɼ����Ӿ����� ����
	 int inertialTimeN;
	 inertialTimeN = InertialData.size();

	 if (inertialTimeN<3)
	 {
		 M_InertialData->frequency = m_I_Frequency;

		 M_InertialData->BodyDirection[0] = m_FaceDirection.X;
		 M_InertialData->BodyDirection[1] = m_FaceDirection.Y;
		 M_InertialData->BodyDirection[2] = m_FaceDirection.Z;
	 }
	 /// ת��Ϊ MATLAB ʶ��ĸ�ʽ

	 // �� InertialData_t �浽 M_InertialData �ĵ� inertialTimeN �� ���ٶ�һ�λص�ֻ�����һ�����ݣ�
	 
	 M_InertialData->visual_k[inertialTimeN - 1] = InertialData_t.m_mappintVisual_k;
	 M_InertialData->time[inertialTimeN - 1] = inertialTimeN/m_I_Frequency;   // ֱ����Ƶ����ʱ��

	 M_InertialData->HeadPosition[inertialTimeN * 3 - 3] = InertialData_t.m_I_HeadP.X;
	 M_InertialData->HeadPosition[inertialTimeN * 3 - 2] = InertialData_t.m_I_HeadP.Y;
	 M_InertialData->HeadPosition[inertialTimeN * 3 - 1] = InertialData_t.m_I_HeadP.Z;

	 M_InertialData->HeadQuaternion[inertialTimeN * 4 - 4] = InertialData_t.m_I_HeadQ.qs;
	 M_InertialData->HeadQuaternion[inertialTimeN * 4 - 3] = InertialData_t.m_I_HeadQ.qx;
	 M_InertialData->HeadQuaternion[inertialTimeN * 4 - 2] = InertialData_t.m_I_HeadQ.qy;
	 M_InertialData->HeadQuaternion[inertialTimeN * 4 - 1] = InertialData_t.m_I_HeadQ.qz;

	 M_InertialData->HipPosition[inertialTimeN * 3 - 3] = InertialData_t.m_I_HipP.X;
	 M_InertialData->HipPosition[inertialTimeN * 3 - 2] = InertialData_t.m_I_HipP.Y;
	 M_InertialData->HipPosition[inertialTimeN * 3 - 1] = InertialData_t.m_I_HipP.Z;

	 M_InertialData->HipQuaternion[inertialTimeN * 4 - 4] = InertialData_t.m_I_HipQ.qs;
	 M_InertialData->HipQuaternion[inertialTimeN * 4 - 3] = InertialData_t.m_I_HipQ.qx;
	 M_InertialData->HipQuaternion[inertialTimeN * 4 - 2] = InertialData_t.m_I_HipQ.qy;
	 M_InertialData->HipQuaternion[inertialTimeN * 4 - 1] = InertialData_t.m_I_HipQ.qz;

	 
	 
	 

 }

// �� VisionData �õ� M_otherMakers
void CHybidTrack::Get_M_otherMakers()
{
	/// ���µ��Ӿ�����
	
	CVisionData_t& VisionData_t = VisionData.back();//  ĩβ ���� ���Ӿ�����

	// ��˵�ĸ���
	int m_OtherMarkersN = VisionData_t.m_OtherMarkersN;
	
	// �б��������ǰ�ɼ����Ӿ����� ����
	int visualTimeN;	
	visualTimeN = VisionData.size()-1;

	/// ת��Ϊ MATLAB ʶ��ĸ�ʽ

	// �� VisionData_t �浽 M_otherMakers �ĵ� visualTimeN �� ���ٶ�һ�λص�ֻ�����һ�����ݣ�
	M_otherMakers[visualTimeN].frequency = m_V_Frequency;

	// time ��ȡ�ӿ�ʼ�ɼ�����ǰ֡��ʱ��
	M_otherMakers[visualTimeN].time = VisionData_t.m_fLatency;  
	M_otherMakers[visualTimeN].inertial_k = VisionData_t.m_mappingInertial_k;
	// ���Ӿ����Ӿ� ��ȥ �Ӿ���ʼ�ɼ� �� ������ʼ�ɼ�ʱ��
	if (!rtIsNaN(m_fLatency_StartTwo))
	{
		M_otherMakers[visualTimeN].time = M_otherMakers[visualTimeN].time - m_fLatency_StartTwo;
	}
	
	M_otherMakers[visualTimeN].otherMakersN = m_OtherMarkersN;
	

	double m_fTimestamp = VisionData_t.m_fTimestamp;
		
	for (int i = 0; i < m_OtherMarkersN; i++)
	{
		// �� m_OtherMarkersN ����˵�������� M_otherMakers[visualTimeN].Position
		// M_otherMakers[visualTimeN].Position Ϊ [3*m_OtherMarkersN]
		// ��һ����˵㣺M_otherMakers[visualTimeN].Position[:,i] Ϊһ�У�[0 + i * 3]  [1 + i * 3]  [2 + i * 3] ��Ӧ m_OtherMarkersP[0].X Y Z

		Point3D_t m_OtherMarkersP_i = VisionData_t.m_OtherMarkersP[i];  // ��һ����Ϊ  m_OtherMarkersP[0]
		
		M_otherMakers[visualTimeN].Position[0 + i * 3] = m_OtherMarkersP_i.X;
		M_otherMakers[visualTimeN].Position[1 + i * 3] = m_OtherMarkersP_i.Y;
		M_otherMakers[visualTimeN].Position[2 + i * 3] = m_OtherMarkersP_i.Z;
	}
		
}


CHybidTrack::CHybidTrack() :
IsBothStart(0)
{	
	GetINSCompensateFromVNS_initialize();

	m_I_Frequency = rtNaN;
	m_V_Frequency = rtNaN;
	m_fLatency_StartTwo = rtNaN;

	// ��ʼ�� List ��С
	InertialData.clear();
	VisionData.clear();
	m_FaceDirection.X = rtNaN;
	m_FaceDirection.Y = rtNaN;
	m_FaceDirection.Z = rtNaN;
	
	for (int k = 0; k < I_BufferN; k++)
	{
		InertialData_visual_k[k] = rtNaN;
	}
	
	/// ���� MATLAB�Զ����ɵĺ������� M_InertialData �� M_otherMakers ���г�ʼ��
	// ����С�ֲ�����Ϊ I_BufferN �� V_BufferN�� ͬʱ����ֵ��Ϊ NaN
	

	M_InertialData = (struct0_T *)calloc(1, sizeof(struct0_T));
	SetM_InertialData_Empty( );
	SetM_otherMakers_Empty();
	CalculateOrder[0].CalEndIN = 0;
	CalculateOrder[0].CalEndVN = 0;
	CalculateOrder[0].CalStartIN = 0;
	CalculateOrder[0].CalStartVN = 0;

	M_compensateRate = 1;   //  λ�Ʋ���ϵ�� Ĭ��ֵ

	// ��ʼ�����Ϊ NaN
	for (int k = 0; k < I_BufferN; k++)
	{
		for (int i = 0; i < 3; i++)
		{
			M_InertialPositionCompensate[3 * k + i] = rtNaN;
			M_HipDisplacementNew[3 * k + i] = rtNaN;
		}
	}
	

	m_OffLineRead = false;
	m_Opt_Path = "E:\\data_xyz\\Hybrid Motion Capture Data\\5.28\\5.28-head6\\Opt.txt";	
	m_inertial_Path = "E:\\data_xyz\\Hybrid Motion Capture Data\\5.28\\5.28-head6\\RawData.raw";
	m_IneritalFrames = 0;

/*
	int oldNumel;
	
	/// ���� MATLB �����Ĵ�С
	//ÿ�������ı� size �󣬶���Ҫ �����ڴ��������
	


	///  M_InertialData

	M_InertialData->time->size[0] = 1;
	M_InertialData->time->size[1] = I_BufferN;
	oldNumel = M_InertialData->time->size[0] * M_InertialData->time->size[1];
	emxEnsureCapacity((emxArray__common *)M_InertialData->time, oldNumel, (int)sizeof(double));

	M_InertialData->HipQuaternion->size[0] = 4;
	M_InertialData->HipQuaternion->size[1] = I_BufferN;
	oldNumel = M_InertialData->HipQuaternion->size[0] * M_InertialData->HipQuaternion->size[1];
	emxEnsureCapacity((emxArray__common *)M_InertialData->HipQuaternion, oldNumel, (int)sizeof(double));

	M_InertialData->HipPosition->size[0] = 3;
	M_InertialData->HipPosition->size[1] = I_BufferN;
	oldNumel = M_InertialData->HipPosition->size[0] * M_InertialData->HipPosition->size[1];
	emxEnsureCapacity((emxArray__common *)M_InertialData->HipPosition, oldNumel, (int)sizeof(double));

	M_InertialData->HeadQuaternion->size[0] = 4;
	M_InertialData->HeadQuaternion->size[1] = I_BufferN;
	oldNumel = M_InertialData->HeadQuaternion->size[0] * M_InertialData->HeadQuaternion->size[1];
	emxEnsureCapacity((emxArray__common *)M_InertialData->HeadQuaternion, oldNumel, (int)sizeof(double));

	M_InertialData->HeadPosition->size[0] = 3;
	M_InertialData->HeadPosition->size[1] = I_BufferN;
	oldNumel = M_InertialData->HeadPosition->size[0] * M_InertialData->HeadPosition->size[1];
	emxEnsureCapacity((emxArray__common *)M_InertialData->HeadPosition, oldNumel, (int)sizeof(double));

	M_InertialData->DataStyle->size[0] = 1;
	M_InertialData->DataStyle->size[1] = 10;
	oldNumel = M_InertialData->DataStyle->size[0] * M_InertialData->DataStyle->size[1];
	emxEnsureCapacity((emxArray__common *)M_InertialData->DataStyle, oldNumel, (int)sizeof(char));


	/// M_otherMakers

	// M_otherMakers ��С�ĳ�ʼ�� 
	M_otherMakers->size[0] = 1;
	M_otherMakers->size[1] = V_BufferN;
	int i0 = M_otherMakers->size[0] * M_otherMakers->size[1];
	emxEnsureCapacity_struct1_T(M_otherMakers, i0);  // ÿ�θ��Ĵ�С����Ҫ�������ȷ�����㹻���ڴ����

	// M_otherMakers ��ÿһ��ʱ�� �� ÿһ����˵�� ÿһ��Ԫ�� ���ó�ʼ����С
	for (int k = 0; k < V_BufferN; k++)
	{
		// �� k ��ʱ��  data ��6��Ԫ��

		M_otherMakers->data[k].Position->size[0] = 3;
		M_otherMakers->data[k].Position->size[1] = 1 * V_BufferN;  // Ĭ�Ͽ��� 1 ����˵�Ŀռ�
		oldNumel = M_otherMakers->data[k].Position->size[0] * M_otherMakers->data[k].Position->size[1];
		emxEnsureCapacity((emxArray__common *)M_otherMakers->data[k].Position, oldNumel, (int)sizeof(double));

		M_otherMakers->data[k].ContinuesFlag->size[0] = 1;
		M_otherMakers->data[k].ContinuesFlag->size[1] = V_BufferN;  // ÿ��ʱ�̿϶�ֻ��һ��Ԫ��
		oldNumel = M_otherMakers->data[k].ContinuesFlag->size[0] * M_otherMakers->data[k].ContinuesFlag->size[1];
		emxEnsureCapacity((emxArray__common *)M_otherMakers->data[k].ContinuesFlag, oldNumel, (int)sizeof(double));

		M_otherMakers->data[k].ContinuesLastPosition->size[0] = 1;
		M_otherMakers->data[k].ContinuesLastPosition->size[1] = V_BufferN;
		oldNumel = M_otherMakers->data[k].ContinuesLastPosition->size[0] * M_otherMakers->data[k].ContinuesLastPosition->size[1];
		emxEnsureCapacity((emxArray__common *)M_otherMakers->data[k].ContinuesLastPosition, oldNumel, (int)sizeof(double));

		M_otherMakers->data[k].ContinuesLastTime->size[0] = 1;
		M_otherMakers->data[k].ContinuesLastTime->size[1] = V_BufferN;
		oldNumel = M_otherMakers->data[k].ContinuesLastTime->size[0] * M_otherMakers->data[k].ContinuesLastTime->size[1];
		emxEnsureCapacity((emxArray__common *)M_otherMakers->data[k].ContinuesLastTime, oldNumel, (int)sizeof(double));

		M_otherMakers->data[k].ContinuesLastK->size[0] = 1;
		M_otherMakers->data[k].ContinuesLastK->size[1] = V_BufferN;
		oldNumel = M_otherMakers->data[k].ContinuesLastK->size[0] * M_otherMakers->data[k].ContinuesLastK->size[1];
		emxEnsureCapacity((emxArray__common *)M_otherMakers->data[k].ContinuesLastK, oldNumel, (int)sizeof(double));

		M_otherMakers->data[k].MarkerSet->size[0] = 1;
		M_otherMakers->data[k].MarkerSet->size[1] = 10;  // 'Head'   'Hip'
		oldNumel = M_otherMakers->data[k].MarkerSet->size[0] * M_otherMakers->data[k].MarkerSet->size[1];
		emxEnsureCapacity((emxArray__common *)M_otherMakers->data[k].MarkerSet, oldNumel, (int)sizeof(char));
	}
	
	/// M_InertialPositionCompensate   
	/// �Ӿ��Թ���λ�ƵĲ�����

	M_InertialPositionCompensate->size[0] = 3;
	M_InertialPositionCompensate->size[0] = I_BufferN;
	oldNumel = M_InertialPositionCompensate->size[0] * M_InertialPositionCompensate->size[1];
	emxEnsureCapacity((emxArray__common *)M_InertialPositionCompensate, oldNumel, (int)sizeof(double));

	/// M_HipDisplacementNew   
	/// ������Ĺ���λ��

	M_HipDisplacementNew->size[0] = 3;
	M_HipDisplacementNew->size[0] = I_BufferN;
	oldNumel = M_HipDisplacementNew->size[0] * M_HipDisplacementNew->size[1];
	emxEnsureCapacity((emxArray__common *)M_HipDisplacementNew, oldNumel, (int)sizeof(double));
	*/
}


CHybidTrack::~CHybidTrack()
{

}

// ���Ӿ��궨ʱ�����������������κ�Ҫ��ʱ����ͨ�� m_FaceDirection ���Ӿ��ĳ������������һ��
// ֻ������ǰһ֡ OtherMarkers
void CHybidTrack::PreProcess_FaceDirection()
{
	
}

// �ڲ��Ź�������ǰ�������е��Ӿ����ݶ���
void CHybidTrack::Read_M_otherMakers_OffLine()
{
	errno_t err;
	err = fopen_s(&m_OptStream, m_Opt_Path, "r");
	if (err == 0)
	{
		printf("The file '...Opt.txt' was opened\n");
	}
	else
	{
		printf("The file '...Opt.txt' was not opened\n");
	}

	char str[100];
	int min = 0, sec = 0, msec = 0;
	int min_last = 0, sec_last = 0, msec_last = 0;
	int OtherMarkersN;
	float_t x = 0, y = 0, z = 0;
	int res = 1;
	res = fscanf_s(m_OptStream, "%[^\n]%*c", str, _countof(str)); // ��һ���� ͷ
	// �ڶ���֮��������
	VisionData.clear();
	CVisionData_t CVisionData_Cur;
	float fLatency = 0;
	int m_mappingInertial_k;
	int VN;
	while (res != EOF)
	{
		// ��ȡһ��ʱ�̵�����
		res = fscanf_s(m_OptStream, "%d:%d:%d", &min,&sec,&msec);
		res = fscanf_s(m_OptStream, "%d", &OtherMarkersN);
		
		
		CVisionData_Cur.m_OtherMarkersN = OtherMarkersN;

		for (int k = 0; k < OtherMarkersN; k++)
		{
			res = fscanf_s(m_OptStream, "%f %f %f", &x, &y, &z);
			Point3D_t OtherMarker_i(x, y, z);
			CVisionData_Cur.m_OtherMarkersP.push_back(OtherMarker_i);  // ����һ����˵�λ��
		}
	

		// ���� fLatency
		if (!VisionData.empty())
		{
			float timeStep = (min-min_last)*60+(sec-sec_last)+(msec-msec_last)/1000.0 ;
			fLatency += timeStep;
		}
		min_last = min;
		sec_last = sec;
		msec_last = msec;

		// ���� m_fLatency �͹��Ե�Ƶ�ʼ��� m_mappingInertial_k
		m_mappingInertial_k = fLatency*m_I_Frequency + 1;
		VN = VisionData.size();
		for (int i = 0; i < 10; i++)
		{
			int temp = InertialData_visual_k[m_mappingInertial_k - i-1];
			if (temp != VN - 1 && temp!=VN)
				InertialData_visual_k[m_mappingInertial_k - i-1] = VN + 1; // �ӵ�ǰ��ǰ��д visualN
			else
				break;
		}

		CVisionData_Cur.m_fLatency = fLatency;
		CVisionData_Cur.m_Timecode = 0;
		CVisionData_Cur.m_TimecodeSubframe = 0;
		CVisionData_Cur.m_fTimestamp = 0;

		CVisionData_Cur.m_mappingInertial_k = m_mappingInertial_k; // ��Ҫ�������¼���  m_mappingInertial_k ������

		// �����Ӿ����ݵ��б��ĩβ    �������Զ�����
		if (VN == V_BufferN)
		{
			VisionData.pop_front();	// �Ѵ洢�㹻������ݣ��б����ˣ���ɾ������ģ��б��ײ���
		}
		VisionData.push_back(CVisionData_Cur);  // ���µķ�����ĩβ
		// �� m_fLatency ���Ƽ���Ƶ��
		CalVisualFrequency();
		// �� CVisionData_Cur ���µ� M_otherMakers
		Get_M_otherMakers();
	}

	// Close stream if it is not NULL 
	if (m_OptStream)
	{
		err = fclose(m_OptStream);
		if (err == 0)
		{
			printf("The file '...Opt.txt' was closed\n");
		}
		else
		{
			printf("The file '...Opt.txt' was not closed\n");
		}
	}
	m_fLatency_StartTwo = 0;
}


// ���´� Optitrack ���յ��� OtherMarkers ����    һ��ʱ�̵�
void CHybidTrack::UpdateVisionData(int OtherMarkersN, float* pOtherMarkers, float fLatency, unsigned int Timecode, unsigned int TimecodeSubframe, double fTimestamp)
{
	if (fLatency == 0)
	{
		return;		// ��һ�����ݻ�������fLatencyû�յ�������
	}
	// ��һ�βɼ�����¼ϵͳʱ��
	int visualN = VisionData.size();
	int InertialN = InertialData.size();
	if (IsBothStart==0 && !VisionData.empty() && !InertialData.empty())
	{
		IsBothStart = 1; // ��һ�β�׽�����Ժ��Ӿ�����ʼ�ɼ�
		// ���Ӿ����
		VisionData.clear();
		SetM_otherMakers_Empty();

		m_fLatency_StartTwo = fLatency - (InertialN-1)/m_I_Frequency;
	}
	
	CVisionData_t CVisionData_Cur;
	CVisionData_Cur.m_OtherMarkersN = OtherMarkersN;
	for (int i = 0; i < OtherMarkersN; i++)
	{
		// ���������˵㵽 m_OtherMarkersP �б��ĩβ
		Point3D_t OtherMarker_i(pOtherMarkers[i * 3], pOtherMarkers[i * 3 + 1], pOtherMarkers[i * 3 + 2]);
		  
		// ��ĩβ push ����һ����˵�(i=0)������ǰ��
		// ��һ����˵㣺 m_OtherMarkersP[0]  ��Ӧ  pOtherMarkers[0 * 3], pOtherMarkers[0 * 3 + 1], pOtherMarkers[0 * 3 + 2]
				// ��Ӧ MATLAB �е� OtherMarkers[:,1]
		CVisionData_Cur.m_OtherMarkersP.push_back(OtherMarker_i);
	}

	
	// ���� m_fLatency �͹��Ե�Ƶ�ʼ��� m_mappingInertial_k
	int m_mappingInertial_k;
	if (!rtIsNaN(m_fLatency_StartTwo))
	{
		m_mappingInertial_k = (fLatency - m_fLatency_StartTwo)*m_I_Frequency + 1;
		
		int VN = VisionData.size();
		for (int i = 0; i < 10; i++)
		{
			int temp = InertialData_visual_k[m_mappingInertial_k - i - 1];
			if (temp != VN - 1 && temp != VN)
				InertialData_visual_k[m_mappingInertial_k - i - 1] = VN + 1; // �ӵ�ǰ��ǰ��д visualN
			else
				break;
		}
	}
	else
	{
		m_mappingInertial_k = 0;
	}
	
	// m_mappintVisual_k ���ܴ����Ӿ����ݵ����ֵ;
	// m_mappingInertial_k ���ܴ��ڹ������ݵ����ֵ
	// ��˵���λ�Ʋ���������ʱ����Ҫ���м�飬���ܰ����µ�����ֱ�ӵ���
	
	CVisionData_Cur.m_fLatency = fLatency;
	CVisionData_Cur.m_Timecode = Timecode;
	CVisionData_Cur.m_TimecodeSubframe = TimecodeSubframe;
	CVisionData_Cur.m_fTimestamp = fTimestamp;

	CVisionData_Cur.m_mappingInertial_k = m_mappingInertial_k;  
	
	// �����Ӿ����ݵ��б��ĩβ    �������Զ�����
	if (VisionData.size() == V_BufferN)
	{
		VisionData.pop_front();	// �Ѵ洢�㹻������ݣ��б����ˣ���ɾ������ģ��б��ײ���
	}
	VisionData.push_back(CVisionData_Cur);  // ���µķ�����ĩβ
	// �� m_fLatency ���Ƽ���Ƶ��
	CalVisualFrequency();
	
	// �� CVisionData_Cur ���µ� M_otherMakers
	Get_M_otherMakers();

	// ���㲹����
	GetDisplacementCompensate();

}

// ���� MATLAB ���ɵ� GetINSCompensateFromVNS ����λ�Ʋ���
void CHybidTrack::GetDisplacementCompensate()
{
	static int IneritalN = 0;
	int visualN = VisionData.size();
	if (!rtIsNaN(m_fLatency_StartTwo))
	{
		if (CalculateOrder[0].CalEndVN == 0)  // ��һ�β���
		{
			M_InertialPositionCompensate[0] = 0;
			M_InertialPositionCompensate[1] = 0;
			M_InertialPositionCompensate[2] = 0;

			M_HipDisplacementNew[0] = M_InertialData->HipPosition[0];
			M_HipDisplacementNew[1] = M_InertialData->HipPosition[1];
			M_HipDisplacementNew[2] = M_InertialData->HipPosition[2];
		}
			// �����µĹ����������ҵ����µ� �����Ӿ���Ӧ����
			int IneritalNew = InertialData.size();
			int newIneritalN = IneritalNew - IneritalN;  // �����Ĺ��Ը���
			int inertialCompensate_k;	// ���¿��ý��в�������� �����������
			int visual_k;			// inertialCompensate_k ָ����Ӿ����
			int CalEndVN_new ;		//  ������µ��Ӿ����¿���������� 
			for (inertialCompensate_k = IneritalNew; inertialCompensate_k > IneritalN; inertialCompensate_k--)
			{
				visual_k = M_InertialData->visual_k[inertialCompensate_k - 1];
				if (visual_k<= visualN) // ���Զ�Ӧ��ʱ�� �� ʵ�ʵġ�OK
				{
					if (M_otherMakers[visual_k - 1].inertial_k <= inertialCompensate_k) // �Ӿ���Ӧ�Ĺ���Ҳ�Ѿ�����
					{
						CalEndVN_new = visual_k;
						break;		// �ҵ��˳�
					}						
				}
			}
			
			// �õ��ɽ��в����Ĺ���������� inertialCompensate_k
			
			if (CalEndVN_new>CalculateOrder[0].CalEndVN && CalEndVN_new>1)  // �����ݸ���
			{
				// ���µ� �� compensated_VN_new ������1��ʼ��
				/// CalculateOrder �м�¼���Ǹ�������1��ʼ�����������
				
				CalculateOrder[0].CalStartVN = CalculateOrder[0].CalEndVN + 1; // ���ϴα�������
				CalculateOrder[0].CalEndVN = CalEndVN_new;	// �õ� ���µ��Ӿ�����
								
				CalculateOrder[0].CalStartIN = CalculateOrder[0].CalEndIN+1;
				CalculateOrder[0].CalEndIN = M_otherMakers[CalEndVN_new - 1].inertial_k;
				M_compensateRate = 1;
				GetINSCompensateFromVNS(M_InertialData, M_otherMakers, M_compensateRate, CalculateOrder,
					M_InertialPositionCompensate, M_HipDisplacementNew);
			}
			
	}

	if (InertialData.size() == m_IneritalFrames)
	{
		// ���һ֡
		printf("the last");
	}
}

// �� m_fLatency ���Ƽ���Ƶ��
void CHybidTrack::CalVisualFrequency()
{
	if ( VisionData.size()>3)
	{
		/// ���µ��Ӿ�����
		CVisionData_t& VisionData_t = VisionData.back(); //  ĩβ ���� ���Ӿ�����
		deque <CVisionData_t>::const_iterator VisionData_cIter = VisionData.begin();
		CVisionData_t VisionData_0 = *VisionData_cIter; //  �ڶ�ĩβ ���Ӿ�����

		double  T = VisionData_t.m_fLatency - VisionData_0.m_fLatency;
		m_V_Frequency = VisionData.size() / T;		
	}
}

// ���¹�������  һ��ʱ�̵�
void CHybidTrack::UpdateInertialData(QUATERNION_t HipQ, Point3D_t HipP, QUATERNION_t HeadQ, Point3D_t HeadP, Vector3_t FaceDirection)
{
	if (rtIsNaN(m_I_Frequency))
	{
		// û�в���Ҳ�ص���һ�Σ�������
		return;
	}
	// ��һ�βɼ�����¼ϵͳʱ��
	if (IsBothStart==1)
	{
		// ��һ�� ��⵽���Ժ��Ӿ�����ʼ�ɼ�
		IsBothStart = 2;
		// �����ǰ�Ĺ�������
		InertialData.clear();
		SetM_InertialData_Empty();
	}

	CInertialData_t CInertialData_Cur(HipQ, HipP, HeadQ, HeadP);

	//  ���� m_mappintVisual_k�� �ӵ�ǰ�����Ӿ���ʱ�䣬����Ƶ��ϸ��
	int m_mappintVisual_k;
	if (rtIsNaN(m_fLatency_StartTwo))
	{
		if (m_OffLineRead)
			m_mappintVisual_k = 1; // ����ģʽ
		else
			m_mappintVisual_k = 0;
		if (IsBothStart == 2)
		{
			m_mappintVisual_k = 1; // ��Ӧ�ó��ֵ�����������̵߳Ĳ�ͬ������
			// �����ǰ�Ĺ�������
			InertialData.clear();
			SetM_InertialData_Empty();
		}			
	}
	else
	{
		int inertialTime = InertialData.size() / m_I_Frequency;
		CVisionData_t& VisionData_t = VisionData.back();//  ĩβ ���� ���Ӿ�����
		int visualTime = VisionData_t.m_fLatency - m_fLatency_StartTwo;
		int m_mappintVisual_k1 = VisionData.size() + (inertialTime - visualTime) * m_V_Frequency;

		m_mappintVisual_k = InertialData_visual_k[InertialData.size()-1+1];
		// �� m_mappintVisual_k ������

		// m_mappintVisual_k ���ܴ����Ӿ����ݵ����ֵ;
		// m_mappingInertial_k ���ܴ��ڹ������ݵ����ֵ
		// ��˵���λ�Ʋ���������ʱ����Ҫ���м�飬���ܰ����µ�����ֱ�ӵ���
	}
	CInertialData_Cur.m_mappintVisual_k = m_mappintVisual_k; 

	// �� λ�ú���̬ ���µ� InertialData ��ĩβ  �������Զ�����
	if (InertialData.size() == I_BufferN)
	{
		InertialData.pop_front();		// �Ѵ洢�㹻������ݣ��б����ˣ���ɾ������ģ��б��ײ���
	}
	InertialData.push_back(CInertialData_Cur);

	if (InertialData.size() == 1)
	{
		// ��һ��ʱ�̸��� m_FaceDirection  ..... �����ж�
		m_FaceDirection.X = FaceDirection.x;
		m_FaceDirection.Y = FaceDirection.y;
		m_FaceDirection.Z = FaceDirection.z;
	}	
	Get_M_InertialData();


	if (m_OffLineRead)// �������ļ�ģʽ
	{
		
		
		if (InertialData.size() == m_IneritalFrames)
		{
			// ���һ֡
			printf("the last");
		}
		GetDisplacementCompensate();
	}
	else// ʵʱ�ɼ�ģʽ
	{
		
		
	}
	
}

void CHybidTrack::DoHipDispCompensate(  )
{

}


CVisionData_t::CVisionData_t() :
m_fLatency(0),
m_Timecode(0),
m_TimecodeSubframe(0),
m_fTimestamp(0),
m_mappingInertial_k(0)
{
	m_OtherMarkersN = 0;
	m_OtherMarkersP.resize(1);
	m_TrackedMarkerP = Point3D_t(0, 0, 0);
}

CVisionData_t::~CVisionData_t()
{

}

CInertialData_t::CInertialData_t()
{
	m_I_HipQ = QUATERNION_t(1, 0, 0, 0);
	m_I_HeadQ = QUATERNION_t(1, 0, 0, 0);
	m_I_HipP = Point3D_t(0, 0, 0);
	m_I_HeadP = Point3D_t(0, 0, 0);
	m_mappintVisual_k = 0;
}
CInertialData_t::CInertialData_t(QUATERNION_t HipQ, Point3D_t HipP, QUATERNION_t HeadQ, Point3D_t HeadP)
{
	m_I_HipQ = HipQ;
	m_I_HeadQ = HeadQ;
	m_I_HipP = HipP;
	m_I_HeadP = HeadP;
	
}

CInertialData_t::~CInertialData_t()
{

}

// �� M_InertialData �ÿ�
void CHybidTrack::SetM_InertialData_Empty( )
{
	int i;
	int k;

	//  %% �� otherMakers ��ֵ���� 1
	//  frequency = otherMakers(2).frequency;
	//  time = otherMakers(2).time;
	//  v_Position = zeros(3,20);
	//  v_Position(:,32) = [1;3;-2];
	//  otherMakersN = otherMakers(6).otherMakersN;
	//
	//  for visual_k=1:100
	//      otherMakers1 = Assign_otherMakers_1( otherMakers1,visual_k,frequency,time,v_Position,otherMakersN ); 
	//  end
	// % InertialData  �� otherMakers �� NaN
	// % ���ڸ� C++ �Զ����� ��ʼ�� ����

	//  M_InertialData.DataStyle =  'GlobalBoneQuat';
	M_InertialData->frequency = rtNaN;
	for (i = 0; i < 46080; i++) {
		M_InertialData->HipQuaternion[i] = rtNaN;
	}

	for (i = 0; i < 11520; i++) {
		M_InertialData->time[i] = rtNaN;
	}

	for (i = 0; i < 34560; i++) {
		M_InertialData->HipPosition[i] = rtNaN;
	}

	for (i = 0; i < 46080; i++) {
		M_InertialData->HeadQuaternion[i] = rtNaN;
	}

	for (i = 0; i < 34560; i++) {
		M_InertialData->HeadPosition[i] = rtNaN;
	}

	for (i = 0; i < 3; i++) {
		M_InertialData->BodyDirection[i] = rtNaN;
	}
}

// �� M_otherMakers �ÿ�
void CHybidTrack::SetM_otherMakers_Empty()
{
	int i;
	int k;

	for (k = 0; k < 3600; k++) {
		M_otherMakers[k].frequency = rtNaN;
		for (i = 0; i < 30; i++) {
			M_otherMakers[k].Position[i] = rtNaN;
		}

		M_otherMakers[k].otherMakersN = 0;
		M_otherMakers[k].time = rtNaN;
		M_otherMakers[k].inertial_k = rtNaN;
		M_otherMakers[k].MarkerSet = 16;

		//  'head';
		for (i = 0; i < 10; i++) {
			M_otherMakers[k].ContinuesFlag[i] = rtNaN;
		}

		for (i = 0; i < 30; i++) {
			M_otherMakers[k].ContinuesLastPosition[i] = rtNaN;
		}

		for (i = 0; i < 10; i++) {
			M_otherMakers[k].ContinuesLastTime[i] = rtNaN;
		}

		for (i = 0; i < 10; i++) {
			M_otherMakers[k].ContinuesLastK[i] = rtNaN;
		}
		for (i = 0; i < 3; i++) {
			M_otherMakers[k].trackedMakerPosition[i] = rtNaN;
		}
		
	}
}


