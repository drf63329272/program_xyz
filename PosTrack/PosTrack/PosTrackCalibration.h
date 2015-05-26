#pragma once

#include "Eigen"
using namespace Eigen;

class PosTrackCalibration
{
	vector<Point3D_t> inertiaPositionBuffer;
	vector<Point3D_t> opticsPositionBuffer;

	static int BuffCount;

	// ��ȡУ׼ʱ���¶���͵�
	Point3D_t getLowestInertiaPoint();
	Point3D_t getLowestOpticsPoint();

	Point3D_t caliPosition;

	// ����ϵ����Ƶ��
	int freq;

public:
	PosTrackCalibration(void);
	~PosTrackCalibration(void);

	// ���У׼����
	void ClearBuff();

	// ����У׼���ݣ�iVec: ����ϵͳλ��ʸ����oVec: ��ѧλ��ʸ��
	void BufferingData(Point3D_t iVec, Point3D_t oVec);

	// ��������ݰٷֱ�
	double BufferedDataPercent;

	// У׼���㣬���ع�ѧϵͳת��������ϵͳ����ת
	MatrixXd Calculate();

	// ����ϵ�����ƽ��ʸ��
    Point3D_t Trans1;

	// ��ѧϵ������ϵ��ƽ��ʸ��
	Point3D_t Trans2;

	// ��ѧϵͳת��������ϵͳ����ת����
	MatrixXd R;
};

