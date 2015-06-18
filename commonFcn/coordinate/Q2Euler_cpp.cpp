
// ��Ԫ��תŷ����
inline Point3D_t QuatToAng(RotateOrders rotateOrder, QUATERNION_t quat, bool useCompensation = false, int boneIndex=-1)
{
	//Quart: ��Ԫ�� [x,y,z,w]
	//�����ϵΪt��tx��ty,tz��

	double w = quat.qs;
	double x0 = quat.qy;
	double y0 = quat.qz;
	double z0 = quat.qx;
	//��t'ϵΪ��tx'��ty',tz'��=��ty��tz,tx��
	// ZYXŷ���� -> YZXŷ����

	int Flag = 1;

	double x(0), y(0), z(0);
	if (rotateOrder == RO_XZY)      
	{	//t'ϵ
		x = x0;
		y = y0;
		z = z0;  // XZY  ��֤OK
	}
	else if (rotateOrder == RO_YXZ) 
	{
		x = y0;	// x = qz ;
		y = z0;	// y = qx ;
		z = x0;	// z = qy ;   // ��֤OK
	}
	else if (rotateOrder == RO_XYZ) 
	{
		x = x0;
		y = -z0;
		z = y0;

		//xyz
		x = -quat.qz;
		y = quat.qy;
		z = quat.qx;
		Flag = -1;
	}
	else if (rotateOrder == RO_YZX) 
	{
		x = y0;
		y = -x0;
		z = z0;

		//xyz
		x = -z0;
		y = y0;
		z = x0;
		Flag = -1;
	}
	else if (rotateOrder == RO_ZXY) 
	{
		x = z0;
		y = -y0;
		z = x0;

		//xyz
		x = -quat.qy;
		y = quat.qx;
		z = quat.qz;
		Flag = -1;
	}
	else if (rotateOrder == RO_ZYX) 
	{
		x = z0; // x = qx ;
		y = x0; // y = qy ;
		z = y0; // z = qz ;  // OK
	}
	else
	{
		printf("unknown order\n");
	}

	// ��Ԫ��->ZYXŷ���� ת����ʽ
	double az = 2 * (w*y - z*x);
	if (az > 1) az = 1;
	if (az < -1) az = -1;

	double axy = 2 * (w*z + x*y);
	double axx = 1 - 2 * (y*y + z*z);

	double ayy = 2 * (w*x + y*z)*Flag;
	double ayx = 1 - 2 * (x*x + y*y);

	//if (useCompensation)
	//{
	//	double angX = atan3(axy, axx); //��Z��ת��
	//	double angY = atan3(ayy, ayx); //��X��ת��
	//	double angZ = asin(az);        //��Y��ת��	

	//	Point3D_t angle(angX, angZ, angY);
	//	angle *= PIdiv;                  // ����ת��
	//	
	//	if (boneIndex == 35)
	//	{
	//		printf("%0.3f %0.3f atan2:%0.3f  atan3:%0.3f | %0.3f atan:%0.3f\n", axy, axx, atan2(axy, axx)*PIdiv, angle.X, axy / axx, atan(axy / axx)*PIdiv);
	//	}

	//	return angle;
	//}
	
	double angX = atan2(axy, axx); //��Z��ת��
	double angY = atan2(ayy, ayx); //��X��ת��
	double angZ = asin(az);        //��Y��ת��	
	
	//double angX = atan3(axy, axx); //��Z��ת��
	//double angY = atan3(ayy, ayx); //��X��ת��
	//double angZ = asin(az);        //��Y��ת��	

	Point3D_t angle(angX, angZ, angY);
	angle *= PIdiv;                  // ����ת��

	return angle;
}
