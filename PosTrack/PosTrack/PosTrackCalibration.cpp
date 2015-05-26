#include "Definitions.h"
#include "PosTrackCalibration.h"

#include "funcs.h"

int PosTrackCalibration::BuffCount = 500;

PosTrackCalibration::PosTrackCalibration(void):	
    R(2,2)
{
	BufferedDataPercent = 0;

	freq = 96;
}


PosTrackCalibration::~PosTrackCalibration(void)
{
}


void PosTrackCalibration::ClearBuff()
{
	BufferedDataPercent = 0;

	inertiaPositionBuffer.clear();
	opticsPositionBuffer.clear();
}


void PosTrackCalibration::BufferingData(Point3D_t  iVec, Point3D_t oVec)
{
	if(inertiaPositionBuffer.size()<BuffCount)
	{
		inertiaPositionBuffer.push_back(iVec);
	}

	if(opticsPositionBuffer.size()<BuffCount)
	{
		opticsPositionBuffer.push_back(oVec);
	}

	BufferedDataPercent = opticsPositionBuffer.size()/(double)BuffCount;
}

MatrixXd PosTrackCalibration::Calculate()
{
 	// ��ȡƽ��ʸ��
    Point3D_t iPt = getLowestInertiaPoint();
    Point3D_t oPt = getLowestOpticsPoint();

    // �Թ���ϵͳ�ĵ�һ������Ϊԭ��ƽ�ƹ���ϵͳ�����е�
    Trans1 = inertiaPositionBuffer[0];
    for(int i=0; i<inertiaPositionBuffer.size(); i++)
    {
        inertiaPositionBuffer[i] = inertiaPositionBuffer[i] - Trans1;
    }


	// �Թ���ϵͳ�ĵ�һ������Ϊԭ��ƽ�ƹ�ѧϵͳ�����е㣬����ѧϵԭ���Ƶ�����ϵԭ�㲢�غ�
    Trans2 = inertiaPositionBuffer[0] - Point3D_t(opticsPositionBuffer[0].X, opticsPositionBuffer[0].Z, opticsPositionBuffer[0].Y);
    for(int i=0; i<opticsPositionBuffer.size(); i++)
    {
        // תΪXZY��洢
        opticsPositionBuffer[i] = Point3D_t(opticsPositionBuffer[i].X, opticsPositionBuffer[i].Z, opticsPositionBuffer[i].Y) + Trans2;
    }

    // ����Wahba problem�ṩ�Ľⷨ,�Ȱ�ÿ��ʱ��ɵ��������������ݹ�һ������÷�������
    int count = inertiaPositionBuffer.size();
    Matrix2d B(2,2);
    B.setZero();
    for(int i=0; i<count; i++)
    {
        double* inertPos = inertiaPositionBuffer[i].ToDouble().get();
        double* opticPos = opticsPositionBuffer[i].ToDouble().get();

        Vector2d tmp1(inertPos[0], inertPos[1]);
        RowVector2d tmp2(opticPos[0], opticPos[1]);

       // B = B +  Vector2d(inertPos[0], inertPos[1]) * RowVector2d(opticPos[0], opticPos[1]);  // inert(x y)  optic(x y)
        B = B + tmp1 * tmp2;
    }
    B.transposeInPlace();
    PrintMatrix(B.data(), B.rows(), B.cols(), "B");

    Matrix2d M;
    M.setZero();
    Matrix2d S;
    S.setZero();
    Matrix2d U, VH;
    U.setZero();
    VH.setZero();
    
	// �ֿ˲�svd�ֽ�
    JacobiSVD<MatrixXd> svd(B, ComputeFullU | ComputeThinV);
    
	// ȡ��U��V
    U = svd.matrixU();
    VH = svd.matrixV();

    Vector2d v = svd.singularValues();
    S.diagonal() = v;

    M(0,0) = 1;
    M(1,1) = U.determinant() * VH.determinant();

	// �õ���ѧϵ������ϵ����ת����
    R = U * M * VH.transpose();
	
	return R;
}

Point3D_t PosTrackCalibration::getLowestInertiaPoint()
{
	int lowestIndex = 0;
	Point3D_t lowestPt;
	double lowestZ = 99999999;
	for(int i=0; i<inertiaPositionBuffer.size(); i++)
	{
		if(lowestZ>inertiaPositionBuffer[i].Z)
		{
			lowestZ = inertiaPositionBuffer[i].Z;
			lowestPt = inertiaPositionBuffer[i];
		}
	}

	return lowestPt;
}

Point3D_t PosTrackCalibration::getLowestOpticsPoint()
{
	int lowestIndex = 0;
	Point3D_t lowestPt;
	double lowestZ = 99999999;
	for(int i=0; i<opticsPositionBuffer.size(); i++)
	{
		if(lowestZ>opticsPositionBuffer[i].Z)
		{
			lowestZ = opticsPositionBuffer[i].Z;
			lowestPt = opticsPositionBuffer[i];
		}
	}

	return lowestPt;
}