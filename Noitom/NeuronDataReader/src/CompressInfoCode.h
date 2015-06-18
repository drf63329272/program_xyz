#pragma once

#pragma pack(push, 1) 
struct  CompressMoveInfo
{
	unsigned short count;       //��¼������ͬ���ݸ���
	unsigned short pos;        //��������ͬ���ݵ���ʼλ��

	CompressMoveInfo()
	{
		count = 0;
		pos = 0;
	}
};
#pragma pack(pop)

class CompressInfoCode
{
public:
	CompressInfoCode();
	~CompressInfoCode();

    CompressMoveInfo* infolist;

private:  
    int infolistCount;   //ѹ�������ݱ����list�ĸ��� 

	float * presrc;      //������һ֡����
	int presrcCount;

	float accuracy;      //ͬ��һ֡������������ľ���

public:
	//ѹ������                                             
	inline int Compress(float* src,  int srcCount, float* des, int& desCount)
	{
		CompressMoveInfo cominfo;

        int listCount = 0;
		int usedpos = 0;

		static unsigned long framecount = 0;
		//���·���ռ�
		if (srcCount>infolistCount)
		{
			delete[] infolist;
			infolist = NULL;

			infolist = new CompressMoveInfo[srcCount];
			infolistCount = srcCount;
		}


		if (framecount % 30 != 0)
		{
			//ѭ��ѹ��
			for (int i = 0; i < srcCount; i++)
			{
				//����һ֡������ͬ
				if (abs(presrc[i] - src[i]) < accuracy)
				{
					//��¼����
					if (0 == cominfo.count)
					{
						cominfo.pos = i;
					}
					//��Ŀ�Լ�
					cominfo.count++;
				}
				else
				{
					if (0 != cominfo.count)
					{
						infolist[listCount++] = cominfo;

						//���ݲ�ͬ���ṹ������
						cominfo.pos = 0;
						cominfo.count = 0;
					}

					//��ǰѹ��
					des[usedpos++] = src[i];
				}
			}
			// ֱ��ѭ����������һ�������ݣ�Ӧ����ѭ��������ͳ����Ϣ���棬����
			if (0 != cominfo.count)
			{
				infolist[listCount++] = cominfo;
				//���ݲ�ͬ���ṹ������
				cominfo.pos = 0;
				cominfo.count = 0;
			}
		}
		else
		{
			usedpos = srcCount;
			memcpy(des, src, srcCount*sizeof(float));
		}
		
		framecount++;

		//ѹ�����des���ȷ���
		desCount = usedpos;

		//���·���ռ�
		if (srcCount != presrcCount)
		{
			delete[] presrc;
			presrc = NULL;

			presrc = new float[srcCount];
			presrcCount = srcCount;
		}

		//����ǰһ֡����
		memcpy(presrc, src, srcCount*sizeof(float));

		//����λ����Ϣ�ĸ���
		return listCount;
	}

	//��ѹ����                              
	inline  float* Uncompress(CompressMoveInfo *srcpos, int infoCount, float* src, int srcCount, float* des, int &desCount)
	{
		int posIndex = 0;
		int srcIndex = 0;
		
		//��Ҫ��ѹ��srcpos
		for (int i = 0; i < infoCount; i++)
		{
			// ������һ֡��ͬ�Ŀ�����pos֮ǰ��
			if (posIndex < srcpos[i].pos)
			{
				while (posIndex < srcpos[i].pos)
				{
					des[posIndex++] = src[srcIndex++];
				}
			}
			// ������һ֡һ�������ݿ�����pos֮�󣬲��ҿ���count��
			if (posIndex == srcpos[i].pos)
			{
				while (srcpos[i].count > 0)
				{
					des[posIndex] = presrc[posIndex];
					posIndex++;
					srcpos[i].count--;
				}
			}
		}
		//���û��ѹ��������������򾭹�����Ľ�ѹ��srcIndex == srcCount
		while (srcIndex<srcCount)
		{
			des[posIndex++] = src[srcIndex++];
		}

		desCount = posIndex;

		//���·���ռ�
		if (posIndex != presrcCount)
		{
			delete[] presrc;
			 
			presrc = new float[desCount];
			presrcCount = desCount;
		}
		//������һ֡����
		memcpy(presrc, des, desCount*sizeof(float));

		return des;
	}
};

