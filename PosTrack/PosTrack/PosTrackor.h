#ifndef POSTRACKOR_H
#define POSTRACKOR_H

#ifdef POSTRACK_EXPORTS
#define POSTRACK_API __declspec(dllexport)
#else
#define POSTRACK_API __declspec(dllimport)
#endif

#include "NatNetDataHandler.h"
#include "Definitions.h"
#include "Eigen"
using namespace Eigen;

class NatNetConnector;
class PosTrackCalibration;

typedef void (CALLBACK* RecievePosTrackorHandle)(void * pOwner, float* data);
typedef void (CALLBACK* RecieveOtherMarkHandle)(void * pOwner, float* otherMarkData, int nOtherMarkers, float fLatency, unsigned int Timecode, unsigned int TimecodeSubframe, double fTimestamp);
class POSTRACK_API PosTrackor : public NatNetDataHandler
{
	RecievePosTrackorHandle recievePostrackHandle;
	void* pOwner;
	RecieveOtherMarkHandle recieveOtherMarkHandle;
	void* pOtherMarkOwner;

	NatNetConnector* connector;
	PosTrackCalibration* cali;
	
	Point3D_t CalibratedPos;

	// ��ѧϵͳ��õ�ʵʱλ��
	Point3D_t OpticsPosition;

	//void DataHandle(RigidBodyData* data);
	void DataHandle(sFrameOfMocapData* data);
	
public:
	PosTrackor(void);
	~PosTrackor(void);

	//////////////////////////////////////////////////////////////////////////
    FILE* filePos;
	BOOL Init();
	BOOL ConnectTo(char* ip, int port);
	void Disconnect();
	BOOL IsEnabled();
	void Release();
	
	BOOL IsCalibrating;
	BOOL IsCalibrated;
	void SetToStartCalibration();    
	void SetRecievePosTrackHandle(void* pOwner, RecievePosTrackorHandle handle);
	void SetRecieveOtherMarkHandle(void* pOwner, RecieveOtherMarkHandle handle); 
	// ����������ĵ�ַ��ֵ������һ���ط�������������塣��ǰ����ֻ�ṩ����
	//////////////////////////////////////////////////////////////////////////


    //////////////////////////////////////////////////////////////////////////
	void AddCalibrationData(Point3D_t inertiaPosition);    
    // add��ѧ����
    void AddCalibrationData(float* inertiaPosition);

    double GetCalibrationPercent();	

	// ����ϵ�����ƽ��ʸ��
	Point3D_t Trans1;

	// ��ѧϵ������ϵ��ƽ��ʸ��
	Point3D_t Trans2;

	// ��ѧϵͳת��������ϵͳ����ת����
	MatrixXd R;
	//////////////////////////////////////////////////////////////////////////
};

#endif
