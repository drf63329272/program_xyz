//
// File: GetINSCompensateFromVNS.cpp
//
// MATLAB Coder version            : 2.6
// C/C++ source code generated on  : 16-Jun-2015 17:44:10
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

#ifndef struct_sDbo8t4Nd8yg93BzqquZf8D
#define struct_sDbo8t4Nd8yg93BzqquZf8D

struct sDbo8t4Nd8yg93BzqquZf8D
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
};

#endif                                 //struct_sDbo8t4Nd8yg93BzqquZf8D

typedef sDbo8t4Nd8yg93BzqquZf8D c_struct_T;
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
#define b_CalStartVN                   (1.0)
#define b_CalEndVN                     (1.0)
#define b_IsOnLine                     (1.0)
#define b_inertialFre                  (96.0)
#define b_visionFre                    (30.0)
#define b_CalStartIN                   (1.0)
#define b_CalEndIN                     (1.0)
#define b_IsGetFirstMarker             (0.0)

// Variable Definitions
static double CalStartVN;
static double CalEndVN;
static double IsOnLine;
static double VisionData_inertial_k[3600];
static double inertialFre;
static double InertialData_visual_k[11520];
static double visionFre;
static double CalStartIN;
static double CalEndIN;
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
static double IsGetFirstMarker;

// Function Declarations
static void BodyDirection2Cr_r1(const double b_BodyDirection[3], double Cr_r1[9]);
static void CalVelocity(const double b_Position[10800], double data_k, double
  fre, double Velocity_k_data[], int Velocity_k_size[1], double *k_calV);
static void CalibDataDistanceJudge(const double b_trackedMakerPosition[10800],
  double search_k_start, double search_k_end, double *IsCalibDataDistanceOK,
  double *dX_xyNorm_VS);
static double CalibDataVelocityJudge(const double trackedMarkerVelocity_k[5]);
static void CompensateSecond(struct1_T otherMakers[3600], const double Crw[9]);
static void GetEmpty_otherMakers(double otherMakers_k_time, int
  otherMakers_k_inertial_k, signed char otherMakers_k_MarkerSet, const double
  c_otherMakers_k_trackedMakerPos[3], const double otherMakers_k_ContinuesFlag
  [10], const double c_otherMakers_k_ContinuesLastPo[30], const double
  otherMakers_k_ContinuesLastTime[10], const double
  otherMakers_k_ContinuesLastK[10], c_struct_T *otherMakersEmpty);
static void GetRightOtherMaker(struct1_T otherMakers[3600], const double
  InertialPosition[34560], double d_trackedMakerPosition_Inertial[34560]);
static void GetRightOtherMaker_init();
static void INSVNSCalib(const double b_INSVNSCalib_VS_k[100], double
  b_Calib_N_New, const double dX_Vision_data[], const int dX_Vision_size[2],
  const double InertialPosition[34560], double Crw[9]);
static void JudgeIsCalibDataEnough(const double b_INSVNSCalib_VS_k[100], double
  b_Calib_N_New, const double b_trackedMakerPosition[10800], double
  *IsCalibDataVelocityOK, double dX_Vision_data[], int dX_Vision_size[2]);
static void JudgeMaker(struct1_T *otherMakers_k, const double
  c_otherMakers_k_last_Position_d[], const int c_otherMakers_k_last_Position_s[2],
  int otherMakers_k_last_otherMakersN, double otherMakers_k_last_time, const
  double c_otherMakers_k_last_ContinuesF[10], const double
  c_otherMakers_k_last_ContinuesL[30], const double
  d_otherMakers_k_last_ContinuesL[10], const double
  e_otherMakers_k_last_ContinuesL[10], double k_vision, int b_inertial_k, const
  double b_trackedMakerPosition[10800], const double InertialPosition[34560],
  int inertial_dT_k_last, const struct_T *b_makerTrackThreshold, double
  trackedMakerPosition_k_OK_data[], int trackedMakerPosition_k_OK_size[1],
  double *TrackFlag, d_struct_T *JudgeIndex);
static void PreProcess(struct1_T otherMakers[3600], const double
  b_BodyDirection[3]);
static void RotateZ(double angZ, double Cz[9]);
static void SearchCalibData(double b_INSVNSCalib_VS_k[100], double Calib_N_Last,
  const double b_trackedMarkerVelocity[18000], const double
  b_trackedMakerPosition[10800], double vision_k, double *b_Calib_N_New, double *
  b_IsCalibDataEnough, double dX_Vision_data[], int dX_Vision_size[2]);
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
static void Track_High_Judge(struct1_T *otherMakers_k, int b_inertial_k, const
  double InertialPosition[34560], double makerTrackThreshold_INSMarkH0, double
  makerTrackThreshold_VNSMarkH0, double *trackedMakerPosition_k_OK, double
  *TrackFlag, double *b_INSVNSMarkHC_Min);
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
static void b_repmat(const double a[3], int varargin_2, emxArray_real_T *b);
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
static void repmat(const double a[3], double b[30]);
static double rt_hypotd_snf(double u0, double u1);
static double rt_roundd_snf(double u);

// Function Definitions

//
// Arguments    : const double b_BodyDirection[3]
//                double Cr_r1[9]
// Return Type  : void
//
static void BodyDirection2Cr_r1(const double b_BodyDirection[3], double Cr_r1[9])
{
  double thita;
  int i1;
  static const signed char a[3] = { 1, 0, 0 };

  // % ���� BodyDirection ����̬
  //  �����д���֤������������������������������������������������������������������ 
  //    BodyDirection  �˳���Ϊ [1 0 0]
  //  ����
  thita = 0.0;
  for (i1 = 0; i1 < 3; i1++) {
    thita += (double)a[i1] * b_BodyDirection[i1];
  }

  thita = acos(thita / normest(b_BodyDirection));

  //  ͨ����˿��жϽǶȷ���
  //  �� V �� BodyDirection ��ʱ��180������ʱ��temp���ϣ�temp(3)<0
  if (b_BodyDirection[1] - 0.0 * b_BodyDirection[0] > 0.0) {
    //  �� V �� BodyDirection ��ʱ��ת������180��
    thita = -thita;
  }

  RotateZ(thita, Cr_r1);
}

//
// �ٶȼ���Ĳ�������
// Arguments    : const double b_Position[10800]
//                double data_k
//                double fre
//                double Velocity_k_data[]
//                int Velocity_k_size[1]
//                double *k_calV
// Return Type  : void
//
static void CalVelocity(const double b_Position[10800], double data_k, double
  fre, double Velocity_k_data[], int Velocity_k_size[1], double *k_calV)
{
  double dN_CalV;
  double angleXY;
  int i4;
  int b_k_calV;
  int c_k_calV;
  double Position1[3];
  double Position2[3];
  double trackedMarkerVelocity_xyNorm;
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
  for (i4 = 0; i4 < 5; i4++) {
    Velocity_k_data[i4] = rtNaN;
  }

  // % �����ٶȣ�
  //  ����� k_calV �������ٶȣ��� [ k_calV-dN_CalV, k_calV+dN_CalV  ] ��һ������ 
  //  �õ� data_k ���ݺ󣬼���� data_k-dN_CalV �������ٶ�
  *k_calV = data_k - dN_CalV;
  if ((*k_calV - dN_CalV < 1.0) || (*k_calV + dN_CalV > 3600.0)) {
  } else {
    b_k_calV = (int)(*k_calV + dN_CalV);
    c_k_calV = (int)(*k_calV - dN_CalV);
    for (i4 = 0; i4 < 3; i4++) {
      Position1[i4] = b_Position[i4 + 3 * (b_k_calV - 1)];
      Position2[i4] = b_Position[i4 + 3 * (c_k_calV - 1)];
    }

    if (rtIsNaN(b_Position[3 * ((int)(*k_calV + dN_CalV) - 1)]) || rtIsNaN
        (b_Position[3 * ((int)(*k_calV - dN_CalV) - 1)])) {
    } else {
      //  xyz��ά���ٶ�
      for (i4 = 0; i4 < 3; i4++) {
        dN_CalV = Position1[i4] - Position2[i4];
        Position1[i4] = dN_CalV;
        Position2[i4] = dN_CalV / 0.2;
      }

      //  �����д洢xyƽ���ٶȵ�ģ
      trackedMarkerVelocity_xyNorm = b_normest(*(double (*)[2])&Position2[0]);

      //  �����д洢xyƽ���ٶ�����ǰ��֮��ļнǣ�ģ����0.2m/sʱ�ż��㣩
      if (trackedMarkerVelocity_xyNorm > 0.1) {
        for (i4 = 0; i4 < 3; i4++) {
          Position1_data[i4] = Position1[i4] / 0.2;
        }

        dN_CalV = 0.0;
        for (i4 = 0; i4 < 2; i4++) {
          dN_CalV += (double)i4 * Position1_data[i4];
        }

        angleXY = acos(dN_CalV / trackedMarkerVelocity_xyNorm);
        if (Position2[0] > 0.0) {
          angleXY = -angleXY;
        }
      }

      Velocity_k_size[0] = 5;
      for (i4 = 0; i4 < 3; i4++) {
        Velocity_k_data[i4] = Position2[i4];
      }

      Velocity_k_data[3] = trackedMarkerVelocity_xyNorm;
      Velocity_k_data[4] = angleXY;
    }
  }
}

//
// % ��ֵ��������
// Arguments    : const double b_trackedMakerPosition[10800]
//                double search_k_start
//                double search_k_end
//                double *IsCalibDataDistanceOK
//                double *dX_xyNorm_VS
// Return Type  : void
//
static void CalibDataDistanceJudge(const double b_trackedMakerPosition[10800],
  double search_k_start, double search_k_end, double *IsCalibDataDistanceOK,
  double *dX_xyNorm_VS)
{
  double dX_xy_VS[3];
  int i5;

  // % �жϴ� search_k_start �� search_k_end ����һ��λ�Ƴ����Ƿ񹻳�
  //  m  ���ڱ궨�����ݵ���С�˶�λ�Ƴ���
  for (i5 = 0; i5 < 3; i5++) {
    dX_xy_VS[i5] = b_trackedMakerPosition[i5 + 3 * ((int)search_k_end - 1)] -
      b_trackedMakerPosition[i5 + 3 * ((int)search_k_start - 1)];
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
// Arguments    : struct1_T otherMakers[3600]
//                const double Crw[9]
// Return Type  : void
//
static void CompensateSecond(struct1_T otherMakers[3600], const double Crw[9])
{
  int k;
  double b[30];
  int i27;
  int i28;
  int i29;

  // ��otherMakers(k).time
  // ��otherMakers(k).MarkerSet
  for (k = 0; k < 3600; k++) {
    for (i27 = 0; i27 < 30; i27++) {
      b[i27] = otherMakers[k].Position[i27];
    }

    for (i27 = 0; i27 < 30; i27++) {
      otherMakers[k].Position[i27] = 0.0;
    }

    for (i27 = 0; i27 < 3; i27++) {
      for (i28 = 0; i28 < 10; i28++) {
        otherMakers[k].Position[i27 + 3 * i28] = 0.0;
        for (i29 = 0; i29 < 3; i29++) {
          otherMakers[k].Position[i27 + 3 * i28] += Crw[i27 + 3 * i29] * b[i29 +
            3 * i28];
        }
      }
    }
  }
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
//                c_struct_T *otherMakersEmpty
// Return Type  : void
//
static void GetEmpty_otherMakers(double otherMakers_k_time, int
  otherMakers_k_inertial_k, signed char otherMakers_k_MarkerSet, const double
  c_otherMakers_k_trackedMakerPos[3], const double otherMakers_k_ContinuesFlag
  [10], const double c_otherMakers_k_ContinuesLastPo[30], const double
  otherMakers_k_ContinuesLastTime[10], const double
  otherMakers_k_ContinuesLastK[10], c_struct_T *otherMakersEmpty)
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
  double c_CalStartVN;
  int i18;
  int k;
  double b_k;
  struct1_T expl_temp;
  int b_inertial_k;
  double k_calV;
  int inertial_dT_k_last;
  int c_otherMakers_k_last_Position_s[2];
  double c_otherMakers_k_last_Position_d[30];
  int i19;
  int loop_ub;
  double otherMakers_k_last_time;
  double c_otherMakers_k_last_ContinuesF[10];
  double c_otherMakers_k_last_ContinuesL[30];
  double d_otherMakers_k_last_ContinuesL[10];
  double e_otherMakers_k_last_ContinuesL[10];
  struct1_T b_expl_temp;
  c_struct_T c_expl_temp;
  d_struct_T JudgeIndex;
  int tmp_size[1];
  double tmp_data[3];
  double Xrw_r[3];
  double trackedMarkerVelocity_k_data[5];
  double b_trackedMarkerVelocity_k_data[5];
  int dX_Vision_size[2];
  double dX_Vision_data[150];
  double Crw[9];

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
  c_CalStartVN = CalStartVN;
  i18 = (int)(CalEndVN + (1.0 - CalStartVN));
  for (k = 0; k < i18; k++) {
    b_k = c_CalStartVN + (double)k;
    expl_temp = otherMakers[(int)b_k - 1];
    b_inertial_k = otherMakers[(int)b_k - 1].inertial_k;

    //   last_dT_k
    k_calV = rt_roundd_snf((double)otherMakers[(int)b_k - 1].inertial_k -
      dT_Ninertial);
    if (k_calV < 2.147483648E+9) {
      if (k_calV >= -2.147483648E+9) {
        inertial_dT_k_last = (int)k_calV;
      } else {
        inertial_dT_k_last = MIN_int32_T;
      }
    } else if (k_calV >= 2.147483648E+9) {
      inertial_dT_k_last = MAX_int32_T;
    } else {
      inertial_dT_k_last = 0;
    }

    if (inertial_dT_k_last < 1) {
      inertial_dT_k_last = 1;
    }

    if (b_k > 1.0) {
      c_otherMakers_k_last_Position_s[0] = 3;
      c_otherMakers_k_last_Position_s[1] = 10;
      for (i19 = 0; i19 < 30; i19++) {
        c_otherMakers_k_last_Position_d[i19] = otherMakers[(int)b_k - 2].
          Position[i19];
      }

      loop_ub = otherMakers[(int)b_k - 2].otherMakersN;
      otherMakers_k_last_time = otherMakers[(int)b_k - 2].time;
      for (i19 = 0; i19 < 10; i19++) {
        c_otherMakers_k_last_ContinuesF[i19] = otherMakers[(int)b_k - 2].
          ContinuesFlag[i19];
      }

      for (i19 = 0; i19 < 30; i19++) {
        c_otherMakers_k_last_ContinuesL[i19] = otherMakers[(int)b_k - 2].
          ContinuesLastPosition[i19];
      }

      for (i19 = 0; i19 < 10; i19++) {
        d_otherMakers_k_last_ContinuesL[i19] = otherMakers[(int)b_k - 2].
          ContinuesLastTime[i19];
      }

      for (i19 = 0; i19 < 10; i19++) {
        e_otherMakers_k_last_ContinuesL[i19] = otherMakers[(int)b_k - 2].
          ContinuesLastK[i19];
      }

      //          if k>2 && isnan(trackedMakerPosition(1,k-2))
      //              if sum(otherMakers_k_last.ContinuesFlag==1)~=0
      //                 disp('err')
      //              end
      //          end
    } else {
      b_expl_temp = otherMakers[0];
      GetEmpty_otherMakers(b_expl_temp.time, b_expl_temp.inertial_k,
                           b_expl_temp.MarkerSet,
                           b_expl_temp.trackedMakerPosition,
                           b_expl_temp.ContinuesFlag,
                           b_expl_temp.ContinuesLastPosition,
                           b_expl_temp.ContinuesLastTime,
                           b_expl_temp.ContinuesLastK, &c_expl_temp);
      c_otherMakers_k_last_Position_s[0] = 3;
      c_otherMakers_k_last_Position_s[1] = c_expl_temp.Position.size[1];
      loop_ub = c_expl_temp.Position.size[0] * c_expl_temp.Position.size[1];
      for (i19 = 0; i19 < loop_ub; i19++) {
        c_otherMakers_k_last_Position_d[i19] = c_expl_temp.Position.data[i19];
      }

      loop_ub = c_expl_temp.otherMakersN;
      otherMakers_k_last_time = c_expl_temp.time;
      for (i19 = 0; i19 < 10; i19++) {
        c_otherMakers_k_last_ContinuesF[i19] = c_expl_temp.ContinuesFlag[i19];
      }

      for (i19 = 0; i19 < 30; i19++) {
        c_otherMakers_k_last_ContinuesL[i19] =
          c_expl_temp.ContinuesLastPosition[i19];
      }

      for (i19 = 0; i19 < 10; i19++) {
        d_otherMakers_k_last_ContinuesL[i19] = c_expl_temp.ContinuesLastTime[i19];
        e_otherMakers_k_last_ContinuesL[i19] = c_expl_temp.ContinuesLastK[i19];
      }
    }

    b_expl_temp = otherMakers[(int)b_k - 1];
    JudgeMaker(&b_expl_temp, c_otherMakers_k_last_Position_d,
               c_otherMakers_k_last_Position_s, loop_ub, otherMakers_k_last_time,
               c_otherMakers_k_last_ContinuesF, c_otherMakers_k_last_ContinuesL,
               d_otherMakers_k_last_ContinuesL, e_otherMakers_k_last_ContinuesL,
               b_k, otherMakers[(int)b_k - 1].inertial_k, trackedMakerPosition,
               InertialPosition, inertial_dT_k_last, &makerTrackThreshold,
               tmp_data, tmp_size, &k_calV, &JudgeIndex);
    for (i19 = 0; i19 < 3; i19++) {
      trackedMakerPosition[i19 + 3 * ((int)b_k - 1)] = tmp_data[i19];
    }

    otherMakers[(int)b_k - 1] = b_expl_temp;

    //  ���� otherMakers(k)
    //     %% ��  INSMarkH0  VNSMarkH0
    if (rtIsNaN(makerTrackThreshold.INSMarkH0) && (!rtIsNaN
         (trackedMakerPosition[3 * ((int)b_k - 1)]))) {
      //  ���Hip�ĸ����ͺ��С��ȡֵ���������������������������������������������������������������������������������� 
      makerTrackThreshold.INSMarkH0 = -InertialPosition[2 + 3 *
        (expl_temp.inertial_k - 1)];
      makerTrackThreshold.VNSMarkH0 = -trackedMakerPosition[2 + 3 * ((int)b_k -
        1)];

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
      for (i19 = 0; i19 < 2; i19++) {
        Xrw_r[i19] = trackedMakerPosition[i19 + 3 * ((int)b_k - 1)] -
          InertialPosition[i19 + 3 * (b_inertial_k - 1)];
      }

      Xrw_r[2] = 0.0;
      for (loop_ub = 0; loop_ub < 3600; loop_ub++) {
        repmat(Xrw_r, c_otherMakers_k_last_ContinuesL);
        b_expl_temp = otherMakers[loop_ub];
        for (i19 = 0; i19 < 30; i19++) {
          otherMakers[loop_ub].Position[i19] = b_expl_temp.Position[i19] -
            c_otherMakers_k_last_ContinuesL[i19];
        }

        for (i19 = 0; i19 < 3; i19++) {
          trackedMakerPosition[i19 + 3 * loop_ub] -= Xrw_r[i19];
        }
      }
    }

    //     %% ���Ӿ��ٶ�
    CalVelocity(trackedMakerPosition, b_k, visionFre,
                trackedMarkerVelocity_k_data, tmp_size, &k_calV);
    if (k_calV > 0.0) {
      loop_ub = tmp_size[0];
      for (i19 = 0; i19 < loop_ub; i19++) {
        b_trackedMarkerVelocity_k_data[i19] = trackedMarkerVelocity_k_data[i19];
      }

      for (i19 = 0; i19 < 5; i19++) {
        trackedMarkerVelocity[i19 + 5 * ((int)k_calV - 1)] =
          b_trackedMarkerVelocity_k_data[i19];
      }

      if (IsCalibDataEnough == 0.0) {
        //         %% ���������ڱ궨������
        //          dbstop in SearchCalibData
        SearchCalibData(INSVNSCalib_VS_k, Calib_N_New, trackedMarkerVelocity,
                        trackedMakerPosition, k_calV, &Calib_N_New,
                        &IsCalibDataEnough, dX_Vision_data, dX_Vision_size);
        if (IsCalibDataEnough == 1.0) {
          INSVNSCalib(INSVNSCalib_VS_k, Calib_N_New, dX_Vision_data,
                      dX_Vision_size, InertialPosition, Crw);
          CompensateSecond(otherMakers, Crw);
        }
      }
    }

    //     %% ת�ɹ�����˵��ʱ��
    for (i19 = 0; i19 < 3; i19++) {
      c_trackedMakerPosition_Inertial[i19 + 3 * (expl_temp.inertial_k - 1)] =
        trackedMakerPosition[i19 + 3 * ((int)b_k - 1)];
    }
  }

  //  %% Output
  memcpy(&d_trackedMakerPosition_Inertial[0], &c_trackedMakerPosition_Inertial[0],
         34560U * sizeof(double));

  //  %% result analyse
  //  if IsOnLine==0
  //       trackedMaker.trackedMakerPosition = trackedMakerPosition ;
  //  %      trackedMaker.time = otherMakersTime ;
  //       trackedMaker.MarkerSet = otherMakers(1).MarkerSet ;
  //       N = length(trackedMakerPosition) ;
  //      for k=1:N
  //          otherMakers(k).trackedMakerPosition = trackedMakerPosition(:,k) ;
  //      end
  //      for k=1:N
  //          i = N-k+1;
  //          if ~isnan(trackedMakerPosition(1,i))
  //              trackedMaker.LastMakerPosition = trackedMakerPosition(:,i);
  //              trackedMaker.LastMakerTime = otherMakers(i).time ;
  //              break;
  //          end
  //      end
  //
  //      DrawTracedINSVNS( trackedMaker,InertialPosition,trackedMarkerVelocity,InertialVelocity,INSVNSCalib_VS_k,INSVNSCalibSet ) ; 
  //
  //  end
}

//
// Arguments    : void
// Return Type  : void
//
static void GetRightOtherMaker_init()
{
  int i12;
  for (i12 = 0; i12 < 10800; i12++) {
    trackedMakerPosition[i12] = rtNaN;
  }

  for (i12 = 0; i12 < 34560; i12++) {
    c_trackedMakerPosition_Inertial[i12] = rtNaN;
  }

  for (i12 = 0; i12 < 18000; i12++) {
    trackedMarkerVelocity[i12] = rtNaN;
  }

  for (i12 = 0; i12 < 100; i12++) {
    INSVNSCalib_VS_k[i12] = rtNaN;
  }

  Calib_N_New = 0.0;
  IsCalibDataEnough = 0.0;
}

//
// Arguments    : const double b_INSVNSCalib_VS_k[100]
//                double b_Calib_N_New
//                const double dX_Vision_data[]
//                const int dX_Vision_size[2]
//                const double InertialPosition[34560]
//                double Crw[9]
// Return Type  : void
//
static void INSVNSCalib(const double b_INSVNSCalib_VS_k[100], double
  b_Calib_N_New, const double dX_Vision_data[], const int dX_Vision_size[2],
  const double InertialPosition[34560], double Crw[9])
{
  emxArray_real_T *dX_Inertial;
  int i7;
  int loop_ub;
  double INSVNSCalib_IS_k[100];
  emxArray_real_T *A;
  int i8;
  double A_data[100];
  emxArray_real_T *b_A;
  int Crw_size[2];
  double Crw_data[100];
  double B_data[100];
  int B_size[2];
  int b_loop_ub;
  int A_size[2];
  double dv0[4];
  static const signed char iv1[3] = { 0, 0, 1 };

  emxInit_real_T(&dX_Inertial, 2);

  // % xyz 2015 ��ͯ�� �ع�
  // % ���� �Ӿ� ����ϵ�궨
  //  λ�Ʋ����ݣ� dX_Vision
  //  rϵ�� �Ӿ�ϵ
  //  wϵ�� ����ϵ��NED��
  //  Crw�� �Ӿ�ϵ����ϵ��ϵ�ķ������Ҿ���
  i7 = dX_Inertial->size[0] * dX_Inertial->size[1];
  dX_Inertial->size[0] = 3;
  dX_Inertial->size[1] = (int)b_Calib_N_New;
  emxEnsureCapacity((emxArray__common *)dX_Inertial, i7, (int)sizeof(double));
  loop_ub = 3 * (int)b_Calib_N_New;
  for (i7 = 0; i7 < loop_ub; i7++) {
    dX_Inertial->data[i7] = 0.0;
  }

  memset(&INSVNSCalib_IS_k[0], 0, 100U * sizeof(double));
  for (loop_ub = 0; loop_ub < (int)b_Calib_N_New; loop_ub++) {
    INSVNSCalib_IS_k[loop_ub << 1] = VisionData_inertial_k[(int)
      b_INSVNSCalib_VS_k[loop_ub << 1] - 1];
    INSVNSCalib_IS_k[1 + (loop_ub << 1)] = VisionData_inertial_k[(int)
      b_INSVNSCalib_VS_k[loop_ub << 1] - 1];
    for (i7 = 0; i7 < 3; i7++) {
      dX_Inertial->data[i7 + dX_Inertial->size[0] * loop_ub] =
        InertialPosition[i7 + 3 * ((int)INSVNSCalib_IS_k[1 + (loop_ub << 1)] - 1)]
        - InertialPosition[i7 + 3 * ((int)INSVNSCalib_IS_k[loop_ub << 1] - 1)];
    }

    dX_Inertial->data[2 + dX_Inertial->size[0] * loop_ub] = 0.0;

    //  �����0
  }

  emxInit_real_T(&A, 2);
  loop_ub = dX_Inertial->size[1];
  i7 = A->size[0] * A->size[1];
  A->size[0] = 2;
  A->size[1] = loop_ub;
  emxEnsureCapacity((emxArray__common *)A, i7, (int)sizeof(double));
  for (i7 = 0; i7 < loop_ub; i7++) {
    for (i8 = 0; i8 < 2; i8++) {
      A->data[i8 + A->size[0] * i7] = dX_Inertial->data[i8 + dX_Inertial->size[0]
        * i7];
    }
  }

  loop_ub = dX_Vision_size[1];
  for (i7 = 0; i7 < loop_ub; i7++) {
    for (i8 = 0; i8 < 2; i8++) {
      A_data[i8 + (i7 << 1)] = dX_Vision_data[i8 + dX_Vision_size[0] * i7];
    }
  }

  i7 = dX_Inertial->size[1];
  emxInit_real_T(&b_A, 2);
  if ((i7 == 0) || (dX_Vision_size[1] == 0)) {
    Crw_size[0] = 2;
    Crw_size[1] = 2;
    for (i7 = 0; i7 < 4; i7++) {
      Crw_data[i7] = 0.0;
    }
  } else if (2 == dX_Vision_size[1]) {
    Crw_size[0] = 2;
    Crw_size[1] = A->size[1];
    loop_ub = A->size[0] * A->size[1];
    for (i7 = 0; i7 < loop_ub; i7++) {
      Crw_data[i7] = A->data[i7];
    }

    eml_lusolve(A_data, Crw_data, Crw_size);
  } else {
    loop_ub = dX_Inertial->size[1];
    B_size[0] = dX_Vision_size[1];
    B_size[1] = 2;
    for (i7 = 0; i7 < 2; i7++) {
      b_loop_ub = dX_Vision_size[1];
      for (i8 = 0; i8 < b_loop_ub; i8++) {
        B_data[i8 + dX_Vision_size[1] * i7] = A_data[i7 + (i8 << 1)];
      }
    }

    i7 = b_A->size[0] * b_A->size[1];
    b_A->size[0] = A->size[1];
    b_A->size[1] = 2;
    emxEnsureCapacity((emxArray__common *)b_A, i7, (int)sizeof(double));
    for (i7 = 0; i7 < 2; i7++) {
      b_loop_ub = A->size[1];
      for (i8 = 0; i8 < b_loop_ub; i8++) {
        b_A->data[i8 + b_A->size[0] * i7] = A->data[i7 + A->size[0] * i8];
      }
    }

    A_size[0] = loop_ub;
    A_size[1] = 2;
    for (i7 = 0; i7 < 2; i7++) {
      for (i8 = 0; i8 < loop_ub; i8++) {
        A_data[i8 + loop_ub * i7] = b_A->data[i8 + loop_ub * i7];
      }
    }

    eml_qrsolve(B_data, B_size, A_data, A_size, dv0);
    Crw_size[0] = 2;
    Crw_size[1] = 2;
    for (i7 = 0; i7 < 2; i7++) {
      for (i8 = 0; i8 < 2; i8++) {
        Crw_data[i8 + (i7 << 1)] = dv0[i7 + (i8 << 1)];
      }
    }
  }

  emxFree_real_T(&b_A);
  emxFree_real_T(&A);
  emxFree_real_T(&dX_Inertial);
  loop_ub = Crw_size[1];
  for (i7 = 0; i7 < loop_ub; i7++) {
    for (i8 = 0; i8 < 2; i8++) {
      Crw[i8 + 3 * i7] = Crw_data[i8 + Crw_size[0] * i7];
    }
  }

  for (i7 = 0; i7 < 2; i7++) {
    Crw[i7 + 3 * Crw_size[1]] = 0.0;
  }

  for (i7 = 0; i7 < 3; i7++) {
    Crw[2 + 3 * i7] = iv1[i7];
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
  int i6;
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
  for (i6 = 0; i6 < HaveBiggerData; i6++) {
    dX_Vision_data[i6] = 0.0;
  }

  HaveBiggerData = (int)b_Calib_N_New;
  for (i6 = 0; i6 < HaveBiggerData; i6++) {
    dX_Angle_data[i6] = 0.0;
  }

  HaveBiggerData = 0;
  HaveSmallerData = 0;
  *IsCalibDataVelocityOK = 0.0;
  for (k = 0; k < (int)b_Calib_N_New; k++) {
    for (i6 = 0; i6 < 3; i6++) {
      dX_Vision_data[i6 + 3 * k] = b_trackedMakerPosition[i6 + 3 * ((int)
        b_INSVNSCalib_VS_k[1 + (k << 1)] - 1)] - b_trackedMakerPosition[i6 + 3 *
        ((int)b_INSVNSCalib_VS_k[k << 1] - 1)];
    }

    //  �� ��ʼ ָ�� ����
    //     %% ֻ����ƽ���ڵ�λ��
    dX_Vision_data[2 + 3 * k] = 0.0;

    //     %% ��������λ��ʸ�����һ��ʸ���ļн��ж��Ƿ�ֲ�����
    angle = 0.0;
    for (i6 = 0; i6 < 3; i6++) {
      angle += dX_Vision_data[i6] * dX_Vision_data[i6 + 3 * k];
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
//                double k_vision
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
  e_otherMakers_k_last_ContinuesL[10], double k_vision, int b_inertial_k, const
  double b_trackedMakerPosition[10800], const double InertialPosition[34560],
  int inertial_dT_k_last, const struct_T *b_makerTrackThreshold, double
  trackedMakerPosition_k_OK_data[], int trackedMakerPosition_k_OK_size[1],
  double *TrackFlag, d_struct_T *JudgeIndex)
{
  double vision_dT_k_last;
  double otherMakersPosition_k[30];
  int i20;
  struct1_T b_otherMakers_k;
  double stepK;
  double trackedMakerPosition_k_OK;
  emxArray_real_T *dPiNorm;
  emxArray_real_T *r0;
  double dPi_data[30];
  int ixstart;
  int itmp;
  int ix;
  boolean_T exitg5;
  int i;
  boolean_T exitg4;
  boolean_T exitg3;
  double b_angleErr_dT_Min;
  boolean_T b;
  boolean_T guard1 = false;
  int32_T exitg2;
  boolean_T guard2 = false;
  double min_dT_k;
  long long i21;
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
  for (i20 = 0; i20 < 30; i20++) {
    otherMakersPosition_k[i20] = otherMakers_k->Position[i20];
  }

  if (rtIsNaN(otherMakers_k->Position[0])) {
  } else {
    // % �߶��ж�
    b_otherMakers_k = *otherMakers_k;
    Track_High_Judge(&b_otherMakers_k, b_inertial_k, InertialPosition,
                     b_makerTrackThreshold->INSMarkH0,
                     b_makerTrackThreshold->VNSMarkH0,
                     &trackedMakerPosition_k_OK, TrackFlag, &stepK);
    *otherMakers_k = b_otherMakers_k;
    JudgeIndex->INSVNSMarkHC_Min = stepK;

    //  ��ĸ������ܱ�������
    if (*TrackFlag == -1.0) {
    } else {
      // % ��˵��������ж�
      //  ǰһʱ�̸��ٳɹ�ʱ��������ǰ���Ƿ���Ը��ٳɹ��ĵ�������  Continues = 1 
      //  ǰһʱ�̸���ʧ��ʱ��������ǰÿ�����Ƿ�Ϊ������Ľ��,�Ҽ�¼�Ÿ�������������ǰ���磨��������dT���ĵ��λ�ú�ʱ�䡣 
      //         Continues = 2 ��
      // % ��˵��������ж�
      //  dPi_ConJudge �� �������ж�ָ��Ĵ�С��ǰ����֡��λ��ģ
      //
      //  global inertialFre visionFre  moveDistance
      //  ��¼ÿ����˵����������
      for (i20 = 0; i20 < 10; i20++) {
        otherMakers_k->ContinuesFlag[i20] = 0.0;
      }

      //  ������
      for (i20 = 0; i20 < 30; i20++) {
        otherMakers_k->ContinuesLastPosition[i20] = rtNaN;
      }

      for (i20 = 0; i20 < 10; i20++) {
        otherMakers_k->ContinuesLastTime[i20] = rtNaN;
      }

      trackedMakerPosition_k_OK = rtNaN;
      emxInit_real_T(&dPiNorm, 2);
      emxInit_real_T(&r0, 2);
      if (k_vision > 1.0) {
        if (!rtIsNaN(b_trackedMakerPosition[3 * ((int)(k_vision - 1.0) - 1)])) {
          //         %% ֻ�жϵ�ǰ��˵��Ƿ���ǰʱ�̸��ٳɹ�����˵�����
          b_repmat(*(double (*)[3])&b_trackedMakerPosition[3 * ((int)(k_vision -
                     1.0) - 1)], b_otherMakers_k.otherMakersN, r0);
          for (i20 = 0; i20 < 30; i20++) {
            dPi_data[i20] = b_otherMakers_k.Position[i20] - r0->data[i20];
          }

          i20 = dPiNorm->size[0] * dPiNorm->size[1];
          dPiNorm->size[0] = 1;
          dPiNorm->size[1] = b_otherMakers_k.otherMakersN;
          emxEnsureCapacity((emxArray__common *)dPiNorm, i20, (int)sizeof(double));
          ixstart = b_otherMakers_k.otherMakersN;
          for (i20 = 0; i20 < ixstart; i20++) {
            dPiNorm->data[i20] = 0.0;
          }

          for (ixstart = 0; ixstart + 1 <= b_otherMakers_k.otherMakersN; ixstart
               ++) {
            dPiNorm->data[ixstart] = normest(*(double (*)[3])&dPi_data[3 *
              ixstart]);
          }

          ixstart = 1;
          trackedMakerPosition_k_OK = dPiNorm->data[0];
          itmp = 0;
          if (dPiNorm->size[1] > 1) {
            if (rtIsNaN(dPiNorm->data[0])) {
              ix = 1;
              exitg5 = false;
              while ((!exitg5) && (ix + 1 <= dPiNorm->size[1])) {
                ixstart = ix + 1;
                if (!rtIsNaN(dPiNorm->data[ix])) {
                  trackedMakerPosition_k_OK = dPiNorm->data[ix];
                  itmp = ix;
                  exitg5 = true;
                } else {
                  ix++;
                }
              }
            }

            if (ixstart < dPiNorm->size[1]) {
              while (ixstart + 1 <= dPiNorm->size[1]) {
                if (dPiNorm->data[ixstart] < trackedMakerPosition_k_OK) {
                  trackedMakerPosition_k_OK = dPiNorm->data[ixstart];
                  itmp = ixstart;
                }

                ixstart++;
              }
            }
          }

          if (trackedMakerPosition_k_OK <
              b_makerTrackThreshold->MaxContinuesDisplacement) {
            //          trackedMakerPosition_k_OK = otherMakersPosition_k(:,m) ; 
            //          TrackFlag = 1;
            //          fprintf('��˵�������λ��=%0.4f������OK \n',Min_otherMakersPosition_k_Dis_Norm); 
            otherMakers_k->ContinuesFlag[itmp] = 1.0;

            //  ��������������ٳɹ���˵�����
            for (i20 = 0; i20 < 3; i20++) {
              otherMakers_k->ContinuesLastPosition[i20 + 3 * itmp] =
                b_trackedMakerPosition[i20 + 3 * ((int)(k_vision - 1.0) - 1)];
            }

            otherMakers_k->ContinuesLastTime[itmp] = otherMakers_k_last_time;
            otherMakers_k->ContinuesLastK[itmp] = k_vision - 1.0;
          }
        } else {
          //         %% �жϵ�ǰ��˵��Ƿ�Ϊ������˵㣬��¼ÿ�����Ӧ�����磨��������dT�������� 
          if (otherMakers_k_last_otherMakersN == 0) {
            //  ��ʱ������˵�
            for (i = 0; i + 1 <= b_otherMakers_k.otherMakersN; i++) {
              otherMakers_k->ContinuesFlag[i] = 0.0;

              //  ������
              for (i20 = 0; i20 < 3; i20++) {
                otherMakers_k->ContinuesLastPosition[i20 + 3 * i] = rtNaN;
              }

              otherMakers_k->ContinuesLastTime[i] = rtNaN;
              otherMakers_k->ContinuesLastK[i] = rtNaN;
            }
          } else {
            //  һ���� M*M_last �����
            for (i = 0; i + 1 <= b_otherMakers_k.otherMakersN; i++) {
              b_repmat(*(double (*)[3])&b_otherMakers_k.Position[3 * i],
                       otherMakers_k_last_otherMakersN, r0);
              ixstart = r0->size[0] * r0->size[1];
              for (i20 = 0; i20 < ixstart; i20++) {
                dPi_data[i20] = r0->data[i20] -
                  c_otherMakers_k_last_Position_d[i20];
              }

              i20 = dPiNorm->size[0] * dPiNorm->size[1];
              dPiNorm->size[0] = 1;
              dPiNorm->size[1] = otherMakers_k_last_otherMakersN;
              emxEnsureCapacity((emxArray__common *)dPiNorm, i20, (int)sizeof
                                (double));
              for (i20 = 0; i20 < otherMakers_k_last_otherMakersN; i20++) {
                dPiNorm->data[i20] = 0.0;
              }

              for (ixstart = 0; ixstart + 1 <= otherMakers_k_last_otherMakersN;
                   ixstart++) {
                dPiNorm->data[ixstart] = normest(*(double (*)[3])&dPi_data[3 *
                  ixstart]);
              }

              ixstart = 1;
              trackedMakerPosition_k_OK = dPiNorm->data[0];
              itmp = 0;
              if (dPiNorm->size[1] > 1) {
                if (rtIsNaN(dPiNorm->data[0])) {
                  ix = 1;
                  exitg4 = false;
                  while ((!exitg4) && (ix + 1 <= dPiNorm->size[1])) {
                    ixstart = ix + 1;
                    if (!rtIsNaN(dPiNorm->data[ix])) {
                      trackedMakerPosition_k_OK = dPiNorm->data[ix];
                      itmp = ix;
                      exitg4 = true;
                    } else {
                      ix++;
                    }
                  }
                }

                if (ixstart < dPiNorm->size[1]) {
                  while (ixstart + 1 <= dPiNorm->size[1]) {
                    if (dPiNorm->data[ixstart] < trackedMakerPosition_k_OK) {
                      trackedMakerPosition_k_OK = dPiNorm->data[ixstart];
                      itmp = ixstart;
                    }

                    ixstart++;
                  }
                }
              }

              if (fabs(trackedMakerPosition_k_OK) <
                  b_makerTrackThreshold->MaxContinuesDisplacement) {
                //   otherMakers_k.Position( :,i ) �� otherMakers_k_last.Position(:,min_i) ���� 
                //  �ҵ�һ�������ĵ㣬��¼��һ��
                otherMakers_k->ContinuesFlag[i] = 2.0;

                //  �������͸���ʧ�ܵĵ�����
                //  ���ǰһ����Ϊ�����㣬��ǰһ�����������¼���ݹ���
                if (c_otherMakers_k_last_ContinuesF[itmp] == 2.0) {
                  otherMakers_k->ContinuesLastK[i] =
                    e_otherMakers_k_last_ContinuesL[itmp];

                  //  ���ݼ�¼��һ��ʱ�̴洢��������Ϣ
                  for (i20 = 0; i20 < 3; i20++) {
                    otherMakers_k->ContinuesLastPosition[i20 + 3 * i] =
                      c_otherMakers_k_last_ContinuesL[i20 + 3 * itmp];
                  }

                  otherMakers_k->ContinuesLastTime[i] =
                    d_otherMakers_k_last_ContinuesL[itmp];
                } else if (c_otherMakers_k_last_ContinuesF[itmp] == 0.0) {
                  otherMakers_k->ContinuesLastK[i] = k_vision - 1.0;

                  //  ֱ�Ӽ�¼��һ��ʱ��
                  for (i20 = 0; i20 < 3; i20++) {
                    otherMakers_k->ContinuesLastPosition[i20 + 3 * i] =
                      c_otherMakers_k_last_Position_d[i20 +
                      c_otherMakers_k_last_Position_s[0] * itmp];
                  }

                  otherMakers_k->ContinuesLastTime[i] = otherMakers_k_last_time;
                } else {
                  if (c_otherMakers_k_last_ContinuesF[itmp] == 1.0) {
                    //  ����ٳɹ����������ɹ���������ʶ��ʧ�ܵ���������ݵ����ڡ��������ʱ�䳬��2�룬���ٴ��ݡ� 
                    if (d_otherMakers_k_last_ContinuesL[itmp] -
                        b_otherMakers_k.time > 20.0) {
                      otherMakers_k->ContinuesFlag[i] = 2.0;
                    } else {
                      otherMakers_k->ContinuesFlag[i] = 1.0;
                    }

                    otherMakers_k->ContinuesLastK[i] =
                      e_otherMakers_k_last_ContinuesL[itmp];

                    //  ���ݼ�¼��һ��ʱ�̴洢��������Ϣ
                    for (i20 = 0; i20 < 3; i20++) {
                      otherMakers_k->ContinuesLastPosition[i20 + 3 * i] =
                        c_otherMakers_k_last_ContinuesL[i20 + 3 * itmp];
                    }

                    otherMakers_k->ContinuesLastTime[i] =
                      d_otherMakers_k_last_ContinuesL[itmp];
                  }
                }
              } else {
                otherMakers_k->ContinuesFlag[i] = 0.0;

                //  ������
                for (i20 = 0; i20 < 3; i20++) {
                  otherMakers_k->ContinuesLastPosition[i20 + 3 * i] = rtNaN;
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
      JudgeIndex->dPi_ConJudge = trackedMakerPosition_k_OK;

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

        if ((k_vision - vision_dT_k_last) / visionFre > 3.0) {
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
                             &min_dT_k, &trackedMakerPosition_k_OK, &stepK,
                             &vision_dT_k_last, &b_angleErr_dT_Min);
              JudgeIndex->dPError_dT_xy = trackedMakerPosition_k_OK;
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
          trackedMakerPosition_k_OK = inertialFre * 60.0;
          if (trackedMakerPosition_k_OK < 0.0) {
            trackedMakerPosition_k_OK = ceil(trackedMakerPosition_k_OK);
          } else {
            trackedMakerPosition_k_OK = floor(trackedMakerPosition_k_OK);
          }

          i21 = b_inertial_k - 1LL;
          if (i21 > 2147483647LL) {
            i21 = 2147483647LL;
          } else {
            if (i21 < -2147483648LL) {
              i21 = -2147483648LL;
            }
          }

          ixstart = (int)i21;
          b_angleErr_dT_Min = rt_roundd_snf(trackedMakerPosition_k_OK);
          if (b_angleErr_dT_Min < 2.147483648E+9) {
            if (b_angleErr_dT_Min >= -2.147483648E+9) {
              i20 = (int)b_angleErr_dT_Min;
            } else {
              i20 = MIN_int32_T;
            }
          } else if (b_angleErr_dT_Min >= 2.147483648E+9) {
            i20 = MAX_int32_T;
          } else {
            i20 = 0;
          }

          if (ixstart > trackedMakerPosition_k_OK) {
            ixstart = i20;
          }

          vision_dT_k_last = rtNaN;

          //  Ĭ�����ã�Ѱ��ʧ��
          // wh = waitbar(0,'SearchDistanceK');
          i = 1;
          exitg1 = false;
          while ((!exitg1) && ((((int)stepK > 0) && (i <= ixstart)) || (((int)
                    stepK < 0) && (i >= ixstart)))) {
            i21 = (long long)b_inertial_k - i;
            if (i21 > 2147483647LL) {
              i21 = 2147483647LL;
            } else {
              if (i21 < -2147483648LL) {
                i21 = -2147483648LL;
              }
            }

            ix = (int)i21;
            for (i20 = 0; i20 < 3; i20++) {
              dP[i20] = InertialPosition[i20 + 3 * (ix - 1)] -
                InertialPosition[i20 + 3 * (b_inertial_k - 1)];
            }

            b_guard1 = false;
            if (normest(dP) > 0.5) {
              //          kCurrent_Vision = InertialK_to_VisionK(kCurrent-i);
              i21 = (long long)b_inertial_k - i;
              if (i21 > 2147483647LL) {
                i21 = 2147483647LL;
              } else {
                if (i21 < -2147483648LL) {
                  i21 = -2147483648LL;
                }
              }

              if (!rtIsNaN(b_trackedMakerPosition[3 * ((int)
                    InertialData_visual_k[(int)i21 - 1] - 1)])) {
                //  �������㣬�� trackedMakerPosition ���ٳɹ�
                i21 = (long long)b_inertial_k - i;
                if (i21 > 2147483647LL) {
                  i21 = 2147483647LL;
                } else {
                  if (i21 < -2147483648LL) {
                    i21 = -2147483648LL;
                  }
                }

                vision_dT_k_last = (int)i21;
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
            trackedMakerPosition_k_OK = -0.17453292519943295;
            *TrackFlag = -1.4;
          } else {
            for (i20 = 0; i20 < 3; i20++) {
              trackedMakerPosition_k_OK = InertialPosition[i20 + 3 *
                (b_inertial_k - 1)] - InertialPosition[i20 + 3 * ((int)
                vision_dT_k_last - 1)];
              stepK = otherMakersPosition_k[i20 + 3 * ((int)min_dT_k - 1)] -
                b_trackedMakerPosition[i20 + 3 * ((int)InertialData_visual_k
                [(int)vision_dT_k_last - 1] - 1)];
              b_dP[i20] = trackedMakerPosition_k_OK - stepK;
              dP[i20] = trackedMakerPosition_k_OK;
              dP_Vision[i20] = stepK;
            }

            stepK = normest(b_dP);
            b_angleErr_dT_Min = 0.0;
            for (i20 = 0; i20 < 3; i20++) {
              b_angleErr_dT_Min += dP[i20] * dP_Vision[i20];
            }

            trackedMakerPosition_k_OK = acos(b_angleErr_dT_Min / normest(dP) /
              normest(dP_Vision));
            if ((stepK < 0.35) && (trackedMakerPosition_k_OK <
                                   0.3490658503988659)) {
              //  ����ͽǶ� ����
              trackedMakerPosition_k_OK_size[0] = 3;
              for (i20 = 0; i20 < 3; i20++) {
                trackedMakerPosition_k_OK_data[i20] = otherMakersPosition_k[i20
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
          JudgeIndex->angleErr_dS = trackedMakerPosition_k_OK;
        }
      }
    }
  }
}

//
// Arguments    : struct1_T otherMakers[3600]
//                const double b_BodyDirection[3]
// Return Type  : void
//
static void PreProcess(struct1_T otherMakers[3600], const double
  b_BodyDirection[3])
{
  double dv1[9];
  int i14;
  int i15;
  double Cvr[9];
  int i16;
  static const signed char b[9] = { 0, -1, 0, 0, 0, -1, 1, 0, 0 };

  double Position_1[3];
  int k;
  double b_k;
  double dv2[30];
  struct1_T b_otherMakers;
  double c_otherMakers[30];
  int i17;

  // % �Ӿ�λ��Ԥ����
  //  1�����Ӿ�����ת������
  // % ��ת�������ص�ͬ������ϵ
  //  dbstop in BodyDirection2Cr_r1
  BodyDirection2Cr_r1(b_BodyDirection, dv1);
  for (i14 = 0; i14 < 3; i14++) {
    for (i15 = 0; i15 < 3; i15++) {
      Cvr[i14 + 3 * i15] = 0.0;
      for (i16 = 0; i16 < 3; i16++) {
        Cvr[i14 + 3 * i15] += dv1[i16 + 3 * i14] * (double)b[i16 + 3 * i15];
      }
    }
  }

  // % ��ת�� ����ϵ �ı����أ������Ӿ��ĳ�ʼ��Ϊԭ�㣨������߶ȣ�
  for (i14 = 0; i14 < 3; i14++) {
    Position_1[i14] = otherMakers[0].Position[i14];
  }

  Position_1[1] = 0.0;

  //  ������߶ȷ���
  i14 = (int)(CalEndVN + (1.0 - CalStartVN));
  for (k = 0; k < i14; k++) {
    b_k = CalStartVN + (double)k;
    repmat(Position_1, dv2);
    b_otherMakers = otherMakers[(int)b_k - 1];
    for (i15 = 0; i15 < 10; i15++) {
      for (i16 = 0; i16 < 3; i16++) {
        c_otherMakers[i16 + 3 * i15] = b_otherMakers.Position[i16 + 3 * i15] -
          dv2[i16 + 3 * i15];
      }
    }

    for (i15 = 0; i15 < 3; i15++) {
      for (i16 = 0; i16 < 10; i16++) {
        otherMakers[(int)b_k - 1].Position[i15 + 3 * i16] = 0.0;
        for (i17 = 0; i17 < 3; i17++) {
          otherMakers[(int)b_k - 1].Position[i15 + 3 * i16] += Cvr[i15 + 3 * i17]
            * c_otherMakers[i17 + 3 * i16];
        }
      }
    }
  }
}

//
// Arguments    : double angZ
//                double Cz[9]
// Return Type  : void
//
static void RotateZ(double angZ, double Cz[9])
{
  int i2;
  static const signed char iv0[3] = { 0, 0, 1 };

  // % xyz 2015.3.25
  // % anticlockwise = positive  rad
  Cz[0] = cos(angZ);
  Cz[3] = sin(angZ);
  Cz[6] = 0.0;
  Cz[1] = -sin(angZ);
  Cz[4] = cos(angZ);
  Cz[7] = 0.0;
  for (i2 = 0; i2 < 3; i2++) {
    Cz[2 + 3 * i2] = iv0[i2];
  }
}

//
// Arguments    : double b_INSVNSCalib_VS_k[100]
//                double Calib_N_Last
//                const double b_trackedMarkerVelocity[18000]
//                const double b_trackedMakerPosition[10800]
//                double vision_k
//                double *b_Calib_N_New
//                double *b_IsCalibDataEnough
//                double dX_Vision_data[]
//                int dX_Vision_size[2]
// Return Type  : void
//
static void SearchCalibData(double b_INSVNSCalib_VS_k[100], double Calib_N_Last,
  const double b_trackedMarkerVelocity[18000], const double
  b_trackedMakerPosition[10800], double vision_k, double *b_Calib_N_New, double *
  b_IsCalibDataEnough, double dX_Vision_data[], int dX_Vision_size[2])
{
  double MaxN_Calib;
  double LastEnd_k;
  double search_k;
  double search_k_end;
  boolean_T exitg4;
  double search_k_start;
  boolean_T exitg3;
  boolean_T guard1 = false;
  double dX_xyNorm_VS;
  double IsCalibDataDistanceOK;
  int i24;
  int i25;
  int ixstart;
  int ix;
  double VelocityDirection_data[3598];
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
  if (rtIsNaN(b_trackedMarkerVelocity[5 * ((int)vision_k - 1)]) || rtIsNaN
      (b_trackedMakerPosition[3 * ((int)vision_k - 1)])) {
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
           ((int)vision_k - 1)]) == 1.0) {
        search_k_end = search_k;

        //  �����µ����ݿ�ʼ�������õ���һ��OK�ĵ���Ϊĩβ��
        //          fprintf('search_k_end = %d \n ',search_k_end)
        exitg4 = true;
      } else {
        search_k--;
      }
    }

    if (rtIsNaN(search_k_end)) {
    } else {
      // % �������
      search_k_start = rtNaN;
      exitg3 = false;
      while ((!exitg3) && ((search_k > LastEnd_k) && ((search_k_end - search_k)
               + 1.0 < MaxN_Calib))) {
        guard1 = false;
        if (CalibDataVelocityJudge(*(double (*)[5])&b_trackedMarkerVelocity[5 *
             ((int)vision_k - 1)]) == 1.0) {
          //  �õ��ٶȴ�С���������� ��ʼ�㣬���ж�λ�Ƴ���
          CalibDataDistanceJudge(b_trackedMakerPosition, search_k + 1.0,
            search_k_end, &IsCalibDataDistanceOK, &dX_xyNorm_VS);
          if (IsCalibDataDistanceOK == 1.0) {
            search_k_start = search_k + 1.0;
            exitg3 = true;
          } else {
            guard1 = true;
          }
        } else {
          guard1 = true;
        }

        if (guard1) {
          search_k--;
        }
      }

      if (rtIsNaN(search_k_start)) {
      } else {
        // % �ж���������ٶȵĽǶȱ仯�ǹ�С
        if (search_k_start > search_k_end) {
          i24 = 1;
          i25 = 1;
        } else {
          i24 = (int)search_k_start;
          i25 = (int)search_k_end + 1;
        }

        ixstart = i25 - i24;
        for (ix = 0; ix < ixstart; ix++) {
          VelocityDirection_data[ix] = b_trackedMarkerVelocity[4 + 5 * ((i24 +
            ix) - 1)];
        }

        //  �ٶȷ���
        ixstart = 1;
        MaxN_Calib = b_trackedMarkerVelocity[4 + 5 * (i24 - 1)];
        if (i25 - i24 > 1) {
          if (rtIsNaN(b_trackedMarkerVelocity[4 + 5 * (i24 - 1)])) {
            ix = 2;
            exitg2 = false;
            while ((!exitg2) && (ix <= i25 - i24)) {
              ixstart = ix;
              if (!rtIsNaN(b_trackedMarkerVelocity[4 + 5 * ((i24 + ix) - 2)])) {
                MaxN_Calib = b_trackedMarkerVelocity[4 + 5 * ((i24 + ix) - 2)];
                exitg2 = true;
              } else {
                ix++;
              }
            }
          }

          if (ixstart < i25 - i24) {
            while (ixstart + 1 <= i25 - i24) {
              if (b_trackedMarkerVelocity[4 + 5 * ((i24 + ixstart) - 1)] >
                  MaxN_Calib) {
                MaxN_Calib = b_trackedMarkerVelocity[4 + 5 * ((i24 + ixstart) -
                  1)];
              }

              ixstart++;
            }
          }
        }

        ixstart = 1;
        LastEnd_k = VelocityDirection_data[0];
        if (i25 - i24 > 1) {
          if (rtIsNaN(VelocityDirection_data[0])) {
            ix = 2;
            exitg1 = false;
            while ((!exitg1) && (ix <= i25 - i24)) {
              ixstart = ix;
              if (!rtIsNaN(VelocityDirection_data[ix - 1])) {
                LastEnd_k = VelocityDirection_data[ix - 1];
                exitg1 = true;
              } else {
                ix++;
              }
            }
          }

          if (ixstart < i25 - i24) {
            while (ixstart + 1 <= i25 - i24) {
              if (VelocityDirection_data[ixstart] < LastEnd_k) {
                LastEnd_k = VelocityDirection_data[ixstart];
              }

              ixstart++;
            }
          }
        }

        if (MaxN_Calib - LastEnd_k > 0.52359877559829882) {
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
          ixstart = b_dX_Vision_size[0] * b_dX_Vision_size[1];
          for (i24 = 0; i24 < ixstart; i24++) {
            dX_Vision_data[i24] = b_dX_Vision_data[i24];
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
  int i3;

  //
  //  figure('name','trackFlag')
  //  plot(TrackFlag,'.')
  //  % plot(otherMakersTime,TrackFlag,'.')
  //  % xlabel('time sec')
  //
  //  figure('name','dPi_ConJudge')
  //  plot(otherMakersTime,dPi_ConJudge)
  //  temp = makerTrackThreshold.MaxContinuesDisplacement ;
  //  line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' ) 
  //
  //  xlabel('time sec')
  //
  //  figure('name','INSVNSMarkHC_Min')
  //  plot(otherMakersTime,INSVNSMarkHC_Min)
  //  temp = makerTrackThreshold.MaxMarkHighChange ;
  //  line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' ) 
  //  temp = -makerTrackThreshold.MaxMarkHighChange ;
  //  line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' ) 
  //  xlabel('time sec')
  //
  //
  //  figure('name','dPError_dT_xy')
  //  plot(otherMakersTime,dPError_dT_xy)
  //  temp = makerTrackThreshold.PositionErrorBear_dT ;
  //  line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' ) 
  //  xlabel('time sec')
  //  legend( 'dPError\_dT\_xy','PositionErrorBear\_dT' )
  //
  //  figure('name','dPError_dT_z')
  //  plot(otherMakersTime,dPError_dT_z)
  //  temp = makerTrackThreshold.PositionErrorBear_dT ;
  //  line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' ) 
  //  xlabel('time sec')
  //  legend( 'dPError\_dT\_z','PositionErrorBear\_dT' )
  //
  //  figure('name','dP_Inertial_xyNorm')
  //  plot(otherMakersTime,dP_Inertial_xyNorm)
  //  temp = makerTrackThreshold.MaxStaticDisp_dT ;
  //  line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' ) 
  //  xlabel('time sec')
  //  legend( 'dPError\_dT','MaxStaticDisp\_dT' )
  //
  //  figure('name','angleErr_dT_Min')
  //  plot(otherMakersTime,angleErr_dT_Min*180/pi)
  //  temp = makerTrackThreshold.Max_dPAngle_dS*180/pi ;
  //  line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' ) 
  //  xlabel('time sec')
  //  legend( 'dPError\_dT','MaxStaticDisp\_dT' )
  //
  //
  //  figure('name','dPError_dS_xyNorm')
  //  plot(otherMakersTime,dPError_dS_xyNorm)
  //  temp = makerTrackThreshold.MaxPositionError_dS ;
  //  line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' ) 
  //  xlabel('time sec')
  //
  //  figure('name','angleErr_dS')
  //  plot(otherMakersTime,angleErr_dS*180/pi)
  //  temp = makerTrackThreshold.Max_dPAngle_dS*180/pi ;
  //  line( [otherMakersTime(1) otherMakersTime(MarkerTN)],[temp temp],'color','r' ) 
  //  xlabel('time sec')
  //
  //  figure('name','ConTrackedFailed')
  //  plot(ConTrackedFailed)
  //
  //
  //
  //  FailTrackFlagNum = sum( TrackFlag<=0 );
  //  fprintf( 'FailTrackFlagNum=%d ( %0.3f ) \n',FailTrackFlagNum,FailTrackFlagNum/length(TrackFlag) ); 
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
  for (i3 = 0; i3 < 2; i3++) {
    c_makerTrackThreshold_MaxHighMo[i3] = -0.3 + 0.8 * (double)i3;
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
// Arguments    : struct1_T *otherMakers_k
//                int b_inertial_k
//                const double InertialPosition[34560]
//                double makerTrackThreshold_INSMarkH0
//                double makerTrackThreshold_VNSMarkH0
//                double *trackedMakerPosition_k_OK
//                double *TrackFlag
//                double *b_INSVNSMarkHC_Min
// Return Type  : void
//
static void Track_High_Judge(struct1_T *otherMakers_k, int b_inertial_k, const
  double InertialPosition[34560], double makerTrackThreshold_INSMarkH0, double
  makerTrackThreshold_VNSMarkH0, double *trackedMakerPosition_k_OK, double
  *TrackFlag, double *b_INSVNSMarkHC_Min)
{
  emxArray_real_T *INSVNSMarkHC;
  int M;
  int i22;
  int ixstart;
  int i;
  unsigned int uv0[2];
  emxArray_real_T *y;
  int ix;
  boolean_T exitg1;
  double invalid_i;
  long long i23;
  double d1;
  double b_otherMakers_k[3];

  // % �߶��ж�
  //  ��1.1������Ŀ��ؽ����Ӿ�Ŀ����˵�߶ȲINSVNSMarkHC�� =  INSVNSMarkL * 
  //  cos(thita)��INSVNSMarkL Ϊ�������ڳ�ʼʱ�̼̿���õ���
  //   INSVNSMarkHC ���㷽������ǰ�߶�-ֱ��ʱ�ĸ߶�
  *trackedMakerPosition_k_OK = rtNaN;
  *b_INSVNSMarkHC_Min = rtNaN;
  *TrackFlag = 0.0;
  if (rtIsNaN(makerTrackThreshold_INSMarkH0)) {
  } else {
    emxInit_real_T(&INSVNSMarkHC, 2);
    M = otherMakers_k->otherMakersN;
    i22 = INSVNSMarkHC->size[0] * INSVNSMarkHC->size[1];
    INSVNSMarkHC->size[0] = 1;
    INSVNSMarkHC->size[1] = otherMakers_k->otherMakersN;
    emxEnsureCapacity((emxArray__common *)INSVNSMarkHC, i22, (int)sizeof(double));
    ixstart = otherMakers_k->otherMakersN;
    for (i22 = 0; i22 < ixstart; i22++) {
      INSVNSMarkHC->data[i22] = 0.0;
    }

    for (i = 0; i + 1 <= otherMakers_k->otherMakersN; i++) {
      INSVNSMarkHC->data[i] = (-InertialPosition[2 + 3 * (b_inertial_k - 1)] +
        otherMakers_k->Position[2 + 3 * i]) - (makerTrackThreshold_INSMarkH0 -
        makerTrackThreshold_VNSMarkH0);
    }

    //  �߶Ȳ���С�ĵ�
    for (i22 = 0; i22 < 2; i22++) {
      uv0[i22] = (unsigned int)INSVNSMarkHC->size[i22];
    }

    emxInit_real_T(&y, 2);
    i22 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = (int)uv0[1];
    emxEnsureCapacity((emxArray__common *)y, i22, (int)sizeof(double));
    for (ixstart = 0; ixstart < INSVNSMarkHC->size[1]; ixstart++) {
      y->data[ixstart] = fabs(INSVNSMarkHC->data[ixstart]);
    }

    ixstart = 1;
    *b_INSVNSMarkHC_Min = y->data[0];
    if (y->size[1] > 1) {
      if (rtIsNaN(y->data[0])) {
        ix = 2;
        exitg1 = false;
        while ((!exitg1) && (ix <= y->size[1])) {
          ixstart = ix;
          if (!rtIsNaN(y->data[ix - 1])) {
            *b_INSVNSMarkHC_Min = y->data[ix - 1];
            exitg1 = true;
          } else {
            ix++;
          }
        }
      }

      if (ixstart < y->size[1]) {
        while (ixstart + 1 <= y->size[1]) {
          if (y->data[ixstart] < *b_INSVNSMarkHC_Min) {
            *b_INSVNSMarkHC_Min = y->data[ixstart];
          }

          ixstart++;
        }
      }
    }

    emxFree_real_T(&y);

    //  ���߶Ȳ�����ĵ��޳�
    invalid_i = 0.0;
    for (i = 1; i <= M; i++) {
      if (fabs(INSVNSMarkHC->data[i - 1]) > 0.4) {
        //  ���߶Ȳ�����ĵ��޳�
        // % �޳� otherMakers_k.Position �еĵ� i ����
        i23 = otherMakers_k->otherMakersN - 1LL;
        if (i23 > 2147483647LL) {
          i23 = 2147483647LL;
        } else {
          if (i23 < -2147483648LL) {
            i23 = -2147483648LL;
          }
        }

        i22 = (int)i23;
        d1 = rt_roundd_snf((double)i - invalid_i);
        if (d1 >= -2.147483648E+9) {
          ixstart = (int)d1;
        } else {
          ixstart = MIN_int32_T;
        }

        while (ixstart <= i22) {
          for (ix = 0; ix < 3; ix++) {
            b_otherMakers_k[ix] = otherMakers_k->Position[ix + 3 * ixstart];
          }

          for (ix = 0; ix < 3; ix++) {
            otherMakers_k->Position[ix + 3 * (ixstart - 1)] = b_otherMakers_k[ix];
          }

          ixstart++;
        }

        ixstart = otherMakers_k->otherMakersN;
        for (i22 = 0; i22 < 3; i22++) {
          otherMakers_k->Position[i22 + 3 * (ixstart - 1)] = rtNaN;
        }

        i23 = otherMakers_k->otherMakersN - 1LL;
        if (i23 > 2147483647LL) {
          i23 = 2147483647LL;
        } else {
          if (i23 < -2147483648LL) {
            i23 = -2147483648LL;
          }
        }

        otherMakers_k->otherMakersN = (int)i23;
        invalid_i++;
      }
    }

    emxFree_real_T(&INSVNSMarkHC);

    // % ͨ���߶��޳���������
    if (otherMakers_k->otherMakersN == 0) {
      *TrackFlag = -1.0;
    }
  }
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
  int i10;
  double d0;
  int k;
  double b_k;
  int i11;

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
    for (i10 = 0; i10 < 34560; i10++) {
      InertialPositionCompensate[i10] = 0.0;

      //  ÿһ�����ۻ�λ�Ʋ����� ��¼
      InertialPositionNew[i10] = rtNaN;
    }

    for (i10 = 0; i10 < 11520; i10++) {
      InertialPositionNew[2 + 3 * i10] = InertialPosition[2 + 3 * i10];
    }

    //  �߶Ȳ�����
    for (i10 = 0; i10 < 2; i10++) {
      InertialPositionNew[i10] = InertialPosition[i10];
    }

    //  ��ʼ��ѡ�����
    memcpy(&HipDisplacementNew[0], &HipDisplacement[0], 34560U * sizeof(double));
  }

  if ((2.0 >= CalStartIN) || rtIsNaN(CalStartIN)) {
    d0 = 2.0;
  } else {
    d0 = CalStartIN;
  }

  i10 = (int)(CalEndIN + (1.0 - d0));
  for (k = 0; k < i10; k++) {
    b_k = d0 + (double)k;

    //  ���ô����Ե���
    for (i11 = 0; i11 < 2; i11++) {
      InertialPositionNew[i11 + 3 * ((int)b_k - 1)] = InertialPositionNew[i11 +
        3 * ((int)(b_k - 1.0) - 1)] + (InertialPosition[i11 + 3 * ((int)b_k - 1)]
        - InertialPosition[i11 + 3 * ((int)(b_k - 1.0) - 1)]);
    }

    //  ���󴿹���Ϊ���
    if (!rtIsNaN(d_trackedMakerPosition_Inertial[3 * ((int)b_k - 1)])) {
      //  �������
      for (i11 = 0; i11 < 2; i11++) {
        InertialErr[i11 + (((int)b_k - 1) << 1)] =
          d_trackedMakerPosition_Inertial[i11 + 3 * ((int)b_k - 1)] -
          InertialPositionNew[i11 + 3 * ((int)b_k - 1)];
        InertialPositionNew[i11 + 3 * ((int)b_k - 1)] += InertialErr[i11 +
          (((int)b_k - 1) << 1)] * compensateRate;
      }
    }

    for (i11 = 0; i11 < 2; i11++) {
      InertialPositionCompensate[i11 + 3 * ((int)b_k - 1)] =
        InertialPositionNew[i11 + 3 * ((int)b_k - 1)] - InertialPosition[i11 + 3
        * ((int)b_k - 1)];
    }

    //  �ۻ�λ�Ʋ�����
  }

  // % ͨ�� InertialPositionNew ���� HipDisplacementNew
  //  ��Headλ�ô���Hip��������ͷ��head�����λ��
  i10 = (int)(CalEndIN + (1.0 - CalStartIN));
  for (k = 0; k < i10; k++) {
    b_k = CalStartIN + (double)k;
    for (i11 = 0; i11 < 2; i11++) {
      HipDisplacementNew[i11 + 3 * ((int)b_k - 1)] = HipDisplacement[i11 + 3 *
        ((int)b_k - 1)] + InertialPositionCompensate[i11 + 3 * ((int)b_k - 1)];
    }
  }

  for (i10 = 0; i10 < 34560; i10++) {
    InertialPositionCompensate_out[i10] = InertialPositionCompensate[i10];
    HipDisplacementNew_out[i10] = HipDisplacementNew[i10];
  }
}

//
// Arguments    : void
// Return Type  : void
//
static void VNSCompensateINS_init()
{
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
// Arguments    : const double a[3]
//                int varargin_2
//                emxArray_real_T *b
// Return Type  : void
//
static void b_repmat(const double a[3], int varargin_2, emxArray_real_T *b)
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
  int i26;
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
          i26 = (ix0 + n) - 2;
          for (k = ix0; k <= i26; k++) {
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
        i26 = (ix0 + n) - 2;
        for (k = ix0; k <= i26; k++) {
          x_data[k - 1] *= *alpha1;
        }

        for (k = 1; k <= knt; k++) {
          xnorm *= 1.0020841800044864E-292;
        }

        *alpha1 = xnorm;
      } else {
        tau = (xnorm - *alpha1) / xnorm;
        *alpha1 = 1.0 / (*alpha1 - xnorm);
        i26 = (ix0 + n) - 2;
        for (k = ix0; k <= i26; k++) {
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
  int i9;
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
  for (i9 = 0; i9 < itemp; i9++) {
    b_A_data[i9] = A_data[i9];
  }

  if (A_size[0] <= 2) {
    b_mn = A_size[0];
  } else {
    b_mn = 2;
  }

  for (i9 = 0; i9 < 2; i9++) {
    jpvt[i9] = (signed char)(1 + i9);
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
              i9 = (pvt + lastv) - 1;
              for (itemp = pvt; itemp <= i9; itemp++) {
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
                i9 = lastv + k;
                for (itemp = k; itemp + 1 <= i9; itemp++) {
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

  for (i9 = 0; i9 < 4; i9++) {
    Y[i9] = 0.0;
  }

  for (pvt = 0; pvt < mn; pvt++) {
    if (tau_data[pvt] != 0.0) {
      for (k = 0; k < 2; k++) {
        c = B_data[pvt + B_size[0] * k];
        i9 = A_size[0] - pvt;
        for (i = 0; i <= i9 - 2; i++) {
          itemp = (pvt + i) + 1;
          c += b_A_data[itemp + A_size[0] * pvt] * B_data[itemp + B_size[0] * k];
        }

        c *= tau_data[pvt];
        if (c != 0.0) {
          B_data[pvt + B_size[0] * k] -= c;
          i9 = A_size[0] - pvt;
          for (i = 0; i <= i9 - 2; i++) {
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
//                double b[30]
// Return Type  : void
//
static void repmat(const double a[3], double b[30])
{
  int jtilecol;
  int ibtile;
  int k;
  for (jtilecol = 0; jtilecol < 10; jtilecol++) {
    ibtile = jtilecol * 3;
    for (k = 0; k < 3; k++) {
      b[ibtile + k] = a[k];
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
//                int CalStartVN_in
//                int CalEndVN_in
//                double b_InertialPositionCompensate[34560]
//                double b_HipDisplacementNew[34560]
// Return Type  : void
//
void GetINSCompensateFromVNS(const struct0_T *InertialData, struct1_T
  otherMakers[3600], double compensateRate, int CalStartVN_in, int CalEndVN_in,
  double b_InertialPositionCompensate[34560], double b_HipDisplacementNew[34560])
{
  int i13;
  int k;
  double b_k;
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
  // % �� Optitrack �� OtherMarker ��������ϵͳ
  // % �õ����� Hip λ�ò����� InertialPositionCompensate
  //  InertialPositionCompensate [ 3*N ]  m  NEDϵ
  //  CalStartVN_in �� ������㣨�Ӿ���
  //  CalEndVN_in �������յ㣨�Ӿ���
  // % ʵʱ�����ߵ��л� ʵ��
  //    CalStartN �� ������ʼ�㣨�Ӿ���
  //    CalEndN �� ��������㣨�Ӿ���
  CalStartVN = CalStartVN_in;
  CalEndVN = CalEndVN_in;
  if ((CalStartVN == 1.0) && (CalEndVN == 3600.0)) {
    IsOnLine = 0.0;

    //  ���ߴ���
  } else {
    IsOnLine = 1.0;

    //  ʵʱ����
  }

  //  codegen -globals {'otherMakersTime',coder.Cosntant(NaN(1,1000))}
  //  codegen -globals {'inertialTime',coder.Cosntant(NaN(1,1000))}
  // % otherMakers Ԥ����
  //  ���Ӿ��궨ʱ�����������������κ�Ҫ��ʱ����ͨ�� BodyDirection ���Ӿ��ĳ������������һ�� 
  //  inertialTime(CalStartVN:CalEndVN ) = InertialData.time(CalStartVN:CalEndVN ) ; 
  if (IsOnLine == 0.0) {
    memset(&VisionData_inertial_k[0], 0, 3600U * sizeof(double));
  }

  i13 = (int)(CalEndVN + (1.0 - CalStartVN));
  for (k = 0; k < i13; k++) {
    b_k = CalStartVN + (double)k;
    VisionData_inertial_k[(int)b_k - 1] = otherMakers[(int)b_k - 1].inertial_k;
  }

  PreProcess(otherMakers, InertialData->BodyDirection);

  //  fprintf('PreProcess OK \n');
  //        DrawAllINSVNS( otherMakers,InertialData ) ;
  //     return;
  // % ����˵����
  //        dbstop in GetRightOtherMaker
  // % load data
  //  inertialTime = InertialData.time ;
  inertialFre = InertialData->frequency;
  for (i13 = 0; i13 < 11520; i13++) {
    InertialData_visual_k[i13] = InertialData->visual_k[i13];
  }

  visionFre = otherMakers[0].frequency;
  CalStartIN = VisionData_inertial_k[(int)CalStartVN - 1];

  //  ������� ����
  CalEndIN = VisionData_inertial_k[(int)CalEndVN - 1];

  //  �����յ� ����
  switch (otherMakers[0].MarkerSet) {
   case 16:
    //  ���м����ݹ������
    //  'Head'
    for (i13 = 0; i13 < 34560; i13++) {
      InertialPosition[i13] = InertialData->HeadPosition[i13];
    }
    break;

   case 1:
    //   'Hip'
    for (i13 = 0; i13 < 34560; i13++) {
      InertialPosition[i13] = InertialData->HipPosition[i13];
    }
    break;

   default:
    for (i13 = 0; i13 < 34560; i13++) {
      InertialPosition[i13] = InertialData->HeadPosition[i13];
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
  c_InertialPositionCompensate_no = false;
  CalEndIN = b_CalEndIN;
  CalStartIN = b_CalStartIN;
  visionFre = b_visionFre;
  for (i0 = 0; i0 < 11520; i0++) {
    InertialData_visual_k[i0] = rtNaN;
  }

  inertialFre = b_inertialFre;
  for (i0 = 0; i0 < 3600; i0++) {
    VisionData_inertial_k[i0] = rtNaN;
  }

  IsOnLine = b_IsOnLine;
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
