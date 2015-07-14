// 2015.7.9 xyz NOITOM
#pragma onece
#include <Eigen/Dense>
#include <Eigen/StdDeque>
#include <deque>

using namespace Eigen;
using namespace std;

#define MaxJointN 6			// ��ʶ��Ĺ��Խڵ���� ���ֵ
/*
һ��ʱ�����й��Խڵ�������Ͼ���һ��Ϊһ���ڵ�
*/
typedef Matrix<double, 3, MaxJointN> AllJoints_k;

// ������˵�ʶ��� ��������
class CINSData_Hybid
{
public:
	CINSData_Hybid(double frequency, int JointN);
	~CINSData_Hybid();
	void UpdateAcc(double* Acc_k_Arry, int JointN);

	double m_frequency;		// �������ݵ�Ƶ��
private:
	
	int m_JointN;
	const double m_BufferTime = 3;		// ���ݻ���ʱ�䳤��
	int m_BufferN;
	/*
	���йؽڵ㣬����������ʱ�䳤���ڵ� ��ؼ��ٶ�
	*/
	std::deque<AllJoints_k, Eigen::aligned_allocator<AllJoints_k>> Acc;
};
