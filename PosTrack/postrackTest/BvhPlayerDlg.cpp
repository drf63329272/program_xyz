// BvhPlayerDlg.cpp : ʵ���ļ�
//

#include "stdafx.h"
#include "postrack.h"
#include "BvhPlayerDlg.h"
#include "afxdialogex.h"

// CBvhPlayerDlg �Ի���

IMPLEMENT_DYNAMIC(CBvhPlayerDlg, CDialogEx)

CBvhPlayerDlg::CBvhPlayerDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CBvhPlayerDlg::IDD, pParent)
{

}

CBvhPlayerDlg::~CBvhPlayerDlg()
{
}

void CBvhPlayerDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CBvhPlayerDlg, CDialogEx)
    ON_WM_SIZE()
END_MESSAGE_MAP()


// CBvhPlayerDlg ��Ϣ�������


BOOL CBvhPlayerDlg::OnInitDialog()
{
    CDialogEx::OnInitDialog();

    // TODO:  �ڴ���Ӷ���ĳ�ʼ��
    PNCreateBvhPlayer(this->m_hWnd);

    PNCreateAvatar();

    // ������һ��У׼���ļ�
    PNLoadCalibrationData();

	PNSetSensorSuitType(SS_LegacySensors);

	PNSetSensorCombinationMode(0, SC_FullBody);

    // ����һ����λ��
    PNSetBvhDataFormat(TRUE, RO_YXZ);

    return TRUE;  // return TRUE unless you set the focus to a control
    // �쳣: OCX ����ҳӦ���� FALSE
}


void CBvhPlayerDlg::OnSize(UINT nType, int cx, int cy)
{
    CDialogEx::OnSize(nType, cx, cy);
    PNBvhPlayerResizeToParent();
    // TODO: �ڴ˴������Ϣ����������
}


BOOL CBvhPlayerDlg::PreTranslateMessage(MSG* pMsg)
{
    // TODO: �ڴ����ר�ô����/����û���
    if(pMsg->message==WM_KEYDOWN && pMsg->wParam==VK_ESCAPE)  return TRUE;
    if(pMsg->message==WM_KEYDOWN && pMsg->wParam==VK_RETURN) return TRUE; 
    return CDialogEx::PreTranslateMessage(pMsg);
}


BOOL CBvhPlayerDlg::DestroyWindow()
{
    // TODO: �ڴ����ר�ô����/����û���
    return CDialogEx::DestroyWindow();
}
