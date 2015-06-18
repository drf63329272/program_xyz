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
	
	/// ���� MATLAB�Զ����ɵĺ������� M_InertialData �� M_otherMakers ���г�ʼ��
	// ����С�ֲ�����Ϊ I_BufferN �� V_BufferN�� ͬʱ����ֵ��Ϊ NaN
	

	M_InertialData = (struct0_T *)calloc(1, sizeof(struct0_T));
	SetM_InertialData_Empty( );
	SetM_otherMakers_Empty();

	M_compensateRate = 0.1;   //  λ�Ʋ���ϵ�� Ĭ��ֵ

	// ��ʼ�����Ϊ NaN
	for (int k = 0; k < I_BufferN; k++)
	{
		for (int i = 0; i < 3; i++)
		{
			M_InertialPositionCompensate[3 * k + i] = rtNaN;
			M_HipDisplacementNew[3 * k + i] = rtNaN;
		}
	}
	
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
	// �� m_fLatency ���Ƽ���Ƶ��
	CalVisualFrequency();

	CVisionData_Cur.m_fLatency = fLatency;
	CVisionData_Cur.m_Timecode = Timecode;
	CVisionData_Cur.m_TimecodeSubframe = TimecodeSubframe;
	CVisionData_Cur.m_fTimestamp = fTimestamp;

	CVisionData_Cur.m_mappingInertial_k = InertialData.size();  // ��ʱ�����б��������Ϊ��Ӧ�Ĺ������
	
	// �����Ӿ����ݵ��б��ĩβ    �������Զ�����
	if (VisionData.size() == V_BufferN)
	{
		VisionData.pop_front();	// �Ѵ洢�㹻������ݣ��б����ˣ���ɾ������ģ��б��ײ���
	}
	VisionData.push_back(CVisionData_Cur);  // ���µķ�����ĩβ
	
	// �� CVisionData_Cur ���µ� M_otherMakers
	Get_M_otherMakers();

	// ���㲹����
	visualN = VisionData.size();
	if (!rtIsNaN(m_fLatency_StartTwo) )
	{
		if (visualN == 1)
		{
			M_InertialPositionCompensate[0] = 0;
			M_InertialPositionCompensate[1] = 0;
			M_InertialPositionCompensate[2] = 0;

			M_HipDisplacementNew[0] = M_InertialData->HipPosition[0];
			M_HipDisplacementNew[1] = M_InertialData->HipPosition[1];
			M_HipDisplacementNew[2] = M_InertialData->HipPosition[2];
		}
		else
		{
			int  CalEndVN_in = VisionData.size();
			int  CalStartVN_in = CalEndVN_in - 1;
			GetINSCompensateFromVNS(M_InertialData, M_otherMakers, M_compensateRate, CalStartVN_in,CalEndVN_in,
				M_InertialPositionCompensate, M_HipDisplacementNew);
		}
		
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
	CInertialData_Cur.m_mappintVisual_k = VisionData.size(); // ��ǰ�Ӿ��б�������Ϊ��Ӧ�Ӿ����

	// �� λ�ú���̬ ���µ� InertialData ��ĩβ  �������Զ�����
	if (InertialData.size() == I_BufferN)
	{
		InertialData.pop_front();		// �Ѵ洢�㹻������ݣ��б����ˣ���ɾ������ģ��б��ײ���
	}
	InertialData.push_back(CInertialData_Cur);

	// ��һ��ʱ�̸��� m_FaceDirection  ..... �����ж�
	m_FaceDirection.X = FaceDirection.x;
	m_FaceDirection.Y = FaceDirection.y;
	m_FaceDirection.Z = FaceDirection.z;

	Get_M_InertialData();
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

