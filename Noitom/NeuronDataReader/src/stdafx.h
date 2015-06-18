// stdafx.h : ��׼ϵͳ�����ļ��İ����ļ���
// ���Ǿ���ʹ�õ��������ĵ�
// �ض�����Ŀ�İ����ļ�
//

#pragma once

#ifdef __OS_XUN__
typedef int                  SOCKET;
#define sprintf_s            snprintf
#define Sleep(t)             usleep(t*1000)
#define closesocket(sock)    close(sock)
#define HOSTENT              struct hostent

/*
 * This is used instead of -1, since the
 * SOCKET type is unsigned.
 */
#define INVALID_SOCKET  (SOCKET)(~0)
#define SOCKET_ERROR            (-1)


#else
// ���� SDKDDKVer.h ��������õ���߰汾�� Windows ƽ̨��
// ���ҪΪ��ǰ�� Windows ƽ̨����Ӧ�ó�������� WinSDKVer.h������
// WIN32_WINNT ������ΪҪ֧�ֵ�ƽ̨��Ȼ���ٰ��� SDKDDKVer.h��
#include <SDKDDKVer.h>
#define WIN32_LEAN_AND_MEAN  //  �� Windows ͷ�ļ����ų�����ʹ�õ���Ϣ
#include <windows.h>         // Windows ͷ�ļ�:
#endif


#ifdef __OS_XUN__
#include <sys/types.h>   // Types used in sys/socket.h and netinet/in.h
#include <netinet/in.h>  // Internet domain address structures and functions
#include <sys/socket.h>  // Structures and functions used for socket API
#include <netdb.h>       // Used for domain/DNS hostname lookup
#include <arpa/inet.h>   // inet_addr
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#else
#include <winsock2.h>
#pragma comment(lib,"ws2_32.lib")
#endif


// socket received data
typedef void(__stdcall *SocketDataReceived)(void* sockRef, unsigned char* data, int len);



#ifdef _DEBUG
   #define DEBUG_NEW   new( _CLIENT_BLOCK, __FILE__, __LINE__)
   #define new DEBUG_NEW

   #define ASSERT(e) if(e==NULL || e==false || e==FALSE) DbgRaiseAssertionFailure();
#else
   #define DEBUG_NEW

   #define ASSERT(e)         // nothing
#endif

#include <stdlib.h>          // atof, atoi
#include <thread>            // std::thread
#include <mutex>             // std::mutex
#include <vector>
using namespace std;
