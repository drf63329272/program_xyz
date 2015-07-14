// EigenStudy.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"

#include <Eigen/Dense>
#include <iostream>

using namespace Eigen;
using namespace std;

int _tmain(int argc, _TCHAR* argv[])
{
	MatrixXd m(2,3);
	m << 1, 2, 3, 4, 5, 6;
	cout << m << endl<<endl;
	m.conservativeResize(3, 2);

	m.setIdentity();
	cout << m << endl;

	return 0;
}

