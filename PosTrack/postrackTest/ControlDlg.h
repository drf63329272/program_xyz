#pragma once
#include "afxcmn.h"
#include "afxwin.h"

#include "Definitions.h"
#include "HybidTrack.h"

class PosTrackor;
class CSerialPort;
class SerialControl;



class CControlDlg : public CDialogEx
{
	DECLARE_DYNAMIC(CControlDlg)

public:
	CControlDlg(CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~CControlDlg();


// �Ի�������
	enum { IDD = IDD_DLG_CONTROL };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

	DECLARE_MESSAGE_MAP()
public:
    virtual BOOL OnInitDialog();
    virtual BOOL PreTranslateMessage(MSG* pMsg);
    CListCtrl m_wndRatioList;
    afx_msg void OnTimer(UINT_PTR nIDEvent);
    CEdit m_wndIP;
    CEdit m_wndPort;
    afx_msg void OnBnClickedBtnTpos();
    afx_msg void OnBnClickedBtnApos();
    afx_msg void OnBnClickedBtnSpos();
    afx_msg void OnBnClickedBtnPos();
    afx_msg void OnBnClickedBtnOpenport();
    afx_msg void OnBnClickedBtnClossensor();
    afx_msg void OnBnClickedBtnConnect();
	afx_msg void OnBnClickedBtnDisconnect();
	afx_msg void OnBnClickedBtnWritefile();

	OutputQuaternionTypes qType;

    PosTrackor* pPosTrackor;
    FILE* fpPos;
	FILE* fpInertia;
	FILE* fpOpt;
   // FILE* fpCali;
    char tmpstr[200];
    CStatic m_wndProgress;

    // ��ѧʵʱͷ��λ������
	Point3D_t OptiTracData;

	// OtherMark
	INT8 m_curOtherMarkN;
	float m_curOtherMark[3];

    // 
    CSerialPort* pSerial;
    SerialControl* pCommandControl;

    void ReadDataFromSerial();
    // �ɼ��߳�
    static  DWORD WINAPI Acquisition(LPVOID param); 
    HANDLE hThread;
    int m_ThreadFlag;

    // �Ƿ�д�ļ�
    bool isWriteFile;
	bool isWriteRawFile;

    unsigned char data[1024];
    CEdit m_wndMsg;
    CString m_Msg;
    CStatic m_wndMessage;

	// ��ѧ�����������ں�
    void DataFusion(float* bonePosX, Point3D_t optiTracData);
	afx_msg void OnDestroy();
	afx_msg void OnBnClickedBtnWriterawfile();
	afx_msg void OnCbnSelchangeCombo1();
	CComboBox wnd_qType;
	afx_msg void OnBnClickedButtonZero();

	// �ɼ�Ƶ��
	float DataFreq;

	// ����һ���첶�ṹ�壬���ڴ洢��϶���������

	CHybidTrack HybidTrack;
	afx_msg void OnBnClickedBtnReadrawfile();
};
