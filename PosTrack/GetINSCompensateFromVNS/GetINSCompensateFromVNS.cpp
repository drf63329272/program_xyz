//
// File: GetINSCompensateFromVNS.cpp
//
// MATLAB Coder version            : 2.6
// C/C++ source code generated on  : 18-Jun-2015 20:22:25
//

// Include files
#include "stdafx.h"
#include "rt_nonfinite.h"
#include "GetINSCompensateFromVNS.h"

// Type Definitions
typedef struct {
  double Min_xyNorm_Calib;
  double MaxTime_Calib;
  double MaxVXY_DirectionChange_Calib;
  double MaxVZ_Calib;
  double MinVXY_Calib;
  double angleUniformityErr;
  double dT_CalV_Calib;
  double MinXYVNorm_CalAngle;
} b_struct_T;

#ifndef struct_emxArray_real_T_3x10
#define struct_emxArray_real_T_3x10

struct emxArray_real_T_3x10
{
  double data[30];
  int size[2];
};

#endif                                 //struct_emxArray_real_T_3x10

#ifndef struct_sCT3MgJe6M19Lmo8bDuzmRE
#define struct_sCT3MgJe6M19Lmo8bDuzmRE

struct sCT3MgJe6M19Lmo8bDuzmRE
{
  double frequency;
  emxArray_real_T_3x10 Position;
  int otherMakersN;
  double time;
  int inertial_k;
  signed char MarkerSet;
  double trackedMakerPosition[3];
  double ContinuesFlag[10];
  double ContinuesLastPosition[30];
  double ContinuesLastTime[10];
  double ContinuesLastK[10];
  unsigned char CalculatedTime;
};

#endif                                 //struct_sCT3MgJe6M19Lmo8bDuzmRE

typedef sCT3MgJe6M19Lmo8bDuzmRE c_struct_T;
typedef struct {
  double dPi_ConJudge;
  double dPError_dT_xy;
  double dPError_dT_z;
  double dPError_dS_xyNorm;
  double dP_Inertial_xyNorm;
  double angleErr_dS;
  double angleErr_dT_Min;
  double INSVNSMarkHC_Min;
} d_struct_T;

#ifndef struct_emxArray__common
#define struct_emxArray__common

struct emxArray__common
{
  void *data;
  int *size;
  int allocatedSize;
  int numDimensions;
  boolean_T canFreeData;
};

#endif                                 //struct_emxArray__common

#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  double *data;
  int *size;
  int allocatedSize;
  int numDimensions;
  boolean_T canFreeData;
};

#endif                                 //struct_emxArray_real_T

typedef struct {
  double moveTime;
  double MaxMoveTime;
  double moveDistance;
  double MaxContinuesDisplacement;
  double PositionErrorBear_dT;
  double ContinuesTrackedMagnifyRate;
  double MaxStaticDisp_dT;
  double MaxPositionError_dS;
  double Max_dPAngle_dS;
  double MaxMarkHighChange;
  double MaxHighMoveErrRate[2];
  double BigHighMove;
  double INSMarkH0;
  double VNSMarkH0;
} struct_T;

// Named Constants
#define b_CalStartVN                   (1)
#define b_CalEndVN                     (1)
#define b_CalStartIN                   (1)
#define b_CalEndIN                     (1)
#define b_inertialFre                  (96.0)
#define b_visionFre                    (30.0)
#define b_IsGetFirstMarker             (0.0)

// Variable Definitions
static int CalStartVN;
static int CalEndVN;
static int CalStartIN;
static int CalEndIN;
static double VisionData_inertial_k[3600];
static double inertialFre;
static double InertialData_visual_k[11520];
static double visionFre;
static double InertialPositionCompensate[34560];
static boolean_T c_InertialPositionCompensate_no;
static double InertialPositionNew[34560];
static double HipDisplacementNew[34560];
static double InertialErr[23040];
static struct_T makerTrackThreshold;
static boolean_T makerTrackThreshold_not_empty;
static b_struct_T INSVNSCalibSet;
static double c_trackedMakerPosition_Inertial[34560];
static double trackedMakerPosition[10800];
static double trackedMarkerVelocity[18000];
static double INSVNSCalib_VS_k[100];
static double Calib_N_New;
static double IsCalibDataEnough;
static double Crw[9];
static double IsGetFirstMarker;

// Function Declarations
static void CalVelocity(const double b_Position[10800], int data_k, double fre,
  double Velocity_k_data[], int Velocity_k_size[1], int *k_calV);
static void CalibDataDistanceJudge(const double b_trackedMakerPosition[10800],
  int search_k_start, double search_k_end, double *IsCalibDataDistanceOK, double
  *dX_xyNorm_VS);
static double CalibDataVelocityJudge(const double trackedMarkerVelocity_k[5]);
static void CompensateSecond(struct1_T *otherMakersNew_k, const double b_Crw[9]);
static double ContinuesJudge(struct1_T *otherMakers_k, const double
  c_otherMakers_k_last_Position_d[], const int c_otherMakers_k_last_Position_s[2],
  int otherMakers_k_last_otherMakersN, double otherMakers_k_last_time, const
  double c_otherMakers_k_last_ContinuesF[10], const double
  c_otherMakers_k_last_ContinuesL[30], const double
  d_otherMakers_k_last_ContinuesL[10], const double
  e_otherMakers_k_last_ContinuesL[10], const double b_trackedMakerPosition[10800],
  int k_vision, double c_makerTrackThreshold_MaxContin);
static void GetEmpty_otherMakers(double otherMakers_k_time, int
  otherMakers_k_inertial_k, signed char otherMakers_k_MarkerSet, const double
  c_otherMakers_k_trackedMakerPos[3], const double otherMakers_k_ContinuesFlag
  [10], const double c_otherMakers_k_ContinuesLastPo[30], const double
  otherMakers_k_ContinuesLastTime[10], const double
  otherMakers_k_ContinuesLastK[10], unsigned char otherMakers_k_CalculatedTime,
  c_struct_T *otherMakersEmpty);
static void GetRightOtherMaker(struct1_T otherMakers[3600], const double
  InertialPosition[34560], double d_trackedMakerPosition_Inertial[34560]);
static void GetRightOtherMaker_init();
static void INSVNSCalib(const double b_INSVNSCalib_VS_k[100], double
  b_Calib_N_New, const double dX_Vision_data[], const int dX_Vision_size[2],
  const double InertialPosition[34560], double b_Crw[9]);
static void JudgeIsCalibDataEnough(const double b_INSVNSCalib_VS_k[100], double
  b_Calib_N_New, const double b_trackedMakerPosition[10800], double
  *IsCalibDataVelocityOK, double dX_Vision_data[], int dX_Vision_size[2]);
static void JudgeMaker(struct1_T *otherMakers_k, const double
  c_otherMakers_k_last_Position_d[], const int c_otherMakers_k_last_Position_s[2],
  int otherMakers_k_last_otherMakersN, double otherMakers_k_last_time, const
  double c_otherMakers_k_last_ContinuesF[10], const double
  c_otherMakers_k_last_ContinuesL[30], const double
  d_otherMakers_k_last_ContinuesL[10], const double
  e_otherMakers_k_last_ContinuesL[10], int k_vision, int b_inertial_k, const
  double b_trackedMakerPosition[10800], const double InertialPosition[34560],
  int inertial_dT_k_last, const struct_T *b_makerTrackThreshold, double
  trackedMakerPosition_k_OK_data[], int trackedMakerPosition_k_OK_size[1],
  double *TrackFlag, d_struct_T *JudgeIndex);
static void PreProcess(struct1_T otherMakers[3600]);
static void SearchCalibData(double b_INSVNSCalib_VS_k[100], double Calib_N_Last,
  const double b_trackedMarkerVelocity[18000], const double
  b_trackedMakerPosition[10800], int vision_k, double *b_Calib_N_New, double
  *b_IsCalibDataEnough, double dX_Vision_data[], int dX_Vision_size[2]);
static void SetParameters(double *makerTrackThreshold_moveTime, double
  *makerTrackThreshold_MaxMoveTime, double *c_makerTrackThreshold_moveDista,
  double *c_makerTrackThreshold_MaxContin, double
  *c_makerTrackThreshold_PositionE, double *c_makerTrackThreshold_Continues,
  double *c_makerTrackThreshold_MaxStatic, double
  *c_makerTrackThreshold_MaxPositi, double *c_makerTrackThreshold_Max_dPAng,
  double *c_makerTrackThreshold_MaxMarkHi, double
  c_makerTrackThreshold_MaxHighMo[2], double *makerTrackThreshold_BigHighMove,
  double *makerTrackThreshold_INSMarkH0, double *makerTrackThreshold_VNSMarkH0,
  b_struct_T *b_INSVNSCalibSet);
static void Track_dT_Judge(const double otherMakers_k_Position[30], const double
  otherMakers_k_ContinuesFlag[10], const double InertialPosition[34560], int
  b_inertial_k, int inertial_dT_k_last, const double
  trackedMakerPosition_last_k_dT[3], const double
  c_makerTrackThreshold_MaxHighMo[2], double trackedMakerPosition_k_OK_data[],
  int trackedMakerPosition_k_OK_size[1], double *TrackFlag, double *min_dT_k,
  double *dPErrorNorm_dT_Min, double *dPError_dT_z_Min, double
  *dP_Inertial_xyNorm_Min, double *b_angleErr_dT_Min);
static void VNSCompensateINS(double compensateRate, const double
  d_trackedMakerPosition_Inertial[34560], const double HipDisplacement[34560],
  const double InertialPosition[34560], double InertialPositionCompensate_out
  [34560], double HipDisplacementNew_out[34560]);
static void VNSCompensateINS_init();
static void b_fix(double *x);
static double b_normest(const double S[2]);
static void eml_lusolve(const double A_data[], double B_data[], int B_size[2]);
static double eml_matlab_zlarfg(int n, double *alpha1, double x_data[], int ix0);
static void eml_qrsolve(const double A_data[], const int A_size[2], double
  B_data[], int B_size[2], double Y[4]);
static double eml_xnrm2(int n, const double x_data[], int ix0);
static void emxEnsureCapacity(emxArray__common *emxArray, int oldNumel, int
  elementSize);
static void emxFree_real_T(emxArray_real_T **pEmxArray);
static void emxInit_real_T(emxArray_real_T **pEmxArray, int b_numDimensions);
static double normest(const double S[3]);
static void repmat(const double a[3], int varargin_2, emxArray_real_T *b);
static double rt_hypotd_snf(double u0, double u1);
static double rt_roundd_snf(double u);

// Function Definitions

//
// �ٶȼ���Ĳ�������
// Arguments    : const double b_Position[10800]
//                int data_k
//                double fre
//                double Velocity_k_data[]
//                int Velocity_k_size[1]
//                int *k_calV
// Return Type  : void
//
static void CalVelocity(const double b_Position[10800], int data_k, double fre,
  double Velocity_k_data[], int Velocity_k_size[1], int *k_calV)
{
  double dN_CalV;
  double angleXY;
  int i2;
  double d0;
  int b_k_calV;
  int c_k_calV;
  double Position1[3];
  double Position2[3];
  double Position1_data[5];

  // % xyz 2015.6.1
  // % ����ĳ������ٶ�
  // % �õ� �� k �����λ�ú󣬼�����ǵ� k_calV ������ٶȣ� k_calV = data_k-dN_CalV ;�� 
  //  dT_CalV�� �ٶȼ��㲽��
  //   V(k) = (X(k+dN_CalV) - X(k-dN_CalV)) / (dT_CalV*2)
  //  fre�� Ƶ��
  //  dT_CalV�� �ٶȼ���Ĳ���ʱ��
  // % Velocity_k
  //  Velocity_k(1:3,1) : xyz��ά���ٶ�
  //  Velocity_k(4,1) : xyƽ���ٶȵ�ģ
  //  Velocity_k(5,1) : xyƽ���ٶ�����ǰ��֮��ļнǣ�ģ����0.2m/sʱ�ż��㣩
  dN_CalV = 0.1 * fre;
  if (dN_CalV < 0.0) {
    dN_CalV = ceil(dN_CalV);
  } else {
    dN_CalV = floor(dN_CalV);
  }

  if (dN_CalV >= 2.0) {
  } else {
    dN_CalV = 2.0;
  }

  if (dN_CalV <= 7.0) {
  } else {
    dN_CalV = 7.0;
  }

  angleXY = rtNaN;
  Velocity_k_size[0] = 5;
  for (i2 = 0; i2 < 5; i2++) {
    Velocity_k_data[i2] = rtNaN;
  }

  // % �����ٶȣ�
  //  ����� k_calV �������ٶȣ��� [ k_calV-dN_CalV, k_calV+dN_CalV  ] ��һ������ 
  //  �õ� data_k ���ݺ󣬼���� data_k-dN_CalV �������ٶ�
  d0 = rt_roundd_snf((double)data_k - dN_CalV);
  if (d0 >= -2.147483648E+9) {
    *k_calV = (int)d0;
  } else {
    *k_calV = MIN_int32_T;
  }

  d0 = rt_roundd_snf((double)*k_calV - dN_CalV);
  if (d0 >= -2.147483648E+9) {
    i2 = (int)d0;
  } else {
    i2 = MIN_int32_T;
  }

  if (i2 < 1) {
  } else {
    d0 = rt_roundd_snf((double)*k_calV + dN_CalV);
    if (d0 < 2.147483648E+9) {
      i2 = (int)d0;
    } else {
      i2 = MAX_int32_T;
    }

    if (i2 > 3600) {
    } else {
      d0 = rt_roundd_snf((double)*k_calV + dN_CalV);
      if (d0 < 2.147483648E+9) {
        b_k_calV = (int)d0;
      } else {
        b_k_calV = MAX_int32_T;
      }

      d0 = rt_roundd_snf((double)*k_calV - dN_CalV);
      if (d0 >= -2.147483648E+9) {
        c_k_calV = (int)d0;
      } else {
        c_k_calV = MIN_int32_T;
      }

      for (i2 = 0; i2 < 3; i2++) {
        Position1[i2] = b_Position[i2 + 3 * (b_k_calV - 1)];
        Position2[i2] = b_Position[i2 + 3 * (c_k_calV - 1)];
      }

      d0 = rt_roundd_snf((double)*k_calV + dN_CalV);
      if (d0 < 2.147483648E+9) {
        i2 = (int)d0;
      } else {
        i2 = MAX_int32_T;
      }

      if (rtIsNaN(b_Position[3 * (i2 - 1)])) {
      } else {
        d0 = rt_roundd_snf((double)*k_calV - dN_CalV);
        if (d0 >= -2.147483648E+9) {
          i2 = (int)d0;
        } else {
          i2 = MIN_int32_T;
        }

        if (rtIsNaN(b_Position[3 * (i2 - 1)])) {
        } else {
          //  xyz��ά���ٶ�
          for (i2 = 0; i2 < 3; i2++) {
            dN_CalV = Position1[i2] - Position2[i2];
            Position1[i2] = dN_CalV;
            Position2[i2] = dN_CalV / 0.2;
          }

          //  �����д洢xyƽ���ٶȵ�ģ
          dN_CalV = b_normest(*(double (*)[2])&Position2[0]);

          //  �����д洢xyƽ���ٶ�����ǰ��֮��ļнǣ�ģ����0.2m/sʱ�ż��㣩
          if (dN_CalV > 0.1) {
            for (i2 = 0; i2 < 3; i2++) {
              Position1_data[i2] = Position1[i2] / 0.2;
            }

            d0 = 0.0;
            for (i2 = 0; i2 < 2; i2++) {
              d0 += (double)i2 * Position1_data[i2];
            }

            angleXY = acos(d0 / dN_CalV);
            if (Position2[0] > 0.0) {
              angleXY = -angleXY;
            }
          }

          Velocity_k_size[0] = 5;
          for (i2 = 0; i2 < 3; i2++) {
            Velocity_k_data[i2] = Position2[i2];
          }

          Velocity_k_data[3] = dN_CalV;
          Velocity_k_data[4] = angleXY;
        }
      }
    }
  }
}

//
// % ��ֵ��������
// Arguments    : const double b_trackedMakerPosition[10800]
//                int search_k_start
//                double search_k_end
//                double *IsCalibDataDistanceOK
//                double *dX_xyNorm_VS
// Return Type  : void
//
static void CalibDataDistanceJudge(const double b_trackedMakerPosition[10800],
  int search_k_start, double search_k_end, double *IsCalibDataDistanceOK, double
  *dX_xyNorm_VS)
{
  double dX_xy_VS[3];
  int i3;

  // % �жϴ� search_k_start �� search_k_end ����һ��λ�Ƴ����Ƿ񹻳�
  //  m  ���ڱ궨�����ݵ���С�˶�λ�Ƴ���
  for (i3 = 0; i3 < 3; i3++) {
    dX_xy_VS[i3] = b_trackedMakerPosition[i3 + 3 * ((int)search_k_end - 1)] -
      b_trackedMakerPosition[i3 + 3 * (search_k_start - 1)];
  }

  dX_xy_VS[2] = 0.0;
  *dX_xyNorm_VS = normest(dX_xy_VS);
  if (*dX_xyNorm_VS > 0.3) {
    *IsCalibDataDistanceOK = 1.0;
  } else {
    //  λ�Ƴ���̫��
    *IsCalibDataDistanceOK = 0.0;
  }
}

//
// % ��ֵ��������
// Arguments    : const double trackedMarkerVelocity_k[5]
// Return Type  : double
//
static double CalibDataVelocityJudge(const double trackedMarkerVelocity_k[5])
{
  double IsCalibDataVelocityOK;

  // % �жϴ� search_k_start �� search_k_end ����һ���ٶ��Ƿ���������
  //  1�� �ٶ�zģС�� MaxVZ_Calib
  //  2�� �ٶ�xyģ���� MinVXY_Calib
  //  m/s Z�����ٶ�������ֵ
  //  m/s XY ƽ���ٶ�ģ��С����ֵ
  IsCalibDataVelocityOK = 0.0;
  if (rtIsNaN(trackedMarkerVelocity_k[0]) || (fabs(trackedMarkerVelocity_k[2]) >
       0.1) || (trackedMarkerVelocity_k[3] < 0.2)) {
  } else {
    IsCalibDataVelocityOK = 1.0;
  }

  return IsCalibDataVelocityOK;
}

//
// Arguments    : struct1_T *otherMakersNew_k
//                const double b_Crw[9]
// Return Type  : void
//
static void CompensateSecond(struct1_T *otherMakersNew_k, const double b_Crw[9])
{
  int i22;
  int loop_ub;
  int cr;
  double C_data[30];
  int ic;
  int br;
  int ar;
  int ib;
  int ia;

  // ��otherMakers(k).time
  // ��otherMakers(k).MarkerSet
  if (1 > otherMakersNew_k->otherMakersN) {
    i22 = 0;
  } else {
    i22 = otherMakersNew_k->otherMakersN;
  }

  loop_ub = 3 * (signed char)i22;
  for (cr = 0; cr < loop_ub; cr++) {
    C_data[cr] = 0.0;
  }

  if (i22 == 0) {
  } else {
    loop_ub = 3 * (i22 - 1);
    for (cr = 0; cr <= loop_ub; cr += 3) {
      for (ic = cr + 1; ic <= cr + 3; ic++) {
        C_data[ic - 1] = 0.0;
      }
    }

    br = 0;
    for (cr = 0; cr <= loop_ub; cr += 3) {
      ar = -1;
      for (ib = br; ib + 1 <= br + 3; ib++) {
        if (otherMakersNew_k->Position[ib % 3 + 3 * (ib / 3)] != 0.0) {
          ia = ar;
          for (ic = cr; ic + 1 <= cr + 3; ic++) {
            ia++;
            C_data[ic] += otherMakersNew_k->Position[ib % 3 + 3 * (ib / 3)] *
              b_Crw[ia];
          }
        }

        ar += 3;
      }

      br += 3;
    }
  }

  loop_ub = (signed char)i22;
  for (i22 = 0; i22 < loop_ub; i22++) {
    for (cr = 0; cr < 3; cr++) {
      otherMakersNew_k->Position[cr + 3 * i22] = C_data[cr + 3 * i22];
    }
  }
}

//
// ǰһʱ�̸��ٳɹ�ʱ��������ǰ���Ƿ���Ը��ٳɹ��ĵ�������  Continues = 1
//  ǰһʱ�̸���ʧ��ʱ��������ǰÿ�����Ƿ�Ϊ������Ľ��,�Ҽ�¼�Ÿ�������������ǰ���磨��������dT���ĵ��λ�ú�ʱ�䡣
//         Continues = 2 ��
// Arguments    : struct1_T *otherMakers_k
//                const double c_otherMakers_k_last_Position_d[]
//                const int c_otherMakers_k_last_Position_s[2]
//                int otherMakers_k_last_otherMakersN
//                double otherMakers_k_last_time
//                const double c_otherMakers_k_last_ContinuesF[10]
//                const double c_otherMakers_k_last_ContinuesL[30]
//                const double d_otherMakers_k_last_ContinuesL[10]
//                const double e_otherMakers_k_last_ContinuesL[10]
//                const double b_trackedMakerPosition[10800]
//                int k_vision
//                double c_makerTrackThreshold_MaxContin
// Return Type  : double
//
static double ContinuesJudge(struct1_T *otherMakers_k, const double
  c_otherMakers_k_last_Position_d[], const int c_otherMakers_k_last_Position_s[2],
  int otherMakers_k_last_otherMakersN, double otherMakers_k_last_time, const
  double c_otherMakers_k_last_ContinuesF[10], const double
  c_otherMakers_k_last_ContinuesL[30], const double
  d_otherMakers_k_last_ContinuesL[10], const double
  e_otherMakers_k_last_ContinuesL[10], const double b_trackedMakerPosition[10800],
  int k_vision, double c_makerTrackThreshold_MaxContin)
{
  double b_dPi_ConJudge;
  int i17;
  emxArray_real_T *dPiNorm;
  emxArray_real_T *r0;
  double trackedMakerPosition_kLast[3];
  int loop_ub;
  int ixstart;
  double dPi_data[30];
  int itmp;
  boolean_T exitg2;
  int i;
  boolean_T exitg1;

  // % ��˵��������ж�
  //  dPi_ConJudge �� �������ж�ָ��Ĵ�С��ǰ����֡��λ��ģ
  //  ContinuesFlag = 0   ������
  //                =1    ��������������ٳɹ���˵�����
  //                =2   �������͸���ʧ�ܵĵ�����
  //  global inertialFre visionFre  moveDistance
  //  ��¼ÿ����˵����������
  for (i17 = 0; i17 < 10; i17++) {
    otherMakers_k->ContinuesFlag[i17] = 0.0;
  }

  //  ������
  for (i17 = 0; i17 < 30; i17++) {
    otherMakers_k->ContinuesLastPosition[i17] = rtNaN;
  }

  for (i17 = 0; i17 < 10; i17++) {
    otherMakers_k->ContinuesLastTime[i17] = rtNaN;
  }

  b_dPi_ConJudge = rtNaN;
  emxInit_real_T(&dPiNorm, 2);
  emxInit_real_T(&r0, 2);
  if (k_vision > 1) {
    if (!rtIsNaN(b_trackedMakerPosition[3 * (k_vision - 2)])) {
      //         %% ֻ�жϵ�ǰ��˵��Ƿ���ǰʱ�̸��ٳɹ�����˵�����
      for (i17 = 0; i17 < 3; i17++) {
        trackedMakerPosition_kLast[i17] = b_trackedMakerPosition[i17 + 3 *
          (k_vision - 2)];
      }

      if (1 > otherMakers_k->otherMakersN) {
        loop_ub = 0;
      } else {
        loop_ub = otherMakers_k->otherMakersN;
      }

      repmat(trackedMakerPosition_kLast, otherMakers_k->otherMakersN, r0);
      for (i17 = 0; i17 < loop_ub; i17++) {
        for (ixstart = 0; ixstart < 3; ixstart++) {
          dPi_data[ixstart + 3 * i17] = otherMakers_k->Position[ixstart + 3 *
            i17] - r0->data[ixstart + r0->size[0] * i17];
        }
      }

      i17 = dPiNorm->size[0] * dPiNorm->size[1];
      dPiNorm->size[0] = 1;
      dPiNorm->size[1] = otherMakers_k->otherMakersN;
      emxEnsureCapacity((emxArray__common *)dPiNorm, i17, (int)sizeof(double));
      loop_ub = otherMakers_k->otherMakersN;
      for (i17 = 0; i17 < loop_ub; i17++) {
        dPiNorm->data[i17] = 0.0;
      }

      for (ixstart = 0; ixstart + 1 <= otherMakers_k->otherMakersN; ixstart++) {
        dPiNorm->data[ixstart] = normest(*(double (*)[3])&dPi_data[3 * ixstart]);
      }

      ixstart = 1;
      b_dPi_ConJudge = dPiNorm->data[0];
      itmp = 0;
      if (dPiNorm->size[1] > 1) {
        if (rtIsNaN(dPiNorm->data[0])) {
          loop_ub = 1;
          exitg2 = false;
          while ((!exitg2) && (loop_ub + 1 <= dPiNorm->size[1])) {
            ixstart = loop_ub + 1;
            if (!rtIsNaN(dPiNorm->data[loop_ub])) {
              b_dPi_ConJudge = dPiNorm->data[loop_ub];
              itmp = loop_ub;
              exitg2 = true;
            } else {
              loop_ub++;
            }
          }
        }

        if (ixstart < dPiNorm->size[1]) {
          while (ixstart + 1 <= dPiNorm->size[1]) {
            if (dPiNorm->data[ixstart] < b_dPi_ConJudge) {
              b_dPi_ConJudge = dPiNorm->data[ixstart];
              itmp = ixstart;
            }

            ixstart++;
          }
        }
      }

      if (b_dPi_ConJudge < c_makerTrackThreshold_MaxContin) {
        //          trackedMakerPosition_k_OK = otherMakersPosition_k(:,m) ;
        //          TrackFlag = 1;
        //          fprintf('��˵�������λ��=%0.4f������OK \n',Min_otherMakersPosition_k_Dis_Norm); 
        otherMakers_k->ContinuesFlag[itmp] = 1.0;

        //  ��������������ٳɹ���˵�����
        for (i17 = 0; i17 < 3; i17++) {
          otherMakers_k->ContinuesLastPosition[i17 + 3 * itmp] =
            trackedMakerPosition_kLast[i17];
        }

        otherMakers_k->ContinuesLastTime[itmp] = otherMakers_k_last_time;
        otherMakers_k->ContinuesLastK[itmp] = (double)k_vision - 1.0;
      }
    } else {
      //         %% �жϵ�ǰ��˵��Ƿ�Ϊ������˵㣬��¼ÿ�����Ӧ�����磨��������dT�������� 
      if (otherMakers_k_last_otherMakersN == 0) {
        //  ��ʱ������˵�
        for (i = 0; i + 1 <= otherMakers_k->otherMakersN; i++) {
          otherMakers_k->ContinuesFlag[i] = 0.0;

          //  ������
          for (i17 = 0; i17 < 3; i17++) {
            otherMakers_k->ContinuesLastPosition[i17 + 3 * i] = rtNaN;
          }

          otherMakers_k->ContinuesLastTime[i] = rtNaN;
          otherMakers_k->ContinuesLastK[i] = rtNaN;
        }
      } else {
        //  һ���� M*M_last �����
        for (i = 0; i + 1 <= otherMakers_k->otherMakersN; i++) {
          repmat(*(double (*)[3])&otherMakers_k->Position[3 * i],
                 otherMakers_k_last_otherMakersN, r0);
          loop_ub = r0->size[0] * r0->size[1];
          for (i17 = 0; i17 < loop_ub; i17++) {
            dPi_data[i17] = r0->data[i17] - c_otherMakers_k_last_Position_d[i17];
          }

          i17 = dPiNorm->size[0] * dPiNorm->size[1];
          dPiNorm->size[0] = 1;
          dPiNorm->size[1] = otherMakers_k_last_otherMakersN;
          emxEnsureCapacity((emxArray__common *)dPiNorm, i17, (int)sizeof(double));
          for (i17 = 0; i17 < otherMakers_k_last_otherMakersN; i17++) {
            dPiNorm->data[i17] = 0.0;
          }

          for (ixstart = 0; ixstart + 1 <= otherMakers_k_last_otherMakersN;
               ixstart++) {
            dPiNorm->data[ixstart] = normest(*(double (*)[3])&dPi_data[3 *
              ixstart]);
          }

          ixstart = 1;
          b_dPi_ConJudge = dPiNorm->data[0];
          itmp = 0;
          if (dPiNorm->size[1] > 1) {
            if (rtIsNaN(dPiNorm->data[0])) {
              loop_ub = 1;
              exitg1 = false;
              while ((!exitg1) && (loop_ub + 1 <= dPiNorm->size[1])) {
                ixstart = loop_ub + 1;
                if (!rtIsNaN(dPiNorm->data[loop_ub])) {
                  b_dPi_ConJudge = dPiNorm->data[loop_ub];
                  itmp = loop_ub;
                  exitg1 = true;
                } else {
                  loop_ub++;
                }
              }
            }

            if (ixstart < dPiNorm->size[1]) {
              while (ixstart + 1 <= dPiNorm->size[1]) {
                if (dPiNorm->data[ixstart] < b_dPi_ConJudge) {
                  b_dPi_ConJudge = dPiNorm->data[ixstart];
                  itmp = ixstart;
                }

                ixstart++;
              }
            }
          }

          if (fabs(b_dPi_ConJudge) < c_makerTrackThreshold_MaxContin) {
            //   otherMakers_k.Position( :,i ) �� otherMakers_k_last.Position(:,min_i) ���� 
            //  �ҵ�һ�������ĵ㣬��¼��һ��
            otherMakers_k->ContinuesFlag[i] = 2.0;

            //  �������͸���ʧ�ܵĵ�����
            //  ���ǰһ����Ϊ�����㣬��ǰһ�����������¼���ݹ���
            if (c_otherMakers_k_last_ContinuesF[itmp] == 2.0) {
              otherMakers_k->ContinuesLastK[i] =
                e_otherMakers_k_last_ContinuesL[itmp];

              //  ���ݼ�¼��һ��ʱ�̴洢��������Ϣ
              for (i17 = 0; i17 < 3; i17++) {
                otherMakers_k->ContinuesLastPosition[i17 + 3 * i] =
                  c_otherMakers_k_last_ContinuesL[i17 + 3 * itmp];
              }

              otherMakers_k->ContinuesLastTime[i] =
                d_otherMakers_k_last_ContinuesL[itmp];
            } else if (c_otherMakers_k_last_ContinuesF[itmp] == 0.0) {
              otherMakers_k->ContinuesLastK[i] = (double)k_vision - 1.0;

              //  ֱ�Ӽ�¼��һ��ʱ��
              for (i17 = 0; i17 < 3; i17++) {
                otherMakers_k->ContinuesLastPosition[i17 + 3 * i] =
                  c_otherMakers_k_last_Position_d[i17 +
                  c_otherMakers_k_last_Position_s[0] * itmp];
              }

              otherMakers_k->ContinuesLastTime[i] = otherMakers_k_last_time;
            } else {
              if (c_otherMakers_k_last_ContinuesF[itmp] == 1.0) {
                //  ����ٳɹ����������ɹ���������ʶ��ʧ�ܵ���������ݵ����ڡ��������ʱ�䳬��2�룬���ٴ��ݡ� 
                if (d_otherMakers_k_last_ContinuesL[itmp] - otherMakers_k->time >
                    20.0) {
                  otherMakers_k->ContinuesFlag[i] = 2.0;
                } else {
                  otherMakers_k->ContinuesFlag[i] = 1.0;
                }

                otherMakers_k->ContinuesLastK[i] =
                  e_otherMakers_k_last_ContinuesL[itmp];

                //  ���ݼ�¼��һ��ʱ�̴洢��������Ϣ
                for (i17 = 0; i17 < 3; i17++) {
                  otherMakers_k->ContinuesLastPosition[i17 + 3 * i] =
                    c_otherMakers_k_last_ContinuesL[i17 + 3 * itmp];
                }

                otherMakers_k->ContinuesLastTime[i] =
                  d_otherMakers_k_last_ContinuesL[itmp];
              }
            }
          } else {
            otherMakers_k->ContinuesFlag[i] = 0.0;

            //  ������
            for (i17 = 0; i17 < 3; i17++) {
              otherMakers_k->ContinuesLastPosition[i17 + 3 * i] = rtNaN;
            }

            otherMakers_k->ContinuesLastTime[i] = rtNaN;
            otherMakers_k->ContinuesLastK[i] = rtNaN;
          }
        }
      }
    }
  }

  emxFree_real_T(&r0);
  emxFree_real_T(&dPiNorm);
  return b_dPi_ConJudge;
}

//
// Arguments    : double otherMakers_k_time
//                int otherMakers_k_inertial_k
//                signed char otherMakers_k_MarkerSet
//                const double c_otherMakers_k_trackedMakerPos[3]
//                const double otherMakers_k_ContinuesFlag[10]
//                const double c_otherMakers_k_ContinuesLastPo[30]
//                const double otherMakers_k_ContinuesLastTime[10]
//                const double otherMakers_k_ContinuesLastK[10]
//                unsigned char otherMakers_k_CalculatedTime
//                c_struct_T *otherMakersEmpty
// Return Type  : void
//
static void GetEmpty_otherMakers(double otherMakers_k_time, int
  otherMakers_k_inertial_k, signed char otherMakers_k_MarkerSet, const double
  c_otherMakers_k_trackedMakerPos[3], const double otherMakers_k_ContinuesFlag
  [10], const double c_otherMakers_k_ContinuesLastPo[30], const double
  otherMakers_k_ContinuesLastTime[10], const double
  otherMakers_k_ContinuesLastK[10], unsigned char otherMakers_k_CalculatedTime,
  c_struct_T *otherMakersEmpty)
{
  int i;
  otherMakersEmpty->time = otherMakers_k_time;
  otherMakersEmpty->inertial_k = otherMakers_k_inertial_k;
  otherMakersEmpty->MarkerSet = otherMakers_k_MarkerSet;
  for (i = 0; i < 3; i++) {
    otherMakersEmpty->trackedMakerPosition[i] =
      c_otherMakers_k_trackedMakerPos[i];
  }

  for (i = 0; i < 10; i++) {
    otherMakersEmpty->ContinuesFlag[i] = otherMakers_k_ContinuesFlag[i];
  }

  for (i = 0; i < 30; i++) {
    otherMakersEmpty->ContinuesLastPosition[i] =
      c_otherMakers_k_ContinuesLastPo[i];
  }

  for (i = 0; i < 10; i++) {
    otherMakersEmpty->ContinuesLastTime[i] = otherMakers_k_ContinuesLastTime[i];
  }

  for (i = 0; i < 10; i++) {
    otherMakersEmpty->ContinuesLastK[i] = otherMakers_k_ContinuesLastK[i];
  }

  otherMakersEmpty->CalculatedTime = otherMakers_k_CalculatedTime;
  otherMakersEmpty->frequency = rtNaN;
  otherMakersEmpty->Position.size[0] = 3;
  otherMakersEmpty->Position.size[1] = 1;
  for (i = 0; i < 3; i++) {
    otherMakersEmpty->Position.data[i] = rtNaN;
  }

  otherMakersEmpty->otherMakersN = -1;
}

//
// Arguments    : struct1_T otherMakers[3600]
//                const double InertialPosition[34560]
//                double d_trackedMakerPosition_Inertial[34560]
// Return Type  : void
//
static void GetRightOtherMaker(struct1_T otherMakers[3600], const double
  InertialPosition[34560], double d_trackedMakerPosition_Inertial[34560])
{
  double dT_Ninertial;
  int c_CalEndVN;
  int k;
  struct1_T expl_temp;
  double d1;
  int inertial_dT_k_last;
  struct1_T otherMakersNew_k;
  int c_otherMakers_k_last_Position_s[2];
  double c_otherMakers_k_last_Position_d[30];
  int i14;
  int otherMakers_k_last_otherMakersN;
  double otherMakers_k_last_time;
  double c_otherMakers_k_last_ContinuesF[10];
  double c_otherMakers_k_last_ContinuesL[30];
  double d_otherMakers_k_last_ContinuesL[10];
  double e_otherMakers_k_last_ContinuesL[10];
  c_struct_T b_expl_temp;
  int loop_ub;
  d_struct_T JudgeIndex;
  int tmp_size[1];
  double tmp_data[3];
  double trackedMarkerVelocity_k_data[5];
  double b_trackedMarkerVelocity_k_data[5];
  int dX_Vision_size[2];
  double dX_Vision_data[150];

  // % xyz 2015.5.25
  // % otherMakers ����˵�ʶ���ڶ����˵����ҵ���ȷ����˵�
  //  trackedMakerPosition �� [3*N] ÿ��ʱ�̸��ٳɹ���˵�λ�ã�����ʧ�� NaN(3,1) 
  //  trackedMarkerVelocity �� [5*N] ���ٳɹ���˵���ٶȣ�ǰ����xyz�ٶȣ�
  //  	trackedMarkerVelocity(4,:)Ϊxyƽ������˵��ٶ�ģ��trackedMarkerVelocity(5,:)Ϊxyƽ������˵��ٶ���[0 1 0] �ļн� 
  // % ���ٲ�����˵���ĵ�
  // % �ж�˼·���Ƚ�2�����λ��ʸ����1��dT(3 sec)�˶�ʱ��ʱ  2��dS��1m���˶�λ�Ƴ���ʱ 
  //  1)dT(3 sec)ʱ���ڣ����Ժ��Ӿ�λ�������Ĵ�С��<0.1m�������<60�㣨��λ��ʸ������С��0.2mʱ���ȽϷ��� 
  // % ��ֵ��������
  if (!makerTrackThreshold_not_empty) {
    SetParameters(&makerTrackThreshold.moveTime,
                  &makerTrackThreshold.MaxMoveTime,
                  &makerTrackThreshold.moveDistance,
                  &makerTrackThreshold.MaxContinuesDisplacement,
                  &makerTrackThreshold.PositionErrorBear_dT,
                  &makerTrackThreshold.ContinuesTrackedMagnifyRate,
                  &makerTrackThreshold.MaxStaticDisp_dT,
                  &makerTrackThreshold.MaxPositionError_dS,
                  &makerTrackThreshold.Max_dPAngle_dS,
                  &makerTrackThreshold.MaxMarkHighChange,
                  makerTrackThreshold.MaxHighMoveErrRate,
                  &makerTrackThreshold.BigHighMove,
                  &makerTrackThreshold.INSMarkH0, &makerTrackThreshold.VNSMarkH0,
                  &INSVNSCalibSet);
    makerTrackThreshold_not_empty = true;
  }

  IsGetFirstMarker = 0.0;
  dT_Ninertial = 2.0 * inertialFre;
  b_fix(&dT_Ninertial);

  // % ����/���� ��һ��Ҫ��Ԥ���������С
  //   �Ӿ�ʱ�䳤��
  // % ��Щ�ж�ָ��ֻ������ʱ��¼
  // % ������ٶ�
  // % ����˵����
  //   wh = waitbar(0,'SearchDistanceK');
  c_CalEndVN = CalEndVN;
  for (k = CalStartVN - 1; k + 1 <= c_CalEndVN; k++) {
    expl_temp = otherMakers[k];

    //   last_dT_k
    d1 = rt_roundd_snf((double)otherMakers[k].inertial_k - dT_Ninertial);
    if (d1 < 2.147483648E+9) {
      if (d1 >= -2.147483648E+9) {
        inertial_dT_k_last = (int)d1;
      } else {
        inertial_dT_k_last = MIN_int32_T;
      }
    } else if (d1 >= 2.147483648E+9) {
      inertial_dT_k_last = MAX_int32_T;
    } else {
      inertial_dT_k_last = 0;
    }

    if (inertial_dT_k_last < 1) {
      inertial_dT_k_last = 1;
    }

    if (k + 1 > 1) {
      otherMakersNew_k = otherMakers[k - 1];
      c_otherMakers_k_last_Position_s[0] = 3;
      c_otherMakers_k_last_Position_s[1] = 10;
      for (i14 = 0; i14 < 30; i14++) {
        c_otherMakers_k_last_Position_d[i14] = otherMakersNew_k.Position[i14];
      }

      otherMakers_k_last_otherMakersN = otherMakersNew_k.otherMakersN;
      otherMakers_k_last_time = otherMakersNew_k.time;
      for (i14 = 0; i14 < 10; i14++) {
        c_otherMakers_k_last_ContinuesF[i14] =
          otherMakersNew_k.ContinuesFlag[i14];
      }

      for (i14 = 0; i14 < 30; i14++) {
        c_otherMakers_k_last_ContinuesL[i14] =
          otherMakersNew_k.ContinuesLastPosition[i14];
      }

      for (i14 = 0; i14 < 10; i14++) {
        d_otherMakers_k_last_ContinuesL[i14] =
          otherMakersNew_k.ContinuesLastTime[i14];
        e_otherMakers_k_last_ContinuesL[i14] =
          otherMakersNew_k.ContinuesLastK[i14];
      }

      //  otherMakers_k_last �����Ǹ������ж�����ģ����һ��
      //          if k>2 && isnan(trackedMakerPosition(1,k-2))
      //              if sum(otherMakers_k_last.ContinuesFlag==1)~=0
      //                 disp('err')
      //              end
      //          end
    } else {
      otherMakersNew_k = otherMakers[0];
      GetEmpty_otherMakers(otherMakersNew_k.time, otherMakersNew_k.inertial_k,
                           otherMakersNew_k.MarkerSet,
                           otherMakersNew_k.trackedMakerPosition,
                           otherMakersNew_k.ContinuesFlag,
                           otherMakersNew_k.ContinuesLastPosition,
                           otherMakersNew_k.ContinuesLastTime,
                           otherMakersNew_k.ContinuesLastK,
                           otherMakersNew_k.CalculatedTime, &b_expl_temp);
      c_otherMakers_k_last_Position_s[0] = 3;
      c_otherMakers_k_last_Position_s[1] = b_expl_temp.Position.size[1];
      loop_ub = b_expl_temp.Position.size[0] * b_expl_temp.Position.size[1];
      for (i14 = 0; i14 < loop_ub; i14++) {
        c_otherMakers_k_last_Position_d[i14] = b_expl_temp.Position.data[i14];
      }

      otherMakers_k_last_otherMakersN = b_expl_temp.otherMakersN;
      otherMakers_k_last_time = b_expl_temp.time;
      for (i14 = 0; i14 < 10; i14++) {
        c_otherMakers_k_last_ContinuesF[i14] = b_expl_temp.ContinuesFlag[i14];
      }

      for (i14 = 0; i14 < 30; i14++) {
        c_otherMakers_k_last_ContinuesL[i14] =
          b_expl_temp.ContinuesLastPosition[i14];
      }

      for (i14 = 0; i14 < 10; i14++) {
        d_otherMakers_k_last_ContinuesL[i14] = b_expl_temp.ContinuesLastTime[i14];
        e_otherMakers_k_last_ContinuesL[i14] = b_expl_temp.ContinuesLastK[i14];
      }
    }

    otherMakersNew_k = otherMakers[k];
    JudgeMaker(&otherMakersNew_k, c_otherMakers_k_last_Position_d,
               c_otherMakers_k_last_Position_s, otherMakers_k_last_otherMakersN,
               otherMakers_k_last_time, c_otherMakers_k_last_ContinuesF,
               c_otherMakers_k_last_ContinuesL, d_otherMakers_k_last_ContinuesL,
               e_otherMakers_k_last_ContinuesL, k + 1, otherMakers[k].inertial_k,
               trackedMakerPosition, InertialPosition, inertial_dT_k_last,
               &makerTrackThreshold, tmp_data, tmp_size, &d1, &JudgeIndex);
    for (i14 = 0; i14 < 3; i14++) {
      trackedMakerPosition[i14 + 3 * k] = tmp_data[i14];
    }

    //     %% ��  INSMarkH0  VNSMarkH0
    if (rtIsNaN(makerTrackThreshold.INSMarkH0) && (!rtIsNaN
         (trackedMakerPosition[3 * k]))) {
      //  ���Hip�ĸ����ͺ��С��ȡֵ���������������������������������������������������������������������������������� 
      makerTrackThreshold.INSMarkH0 = -InertialPosition[2 + 3 * (otherMakers[k].
        inertial_k - 1)];
      makerTrackThreshold.VNSMarkH0 = -trackedMakerPosition[2 + 3 * k];

      //          HipQuaternion_k = HipQuaternion( :,inertial_k );
      //          HipAttitude = GetHipAttitude( HipQuaternion_k );
      //
      //          HipQuaternion_k = Qinv( HipQuaternion_k ) ; % ��Ԫ�������� ˳ʱ�� ��Ϊ ��ʱ�롣 
      //
      //          CHip_k = Q2C(HipQuaternion_k);
      //
      //          C_HipLUF_NED0 = RotateX(pi/2) * RotateY(-pi/2);  % Hip ������ǰϵ �� NED��0��̬ϵ 
      //          C_NED_HipNED0 = C_HipLUF_NED0 * CHip_k ;
      //          Attitude = C2Euler( C_NED_HipNED0,'ZYX' )*180/pi
      //         %% ��һ�θ�����˵�ɹ�
      //  �궨�Ӿ����ѧ��ԭ�㣨�����Ƿ���
      //          Xrw_r = trackedMakerPosition(1:2,k) - InertialPosition(1:2,inertial_k); 
      //          Xrw_r = [Xrw_r;0];
      //          N_otherMakers = length( otherMakers );
      //          for i=1:N_otherMakers
      //              if ~isempty(otherMakers(i).Position)
      //                  m = size( otherMakers(i).Position,2 );
      //                  otherMakers(i).Position = otherMakers(i).Position - repmat(Xrw_r,1,m) ; 
      //                  trackedMakerPosition(:,i) = trackedMakerPosition(:,i) - Xrw_r ; 
      //              end
      //          end
    }

    //     %% ���Ӿ��ٶ�
    CalVelocity(trackedMakerPosition, k + 1, visionFre,
                trackedMarkerVelocity_k_data, tmp_size,
                &otherMakers_k_last_otherMakersN);
    if (otherMakers_k_last_otherMakersN > 0) {
      loop_ub = tmp_size[0];
      for (i14 = 0; i14 < loop_ub; i14++) {
        b_trackedMarkerVelocity_k_data[i14] = trackedMarkerVelocity_k_data[i14];
      }

      for (i14 = 0; i14 < 5; i14++) {
        trackedMarkerVelocity[i14 + 5 * (otherMakers_k_last_otherMakersN - 1)] =
          b_trackedMarkerVelocity_k_data[i14];
      }

      if (IsCalibDataEnough == 0.0) {
        //  ֻ����һ��
        //         %% ���������ڱ궨������
        //          dbstop in SearchCalibData
        SearchCalibData(INSVNSCalib_VS_k, Calib_N_New, trackedMarkerVelocity,
                        trackedMakerPosition, otherMakers_k_last_otherMakersN,
                        &Calib_N_New, &IsCalibDataEnough, dX_Vision_data,
                        dX_Vision_size);
        if (IsCalibDataEnough == 1.0) {
          INSVNSCalib(INSVNSCalib_VS_k, Calib_N_New, dX_Vision_data,
                      dX_Vision_size, InertialPosition, Crw);
        }
      }
    }

    CompensateSecond(&otherMakersNew_k, Crw);
    otherMakers[k] = otherMakersNew_k;

    //  ���� otherMakers(k)
    //     %% ת�ɹ�����˵��ʱ��
    for (i14 = 0; i14 < 3; i14++) {
      c_trackedMakerPosition_Inertial[i14 + 3 * (expl_temp.inertial_k - 1)] =
        trackedMakerPosition[i14 + 3 * k];
    }

    //
    //      if mod(k,fix(MarkerTN/10))==0
    //          waitbar(k/MarkerTN);
    //      end
  }

  //   close(wh);
  //  %% Output
  memcpy(&d_trackedMakerPosition_Inertial[0], &c_trackedMakerPosition_Inertial[0],
         34560U * sizeof(double));

  //  %% result analyse
}

//
// Arguments    : void
// Return Type  : void
//
static void GetRightOtherMaker_init()
{
  int k;
  for (k = 0; k < 10800; k++) {
    trackedMakerPosition[k] = rtNaN;
  }

  for (k = 0; k < 34560; k++) {
    c_trackedMakerPosition_Inertial[k] = rtNaN;
  }

  for (k = 0; k < 18000; k++) {
    trackedMarkerVelocity[k] = rtNaN;
  }

  for (k = 0; k < 100; k++) {
    INSVNSCalib_VS_k[k] = rtNaN;
  }

  Calib_N_New = 0.0;
  IsCalibDataEnough = 0.0;
  memset(&Crw[0], 0, 9U * sizeof(double));
  for (k = 0; k < 3; k++) {
    Crw[k + 3 * k] = 1.0;
  }
}

//
// Arguments    : const double b_INSVNSCalib_VS_k[100]
//                double b_Calib_N_New
//                const double dX_Vision_data[]
//                const int dX_Vision_size[2]
//                const double InertialPosition[34560]
//                double b_Crw[9]
// Return Type  : void
//
static void INSVNSCalib(const double b_INSVNSCalib_VS_k[100], double
  b_Calib_N_New, const double dX_Vision_data[], const int dX_Vision_size[2],
  const double InertialPosition[34560], double b_Crw[9])
{
  emxArray_real_T *dX_Inertial;
  int i5;
  int loop_ub;
  double INSVNSCalib_IS_k[100];
  emxArray_real_T *A;
  int i6;
  double A_data[100];
  emxArray_real_T *b_A;
  int Crw_size[2];
  double Crw_data[100];
  double B_data[100];
  int B_size[2];
  int b_loop_ub;
  int A_size[2];
  double dv0[4];
  static const signed char iv0[3] = { 0, 0, 1 };

  emxInit_real_T(&dX_Inertial, 2);

  // % xyz 2015 ��ͯ�� �ع�
  // % ���� �Ӿ� ����ϵ�궨
  //  λ�Ʋ����ݣ� dX_Vision
  //  rϵ�� �Ӿ�ϵ
  //  wϵ�� ����ϵ��NED��
  //  Crw�� �Ӿ�ϵ����ϵ��ϵ�ķ������Ҿ���
  i5 = dX_Inertial->size[0] * dX_Inertial->size[1];
  dX_Inertial->size[0] = 3;
  dX_Inertial->size[1] = (int)b_Calib_N_New;
  emxEnsureCapacity((emxArray__common *)dX_Inertial, i5, (int)sizeof(double));
  loop_ub = 3 * (int)b_Calib_N_New;
  for (i5 = 0; i5 < loop_ub; i5++) {
    dX_Inertial->data[i5] = 0.0;
  }

  memset(&INSVNSCalib_IS_k[0], 0, 100U * sizeof(double));
  for (loop_ub = 0; loop_ub < (int)b_Calib_N_New; loop_ub++) {
    INSVNSCalib_IS_k[loop_ub << 1] = VisionData_inertial_k[(int)
      b_INSVNSCalib_VS_k[loop_ub << 1] - 1];
    INSVNSCalib_IS_k[1 + (loop_ub << 1)] = VisionData_inertial_k[(int)
      b_INSVNSCalib_VS_k[1 + (loop_ub << 1)] - 1];
    for (i5 = 0; i5 < 3; i5++) {
      dX_Inertial->data[i5 + dX_Inertial->size[0] * loop_ub] =
        InertialPosition[i5 + 3 * ((int)INSVNSCalib_IS_k[1 + (loop_ub << 1)] - 1)]
        - InertialPosition[i5 + 3 * ((int)INSVNSCalib_IS_k[loop_ub << 1] - 1)];
    }

    dX_Inertial->data[2 + dX_Inertial->size[0] * loop_ub] = 0.0;

    //  �����0
  }

  emxInit_real_T(&A, 2);
  loop_ub = dX_Inertial->size[1];
  i5 = A->size[0] * A->size[1];
  A->size[0] = 2;
  A->size[1] = loop_ub;
  emxEnsureCapacity((emxArray__common *)A, i5, (int)sizeof(double));
  for (i5 = 0; i5 < loop_ub; i5++) {
    for (i6 = 0; i6 < 2; i6++) {
      A->data[i6 + A->size[0] * i5] = dX_Inertial->data[i6 + dX_Inertial->size[0]
        * i5];
    }
  }

  loop_ub = dX_Vision_size[1];
  for (i5 = 0; i5 < loop_ub; i5++) {
    for (i6 = 0; i6 < 2; i6++) {
      A_data[i6 + (i5 << 1)] = dX_Vision_data[i6 + dX_Vision_size[0] * i5];
    }
  }

  i5 = dX_Inertial->size[1];
  emxInit_real_T(&b_A, 2);
  if ((i5 == 0) || (dX_Vision_size[1] == 0)) {
    Crw_size[0] = 2;
    Crw_size[1] = 2;
    for (i5 = 0; i5 < 4; i5++) {
      Crw_data[i5] = 0.0;
    }
  } else if (2 == dX_Vision_size[1]) {
    Crw_size[0] = 2;
    Crw_size[1] = A->size[1];
    loop_ub = A->size[0] * A->size[1];
    for (i5 = 0; i5 < loop_ub; i5++) {
      Crw_data[i5] = A->data[i5];
    }

    eml_lusolve(A_data, Crw_data, Crw_size);
  } else {
    loop_ub = dX_Inertial->size[1];
    B_size[0] = dX_Vision_size[1];
    B_size[1] = 2;
    for (i5 = 0; i5 < 2; i5++) {
      b_loop_ub = dX_Vision_size[1];
      for (i6 = 0; i6 < b_loop_ub; i6++) {
        B_data[i6 + dX_Vision_size[1] * i5] = A_data[i5 + (i6 << 1)];
      }
    }

    i5 = b_A->size[0] * b_A->size[1];
    b_A->size[0] = A->size[1];
    b_A->size[1] = 2;
    emxEnsureCapacity((emxArray__common *)b_A, i5, (int)sizeof(double));
    for (i5 = 0; i5 < 2; i5++) {
      b_loop_ub = A->size[1];
      for (i6 = 0; i6 < b_loop_ub; i6++) {
        b_A->data[i6 + b_A->size[0] * i5] = A->data[i5 + A->size[0] * i6];
      }
    }

    A_size[0] = loop_ub;
    A_size[1] = 2;
    for (i5 = 0; i5 < 2; i5++) {
      for (i6 = 0; i6 < loop_ub; i6++) {
        A_data[i6 + loop_ub * i5] = b_A->data[i6 + loop_ub * i5];
      }
    }

    eml_qrsolve(B_data, B_size, A_data, A_size, dv0);
    Crw_size[0] = 2;
    Crw_size[1] = 2;
    for (i5 = 0; i5 < 2; i5++) {
      for (i6 = 0; i6 < 2; i6++) {
        Crw_data[i6 + (i5 << 1)] = dv0[i5 + (i6 << 1)];
      }
    }
  }

  emxFree_real_T(&b_A);
  emxFree_real_T(&A);
  emxFree_real_T(&dX_Inertial);
  loop_ub = Crw_size[1];
  for (i5 = 0; i5 < loop_ub; i5++) {
    for (i6 = 0; i6 < 2; i6++) {
      b_Crw[i6 + 3 * i5] = Crw_data[i6 + Crw_size[0] * i5];
    }
  }

  for (i5 = 0; i5 < 2; i5++) {
    b_Crw[i5 + 3 * Crw_size[1]] = 0.0;
  }

  for (i5 = 0; i5 < 3; i5++) {
    b_Crw[2 + 3 * i5] = iv0[i5];
  }
}

//
// Arguments    : const double b_INSVNSCalib_VS_k[100]
//                double b_Calib_N_New
//                const double b_trackedMakerPosition[10800]
//                double *IsCalibDataVelocityOK
//                double dX_Vision_data[]
//                int dX_Vision_size[2]
// Return Type  : void
//
static void JudgeIsCalibDataEnough(const double b_INSVNSCalib_VS_k[100], double
  b_Calib_N_New, const double b_trackedMakerPosition[10800], double
  *IsCalibDataVelocityOK, double dX_Vision_data[], int dX_Vision_size[2])
{
  int HaveBiggerData;
  int i4;
  double dX_Angle_data[50];
  int HaveSmallerData;
  int k;
  double angle;

  //  fprintf( '\n ��%d��λ�ƣ�[%d  %d]sec��  \n �Ƕȷ�Χ = %0.2f �㣬λ�Ƴ��� = %0.2f m��\n   ʱ��=%0.2f sec ��ƽ���ٶȣ� %0.2f m/s \n',... 
  //      Calib_N_New,search_k_start/visionFre,search_k_end/visionFre,VelocityDirectionRange*180/pi,dX_xyNorm_VS,searchT,dX_xyNorm_VS/searchT ); 
  // % �ж������õ���λ�����ݹ������࣬�Ƿ��Ѿ����ȷֲ�
  dX_Vision_size[0] = 3;
  dX_Vision_size[1] = (int)b_Calib_N_New;
  HaveBiggerData = 3 * (int)b_Calib_N_New;
  for (i4 = 0; i4 < HaveBiggerData; i4++) {
    dX_Vision_data[i4] = 0.0;
  }

  HaveBiggerData = (int)b_Calib_N_New;
  for (i4 = 0; i4 < HaveBiggerData; i4++) {
    dX_Angle_data[i4] = 0.0;
  }

  HaveBiggerData = 0;
  HaveSmallerData = 0;
  *IsCalibDataVelocityOK = 0.0;
  for (k = 0; k < (int)b_Calib_N_New; k++) {
    for (i4 = 0; i4 < 3; i4++) {
      dX_Vision_data[i4 + 3 * k] = b_trackedMakerPosition[i4 + 3 * ((int)
        b_INSVNSCalib_VS_k[1 + (k << 1)] - 1)] - b_trackedMakerPosition[i4 + 3 *
        ((int)b_INSVNSCalib_VS_k[k << 1] - 1)];
    }

    //  �� ��ʼ ָ�� ����
    //     %% ֻ����ƽ���ڵ�λ��
    dX_Vision_data[2 + 3 * k] = 0.0;

    //     %% ��������λ��ʸ�����һ��ʸ���ļн��ж��Ƿ�ֲ�����
    angle = 0.0;
    for (i4 = 0; i4 < 3; i4++) {
      angle += dX_Vision_data[i4] * dX_Vision_data[i4 + 3 * k];
    }

    angle = acos(angle / normest(*(double (*)[3])&dX_Vision_data[0]) / normest
                 (*(double (*)[3])&dX_Vision_data[3 * k]));

    //  ͨ����˿��жϽǶȷ���
    if (dX_Vision_data[0] * dX_Vision_data[1 + 3 * k] - dX_Vision_data[1] *
        dX_Vision_data[3 * k] < 0.0) {
      //  �� dX_Vision(:,1) �� dX_Vision(:,k) ��ʱ��ת������180��
      angle = -angle;
    }

    //  ��dX_Vision(:,1)Ϊ���ģ������е�λ��ʸ��������dX_Vision(:,1)�нǴ���90���򷴺� 
    if (angle > 1.5707963267948966) {
      angle -= 3.1415926535897931;
    }

    if (angle < -1.5707963267948966) {
      angle += 3.1415926535897931;
    }

    dX_Angle_data[k] = angle;

    //  �� [60-angleUniformityErr,60+angleUniformityErr] ��
    //  [-60-angleUniformityErr,-60+angleUniformityErr] ��Χ�ھ�����λ��ʸ��ʱ�ж��ֲ����� 
    if ((dX_Angle_data[k] > 0.87266462599716466) && (dX_Angle_data[k] <
         1.2217304763960306)) {
      HaveBiggerData = 1;
    }

    if ((dX_Angle_data[k] > -1.2217304763960306) && (dX_Angle_data[k] <
         -0.87266462599716466)) {
      HaveSmallerData = 1;
    }

    if ((HaveSmallerData == 1) && (HaveBiggerData == 1)) {
      //        %% �ж�λ��ʸ������ֲ���������
      *IsCalibDataVelocityOK = 1.0;
    }
  }

  // % ��������������ʱ�����е�λ��ʸ�����Ƴ���
}

//
// Arguments    : struct1_T *otherMakers_k
//                const double c_otherMakers_k_last_Position_d[]
//                const int c_otherMakers_k_last_Position_s[2]
//                int otherMakers_k_last_otherMakersN
//                double otherMakers_k_last_time
//                const double c_otherMakers_k_last_ContinuesF[10]
//                const double c_otherMakers_k_last_ContinuesL[30]
//                const double d_otherMakers_k_last_ContinuesL[10]
//                const double e_otherMakers_k_last_ContinuesL[10]
//                int k_vision
//                int b_inertial_k
//                const double b_trackedMakerPosition[10800]
//                const double InertialPosition[34560]
//                int inertial_dT_k_last
//                const struct_T *b_makerTrackThreshold
//                double trackedMakerPosition_k_OK_data[]
//                int trackedMakerPosition_k_OK_size[1]
//                double *TrackFlag
//                d_struct_T *JudgeIndex
// Return Type  : void
//
static void JudgeMaker(struct1_T *otherMakers_k, const double
  c_otherMakers_k_last_Position_d[], const int c_otherMakers_k_last_Position_s[2],
  int otherMakers_k_last_otherMakersN, double otherMakers_k_last_time, const
  double c_otherMakers_k_last_ContinuesF[10], const double
  c_otherMakers_k_last_ContinuesL[30], const double
  d_otherMakers_k_last_ContinuesL[10], const double
  e_otherMakers_k_last_ContinuesL[10], int k_vision, int b_inertial_k, const
  double b_trackedMakerPosition[10800], const double InertialPosition[34560],
  int inertial_dT_k_last, const struct_T *b_makerTrackThreshold, double
  trackedMakerPosition_k_OK_data[], int trackedMakerPosition_k_OK_size[1],
  double *TrackFlag, d_struct_T *JudgeIndex)
{
  double vision_dT_k_last;
  double otherMakersPosition_k[30];
  int i15;
  struct1_T b_otherMakers_k;
  double stepK;
  int b_TrackFlag;
  emxArray_real_T *INSVNSMarkHC;
  int ixstart;
  int i;
  unsigned int uv0[2];
  emxArray_real_T *y;
  int ix;
  boolean_T exitg4;
  double invalid_i;
  long long i16;
  double b_angleErr_dT_Min;
  boolean_T exitg3;
  boolean_T b;
  boolean_T guard1 = false;
  int32_T exitg2;
  boolean_T guard2 = false;
  double min_dT_k;
  boolean_T exitg1;
  double dP[3];
  boolean_T b_guard1 = false;
  double b_dP[3];
  double dP_Vision[3];

  // % Judge which is the right maker
  //  1) �̶��˶�ʱ��λ���жϣ�ֻ�ж�λ�Ʋ��
  //  2���̶��˶�����λ���жϣ�ͬʱ�ж�λ�Ʋ�Ⱥͷ���
  vision_dT_k_last = InertialData_visual_k[inertial_dT_k_last - 1];

  //  ��ʼֵ
  JudgeIndex->dPi_ConJudge = rtNaN;
  JudgeIndex->dPError_dT_xy = rtNaN;
  JudgeIndex->dPError_dT_z = rtNaN;
  JudgeIndex->dPError_dS_xyNorm = rtNaN;
  JudgeIndex->dP_Inertial_xyNorm = rtNaN;
  JudgeIndex->angleErr_dS = rtNaN;
  JudgeIndex->angleErr_dT_Min = rtNaN;
  JudgeIndex->INSVNSMarkHC_Min = rtNaN;
  trackedMakerPosition_k_OK_size[0] = 1;
  trackedMakerPosition_k_OK_data[0] = rtNaN;

  //  ������˵�ʧ���� NaN
  *TrackFlag = 0.0;

  //  M = otherMakers_k.otherMakersN ;
  for (i15 = 0; i15 < 30; i15++) {
    otherMakersPosition_k[i15] = otherMakers_k->Position[i15];
  }

  if (rtIsNaN(otherMakers_k->Position[0])) {
  } else {
    // % �߶��ж�
    //   �� otherMakers_k �и߶ȱ仯��ĵ�ֱ���޳���
    b_otherMakers_k = *otherMakers_k;

    // % �߶��ж�
    //  ��1.1������Ŀ��ؽ����Ӿ�Ŀ����˵�߶ȲINSVNSMarkHC�� =  INSVNSMarkL * 
    //  cos(thita)��INSVNSMarkL Ϊ�������ڳ�ʼʱ�̼̿���õ���
    //   INSVNSMarkHC ���㷽������ǰ�߶�-ֱ��ʱ�ĸ߶�
    stepK = rtNaN;
    b_TrackFlag = 0;
    if (rtIsNaN(b_makerTrackThreshold->INSMarkH0)) {
    } else {
      emxInit_real_T(&INSVNSMarkHC, 2);
      i15 = INSVNSMarkHC->size[0] * INSVNSMarkHC->size[1];
      INSVNSMarkHC->size[0] = 1;
      INSVNSMarkHC->size[1] = otherMakers_k->otherMakersN;
      emxEnsureCapacity((emxArray__common *)INSVNSMarkHC, i15, (int)sizeof
                        (double));
      ixstart = otherMakers_k->otherMakersN;
      for (i15 = 0; i15 < ixstart; i15++) {
        INSVNSMarkHC->data[i15] = 0.0;
      }

      for (i = 0; i + 1 <= otherMakers_k->otherMakersN; i++) {
        INSVNSMarkHC->data[i] = (-InertialPosition[2 + 3 * (b_inertial_k - 1)] +
          otherMakers_k->Position[2 + 3 * i]) -
          (b_makerTrackThreshold->INSMarkH0 - b_makerTrackThreshold->VNSMarkH0);
      }

      //  �߶Ȳ���С�ĵ�
      for (i15 = 0; i15 < 2; i15++) {
        uv0[i15] = (unsigned int)INSVNSMarkHC->size[i15];
      }

      emxInit_real_T(&y, 2);
      i15 = y->size[0] * y->size[1];
      y->size[0] = 1;
      y->size[1] = (int)uv0[1];
      emxEnsureCapacity((emxArray__common *)y, i15, (int)sizeof(double));
      for (ixstart = 0; ixstart < INSVNSMarkHC->size[1]; ixstart++) {
        y->data[ixstart] = fabs(INSVNSMarkHC->data[ixstart]);
      }

      ixstart = 1;
      stepK = y->data[0];
      if (y->size[1] > 1) {
        if (rtIsNaN(y->data[0])) {
          ix = 2;
          exitg4 = false;
          while ((!exitg4) && (ix <= y->size[1])) {
            ixstart = ix;
            if (!rtIsNaN(y->data[ix - 1])) {
              stepK = y->data[ix - 1];
              exitg4 = true;
            } else {
              ix++;
            }
          }
        }

        if (ixstart < y->size[1]) {
          while (ixstart + 1 <= y->size[1]) {
            if (y->data[ixstart] < stepK) {
              stepK = y->data[ixstart];
            }

            ixstart++;
          }
        }
      }

      emxFree_real_T(&y);

      //  ���߶Ȳ�����ĵ��޳�
      invalid_i = 0.0;
      for (i = 1; i <= otherMakers_k->otherMakersN; i++) {
        if (fabs(INSVNSMarkHC->data[i - 1]) > 0.4) {
          //  ���߶Ȳ�����ĵ��޳�
          // % �޳� otherMakers_k.Position �еĵ� i ����
          i16 = b_otherMakers_k.otherMakersN - 1LL;
          if (i16 > 2147483647LL) {
            i16 = 2147483647LL;
          } else {
            if (i16 < -2147483648LL) {
              i16 = -2147483648LL;
            }
          }

          i15 = (int)i16;
          b_angleErr_dT_Min = rt_roundd_snf((double)i - invalid_i);
          if (b_angleErr_dT_Min >= -2.147483648E+9) {
            ixstart = (int)b_angleErr_dT_Min;
          } else {
            ixstart = MIN_int32_T;
          }

          while (ixstart <= i15) {
            for (ix = 0; ix < 3; ix++) {
              b_otherMakers_k.Position[ix + 3 * (ixstart - 1)] =
                b_otherMakers_k.Position[ix + 3 * ixstart];
            }

            ixstart++;
          }

          for (i15 = 0; i15 < 3; i15++) {
            b_otherMakers_k.Position[i15 + 3 * (b_otherMakers_k.otherMakersN - 1)]
              = rtNaN;
          }

          i16 = b_otherMakers_k.otherMakersN - 1LL;
          if (i16 > 2147483647LL) {
            i16 = 2147483647LL;
          } else {
            if (i16 < -2147483648LL) {
              i16 = -2147483648LL;
            }
          }

          b_otherMakers_k.otherMakersN = (int)i16;
          invalid_i++;
        }
      }

      emxFree_real_T(&INSVNSMarkHC);

      // % ͨ���߶��޳���������
      if (b_otherMakers_k.otherMakersN == 0) {
        b_TrackFlag = -1;
      }
    }

    *otherMakers_k = b_otherMakers_k;
    *TrackFlag = b_TrackFlag;
    JudgeIndex->INSVNSMarkHC_Min = stepK;

    //  ��ĸ������ܱ�������
    if (b_TrackFlag == -1) {
    } else {
      // % ��˵��������ж�
      invalid_i = ContinuesJudge(otherMakers_k, c_otherMakers_k_last_Position_d,
        c_otherMakers_k_last_Position_s, otherMakers_k_last_otherMakersN,
        otherMakers_k_last_time, c_otherMakers_k_last_ContinuesF,
        c_otherMakers_k_last_ContinuesL, d_otherMakers_k_last_ContinuesL,
        e_otherMakers_k_last_ContinuesL, b_trackedMakerPosition, k_vision,
        b_makerTrackThreshold->MaxContinuesDisplacement);
      JudgeIndex->dPi_ConJudge = invalid_i;

      // % dT ʱ��ε�λ�Ʋֻ����λ��ʸ����С
      //  ��� vision_dT_k_last û���ٳɹ�����ʱ����ǰ��ֱ���ҵ����ٳɹ��ĵ㡣���ǲ�����ǰ�Ƴ��� Max_dT ʱ�䡣������ 
      //  Max_dTʱ�仹û���ҵ��Ļ���
      exitg3 = false;
      while ((!exitg3) && ((vision_dT_k_last > 1.0) && rtIsNaN
                           (b_trackedMakerPosition[3 * ((int)vision_dT_k_last -
                1)]))) {
        //  trackedMakerPosition(1) ������֪����Ϊnan��
        vision_dT_k_last--;
        b_angleErr_dT_Min = rt_roundd_snf(VisionData_inertial_k[(int)
          vision_dT_k_last - 1]);
        if (b_angleErr_dT_Min < 2.147483648E+9) {
          if (b_angleErr_dT_Min >= -2.147483648E+9) {
            inertial_dT_k_last = (int)b_angleErr_dT_Min;
          } else {
            inertial_dT_k_last = MIN_int32_T;
          }
        } else if (b_angleErr_dT_Min >= 2.147483648E+9) {
          inertial_dT_k_last = MAX_int32_T;
        } else {
          inertial_dT_k_last = 0;
        }

        if (inertial_dT_k_last < 1) {
          inertial_dT_k_last = 1;
        }

        b_angleErr_dT_Min = rt_roundd_snf((double)k_vision - vision_dT_k_last);
        if (b_angleErr_dT_Min >= -2.147483648E+9) {
          i15 = (int)b_angleErr_dT_Min;
        } else {
          i15 = MIN_int32_T;
        }

        b_angleErr_dT_Min = rt_roundd_snf((double)i15 / visionFre);
        if (b_angleErr_dT_Min < 2.147483648E+9) {
          if (b_angleErr_dT_Min >= -2.147483648E+9) {
            i15 = (int)b_angleErr_dT_Min;
          } else {
            i15 = MIN_int32_T;
          }
        } else if (b_angleErr_dT_Min >= 2.147483648E+9) {
          i15 = MAX_int32_T;
        } else {
          i15 = 0;
        }

        if (i15 > 3) {
          //          fprintf( '������������Ϊ�µ���������  k_vision = %d , vision_dT_k_last = %d \n',k_vision,vision_dT_k_last ); 
          exitg3 = true;
        }
      }

      b = rtIsNaN(b_trackedMakerPosition[3 * ((int)vision_dT_k_last - 1)]);
      guard1 = false;
      if (b) {
        //     %% Ѱ�ҵ�һ���㣨��һ���㣺��ô���Ҳ���֮ǰ���ٳɹ��ĵ㣩
        //  ��������������㣬������ǰ��˵���ÿһ�������㣬���ĳ��������� dT �ж�ͨ��������Ϊ���ǵ�һ���� 
        ixstart = 0;
        i = 0;
        do {
          exitg2 = 0;
          if (i + 1 <= b_otherMakers_k.otherMakersN) {
            guard2 = false;
            if ((otherMakers_k->ContinuesFlag[i] == 2.0) ||
                (otherMakers_k->ContinuesFlag[i] == 1.0)) {
              ixstart = 1;

              //  ��һ����˵������Ĺؼ����Ե�ǰ��˵��Ӧ�����������Ϊ���ٳɹ��� 
              Track_dT_Judge(otherMakers_k->Position,
                             otherMakers_k->ContinuesFlag, InertialPosition,
                             b_inertial_k, inertial_dT_k_last, *(double (*)[3])&
                             otherMakers_k->ContinuesLastPosition[3 * i],
                             b_makerTrackThreshold->MaxHighMoveErrRate,
                             trackedMakerPosition_k_OK_data,
                             trackedMakerPosition_k_OK_size, TrackFlag,
                             &min_dT_k, &invalid_i, &stepK, &vision_dT_k_last,
                             &b_angleErr_dT_Min);
              JudgeIndex->dPError_dT_xy = invalid_i;
              JudgeIndex->dPError_dT_z = stepK;
              JudgeIndex->dP_Inertial_xyNorm = vision_dT_k_last;
              JudgeIndex->angleErr_dT_Min = b_angleErr_dT_Min;
              if ((!rtIsNaN(trackedMakerPosition_k_OK_data[0])) &&
                  (IsGetFirstMarker == 0.0)) {
                IsGetFirstMarker = 1.0;
                exitg2 = 1;
              } else {
                guard2 = true;
              }
            } else {
              guard2 = true;
            }

            if (guard2) {
              i++;
            }
          } else {
            if (ixstart == 0) {
              //  ���Ҳ���֮ǰ���ٳɹ��ĵ㣬���Ҳ��������ĵ㣬������
              //          fprintf('������һ���㣺�ȴ��㹻�������Եĵ� k_vision = %d \n ',k_vision) 
            } else {
              guard1 = true;
            }

            exitg2 = 1;
          }
        } while (exitg2 == 0);
      } else {
        //  ֮ǰ�и��ٳɹ�������
        Track_dT_Judge(otherMakers_k->Position, otherMakers_k->ContinuesFlag,
                       InertialPosition, b_inertial_k, inertial_dT_k_last,
                       *(double (*)[3])&b_trackedMakerPosition[3 * ((int)
          vision_dT_k_last - 1)], b_makerTrackThreshold->MaxHighMoveErrRate,
                       trackedMakerPosition_k_OK_data,
                       trackedMakerPosition_k_OK_size, TrackFlag, &min_dT_k,
                       &JudgeIndex->dPError_dT_xy, &JudgeIndex->dPError_dT_z,
                       &JudgeIndex->dP_Inertial_xyNorm,
                       &JudgeIndex->angleErr_dT_Min);
        guard1 = true;
      }

      if (guard1) {
        if (!rtIsNaN(trackedMakerPosition_k_OK_data[0])) {
        } else {
          // % dS λ�Ƴ��ȶε�λ�Ʋͬʱ����λ�Ʋ��С�ͷ���
          // % ��˵��ж� 4) Ѱ�ҹ����˶� dS ����(���� moveDistance)������˵���ٳɹ�����ʱ�̣��ж� dP_Inertial �� dP_Vision�� 
          trackedMakerPosition_k_OK_size[0] = 1;
          trackedMakerPosition_k_OK_data[0] = rtNaN;

          // % dS λ�Ƴ��ȶε�λ�Ʋͬʱ����λ�Ʋ��С�ͷ���
          //  find the point which moved moveDistance
          // % ���ҹ���kʱ��ǰ�˶��˴��� dS ���������ĵ�
          //  �Ҹõ�trackedMakerPosition���ٳɹ�
          //  ��������ʱ��
          //  �����ʱ�䳤��
          if (inertialFre < 0.0) {
            stepK = ceil(inertialFre);
          } else {
            stepK = floor(inertialFre);
          }

          //  ��������
          invalid_i = inertialFre * 60.0;
          if (invalid_i < 0.0) {
            invalid_i = ceil(invalid_i);
          } else {
            invalid_i = floor(invalid_i);
          }

          i16 = b_inertial_k - 1LL;
          if (i16 > 2147483647LL) {
            i16 = 2147483647LL;
          } else {
            if (i16 < -2147483648LL) {
              i16 = -2147483648LL;
            }
          }

          ixstart = (int)i16;
          b_angleErr_dT_Min = rt_roundd_snf(invalid_i);
          if (b_angleErr_dT_Min < 2.147483648E+9) {
            if (b_angleErr_dT_Min >= -2.147483648E+9) {
              i15 = (int)b_angleErr_dT_Min;
            } else {
              i15 = MIN_int32_T;
            }
          } else if (b_angleErr_dT_Min >= 2.147483648E+9) {
            i15 = MAX_int32_T;
          } else {
            i15 = 0;
          }

          if (ixstart > invalid_i) {
            ixstart = i15;
          }

          vision_dT_k_last = rtNaN;

          //  Ĭ�����ã�Ѱ��ʧ��
          // wh = waitbar(0,'SearchDistanceK');
          i = 1;
          exitg1 = false;
          while ((!exitg1) && ((((int)stepK > 0) && (i <= ixstart)) || (((int)
                    stepK < 0) && (i >= ixstart)))) {
            i16 = (long long)b_inertial_k - i;
            if (i16 > 2147483647LL) {
              i16 = 2147483647LL;
            } else {
              if (i16 < -2147483648LL) {
                i16 = -2147483648LL;
              }
            }

            ix = (int)i16;
            for (i15 = 0; i15 < 3; i15++) {
              dP[i15] = InertialPosition[i15 + 3 * (ix - 1)] -
                InertialPosition[i15 + 3 * (b_inertial_k - 1)];
            }

            b_guard1 = false;
            if (normest(dP) > 0.5) {
              //          kCurrent_Vision = InertialK_to_VisionK(kCurrent-i);
              i16 = (long long)b_inertial_k - i;
              if (i16 > 2147483647LL) {
                i16 = 2147483647LL;
              } else {
                if (i16 < -2147483648LL) {
                  i16 = -2147483648LL;
                }
              }

              if (!rtIsNaN(b_trackedMakerPosition[3 * ((int)
                    InertialData_visual_k[(int)i16 - 1] - 1)])) {
                //  �������㣬�� trackedMakerPosition ���ٳɹ�
                i16 = (long long)b_inertial_k - i;
                if (i16 > 2147483647LL) {
                  i16 = 2147483647LL;
                } else {
                  if (i16 < -2147483648LL) {
                    i16 = -2147483648LL;
                  }
                }

                vision_dT_k_last = (int)i16;
                exitg1 = true;
              } else {
                b_guard1 = true;
              }
            } else {
              b_guard1 = true;
            }

            if (b_guard1) {
              //    waitbar(i/kCurrent);
              i += (int)stepK;
            }
          }

          // close(wh)
          if (rtIsNaN(vision_dT_k_last)) {
            //  �Ҳ����˶����� dS ������trackedMakerPosition�и��ٵ��ĵ�
            //      fprintf('�Ҳ����˶��̶����ȵĵ㣬��������֤<2>������ʧ�ܡ�\n'); 
            stepK = -0.2;

            //  ����ֵ��ʾû���ҵ�
            invalid_i = -0.17453292519943295;
            *TrackFlag = -1.4;
          } else {
            for (i15 = 0; i15 < 3; i15++) {
              invalid_i = InertialPosition[i15 + 3 * (b_inertial_k - 1)] -
                InertialPosition[i15 + 3 * ((int)vision_dT_k_last - 1)];
              stepK = otherMakersPosition_k[i15 + 3 * ((int)min_dT_k - 1)] -
                b_trackedMakerPosition[i15 + 3 * ((int)InertialData_visual_k
                [(int)vision_dT_k_last - 1] - 1)];
              b_dP[i15] = invalid_i - stepK;
              dP[i15] = invalid_i;
              dP_Vision[i15] = stepK;
            }

            stepK = normest(b_dP);
            b_angleErr_dT_Min = 0.0;
            for (i15 = 0; i15 < 3; i15++) {
              b_angleErr_dT_Min += dP[i15] * dP_Vision[i15];
            }

            invalid_i = acos(b_angleErr_dT_Min / normest(dP) / normest(dP_Vision));
            if ((stepK < 0.35) && (invalid_i < 0.3490658503988659)) {
              //  ����ͽǶ� ����
              trackedMakerPosition_k_OK_size[0] = 3;
              for (i15 = 0; i15 < 3; i15++) {
                trackedMakerPosition_k_OK_data[i15] = otherMakersPosition_k[i15
                  + 3 * ((int)min_dT_k - 1)];
              }

              *TrackFlag += 4.0;

              //      fprintf('3.1��3.2�� ģ=%0.3f���ǶȲ�=%0.3f������OK \n',normest(dPError_dS),angleErr_dS*180/pi); 
            } else {
              *TrackFlag = -*TrackFlag;

              //      fprintf('3.1��3.2�� ģ=%0.3f���ǶȲ�=%0.3f������ʧ�� \n',normest(dPError_dS),angleErr_dS*180/pi); 
            }
          }

          JudgeIndex->dPError_dS_xyNorm = stepK;
          JudgeIndex->angleErr_dS = invalid_i;
        }
      }
    }
  }
}

//
// Arguments    : struct1_T otherMakers[3600]
// Return Type  : void
//
static void PreProcess(struct1_T otherMakers[3600])
{
  int k;
  struct1_T b_otherMakers;
  int i11;
  int i12;
  int i13;
  static const signed char a[9] = { 0, -1, 0, 0, 0, -1, 1, 0, 0 };

  // % �Ӿ�λ��Ԥ����
  //  1�����Ӿ�����  ���Ӿ���������ϵ ת�� ����������ϵ
  // % ��ת�������ص�ͬ������ϵ
  //  dbstop in BodyDirection2Cr_r1
  //    ����1��    Ҫ���˳��Ӿ��궨�궨����������ϵ���ж�׼
  //    ����2��    Ҫ���Ӿ���������ϵ��Z�ᳯ������
  // % ��ת�� ����ϵ �ı����أ������Ӿ��ĳ�ʼ��Ϊԭ�㣨������߶ȣ�
  //  ������߶ȷ���
  for (k = CalStartVN - 1; k + 1 <= CalEndVN; k++) {
    //          m = size(Position_k,2);
    //          position_offest = repmat(Position_1,1,m);
    //          Position_k_new = Cvr*(Position_k-position_offest) ;  % ���Ӿ���������ϵ ת�� ����������ϵ 
    b_otherMakers = otherMakers[k];
    for (i11 = 0; i11 < 3; i11++) {
      for (i12 = 0; i12 < 10; i12++) {
        otherMakers[k].Position[i11 + 3 * i12] = 0.0;
        for (i13 = 0; i13 < 3; i13++) {
          otherMakers[k].Position[i11 + 3 * i12] += (double)a[i11 + 3 * i13] *
            b_otherMakers.Position[i13 + 3 * i12];
        }
      }
    }

    i11 = (int)(otherMakers[k].CalculatedTime + 1U);
    if ((unsigned int)i11 > 255U) {
      i11 = 255;
    }

    otherMakers[k].CalculatedTime = (unsigned char)i11;
  }
}

//
// Arguments    : double b_INSVNSCalib_VS_k[100]
//                double Calib_N_Last
//                const double b_trackedMarkerVelocity[18000]
//                const double b_trackedMakerPosition[10800]
//                int vision_k
//                double *b_Calib_N_New
//                double *b_IsCalibDataEnough
//                double dX_Vision_data[]
//                int dX_Vision_size[2]
// Return Type  : void
//
static void SearchCalibData(double b_INSVNSCalib_VS_k[100], double Calib_N_Last,
  const double b_trackedMarkerVelocity[18000], const double
  b_trackedMakerPosition[10800], int vision_k, double *b_Calib_N_New, double
  *b_IsCalibDataEnough, double dX_Vision_data[], int dX_Vision_size[2])
{
  double MaxN_Calib;
  double LastEnd_k;
  int search_k;
  double search_k_end;
  boolean_T exitg4;
  long long i18;
  double search_k_start;
  boolean_T exitg3;
  double IsCalibDataDistanceOK;
  int i19;
  boolean_T guard1 = false;
  int search_k_start_temp;
  double dX_xyNorm_VS;
  int i20;
  double VelocityDirection_data[3600];
  boolean_T exitg2;
  boolean_T exitg1;
  int b_dX_Vision_size[2];
  double b_dX_Vision_data[150];

  // % xyz 2015 ��ͯ���ع�
  // % ���� trackedMarkerVelocity �Զ�ѡ�����ڱ궨���Ժ��Ӿ�����ϵ������
  //  INSVNSCalib_VS_k �� [2*N]
  //  INSVNSCalib_VS_k(1,k)Ϊĳ��λ�Ƶ���ʼ��INSVNSCalib_VS_k(2,k)Ϊĳ��λ�ƵĽ��� �Ӿ�������� 
  *b_IsCalibDataEnough = 0.0;
  dX_Vision_size[0] = 0;
  dX_Vision_size[1] = 0;
  *b_Calib_N_New = Calib_N_Last;
  if (rtIsNaN(b_trackedMarkerVelocity[5 * (vision_k - 1)]) || rtIsNaN
      (b_trackedMakerPosition[3 * (vision_k - 1)])) {
  } else {
    // % ��ֵ��������
    //  sec  ���ڱ궨�����ݵ��ʱ��
    //  �� XYƽ���ٶȷ���仯���Χ
    MaxN_Calib = 2.0 * visionFre;
    b_fix(&MaxN_Calib);

    // % ����һ��λ�Ʋ�����֮��ʼ����
    if (Calib_N_Last > 0.0) {
      LastEnd_k = b_INSVNSCalib_VS_k[1 + (((int)Calib_N_Last - 1) << 1)];
    } else {
      LastEnd_k = 0.0;

      //  ��һ������
    }

    //  �� LastEnd_k+1 ������ vision_k
    search_k = vision_k;

    // % ����ĩβ��
    search_k_end = rtNaN;
    exitg4 = false;
    while ((!exitg4) && (search_k > LastEnd_k)) {
      if (CalibDataVelocityJudge(*(double (*)[5])&b_trackedMarkerVelocity[5 *
           (vision_k - 1)]) == 1.0) {
        search_k_end = search_k;

        //  �����µ����ݿ�ʼ�������õ���һ��OK�ĵ���Ϊĩβ��
        //          fprintf('search_k_end = %d \n ',search_k_end)
        exitg4 = true;
      } else {
        i18 = search_k - 1LL;
        if (i18 > 2147483647LL) {
          i18 = 2147483647LL;
        } else {
          if (i18 < -2147483648LL) {
            i18 = -2147483648LL;
          }
        }

        search_k = (int)i18;
      }
    }

    if (rtIsNaN(search_k_end)) {
    } else {
      // % �������
      search_k_start = rtNaN;
      exitg3 = false;
      while ((!exitg3) && (search_k > LastEnd_k)) {
        IsCalibDataDistanceOK = rt_roundd_snf(search_k_end - (double)search_k);
        if (IsCalibDataDistanceOK < 2.147483648E+9) {
          if (IsCalibDataDistanceOK >= -2.147483648E+9) {
            i19 = (int)IsCalibDataDistanceOK;
          } else {
            i19 = MIN_int32_T;
          }
        } else if (IsCalibDataDistanceOK >= 2.147483648E+9) {
          i19 = MAX_int32_T;
        } else {
          i19 = 0;
        }

        i18 = i19 + 1LL;
        if (i18 > 2147483647LL) {
          i18 = 2147483647LL;
        } else {
          if (i18 < -2147483648LL) {
            i18 = -2147483648LL;
          }
        }

        if ((int)i18 < MaxN_Calib) {
          guard1 = false;
          if (CalibDataVelocityJudge(*(double (*)[5])&b_trackedMarkerVelocity[5 *
               (vision_k - 1)]) == 1.0) {
            i18 = search_k + 1LL;
            if (i18 > 2147483647LL) {
              i18 = 2147483647LL;
            } else {
              if (i18 < -2147483648LL) {
                i18 = -2147483648LL;
              }
            }

            search_k_start_temp = (int)i18;

            //  �õ��ٶȴ�С���������� ��ʼ�㣬���ж�λ�Ƴ���
            CalibDataDistanceJudge(b_trackedMakerPosition, search_k_start_temp,
              search_k_end, &IsCalibDataDistanceOK, &dX_xyNorm_VS);
            if (IsCalibDataDistanceOK == 1.0) {
              search_k_start = search_k_start_temp;
              exitg3 = true;
            } else {
              guard1 = true;
            }
          } else {
            guard1 = true;
          }

          if (guard1) {
            i18 = search_k - 1LL;
            if (i18 > 2147483647LL) {
              i18 = 2147483647LL;
            } else {
              if (i18 < -2147483648LL) {
                i18 = -2147483648LL;
              }
            }

            search_k = (int)i18;
          }
        } else {
          exitg3 = true;
        }
      }

      if (rtIsNaN(search_k_start)) {
      } else {
        // % �ж���������ٶȵĽǶȱ仯�ǹ�С
        if (search_k_start > search_k_end) {
          i19 = 1;
          i20 = 1;
        } else {
          i19 = (int)search_k_start;
          i20 = (int)search_k_end + 1;
        }

        search_k_start_temp = i20 - i19;
        for (search_k = 0; search_k < search_k_start_temp; search_k++) {
          VelocityDirection_data[search_k] = b_trackedMarkerVelocity[4 + 5 *
            ((i19 + search_k) - 1)];
        }

        //  �ٶȷ���
        search_k_start_temp = 1;
        IsCalibDataDistanceOK = b_trackedMarkerVelocity[4 + 5 * (i19 - 1)];
        if (i20 - i19 > 1) {
          if (rtIsNaN(b_trackedMarkerVelocity[4 + 5 * (i19 - 1)])) {
            search_k = 2;
            exitg2 = false;
            while ((!exitg2) && (search_k <= i20 - i19)) {
              search_k_start_temp = search_k;
              if (!rtIsNaN(b_trackedMarkerVelocity[4 + 5 * ((i19 + search_k) - 2)]))
              {
                IsCalibDataDistanceOK = b_trackedMarkerVelocity[4 + 5 * ((i19 +
                  search_k) - 2)];
                exitg2 = true;
              } else {
                search_k++;
              }
            }
          }

          if (search_k_start_temp < i20 - i19) {
            while (search_k_start_temp + 1 <= i20 - i19) {
              if (b_trackedMarkerVelocity[4 + 5 * ((i19 + search_k_start_temp) -
                   1)] > IsCalibDataDistanceOK) {
                IsCalibDataDistanceOK = b_trackedMarkerVelocity[4 + 5 * ((i19 +
                  search_k_start_temp) - 1)];
              }

              search_k_start_temp++;
            }
          }
        }

        search_k_start_temp = 1;
        dX_xyNorm_VS = VelocityDirection_data[0];
        if (i20 - i19 > 1) {
          if (rtIsNaN(VelocityDirection_data[0])) {
            search_k = 2;
            exitg1 = false;
            while ((!exitg1) && (search_k <= i20 - i19)) {
              search_k_start_temp = search_k;
              if (!rtIsNaN(VelocityDirection_data[search_k - 1])) {
                dX_xyNorm_VS = VelocityDirection_data[search_k - 1];
                exitg1 = true;
              } else {
                search_k++;
              }
            }
          }

          if (search_k_start_temp < i20 - i19) {
            while (search_k_start_temp + 1 <= i20 - i19) {
              if (VelocityDirection_data[search_k_start_temp] < dX_xyNorm_VS) {
                dX_xyNorm_VS = VelocityDirection_data[search_k_start_temp];
              }

              search_k_start_temp++;
            }
          }
        }

        if (IsCalibDataDistanceOK - dX_xyNorm_VS > 0.52359877559829882) {
        } else {
          // % ����һ��λ�Ƴɹ�
          *b_Calib_N_New = Calib_N_Last + 1.0;
          b_INSVNSCalib_VS_k[((int)(Calib_N_Last + 1.0) - 1) << 1] =
            search_k_start;
          b_INSVNSCalib_VS_k[1 + (((int)(Calib_N_Last + 1.0) - 1) << 1)] =
            search_k_end;

          // % �жϵ�ǰ����������λ���Ƿ������������
          JudgeIsCalibDataEnough(b_INSVNSCalib_VS_k, Calib_N_Last + 1.0,
            b_trackedMakerPosition, b_IsCalibDataEnough, b_dX_Vision_data,
            b_dX_Vision_size);
          dX_Vision_size[0] = 3;
          dX_Vision_size[1] = b_dX_Vision_size[1];
          search_k_start_temp = b_dX_Vision_size[0] * b_dX_Vision_size[1];
          for (i19 = 0; i19 < search_k_start_temp; i19++) {
            dX_Vision_data[i19] = b_dX_Vision_data[i19];
          }
        }
      }
    }
  }
}

//
// Arguments    : double *makerTrackThreshold_moveTime
//                double *makerTrackThreshold_MaxMoveTime
//                double *c_makerTrackThreshold_moveDista
//                double *c_makerTrackThreshold_MaxContin
//                double *c_makerTrackThreshold_PositionE
//                double *c_makerTrackThreshold_Continues
//                double *c_makerTrackThreshold_MaxStatic
//                double *c_makerTrackThreshold_MaxPositi
//                double *c_makerTrackThreshold_Max_dPAng
//                double *c_makerTrackThreshold_MaxMarkHi
//                double c_makerTrackThreshold_MaxHighMo[2]
//                double *makerTrackThreshold_BigHighMove
//                double *makerTrackThreshold_INSMarkH0
//                double *makerTrackThreshold_VNSMarkH0
//                b_struct_T *b_INSVNSCalibSet
// Return Type  : void
//
static void SetParameters(double *makerTrackThreshold_moveTime, double
  *makerTrackThreshold_MaxMoveTime, double *c_makerTrackThreshold_moveDista,
  double *c_makerTrackThreshold_MaxContin, double
  *c_makerTrackThreshold_PositionE, double *c_makerTrackThreshold_Continues,
  double *c_makerTrackThreshold_MaxStatic, double
  *c_makerTrackThreshold_MaxPositi, double *c_makerTrackThreshold_Max_dPAng,
  double *c_makerTrackThreshold_MaxMarkHi, double
  c_makerTrackThreshold_MaxHighMo[2], double *makerTrackThreshold_BigHighMove,
  double *makerTrackThreshold_INSMarkH0, double *makerTrackThreshold_VNSMarkH0,
  b_struct_T *b_INSVNSCalibSet)
{
  double varargin_1;
  int i1;

  // % ��ֵ��������
  //  sec �켣�����ж�ʱ�䲽��
  //  m   �켣�����ж�λ�Ʋ���  ������ֵ����0.4m-0.7m��
  //  m/s  ��˵��˶����������ٶȣ���������ٶ�����Ϊ������
  *makerTrackThreshold_moveTime = 2.0;
  *makerTrackThreshold_MaxMoveTime = 3.0;
  *c_makerTrackThreshold_moveDista = 0.5;
  varargin_1 = 1.0 / visionFre * 1.5;
  if (varargin_1 <= 0.1) {
    *c_makerTrackThreshold_MaxContin = varargin_1;
  } else {
    *c_makerTrackThreshold_MaxContin = 0.1;
  }

  //  ��˵������ж����λ��ģ
  *c_makerTrackThreshold_PositionE = 0.1;

  //  �̶�ʱ�������˶���������һ������λ�Ʋ��������Χ�ڵģ�ֱ���ж�<У��1>ͨ�� 
  *c_makerTrackThreshold_Continues = 1.3;

  //  �������ڸ��ٳɹ��ĵ�ʱ���Ŵ�PositionErrorBear_dT
  //  m/s ��ֹʱ������������������
  *c_makerTrackThreshold_MaxStatic = 0.2;

  //  �̶�ʱ�������˶��������ڶ�����������һ����ͨ����λ�Ʋ�ĳ����ǹ���λ�Ƴ��ȵ�MaxPositionError_dT������ 
  *c_makerTrackThreshold_MaxPositi = 0.35;

  //  �˶��̶�����λ�Ƶ�����˶��������˶������50% ����Ҫ�������Ƕ�Լ����
  *c_makerTrackThreshold_Max_dPAng = 0.3490658503988659;

  //  �˶��̶�����λ�Ƶ����λ�Ʒ���ǶȲ�
  *c_makerTrackThreshold_MaxMarkHi = 0.4;

  //  m �������Ӿ�Ŀ����˵�߶Ȳ�仯���Χ�������޳��߶����ϴ�ĵ�
  for (i1 = 0; i1 < 2; i1++) {
    c_makerTrackThreshold_MaxHighMo[i1] = -0.3 + 0.8 * (double)i1;
  }

  //   �߶ȷ���仯��ʱ�����仯����С�����ֵ��ֱ���϶�����OK
  //  ���ָ߶ȷ�������ǳ�
  *makerTrackThreshold_BigHighMove = 0.18;

  //  m �������ֵ����Ϊ�߶ȷ���仯��
  // % ����ϵ�궨����
  b_INSVNSCalibSet->Min_xyNorm_Calib = 0.3;

  //  m  ���ڱ궨�����ݵ���С�˶�λ�Ƴ���
  b_INSVNSCalibSet->MaxTime_Calib = 2.0;

  //  sec  ���ڱ궨�����ݵ��ʱ��
  b_INSVNSCalibSet->MaxVXY_DirectionChange_Calib = 0.52359877559829882;

  //  �� XYƽ���ٶȷ���仯���Χ
  b_INSVNSCalibSet->MaxVZ_Calib = 0.1;

  //  m/s Z�����ٶ�������ֵ
  b_INSVNSCalibSet->MinVXY_Calib = 0.2;

  //  m/s XY ƽ���ٶ�ģ��С����ֵ
  b_INSVNSCalibSet->angleUniformityErr = 0.17453292519943295;

  //  �� λ��ʸ��������������
  //  �ٶȼ���
  b_INSVNSCalibSet->dT_CalV_Calib = 0.1;

  //  �����ٶ�ʱ�䲽�����궨λ������ѡ��
  b_INSVNSCalibSet->MinXYVNorm_CalAngle = 0.1;

  //   m/s xy�ٶ�ģ�������ֵ�ż����ٶȵķ���
  *makerTrackThreshold_INSMarkH0 = rtNaN;
  *makerTrackThreshold_VNSMarkH0 = rtNaN;
}

//
// global InertialData
// Arguments    : const double otherMakers_k_Position[30]
//                const double otherMakers_k_ContinuesFlag[10]
//                const double InertialPosition[34560]
//                int b_inertial_k
//                int inertial_dT_k_last
//                const double trackedMakerPosition_last_k_dT[3]
//                const double c_makerTrackThreshold_MaxHighMo[2]
//                double trackedMakerPosition_k_OK_data[]
//                int trackedMakerPosition_k_OK_size[1]
//                double *TrackFlag
//                double *min_dT_k
//                double *dPErrorNorm_dT_Min
//                double *dPError_dT_z_Min
//                double *dP_Inertial_xyNorm_Min
//                double *b_angleErr_dT_Min
// Return Type  : void
//
static void Track_dT_Judge(const double otherMakers_k_Position[30], const double
  otherMakers_k_ContinuesFlag[10], const double InertialPosition[34560], int
  b_inertial_k, int inertial_dT_k_last, const double
  trackedMakerPosition_last_k_dT[3], const double
  c_makerTrackThreshold_MaxHighMo[2], double trackedMakerPosition_k_OK_data[],
  int trackedMakerPosition_k_OK_size[1], double *TrackFlag, double *min_dT_k,
  double *dPErrorNorm_dT_Min, double *dPError_dT_z_Min, double
  *dP_Inertial_xyNorm_Min, double *b_angleErr_dT_Min)
{
  double dP_Inertial[3];
  int ix;
  double dP_Vision[30];
  double dPErrorNorm_dT[10];
  double b_dPError_dT_z[10];
  double angleErr_dT[10];
  int ixstart;
  double b_dP_Inertial[3];
  double dP_Inertial_Norm;
  int itmp;
  boolean_T exitg1;
  double b_PositionErrorBear_dT;
  double b_Max_dPAngle_dS;
  double b_MaxHighMoveErrRate[2];
  boolean_T guard1 = false;
  double HighMoveErr;

  // % ��˵��ж� 3) ��ʱ�䣨dT=3���˶��Ĺ��̣����Ժ��Ӿ�λ�Ʋ� dPError_dT �����ж��� dPError_dT(i) = normest(dP_Inertial-dP_Vision) 
  trackedMakerPosition_k_OK_size[0] = 1;
  trackedMakerPosition_k_OK_data[0] = rtNaN;
  for (ix = 0; ix < 3; ix++) {
    dP_Inertial[ix] = InertialPosition[ix + 3 * (b_inertial_k - 1)] -
      InertialPosition[ix + 3 * (inertial_dT_k_last - 1)];
  }

  //  ����Ϊ��
  *b_angleErr_dT_Min = rtNaN;

  // % λ�Ʋ� ģ�� �ǶȲ�
  for (ixstart = 0; ixstart < 10; ixstart++) {
    //  λ�Ʋ�
    for (ix = 0; ix < 3; ix++) {
      dP_Vision[ix + 3 * ixstart] = otherMakers_k_Position[ix + 3 * ixstart] -
        trackedMakerPosition_last_k_dT[ix];
      b_dP_Inertial[ix] = dP_Inertial[ix] - dP_Vision[ix + 3 * ixstart];
    }

    dPErrorNorm_dT[ixstart] = normest(b_dP_Inertial);
    b_dPError_dT_z[ixstart] = dP_Inertial[2] - dP_Vision[2 + 3 * ixstart];

    //  ��ͷʱ��dP_Inertial_z��dP_Vision(3,i)��Ϊ����dP_Vision(3,i)��ģ����dPError_dT_z(i)Ϊ�� 
    //  �ǶȲ�
    dP_Inertial_Norm = 0.0;
    for (ix = 0; ix < 3; ix++) {
      dP_Inertial_Norm += dP_Inertial[ix] * dP_Vision[ix + 3 * ixstart];
    }

    angleErr_dT[ixstart] = acos(dP_Inertial_Norm / normest(dP_Inertial) /
      normest(*(double (*)[3])&dP_Vision[3 * ixstart]));
  }

  ixstart = 1;
  *dPErrorNorm_dT_Min = dPErrorNorm_dT[0];
  itmp = 0;
  if (rtIsNaN(dPErrorNorm_dT[0])) {
    ix = 1;
    exitg1 = false;
    while ((!exitg1) && (ix + 1 < 11)) {
      ixstart = ix + 1;
      if (!rtIsNaN(dPErrorNorm_dT[ix])) {
        *dPErrorNorm_dT_Min = dPErrorNorm_dT[ix];
        itmp = ix;
        exitg1 = true;
      } else {
        ix++;
      }
    }
  }

  if (ixstart < 10) {
    while (ixstart + 1 < 11) {
      if (dPErrorNorm_dT[ixstart] < *dPErrorNorm_dT_Min) {
        *dPErrorNorm_dT_Min = dPErrorNorm_dT[ixstart];
        itmp = ixstart;
      }

      ixstart++;
    }
  }

  *min_dT_k = itmp + 1;

  //  ȡλ�Ʋ���С�ĵ��ж�
  *dPError_dT_z_Min = b_dPError_dT_z[itmp];

  //  ����λ�ƴ�С �� ���۾�ֹ�����˶�
  dP_Inertial_Norm = normest(dP_Inertial);
  *dP_Inertial_xyNorm_Min = b_normest(*(double (*)[2])&dP_Inertial[0]);
  if (dP_Inertial_Norm < 0.2) {
    //     %% ׼��ֹ״̬����dSλ���ж�
    if (*dPErrorNorm_dT_Min > 0.1) {
      //  ��˵������˶����޳�
      *TrackFlag = -3.1;
    } else {
      //  �����Ӿ��˶�λ�Ʋ�С���������ڸ���OK����˵㣬�����OK��
      //         %% �����жϳ���ʱ������
      if (otherMakers_k_ContinuesFlag[itmp] == 1.0) {
        trackedMakerPosition_k_OK_size[0] = 3;
        for (ix = 0; ix < 3; ix++) {
          trackedMakerPosition_k_OK_data[ix] = otherMakers_k_Position[ix + 3 *
            itmp];
        }

        *TrackFlag = 3.1;
      } else {
        //  �����Ӿ��˶�λ�Ʋ�С����������������4���ж�
        *TrackFlag = 1.31;
      }
    }
  } else {
    //     %% �˶�״̬��
    if (otherMakers_k_ContinuesFlag[itmp] == 1.0) {
      //        %% ��ǰһʱ�̸��ٳɹ��ĵ�������ſ�Ҫ��
      b_PositionErrorBear_dT = 0.13;
      b_Max_dPAngle_dS = 0.4537856055185257;
      for (ix = 0; ix < 2; ix++) {
        b_MaxHighMoveErrRate[ix] = c_makerTrackThreshold_MaxHighMo[ix] * 1.3;
      }
    } else {
      b_PositionErrorBear_dT = 0.1;
      b_Max_dPAngle_dS = 0.3490658503988659;
      for (ix = 0; ix < 2; ix++) {
        b_MaxHighMoveErrRate[ix] = c_makerTrackThreshold_MaxHighMo[ix];
      }
    }

    //  ��ֹ��ֱ���޳�
    if (normest(*(double (*)[3])&dP_Vision[3 * itmp]) < 0.2) {
      *TrackFlag = 1.35;
    } else {
      //     %% �߶ȱ仯��ˮƽ���򲻿��ţ�ֱ��ͨ���߶��ж�
      guard1 = false;
      if (fabs(dP_Inertial[2]) > 0.18) {
        HighMoveErr = b_dPError_dT_z[itmp] / dP_Inertial[2];
        if ((HighMoveErr > b_MaxHighMoveErrRate[0]) && (HighMoveErr <
             b_MaxHighMoveErrRate[1])) {
          //            %% �߶ȷ���λ��������С������OK
          *TrackFlag = 3.9;
          trackedMakerPosition_k_OK_size[0] = 3;
          for (ix = 0; ix < 3; ix++) {
            trackedMakerPosition_k_OK_data[ix] = otherMakers_k_Position[ix + 3 *
              itmp];
          }
        } else {
          guard1 = true;
        }
      } else {
        guard1 = true;
      }

      if (guard1) {
        //     %% ���ǶȲ��ж�Ϊ�������˶����볬�� moveDistance ʱ���жϽǶȲ���ſ�λ�Ʋ����� 
        if ((dP_Inertial_Norm > 0.5) && (angleErr_dT[itmp] < 0.3490658503988659)
            && (*dPErrorNorm_dT_Min < 0.35)) {
          trackedMakerPosition_k_OK_size[0] = 3;
          for (ix = 0; ix < 3; ix++) {
            trackedMakerPosition_k_OK_data[ix] = otherMakers_k_Position[ix + 3 *
              itmp];
          }

          *TrackFlag = 3.7;
          *b_angleErr_dT_Min = angleErr_dT[itmp];
        } else {
          //     %% λ�Ʋ��ж�Ϊ��
          if ((*dPErrorNorm_dT_Min < b_PositionErrorBear_dT) &&
              (angleErr_dT[itmp] < b_Max_dPAngle_dS * 2.0)) {
            trackedMakerPosition_k_OK_size[0] = 3;
            for (ix = 0; ix < 3; ix++) {
              trackedMakerPosition_k_OK_data[ix] = otherMakers_k_Position[ix + 3
                * itmp];
            }

            *TrackFlag = 3.5;

            //      fprintf( '3.5�������Ӿ�λ�Ʋ��=%0.4f ������OK\n',normest(dPError_dT) ); 
          } else {
            *TrackFlag = 1.37;
          }
        }
      }
    }
  }
}

//
// Arguments    : double compensateRate
//                const double d_trackedMakerPosition_Inertial[34560]
//                const double HipDisplacement[34560]
//                const double InertialPosition[34560]
//                double InertialPositionCompensate_out[34560]
//                double HipDisplacementNew_out[34560]
// Return Type  : void
//
static void VNSCompensateINS(double compensateRate, const double
  d_trackedMakerPosition_Inertial[34560], const double HipDisplacement[34560],
  const double InertialPosition[34560], double InertialPositionCompensate_out
  [34560], double HipDisplacementNew_out[34560])
{
  int i8;
  int k;
  long long i9;
  int b_k;
  int c_k;

  // % λ�Ʋ���
  // %% Input
  //  trackedMakerPosition_InertialTime �� ��˵��ѧλ�ã�������ʱ��洢
  //  HipDisplacement �� Hip�ڱ������µ�λ�� ���� BVH �õ���
  //  InertialPosition�� ����ϵ����˵㰲װλ�ö�Ӧ�ؽڵ�λ�ã���װ��ͷ��ʱ��InertialPosition Ϊ����ͷ��λ�ã� 
  // %% Output
  //  InertialPositionNew �� ��������Ե�λ��
  //  HipDisplacementNew�� ������Hip��λ��
  // % BVH ��ȡ�ĸ��� N_BVH ���ܻ�� N1 �༸��
  // % �Ȳ��� InertialPositionNew
  if (!c_InertialPositionCompensate_no) {
    c_InertialPositionCompensate_no = true;

    //  ÿһ�����ۻ�λ�Ʋ����� ��¼
    for (i8 = 0; i8 < 3; i8++) {
      InertialPositionCompensate[i8] = 0.0;
    }

    for (i8 = 0; i8 < 11520; i8++) {
      InertialPositionNew[2 + 3 * i8] = InertialPosition[2 + 3 * i8];
    }

    //  �߶Ȳ�����
    for (i8 = 0; i8 < 2; i8++) {
      InertialPositionNew[i8] = InertialPosition[i8];
    }

    //  ��ʼ��ѡ�����
    for (i8 = 0; i8 < 11520; i8++) {
      HipDisplacementNew[2 + 3 * i8] = HipDisplacement[2 + 3 * i8];
    }

    for (i8 = 0; i8 < 3; i8++) {
      HipDisplacementNew[i8] = HipDisplacement[i8];
    }
  }

  if (2 < CalStartIN) {
    k = CalStartIN - 1;
  } else {
    k = 1;
  }

  while (k + 1 <= CalEndIN) {
    //  ���ô����Ե���
    i9 = (k + 1) - 1LL;
    if (i9 > 2147483647LL) {
      i9 = 2147483647LL;
    } else {
      if (i9 < -2147483648LL) {
        i9 = -2147483648LL;
      }
    }

    b_k = (int)i9;
    i9 = (k + 1) - 1LL;
    if (i9 > 2147483647LL) {
      i9 = 2147483647LL;
    } else {
      if (i9 < -2147483648LL) {
        i9 = -2147483648LL;
      }
    }

    c_k = (int)i9;
    for (i8 = 0; i8 < 2; i8++) {
      InertialPositionNew[i8 + 3 * k] = InertialPositionNew[i8 + 3 * (b_k - 1)]
        + (InertialPosition[i8 + 3 * k] - InertialPosition[i8 + 3 * (c_k - 1)]);
    }

    //  ���󴿹���Ϊ���
    if (!rtIsNaN(d_trackedMakerPosition_Inertial[3 * k])) {
      for (i8 = 0; i8 < 2; i8++) {
        InertialErr[i8 + (k << 1)] = d_trackedMakerPosition_Inertial[i8 + 3 * k]
          - InertialPositionNew[i8 + 3 * k];

        //  �������
        InertialPositionNew[i8 + 3 * k] += InertialErr[i8 + (k << 1)] *
          compensateRate;
      }
    }

    for (i8 = 0; i8 < 2; i8++) {
      InertialPositionCompensate[i8 + 3 * k] = InertialPositionNew[i8 + 3 * k] -
        InertialPosition[i8 + 3 * k];
    }

    //  �ۻ�λ�Ʋ�����
    k++;
  }

  // % ͨ�� InertialPositionNew ���� HipDisplacementNew
  //  ��Headλ�ô���Hip��������ͷ��head�����λ��
  for (k = CalStartIN - 1; k + 1 <= CalEndIN; k++) {
    for (i8 = 0; i8 < 2; i8++) {
      HipDisplacementNew[i8 + 3 * k] = HipDisplacement[i8 + 3 * k] +
        InertialPositionCompensate[i8 + 3 * k];
    }

    for (i8 = 0; i8 < 3; i8++) {
      HipDisplacementNew[i8 + 3 * k] = HipDisplacement[i8 + 3 * k];
    }
  }

  for (i8 = 0; i8 < 34560; i8++) {
    InertialPositionCompensate_out[i8] = InertialPositionCompensate[i8];
    HipDisplacementNew_out[i8] = HipDisplacementNew[i8];
  }
}

//
// Arguments    : void
// Return Type  : void
//
static void VNSCompensateINS_init()
{
  int i10;
  c_InertialPositionCompensate_no = false;
  for (i10 = 0; i10 < 34560; i10++) {
    InertialPositionCompensate[i10] = rtNaN;
    InertialPositionNew[i10] = rtNaN;
    HipDisplacementNew[i10] = rtNaN;
  }

  memset(&InertialErr[0], 0, 23040U * sizeof(double));
}

//
// Arguments    : double *x
// Return Type  : void
//
static void b_fix(double *x)
{
  if (*x < 0.0) {
    *x = ceil(*x);
  } else {
    *x = floor(*x);
  }
}

//
// Arguments    : const double S[2]
// Return Type  : double
//
static double b_normest(const double S[2])
{
  double e;
  double scale;
  int k;
  double absxk;
  double t;
  e = 0.0;
  scale = 2.2250738585072014E-308;
  for (k = 0; k < 2; k++) {
    absxk = fabs(S[k]);
    if (absxk > scale) {
      t = scale / absxk;
      e = 1.0 + e * t * t;
      scale = absxk;
    } else {
      t = absxk / scale;
      e += t * t;
    }
  }

  return scale * sqrt(e);
}

//
// Arguments    : const double A_data[]
//                double B_data[]
//                int B_size[2]
// Return Type  : void
//
static void eml_lusolve(const double A_data[], double B_data[], int B_size[2])
{
  double b_A_data[4];
  int ix;
  int ipiv_data_idx_0;
  int iy;
  int k;
  double temp;
  int jBcol;
  int jAcol;
  for (ix = 0; ix < 4; ix++) {
    b_A_data[ix] = A_data[ix];
  }

  ipiv_data_idx_0 = 1;
  ix = 0;
  if (fabs(b_A_data[1]) > fabs(b_A_data[0])) {
    ix = 1;
  }

  if (b_A_data[ix] != 0.0) {
    if (ix != 0) {
      ipiv_data_idx_0 = 2;
      ix = 0;
      iy = 1;
      for (k = 0; k < 2; k++) {
        temp = b_A_data[ix];
        b_A_data[ix] = b_A_data[iy];
        b_A_data[iy] = temp;
        ix += 2;
        iy += 2;
      }
    }

    b_A_data[1] /= b_A_data[0];
  }

  if (b_A_data[2] != 0.0) {
    b_A_data[3] += b_A_data[1] * -b_A_data[2];
  }

  if (B_size[1] == 0) {
  } else {
    for (iy = 0; iy < 2; iy++) {
      jBcol = iy << 1;
      jAcol = iy << 1;
      k = 1;
      while (k <= iy) {
        if (b_A_data[jAcol] != 0.0) {
          for (ix = 0; ix < 2; ix++) {
            B_data[ix + jBcol] -= b_A_data[jAcol] * B_data[ix];
          }
        }

        k = 2;
      }

      temp = 1.0 / b_A_data[iy + jAcol];
      for (ix = 0; ix < 2; ix++) {
        B_data[ix + jBcol] *= temp;
      }
    }
  }

  if (B_size[1] == 0) {
  } else {
    for (iy = 1; iy > -1; iy += -1) {
      jBcol = iy << 1;
      jAcol = (iy << 1) + 1;
      k = iy + 2;
      while (k <= 2) {
        if (b_A_data[jAcol] != 0.0) {
          for (ix = 0; ix < 2; ix++) {
            B_data[ix + jBcol] -= b_A_data[jAcol] * B_data[ix + 2];
          }
        }

        k = 3;
      }
    }
  }

  if (ipiv_data_idx_0 != 1) {
    for (ix = 0; ix < 2; ix++) {
      temp = B_data[ix];
      B_data[ix] = B_data[ix + B_size[0]];
      B_data[ix + B_size[0]] = temp;
    }
  }
}

//
// Arguments    : int n
//                double *alpha1
//                double x_data[]
//                int ix0
// Return Type  : double
//
static double eml_matlab_zlarfg(int n, double *alpha1, double x_data[], int ix0)
{
  double tau;
  double xnorm;
  int knt;
  int i21;
  int k;
  tau = 0.0;
  if (n <= 0) {
  } else {
    xnorm = eml_xnrm2(n - 1, x_data, ix0);
    if (xnorm != 0.0) {
      xnorm = rt_hypotd_snf(*alpha1, xnorm);
      if (*alpha1 >= 0.0) {
        xnorm = -xnorm;
      }

      if (fabs(xnorm) < 1.0020841800044864E-292) {
        knt = 0;
        do {
          knt++;
          i21 = (ix0 + n) - 2;
          for (k = ix0; k <= i21; k++) {
            x_data[k - 1] *= 9.9792015476736E+291;
          }

          xnorm *= 9.9792015476736E+291;
          *alpha1 *= 9.9792015476736E+291;
        } while (!(fabs(xnorm) >= 1.0020841800044864E-292));

        xnorm = eml_xnrm2(n - 1, x_data, ix0);
        xnorm = rt_hypotd_snf(*alpha1, xnorm);
        if (*alpha1 >= 0.0) {
          xnorm = -xnorm;
        }

        tau = (xnorm - *alpha1) / xnorm;
        *alpha1 = 1.0 / (*alpha1 - xnorm);
        i21 = (ix0 + n) - 2;
        for (k = ix0; k <= i21; k++) {
          x_data[k - 1] *= *alpha1;
        }

        for (k = 1; k <= knt; k++) {
          xnorm *= 1.0020841800044864E-292;
        }

        *alpha1 = xnorm;
      } else {
        tau = (xnorm - *alpha1) / xnorm;
        *alpha1 = 1.0 / (*alpha1 - xnorm);
        i21 = (ix0 + n) - 2;
        for (k = ix0; k <= i21; k++) {
          x_data[k - 1] *= *alpha1;
        }

        *alpha1 = xnorm;
      }
    }
  }

  return tau;
}

//
// Arguments    : const double A_data[]
//                const int A_size[2]
//                double B_data[]
//                int B_size[2]
//                double Y[4]
// Return Type  : void
//
static void eml_qrsolve(const double A_data[], const int A_size[2], double
  B_data[], int B_size[2], double Y[4])
{
  int mn;
  int itemp;
  int i7;
  double b_A_data[100];
  int b_mn;
  double tau_data[2];
  signed char jpvt[2];
  double work[2];
  int i;
  int k;
  double vn1[2];
  double vn2[2];
  int pvt;
  double c;
  int i_i;
  int mmi;
  int ix;
  int iy;
  double atmp;
  int lastv;
  int lastc;
  boolean_T exitg2;
  int32_T exitg1;
  double absxk;
  double t;
  int b_A_size;
  if (A_size[0] <= 2) {
    mn = A_size[0];
  } else {
    mn = 2;
  }

  itemp = A_size[0] * A_size[1];
  for (i7 = 0; i7 < itemp; i7++) {
    b_A_data[i7] = A_data[i7];
  }

  if (A_size[0] <= 2) {
    b_mn = A_size[0];
  } else {
    b_mn = 2;
  }

  for (i7 = 0; i7 < 2; i7++) {
    jpvt[i7] = (signed char)(1 + i7);
  }

  if (A_size[0] == 0) {
  } else {
    for (i = 0; i < 2; i++) {
      work[i] = 0.0;
    }

    k = 1;
    for (pvt = 0; pvt < 2; pvt++) {
      c = eml_xnrm2(A_size[0], A_data, k);
      vn2[pvt] = c;
      k += A_size[0];
      vn1[pvt] = c;
    }

    for (i = 0; i + 1 <= b_mn; i++) {
      i_i = i + i * A_size[0];
      mmi = (A_size[0] - i) - 1;
      itemp = 0;
      if ((2 - i > 1) && (fabs(vn1[1]) > fabs(vn1[i]))) {
        itemp = 1;
      }

      pvt = i + itemp;
      if (pvt + 1 != i + 1) {
        ix = A_size[0] * pvt;
        iy = A_size[0] * i;
        for (k = 1; k <= A_size[0]; k++) {
          c = b_A_data[ix];
          b_A_data[ix] = b_A_data[iy];
          b_A_data[iy] = c;
          ix++;
          iy++;
        }

        itemp = jpvt[pvt];
        jpvt[pvt] = jpvt[i];
        jpvt[i] = (signed char)itemp;
        vn1[pvt] = vn1[i];
        vn2[pvt] = vn2[i];
      }

      if (i + 1 < A_size[0]) {
        atmp = b_A_data[i_i];
        tau_data[i] = eml_matlab_zlarfg(mmi + 1, &atmp, b_A_data, i_i + 2);
      } else {
        atmp = b_A_data[i_i];
        tau_data[i] = 0.0;
      }

      b_A_data[i_i] = atmp;
      if (i + 1 < 2) {
        atmp = b_A_data[i_i];
        b_A_data[i_i] = 1.0;
        if (tau_data[0] != 0.0) {
          lastv = 1 + mmi;
          itemp = i_i + mmi;
          while ((lastv > 0) && (b_A_data[itemp] == 0.0)) {
            lastv--;
            itemp--;
          }

          lastc = 1;
          exitg2 = false;
          while ((!exitg2) && (lastc > 0)) {
            itemp = A_size[0];
            do {
              exitg1 = 0;
              if (itemp + 1 <= A_size[0] + lastv) {
                if (b_A_data[itemp] != 0.0) {
                  exitg1 = 1;
                } else {
                  itemp++;
                }
              } else {
                lastc = 0;
                exitg1 = 2;
              }
            } while (exitg1 == 0);

            if (exitg1 == 1) {
              exitg2 = true;
            }
          }
        } else {
          lastv = 0;
          lastc = 0;
        }

        if (lastv > 0) {
          if (lastc == 0) {
          } else {
            work[0] = 0.0;
            iy = 0;
            for (pvt = 1 + A_size[0]; pvt <= 1 + A_size[0]; pvt += A_size[0]) {
              ix = i_i;
              c = 0.0;
              i7 = (pvt + lastv) - 1;
              for (itemp = pvt; itemp <= i7; itemp++) {
                c += b_A_data[itemp - 1] * b_A_data[ix];
                ix++;
              }

              work[iy] += c;
              iy++;
            }
          }

          if (-tau_data[0] == 0.0) {
          } else {
            k = A_size[0];
            iy = 0;
            pvt = 1;
            while (pvt <= lastc) {
              if (work[iy] != 0.0) {
                c = work[iy] * -tau_data[0];
                ix = i_i;
                i7 = lastv + k;
                for (itemp = k; itemp + 1 <= i7; itemp++) {
                  b_A_data[itemp] += b_A_data[ix] * c;
                  ix++;
                }
              }

              iy++;
              k += A_size[0];
              pvt = 2;
            }
          }
        }

        b_A_data[i_i] = atmp;
      }

      pvt = i + 2;
      while (pvt < 3) {
        itemp = (i + A_size[0]) + 1;
        if (vn1[1] != 0.0) {
          c = fabs(b_A_data[i + A_size[0]]) / vn1[1];
          c = 1.0 - c * c;
          if (c < 0.0) {
            c = 0.0;
          }

          atmp = vn1[1] / vn2[1];
          atmp = c * (atmp * atmp);
          if (atmp <= 1.4901161193847656E-8) {
            if (i + 1 < A_size[0]) {
              c = 0.0;
              if (mmi < 1) {
              } else if (mmi == 1) {
                c = fabs(b_A_data[itemp]);
              } else {
                atmp = 2.2250738585072014E-308;
                pvt = itemp + mmi;
                while (itemp + 1 <= pvt) {
                  absxk = fabs(b_A_data[itemp]);
                  if (absxk > atmp) {
                    t = atmp / absxk;
                    c = 1.0 + c * t * t;
                    atmp = absxk;
                  } else {
                    t = absxk / atmp;
                    c += t * t;
                  }

                  itemp++;
                }

                c = atmp * sqrt(c);
              }

              vn1[1] = c;
              vn2[1] = c;
            } else {
              vn1[1] = 0.0;
              vn2[1] = 0.0;
            }
          } else {
            vn1[1] *= sqrt(c);
          }
        }

        pvt = 3;
      }
    }
  }

  atmp = 0.0;
  if (mn > 0) {
    if (A_size[0] >= 2) {
      b_A_size = A_size[0];
    } else {
      b_A_size = 2;
    }

    c = (double)b_A_size * fabs(b_A_data[0]) * 2.2204460492503131E-16;
    k = 0;
    while ((k <= mn - 1) && (!(fabs(b_A_data[k + A_size[0] * k]) <= c))) {
      atmp++;
      k++;
    }
  }

  for (i7 = 0; i7 < 4; i7++) {
    Y[i7] = 0.0;
  }

  for (pvt = 0; pvt < mn; pvt++) {
    if (tau_data[pvt] != 0.0) {
      for (k = 0; k < 2; k++) {
        c = B_data[pvt + B_size[0] * k];
        i7 = A_size[0] - pvt;
        for (i = 0; i <= i7 - 2; i++) {
          itemp = (pvt + i) + 1;
          c += b_A_data[itemp + A_size[0] * pvt] * B_data[itemp + B_size[0] * k];
        }

        c *= tau_data[pvt];
        if (c != 0.0) {
          B_data[pvt + B_size[0] * k] -= c;
          i7 = A_size[0] - pvt;
          for (i = 0; i <= i7 - 2; i++) {
            itemp = (pvt + i) + 1;
            B_data[itemp + B_size[0] * k] -= b_A_data[itemp + A_size[0] * pvt] *
              c;
          }
        }
      }
    }
  }

  for (k = 0; k < 2; k++) {
    for (i = 0; i < (int)atmp; i++) {
      Y[(jpvt[i] + (k << 1)) - 1] = B_data[i + B_size[0] * k];
    }

    for (pvt = 0; pvt < (int)-(1.0 + (-1.0 - atmp)); pvt++) {
      c = atmp + -(double)pvt;
      Y[(jpvt[(int)c - 1] + (k << 1)) - 1] /= b_A_data[((int)c + A_size[0] *
        ((int)c - 1)) - 1];
      i = 0;
      while (i <= (int)c - 2) {
        Y[(jpvt[0] + (k << 1)) - 1] -= Y[(jpvt[(int)c - 1] + (k << 1)) - 1] *
          b_A_data[A_size[0] * ((int)c - 1)];
        i = 1;
      }
    }
  }
}

//
// Arguments    : int n
//                const double x_data[]
//                int ix0
// Return Type  : double
//
static double eml_xnrm2(int n, const double x_data[], int ix0)
{
  double y;
  double scale;
  int kend;
  int k;
  double absxk;
  double t;
  y = 0.0;
  if (n < 1) {
  } else if (n == 1) {
    y = fabs(x_data[ix0 - 1]);
  } else {
    scale = 2.2250738585072014E-308;
    kend = (ix0 + n) - 1;
    for (k = ix0; k <= kend; k++) {
      absxk = fabs(x_data[k - 1]);
      if (absxk > scale) {
        t = scale / absxk;
        y = 1.0 + y * t * t;
        scale = absxk;
      } else {
        t = absxk / scale;
        y += t * t;
      }
    }

    y = scale * sqrt(y);
  }

  return y;
}

//
// Arguments    : emxArray__common *emxArray
//                int oldNumel
//                int elementSize
// Return Type  : void
//
static void emxEnsureCapacity(emxArray__common *emxArray, int oldNumel, int
  elementSize)
{
  int newNumel;
  int i;
  void *newData;
  newNumel = 1;
  for (i = 0; i < emxArray->numDimensions; i++) {
    newNumel *= emxArray->size[i];
  }

  if (newNumel > emxArray->allocatedSize) {
    i = emxArray->allocatedSize;
    if (i < 16) {
      i = 16;
    }

    while (i < newNumel) {
      i <<= 1;
    }

    newData = calloc((unsigned int)i, (unsigned int)elementSize);
    if (emxArray->data != NULL) {
      memcpy(newData, emxArray->data, (unsigned int)(elementSize * oldNumel));
      if (emxArray->canFreeData) {
        free(emxArray->data);
      }
    }

    emxArray->data = newData;
    emxArray->allocatedSize = i;
    emxArray->canFreeData = true;
  }
}

//
// Arguments    : emxArray_real_T **pEmxArray
// Return Type  : void
//
static void emxFree_real_T(emxArray_real_T **pEmxArray)
{
  if (*pEmxArray != (emxArray_real_T *)NULL) {
    if (((*pEmxArray)->data != (double *)NULL) && (*pEmxArray)->canFreeData) {
      free((void *)(*pEmxArray)->data);
    }

    free((void *)(*pEmxArray)->size);
    free((void *)*pEmxArray);
    *pEmxArray = (emxArray_real_T *)NULL;
  }
}

//
// Arguments    : emxArray_real_T **pEmxArray
//                int b_numDimensions
// Return Type  : void
//
static void emxInit_real_T(emxArray_real_T **pEmxArray, int b_numDimensions)
{
  emxArray_real_T *emxArray;
  int i;
  *pEmxArray = (emxArray_real_T *)malloc(sizeof(emxArray_real_T));
  emxArray = *pEmxArray;
  emxArray->data = (double *)NULL;
  emxArray->numDimensions = b_numDimensions;
  emxArray->size = (int *)malloc((unsigned int)(sizeof(int) * b_numDimensions));
  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < b_numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

//
// Arguments    : const double S[3]
// Return Type  : double
//
static double normest(const double S[3])
{
  double e;
  double scale;
  int k;
  double absxk;
  double t;
  e = 0.0;
  scale = 2.2250738585072014E-308;
  for (k = 0; k < 3; k++) {
    absxk = fabs(S[k]);
    if (absxk > scale) {
      t = scale / absxk;
      e = 1.0 + e * t * t;
      scale = absxk;
    } else {
      t = absxk / scale;
      e += t * t;
    }
  }

  return scale * sqrt(e);
}

//
// Arguments    : const double a[3]
//                int varargin_2
//                emxArray_real_T *b
// Return Type  : void
//
static void repmat(const double a[3], int varargin_2, emxArray_real_T *b)
{
  int jtilecol;
  int ibtile;
  int k;
  jtilecol = b->size[0] * b->size[1];
  b->size[0] = 3;
  b->size[1] = varargin_2;
  emxEnsureCapacity((emxArray__common *)b, jtilecol, (int)sizeof(double));
  if (varargin_2 == 0) {
  } else {
    for (jtilecol = 1; jtilecol <= varargin_2; jtilecol++) {
      ibtile = (jtilecol - 1) * 3;
      for (k = 0; k < 3; k++) {
        b->data[ibtile + k] = a[k];
      }
    }
  }
}

//
// Arguments    : double u0
//                double u1
// Return Type  : double
//
static double rt_hypotd_snf(double u0, double u1)
{
  double y;
  double a;
  double b;
  a = fabs(u0);
  b = fabs(u1);
  if (a < b) {
    a /= b;
    y = b * sqrt(a * a + 1.0);
  } else if (a > b) {
    b /= a;
    y = a * sqrt(b * b + 1.0);
  } else if (rtIsNaN(b)) {
    y = b;
  } else {
    y = a * 1.4142135623730951;
  }

  return y;
}

//
// Arguments    : double u
// Return Type  : double
//
static double rt_roundd_snf(double u)
{
  double y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = u * 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

//
// Arguments    : const struct0_T *InertialData
//                struct1_T otherMakers[3600]
//                double compensateRate
//                const struct2_T *CalculateOrder
//                double b_InertialPositionCompensate[34560]
//                double b_HipDisplacementNew[34560]
// Return Type  : void
//
void GetINSCompensateFromVNS(const struct0_T *InertialData, struct1_T
  otherMakers[3600], double compensateRate, const struct2_T *CalculateOrder,
  double b_InertialPositionCompensate[34560], double b_HipDisplacementNew[34560])
{
  int k;
  static double InertialPosition[34560];
  static double d_trackedMakerPosition_Inertial[34560];

  // % xyz 2015 5.25
  // % otherMakers
  //  otherMakers(k).frequency [1]
  //  otherMakers(k).Position  [3*M]
  //  otherMakers(k).otherMakersN [1]
  // ��otherMakers(k).time [1]
  // ��otherMakers(k).inertial_k [1]
  // ��otherMakers(k).MarkerSet ""
  //  ��¼ÿ����˵����������
  //  otherMakers(k).trackedMakerPosition  = NaN(3,1);
  //  otherMakers(k).ContinuesFlag = zeros(1,M) ; % ������
  //  otherMakers(k).ContinuesLastPosition = NaN(3,M)  ;
  //  otherMakers(k).ContinuesLastTime = NaN[1*M] ;
  //  otherMakers(k).ContinuesLastK = NaN[1*M];
  // % InertialData
  //  InertialData.frequency (k)
  //  InertialData.time (k)
  //  InertialData.visuak_k  (k)
  //  InertialData.HipQuaternion(k)  [4*N]
  //  InertialData.HipPosition (k)  [3*N]
  //  InertialData.HeadQuaternion (k)  [4*N]
  //  InertialData.HeadPosition (k)  [3*N]
  //  InertialData.BodyDirection(k)  [3*1]
  // % CalculateOrder �������
  //  CalStartVN = CalculateOrder.CalStartVN ;  �Ӿ�������� int32[1]
  //  CalEndVN = CalculateOrder.CalEndVN ;      �Ӿ������յ�
  //  CalStartIN = CalculateOrder.CalStartIN;   ���Լ������
  //  CalEndIN = CalculateOrder.CalEndIN;       ���Լ����յ�
  // % CalculateOrder �����ù���
  //    CalStartVN �� CalStartIN ��1��ʼ��������һʱ�̱��������� CalStartIN = CalEndINSave+1; CalStartVN = CalStartVNSave+1; 
  //    CalEndIN ���ڻ���� CalStartVN ��  CalEndVN ���ڻ����CalStartVN
  // % �� Optitrack �� OtherMarker ��������ϵͳ
  // % �õ����� Hip λ�ò����� InertialPositionCompensate
  //  InertialPositionCompensate [ 3*N ]  m  NEDϵ
  //  CalStartVN_in �� �Ӿ�������㣨��
  //  CalEndVN_in �������յ㣨�Ӿ���
  //  IsHandledVisual IsHandledInerital ��¼ÿ�����Ĵ������ �� 0��ʾû����1��ʾ1��-������2�����ظ����� 
  // % �������  ʵʱ�����ߵ��л� ʵ��
  //    CalStartN �� ������ʼ�㣨�Ӿ���
  //    CalEndN �� ��������㣨�Ӿ���
  CalStartVN = CalculateOrder->CalStartVN;
  CalEndVN = CalculateOrder->CalEndVN;
  CalStartIN = CalculateOrder->CalStartIN;
  CalEndIN = CalculateOrder->CalEndIN;

  //  ���Ӿ��궨ʱ�����������������κ�Ҫ��ʱ����ͨ�� BodyDirection ���Ӿ��ĳ������������һ�� 
  //  inertialTime(CalStartVN:CalEndVN ) = InertialData.time(CalStartVN:CalEndVN ) ; 
  if (CalStartVN < 10) {
    k = 0;
  } else {
    k = CalStartVN - 1;
  }

  while (k + 1 <= CalEndVN) {
    VisionData_inertial_k[k] = otherMakers[k].inertial_k;
    k++;
  }

  // % otherMakers Ԥ����
  PreProcess(otherMakers);

  //  fprintf('PreProcess OK \n');
  //        DrawAllINSVNS( otherMakers,InertialData ) ;
  //     return;
  // % ����˵����
  //        dbstop in GetRightOtherMaker
  // % load data
  //  inertialTime = InertialData.time ;
  inertialFre = InertialData->frequency;
  for (k = 0; k < 11520; k++) {
    InertialData_visual_k[k] = InertialData->visual_k[k];
  }

  visionFre = otherMakers[0].frequency;
  switch (otherMakers[0].MarkerSet) {
   case 16:
    //  ���м����ݹ������
    //  'Head'
    for (k = 0; k < 34560; k++) {
      InertialPosition[k] = InertialData->HeadPosition[k];
    }
    break;

   case 1:
    //   'Hip'
    for (k = 0; k < 34560; k++) {
      InertialPosition[k] = InertialData->HipPosition[k];
    }
    break;

   default:
    for (k = 0; k < 34560; k++) {
      InertialPosition[k] = InertialData->HeadPosition[k];
    }
    break;
  }

  GetRightOtherMaker(otherMakers, InertialPosition,
                     d_trackedMakerPosition_Inertial);

  // % λ�ò���
  VNSCompensateINS(compensateRate, d_trackedMakerPosition_Inertial,
                   InertialData->HipPosition, InertialPosition,
                   b_InertialPositionCompensate, b_HipDisplacementNew);
}

//
// Arguments    : void
// Return Type  : void
//
void GetINSCompensateFromVNS_initialize()
{
  int i0;
  rt_InitInfAndNaN(8U);
  IsGetFirstMarker = b_IsGetFirstMarker;
  makerTrackThreshold_not_empty = false;
  visionFre = b_visionFre;
  for (i0 = 0; i0 < 11520; i0++) {
    InertialData_visual_k[i0] = rtNaN;
  }

  inertialFre = b_inertialFre;
  for (i0 = 0; i0 < 3600; i0++) {
    VisionData_inertial_k[i0] = rtNaN;
  }

  CalEndIN = b_CalEndIN;
  CalStartIN = b_CalStartIN;
  CalEndVN = b_CalEndVN;
  CalStartVN = b_CalStartVN;
  VNSCompensateINS_init();
  GetRightOtherMaker_init();
}

//
// Arguments    : void
// Return Type  : void
//
void GetINSCompensateFromVNS_terminate()
{
  // (no terminate code required)
}

//
// File trailer for GetINSCompensateFromVNS.cpp
//
// [EOF]
//
