#pragma once


// CBvhPlayerDlg �Ի���

class CBvhPlayerDlg : public CDialogEx
{
	DECLARE_DYNAMIC(CBvhPlayerDlg)

public:
	CBvhPlayerDlg(CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~CBvhPlayerDlg();

// �Ի�������
	enum { IDD = IDD_DLG_BVHPLAYER };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

	DECLARE_MESSAGE_MAP()
public:
    virtual BOOL OnInitDialog();
    afx_msg void OnSize(UINT nType, int cx, int cy);
    virtual BOOL PreTranslateMessage(MSG* pMsg);
    virtual BOOL DestroyWindow();
};
