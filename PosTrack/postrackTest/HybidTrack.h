/*
xyz 2015.6.9
�����Ӿ���϶��������ںϺ���
*/

#pragma once
# include"Definitions.h"
# include "GetINSCompensateFromVNS_types.h"
#include <deque>
#include <mutex>

// һ��ʱ�̵��Ӿ�����
class CVisionData_t
{
public:
	/// �Ӿ�����

	// Optitrack OtherMarker ����
	int m_OtherMarkersN;
	// Optitrack OtherMarker λ�� NED-r λ��
	// ���б�洢���������� m_OtherMarkersN ��, ��ĩβ���룬��һ����˵��ڱ��ף� m_OtherMarkersP[0]
	vector<Point3D_t> m_OtherMarkersP; 
	// ���ٳɹ��� OtherMarker  NED-r λ�� 
	Point3D_t m_TrackedMarkerP;
	// ��ǰ���ݣ��ӿ�ʼ�ɼ�����ǰ��ʱ�� 

	// sec �޳����ӳٵ� m_fTimestamp�� �� m_fTimestamp С 0.7ms ����
	float m_fLatency;                             // host defined time delta between capture and send
	unsigned int m_Timecode;                      // SMPTE timecode (if available)
	unsigned int m_TimecodeSubframe;              // timecode sub-frame data
	// �ӿ�ʼ�ɼ�����ǰ֡��ʱ�� sec 
	double m_fTimestamp;                          // FrameGroup timestamp
	int m_mappingInertial_k;	//  ��ǰ�Ӿ����ݶ�Ӧ�Ĺ������� �ڹ����б��е����
	CVisionData_t();
	~CVisionData_t();
};

// һ��ʱ�̵Ĺ�������
class CInertialData_t
{
public:
	/// ��������

	// ���� ��Ԫ���� bvhGlobal �� Hip Bone
	QUATERNION_t m_I_HipQ;
	// ���� ��Ԫ���� bvhGlobal �� Head Bone
	QUATERNION_t m_I_HeadQ;
	// NED-w ����ϵ��Hip��λ�� m
	Point3D_t m_I_HipP;
	// NED-w ����ϵ��Head��λ�� m
	Point3D_t m_I_HeadP;
	int m_mappintVisual_k;	//  ��ǰ�������ݶ�Ӧ���Ӿ����� ���Ӿ��б��е����

	CInertialData_t();
	CInertialData_t(QUATERNION_t HipQ, Point3D_t HipP, QUATERNION_t HeadQ, Point3D_t HeadP);
	~CInertialData_t();

};

class CHybidTrack
{
	std::mutex mtx;
	// ���Ժ��Ӿ� �����ڴ濪��ʱ�� sec
	static const int  BufferTime = 60 * 2; 

	// �������ݱ�����������Ĭ��96 HZ ���ٴ洢�ռ�
	static const int  I_BufferN = BufferTime * 96;

	// �Ӿ����ݱ�����������Ĭ��30 HZ ���ٴ洢�ռ�
	static const int  V_BufferN = BufferTime * 30;

public:
	
	// �������ݵ�Ƶ�� HZ
	float m_I_Frequency;
	// �˵ĳ�ʼ����
	Point3D_t m_FaceDirection;
	// �Ӿ����ݵ�Ƶ��
	float m_V_Frequency;

	int IsBothStart;  // �Ƿ���Ժ��Ӿ�����ʼ�ɼ�; 
		// 0��û�ж���ʼ��1���Ӿ����ֶ���ʼ��2�������Ѿ�֪������ʼ

	// �ӹ���ϵͳ��ʼ�ɼ� �� �Ӿ�ϵͳ��ʼ�ɼ� ��ʱ�� sec
	// ����ͬ�����Ժ��Ӿ����ݣ�ʹ����ʱ����Թ��Կ�ʼ�ɼ�ʱ��Ϊ0.
//	double Time_Inertial_To_Vision;   // ��δ����Ϊ NaN��
	// ���㷽����ͨ����¼���Ժ��Ӿ���һ�� CallBack ʱ��win ϵͳʱ���ֵ�õ�������Ƚϴֲڣ��պ��ٸĽ�...
	// ʹ�÷��� ����Time_Inertial_To_Vision��  �������Ӿ���ʱ����� Time_Inertial_To_Vision

	// ���Ժ��Ӿ�����ʼ�ɼ�ʱ �� m_fLatency ֵ
	// ��ʵʱ�� m_fLatency-m_fLatency_StartTwo  ���Թ����Ӿ�ͬʱ������ʱ��Ϊ���
	double m_fLatency_StartTwo; 


//	SYSTEMTIME VStartT;		// �Ӿ���ʼ�ɼ�ʱ�� win ϵͳʱ��  
//	SYSTEMTIME IStartT;	// ���Կ�ʼ�ɼ�ʱ�� win ϵͳʱ��
	
	deque<CInertialData_t> InertialData;	// ֱ�Ӵӻص��еõ����ڹ�ѧ���������Ϲ��Ե��Ƶõ���ֻ������һ֡û�в�������   ���µ� �� ��ĩβ
	deque<CInertialData_t> InertialData_PurINS;	// û���κβ���ʱ��ԭʼ�Ĺ����Ӿ���ͨ��InertialData��ӵõ���
	deque<CVisionData_t> VisionData;		// ���µ� �� ��ĩβ
	int InertialData_visual_k[I_BufferN];   // �Ӿ����ݶ�ȡʱ������Ĺ������ݶ�Ӧ���Ӿ����
		
	CHybidTrack();
	~CHybidTrack();

	// �� m_fLatency ���Ƽ���Ƶ��
	void CalVisualFrequency();

	// ���´� Optitrack ���յ��� OtherMarkers ����
	void UpdateVisionData(int OtherMarkersN, float* pOtherMarkers, float fLatency, unsigned int Timecode, unsigned int TimecodeSubframe, double fTimestamp);

	// ���¹�������
	void UpdateInertialData(QUATERNION_t HipQ, Point3D_t HipP, QUATERNION_t HeadQ, Point3D_t HeadP, Vector3_t FaceDirection);
	
	// ���Ӿ��궨ʱ�����������������κ�Ҫ��ʱ����ͨ�� m_FaceDirection ���Ӿ��ĳ������������һ��
	void PreProcess_FaceDirection(  );

	// FaceDirection ��Ӧ�ķ������Ҿ���
	void FaceDirection2C( );

	// 
	BOOL IsDoCompensate;   // �Ƿ���в�����Ĭ��ֻ�ɼ����ݣ�=0��

	// MATLAB �Զ����ɺ����ĸ�ʽ  M_...
	struct0_T *M_InertialData;
	struct1_T M_otherMakers[V_BufferN];
/*	%% CalculateOrder �����ù���
	%   CalStartVN �� CalStartIN ��1��ʼ��������һʱ�̱��������� CalStartIN = CalEndINSave + 1; CalStartVN = CalStartVNSave + 1;
	%   CalEndIN ���ڻ���� CalStartVN ��  CalEndVN ���ڻ����CalStartVN	*/
	struct2_T CalculateOrder[1];
	double M_compensateRate;
	double M_InertialPositionCompensate_k[3];
	double M_InertialPositionCompensate[I_BufferN * 3];
//	double M_HipDisplacementNew[I_BufferN * 3];


	/// MATLAB ����Cpp���������������ȡ
	// �� M_InertialData �ÿ�
	void SetM_InertialData_Empty();
	// �� M_otherMakers �ÿ�
	void SetM_otherMakers_Empty();

	// �� VisionData �õ� M_otherMakers
	void Get_M_otherMakers();
	// �� InertialData ��ȡ M_InertialData
	void Get_M_InertialData();

	// ִ�� �Ӿ����� ���� ���㣬���� MATLAB �Զ����ɵĳ���
	void GetDisplacementCompensate();



	///  ֱ�Ӵ��ļ��ж�����  **********************************
	BOOL m_OffLineRead;
	FILE* m_OptStream;	
	int m_IneritalFrames;
	char *m_Opt_Path,*m_inertial_Path;

	void Read_M_otherMakers_OffLine();		// ���ļ������߶��Ӿ�����

	void Cal_m_mappingInertial_k();			// ���� m_fLatency �͹��Ե�Ƶ�ʼ��� m_mappingInertial_k

private:

};


/* M_otherMakers ���ͽ���

typedef struct
{
	double frequency;
	emxArray_real_T *Position;
	int otherMakersN;
	double time;
	emxArray_char_T *MarkerSet;
	emxArray_real_T *ContinuesFlag;
	emxArray_real_T *ContinuesLastPosition;
	emxArray_real_T *ContinuesLastTime;
	emxArray_real_T *ContinuesLastK;
} struct1_T;
#ifndef struct_emxArray_struct1_T
#define struct_emxArray_struct1_T
struct emxArray_struct1_T
{
	struct1_T *data;  

	//data Ϊ [3*N]ʱ����һ��Ϊ data[0]  data[1] data[2]
	// data Ϊ [3*N]ʱ size[0]Ϊ3��size[1]ΪN

	int *size;
	int allocatedSize;
	int numDimensions;
	boolean_T canFreeData;
};

*/


