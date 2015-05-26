// ControlDlg.cpp : ʵ���ļ�
//

#include "stdafx.h"
#include "postrack.h"
#include "ControlDlg.h"
#include "afxdialogex.h"

#include "PosTrackor.h"
#include "CommandControl.h"
#include "serialport.h"

CRITICAL_SECTION g_cs;

// ��ѧ����
void CALLBACK recievePosTrackor(void * pOwner, float* optiTracData)
{
    if (pOwner == NULL) return ;

    CControlDlg* dlg = (CControlDlg*)pOwner;    
    if (dlg == NULL)return ;

	// save optic track data for data fusion
	dlg->OptiTracData = Point3D_t(optiTracData[0], optiTracData[2], optiTracData[1]); // ת�ɹ�������ϵ
}

// ��ѧ����
void CALLBACK recieveOherMark(void * pOwner, float* otherMarkData, int count)
{
	if (pOwner == NULL) return;
	CControlDlg* dlg = (CControlDlg*)pOwner;
	if (dlg == NULL)return;

	if (!dlg->isWriteRawFile) return;

	SYSTEMTIME  time;
	GetLocalTime(&time);

	if (dlg->fpOpt)
	{
		fprintf(dlg->fpOpt, "%02d:%02d:%02d    %d", time.wMinute, time.wSecond, time.wMilliseconds, count);
		if (count)
		{
			for (int i = 0; i < count; i++)
			{
				fprintf(dlg->fpOpt, " %0.5f %0.5f %0.5f",  
					 otherMarkData[i + 0], otherMarkData[i + 1], otherMarkData[i + 2]);
			}
		}
		fprintf(dlg->fpOpt, "\n");
	}

}

void __stdcall CalculatedBinaryDataCallback(void* customObject, int avatarIndex, CalculationDataHeader* cbp, int packLen)
{
   //�м�Ĭ�������QAWΪ QT_GlobalRawQuat AT_ModelRawData GY_ModelRawData
    
    CControlDlg* dlg = (CControlDlg*)customObject;
    SYSTEMTIME  time;
    GetLocalTime(&time);

	// Get X data
    float X[126] = { 0.0 };
    float* begin = (float*)((char*)cbp + sizeof(CalculationDataHeader));
	for (int i = 0; i < 21; i++)
	{
		for (int j = 0; j < 6;j++)
		{
			X[i * 6 + j] = begin[i * 16 + j];
		}
	}
	
	if (dlg->isWriteRawFile)
	{
		if (dlg->fpInertia)
		{
		fprintf(dlg->fpInertia, "%02d:%02d:%02d    "                   // time �֣��룺����
			"%0.5f %0.5f %0.5f %0.5f %0.5f %0.5f %0.5f "               // hip-q hip-disp
			"%0.5f %0.5f %0.5f %0.5f %0.5f %0.5f %0.5f\n",             // head-q head-disp
			time.wMinute, time.wSecond, time.wMilliseconds,
			begin[6], begin[7], begin[8], begin[9], X[0], X[1], X[2],
			begin[246], begin[247], begin[248], begin[249], X[90], X[91], X[92]);
		}
	}

    // Save org head pos data
    sprintf(dlg->tmpstr, "%02d-%02d-%02d-%02d  %0.3f %0.3f %0.3f",
        time.wHour, time.wMinute, time.wSecond, time.wMilliseconds,
        X[90], X[91], X[92]); //  inert X Y Z 

    // Calibrating
    if (dlg->pPosTrackor->IsCalibrating)
    {
        Point3D_t pt;
        pt.X = X[90];
        pt.Y = X[91];
        pt.Z = X[92];
        dlg->m_wndMsg.SetWindowText(L"��ѧУ׼��...");
        dlg->pPosTrackor->AddCalibrationData(pt);
        return;
    }

    // ͷ���Ľڵ���10 �ǵ�15�������� ����ǰ15*6 = 90(0~90)   90:x  91:y 92:z
    // �����ں�
    dlg->DataFusion(X, dlg->OptiTracData);

}

void CControlDlg::DataFusion(float* bonePosX, Point3D_t optiTracData)
{
	char tmpFileStr[300];
	memset(tmpFileStr, '\0', 300);

	// �Ƿ����У׼����ԭʼУ׼����д���ļ���
	if (pPosTrackor->IsCalibrating)return;
	// ���û������У׼�򷵻�
	if (!pPosTrackor->IsCalibrated)return;

	// Save tmp data
	Point3D_t tmpOrgOptiTrac = optiTracData;

	// Get head position data
	Point3D_t headPosition(bonePosX[90], bonePosX[91], bonePosX[92]);

	// ��������ϵλ��
	headPosition = headPosition - pPosTrackor->Trans1;

	// ����ѧϵƽ�Ƶ�����ϵ��ʹԭ�������ϵ�غ�
	optiTracData.X += pPosTrackor->Trans2.X;
	optiTracData.Y += pPosTrackor->Trans2.Y;
	optiTracData.Z += pPosTrackor->Trans2.Z;

	// ����ѧϵ��ת������ϵ��ʹ���������ϵ�غ�
	Vector2d rotatedOptiTrac = pPosTrackor->R.transpose() * Vector2d(optiTracData.X, optiTracData.Y);
	optiTracData.X = rotatedOptiTrac[0];
	optiTracData.Y = rotatedOptiTrac[1];

	// ��ȡ��ѧϵ�����ϵ�Ĳ�
	Point3D_t offset = headPosition - optiTracData;
	Point3D_t outputOffset = offset;

	// ��ƫϵ��
	static double rectifyFactor = 0.3;
	// ͨ����ƫϵ������ÿ�ξ�ƫ����
	offset = offset * rectifyFactor;
	offset = offset * rectifyFactor;

	// ��ƫ
	for (int i = 0; i < 126; i += 6)
	{
		bonePosX[i + 0] -= offset.X;
		bonePosX[i + 1] -= offset.Y;
		//bonePosX[i + 2] -= offset.Z;
	}

	// Ӧ�õ�������
	PNUpdateXt(0, bonePosX);

	m_Msg.Format(L"x = %0.3f, y = %0.3f, z = %0.3f \r\n r_x = %0.3f, y = %0.3f, r_z = %0.3f",
		tmpOrgOptiTrac.X, tmpOrgOptiTrac.Y, tmpOrgOptiTrac.Z,
		optiTracData.X, optiTracData.Y, optiTracData.Z);
	m_wndMsg.SetWindowText(m_Msg);

	if (!isWriteFile) return;

	// Time ԭʼ����XYZ  ƫ�ƹ��Ĺ���XYZ  ƫ�ƹ�+��ת��ѧ XZY  ԭʼ��ѧXZY
	sprintf_s(tmpFileStr, "%s  %0.3f %0.3f %0.3f  %0.3f %0.3f %0.3f  %0.3f %0.3f %0.3f %0.3f\n",
		tmpstr,
		headPosition.X, headPosition.Y, headPosition.Z,
		optiTracData.X, optiTracData.Y, optiTracData.Z,
		tmpOrgOptiTrac.X, tmpOrgOptiTrac.Y, tmpOrgOptiTrac.Z,
		outputOffset.mod());

	if (fpPos == NULL) return;

	fwrite(tmpFileStr, strlen(tmpFileStr), 1, fpPos);
}


void __stdcall CalibrationProgressCallback(void* HandleObject, int avatarIndex, float percent)
{
    CControlDlg* dlg = (CControlDlg*)HandleObject;
    wchar_t str[20];
    swprintf_s(str,20, L"%d%%\0", (int)(percent*100));
    dlg->m_wndProgress.SetWindowText(str);
}

IMPLEMENT_DYNAMIC(CControlDlg, CDialogEx)

CControlDlg::CControlDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CControlDlg::IDD, pParent)
{
    pPosTrackor = NULL;
    
    fpPos = NULL;
    //fpCali = NULL;
	fpInertia = NULL;
	fpOpt = NULL;

    memset(tmpstr, '\0', 200);
    
    pSerial = NULL;

    pCommandControl = NULL;

    m_ThreadFlag = 1;
    
    hThread = NULL;

    memset(data, '\0', sizeof(data));

    isWriteFile = false;
	isWriteRawFile = false;

	qType = QT_GlobalBoneQuat;
}

CControlDlg::~CControlDlg()
{
    // ������ȡ�߳�
    m_ThreadFlag = 0;
    Sleep(1000);
    if (hThread)
    {
        CloseHandle(hThread);
        hThread = NULL;
    }
}

void CControlDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_LIST1, m_wndRatioList);
	DDX_Control(pDX, IDC_EDIT_IP, m_wndIP);
	DDX_Control(pDX, IDC_EDIT_PORT, m_wndPort);
	DDX_Control(pDX, IDC_STC_PROGRESS, m_wndProgress);
	DDX_Control(pDX, IDC_EDIT1, m_wndMsg);
	DDX_Control(pDX, IDC_STATIC_MSG, m_wndMessage);
	DDX_Control(pDX, IDC_COMBO1, wnd_qType);
}


BEGIN_MESSAGE_MAP(CControlDlg, CDialogEx)
    ON_WM_TIMER()
    ON_BN_CLICKED(IDC_BTN_TPOS, &CControlDlg::OnBnClickedBtnTpos)
    ON_BN_CLICKED(IDC_BTN_APOS, &CControlDlg::OnBnClickedBtnApos)
    ON_BN_CLICKED(IDC_BTN_SPOS, &CControlDlg::OnBnClickedBtnSpos)
    ON_BN_CLICKED(IDC_BTN_POS, &CControlDlg::OnBnClickedBtnPos)
    ON_BN_CLICKED(IDC_BTN_OPENPORT, &CControlDlg::OnBnClickedBtnOpenport)
    ON_BN_CLICKED(IDC_BTN_CLOSSENSOR, &CControlDlg::OnBnClickedBtnClossensor)
    ON_BN_CLICKED(IDC_BTN_CONNECT, &CControlDlg::OnBnClickedBtnConnect)
    ON_BN_CLICKED(IDC_BTN_DISCONNECT, &CControlDlg::OnBnClickedBtnDisconnect)
    ON_BN_CLICKED(IDC_BTN_WRITEFILE, &CControlDlg::OnBnClickedBtnWritefile)
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_BTN_WRITERAWFILE, &CControlDlg::OnBnClickedBtnWriterawfile)
	ON_CBN_SELCHANGE(IDC_COMBO1, &CControlDlg::OnCbnSelchangeCombo1)
	ON_BN_CLICKED(IDC_BUTTON_ZERO, &CControlDlg::OnBnClickedButtonZero)
END_MESSAGE_MAP()


// CControlDlg ��Ϣ�������


BOOL CControlDlg::OnInitDialog()
{
    CDialogEx::OnInitDialog();

    // TODO:  �ڴ���Ӷ���ĳ�ʼ��
    // ���õð�����ʾ
    m_wndRatioList.InsertColumn(0, _T("BoneID"), LVCFMT_CENTER, 100);
    m_wndRatioList.InsertColumn(1, _T("Ratio"), LVCFMT_LEFT, 100);
    m_wndRatioList.SetExtendedStyle(LVS_EX_FULLROWSELECT|LVS_EX_GRIDLINES);

	// �����Q�ĳ�ʼ��
	wnd_qType.SetCurSel(0);

    for (int i = 0; i < 17; i++)
    {
        TCHAR strTmp[5];
        swprintf_s(strTmp, 5, L"%d", i+1);
        m_wndRatioList.InsertItem(i, strTmp);
    }

    // ����BoneQ���м����ݸ�ʽ
	PNSetCalculatedQuaternionDataType(qType);

    // ����ʵʱ�м�����
    PNEnableCalculationDataBoardcast(TRUE);

    // ����У׼���Ȼص�����
    PNRegisterCalibrationProgressHandle(this, CalibrationProgressCallback);

    // �����м����ݻص�����
    PNRegisterCalculatedBinaryDataBoardcastHandle(this, CalculatedBinaryDataCallback);


    pPosTrackor = new PosTrackor();
    pPosTrackor->SetRecievePosTrackHandle(this, recievePosTrackor);
	pPosTrackor->SetRecieveOtherMarkHandle(this, recieveOherMark);
    // ��������Ĭ��ֵ
    m_wndIP.SetWindowText(L"127.0.0.1");
    m_wndPort.SetWindowText(L"1511");

    // ��ʱ����ȡ������״̬
    SetTimer(1, 1000, NULL);
    
    // ���ڹ����
    pSerial = new CSerialPort();
    pCommandControl = new SerialControl(pSerial);

    // ����һ�����Բɼ��߳�
    hThread = CreateThread(NULL, 0, Acquisition, this, 0, NULL);

    return TRUE;  // return TRUE unless you set the focus to a control
    // �쳣: OCX ����ҳӦ���� FALSE
}


BOOL CControlDlg::PreTranslateMessage(MSG* pMsg)
{
    // TODO: �ڴ����ר�ô����/����û���
    if(pMsg->message==WM_KEYDOWN && pMsg->wParam==VK_ESCAPE)  return TRUE;
    if(pMsg->message==WM_KEYDOWN && pMsg->wParam==VK_RETURN) return TRUE; 
    return CDialogEx::PreTranslateMessage(pMsg);
}


void CControlDlg::OnTimer(UINT_PTR nIDEvent)
{
    // TODO: �ڴ������Ϣ�����������/�����Ĭ��ֵ
    switch (nIDEvent)
    {
    case 1:
        {
            double SensorRatios[167] = {0.0};
            UINT SensorState[167];

            // �õ���������Ratios
            PNGetSensorReceivingStatus(0, SensorRatios);

            LVITEM lvitem;
            lvitem.mask = LVIF_TEXT;
            lvitem.iItem = 0;
            lvitem.iSubItem = 1;
            wchar_t str[10];
            for (int i = 0; i < 19; i++)
            {
                SensorState[i] = UINT(SensorRatios[i]*100.0f);			
                swprintf_s(str, 6, _T("%d%%"), SensorState[i]);
                if (i == 17 || i == 16 ) continue;
                if (i == 18)
                {
                    m_wndRatioList.SetItemText(16, 1, str);
                }
                else
                {
                    m_wndRatioList.SetItemText(i, 1, str);
                }
                
            }
        }
        break;
    default:
        break;
    }
    CDialogEx::OnTimer(nIDEvent);
}


void CControlDlg::OnBnClickedBtnTpos()
{
    // TPos
    Sleep(3000);
    PNCalibrateAllAvatars(Cali_TPose);
}


void CControlDlg::OnBnClickedBtnApos()
{
    // APos
    Sleep(3000);
    PNCalibrateAllAvatars(Cali_APose);
}


void CControlDlg::OnBnClickedBtnSpos()
{
    // SPos
    Sleep(3000);
    PNCalibrateAllAvatars(Cali_SPose);
}

// ��ѧУ׼
void CControlDlg::OnBnClickedBtnPos()
{
    
    if (pPosTrackor->IsEnabled())
    {
   
        pPosTrackor->SetToStartCalibration();
    }
    else
    {
         MessageBox(L"��ѧ�豸δ���ӣ�");
    }
}


void CControlDlg::OnBnClickedBtnOpenport()
{
    if (pSerial->IsOpen())
    {
        pCommandControl->SensorSleep();
        m_ThreadFlag = 1;
        Sleep(100);
        pSerial->Close();

        SetDlgItemText(IDC_BTN_OPENPORT, L"��ʼ�ɼ�");
    }
    else
    {
        pSerial->Open();
        char str[100];
        memset(str, '\0', 100);

        BOOL isExit = pCommandControl->QueryReceiverNodeVersion(str, 100);
        if(isExit)
        {
            m_Msg = "�ҵ����ڵ����";
            m_wndMessage.SetWindowText(m_Msg);
        }
        else
        {
            m_Msg = "���ڵ㲻����";
            m_wndMessage.SetWindowText(m_Msg);
            return;
        }

        // �����ɼ�
        pCommandControl->StartCapture();

        // ��������ģʽ
        pCommandControl->SensorToDataMode();

        // �߳̿�ʼ��ȡ
        m_ThreadFlag = 2;
        
        SetDlgItemText(IDC_BTN_OPENPORT, L"��ͣ�ɼ�");
    }
}


void CControlDlg::OnBnClickedBtnClossensor()
{
    m_ThreadFlag = 1;
    Sleep(100);
    pCommandControl->SensorPowerOff();
}


void CControlDlg::OnBnClickedBtnConnect()
{
	USES_CONVERSION;

    wchar_t strTmp[20];
    m_wndIP.GetWindowText(strTmp, 20);
	wchar_t strPort[10];
    m_wndPort.GetWindowText(strPort, 10);

    if (pPosTrackor->IsEnabled())
    {
        pPosTrackor->Disconnect();
    }
    pPosTrackor->Init();
	
	char* ip = W2A(strTmp);
	char* port = W2A(strPort);
	int nport = atoi(port);
	BOOL flag = pPosTrackor->ConnectTo(ip, nport);

    if (flag == false)
    {
        if (fpPos != NULL)
        {
            fclose(fpPos);
            fpPos = NULL;
        }
       MessageBox(L"���ӹ�ѧ�豸ʧ��");
       pPosTrackor->Disconnect();
       pPosTrackor->Release();
       return ;
    }
    m_wndMessage.SetWindowText(L"��ѧ�豸���ӳɹ�");
}


void CControlDlg::OnBnClickedBtnDisconnect()
{
    if (fpPos != NULL)
    {
        fclose(fpPos);
        fpPos =NULL;

        m_Msg = "pos��¼�ļ��Ѿ��ر� λ�ã�D:\\pos.txt";
        m_wndMessage.SetWindowText(m_Msg);
    }

    pPosTrackor->Disconnect();
    pPosTrackor->Release();
}

void CControlDlg::ReadDataFromSerial()
{
    int len = pSerial->Read(data, sizeof(data));
    PNPushData(data, len);
}

DWORD WINAPI CControlDlg::Acquisition(LPVOID param)
{
    CControlDlg* dlg = (CControlDlg*)param;

    if (dlg == NULL) return -1;

    while (true)
    {
        // ��ͣ
        if (dlg->m_ThreadFlag == 1)
        {
            Sleep(200);
            continue;
        }
        else if (dlg->m_ThreadFlag == 2)
        {
            // �Ӵ��ڶ�ȡ����
            dlg->ReadDataFromSerial();
        }
        else
        {
            break;
        }
    }
    return 0;
}

void CControlDlg::OnBnClickedBtnWritefile()
{
    isWriteFile = (isWriteFile == false)?true:false;
    if (isWriteFile)
    {
        if (fpPos != NULL)
        {
            fclose(fpPos);
            fpPos = NULL;
        }

        fpPos = fopen("D:\\pos.txt", "w+");

        if (fpPos == NULL)
        {
            MessageBox(L"�򿪱����ļ�ʧ��\n");
            return ;
        }
        char fileHeader[200];

        fprintf(fpPos, "Time   inert-X inert-Y inert-Z   optic-rX optic-rY optic-rZ   optic-X optic-Y optic-Z\n");

		SetDlgItemText(IDC_BTN_WRITEFILE, L"ֹͣ�ɼ�");
    }
    else
    {
        fclose(fpPos);
        fpPos =NULL;

        m_Msg = "pos��¼�ļ��Ѿ��ر� λ�ã�D:\\pos.txt\r\n  posCali���ݱ�����D��\\posCali.txt\r\n";
        m_wndMessage.SetWindowText(m_Msg);

		SetDlgItemText(IDC_BTN_WRITEFILE, L"��ѧ�ɼ�");
    }
}

void CControlDlg::OnDestroy()
{
	CDialogEx::OnDestroy();

	isWriteFile = false;
	isWriteRawFile = false;
	// TODO: �ڴ����ר�ô����/����û���
	m_ThreadFlag = 0;
	Sleep(200);
	if (hThread != NULL)
	{
		CloseHandle(hThread);
		hThread = NULL;
	}

	if (pSerial != NULL)
	{
		delete pSerial;
	}
	if (pCommandControl != NULL)
	{
		delete pCommandControl;
	}
}


void CControlDlg::OnBnClickedBtnWriterawfile()
{
	isWriteRawFile = (isWriteRawFile == false) ? true : false;
	if (isWriteRawFile)
	{
		wnd_qType.EnableWindow(FALSE);

		if (fpInertia != NULL)
		{
			fclose(fpInertia);
			fpInertia = NULL;
		}

		fpInertia = fopen("D:\\inertia.txt", "w+");

		if (fpInertia == NULL)
		{
			MessageBox(L"�򿪱����ļ�ʧ��\n");
			return;
		}

		CalibrationData data;
		PNGetCalibrationData(0, &data);
		fprintf(fpInertia, "Body Direction:%0.4f %0.4f %0.4f\n", data.FaceDirection.x, data.FaceDirection.y, data.FaceDirection.z);

		if (qType == QT_GlobalBoneQuat)
		{
			fprintf(fpInertia, "GlobalBoneQuat\n");
		}
		else if (qType == QT_GlobalRawQuat)
		{
			fprintf(fpInertia, "GlobalRawQuat\n");
		}

		fprintf(fpInertia, "Time hip-qs hip-qx hip-qy hip-qz hip-x hip-y hip-z head-qs head-qx head-qy head-qz head-x head-y head-z\n");
		
		if (fpOpt != NULL)
		{
			fclose(fpOpt);
			fpOpt = NULL;
		}

		fpOpt = fopen("D:\\Opt.txt", "w+");

		if (fpOpt == NULL)
		{
			MessageBox(L"�򿪱����ļ�ʧ��\n");
			return;
		}

		fprintf(fpOpt, "Time Count nOtherMarks otherMark(x y z).........\n");

		SetDlgItemText(IDC_BTN_WRITERAWFILE, L"ֹͣ�ɼ�");
	}
	else
	{
		fclose(fpInertia);
		fpInertia = NULL;

		fclose(fpOpt);
		fpOpt = NULL;

		m_Msg = "��¼�ļ��Ѿ�����\r\n λ�ã�D�� �ļ�����inertia.txt Opt.txt";
		m_wndMessage.SetWindowText(m_Msg);
		wnd_qType.EnableWindow(TRUE);
		SetDlgItemText(IDC_BTN_WRITERAWFILE, L"��ʼ�ɼ�ԭʼ����");
	}
}


void CControlDlg::OnCbnSelchangeCombo1()
{
	int index = wnd_qType.GetCurSel();
	if (index == 0)
	{
		qType = QT_GlobalBoneQuat;
	}
	else if (index == 1)
	{
		qType = QT_GlobalRawQuat;
	}

	PNSetCalculatedQuaternionDataType(qType);
}


void CControlDlg::OnBnClickedButtonZero()
{
	// TODO:  �ڴ���ӿؼ�֪ͨ����������
	PNZeroOutPosition(0);
}
