%FusionData = fopen('d:\pos.txt');
close all;
[time, inerX, inerY, inerZ, optiX, optiZ, optiY] = textread('pos.txt',...
    '%s %f %f %f %f %f %f');

a =50;b = length(inerX)-50;
optical=[optiX,optiY,optiZ];
inertia=[inerX,inerY,inerZ];
%fclose(FusionData);
%������ԭʼͼ
figure
axis equal
plot(optical(a:1:b,1),optical(a:1:b,2),'-b',optical(a,1),optical(a,2),'ob',optical(b,1),optical(b,2),'*b');
hold on
plot(inertia(a:1:b,1),inertia(a:1:b,2),'-r',inertia(a,1),inertia(a,2),'or',inertia(b,1),inertia(b,2),'*r');
hold off
title('origin x-y')
grid on
axis([-5,5,-5,5])

%���߶�
figure
plot(optical(a:1:b,3),'-b')%optical(a,3),'ob',optical(b,3),'*b');
hold on
plot(inertia(a:1:b,3),'-r')%inertia(a,3),'or',inertia(b,3),'*r');
hold off
title('origin z')

%�����Ե�����ƽ�ƣ��д���ȶ��,ǿ�а���ʼ����������ԭ��
Translate1=inertia(a,:)
for i=1:1:max(size(inertia))
    inertia(i,:)=inertia(i,:)-Translate1;
end

%����ѧ������ƽ��
Translate=inertia(a,:)-optical(a,:)
for i=1:1:max(size(optical))
    optical(i,:)=optical(i,:)+Translate;
end
%��ƽ��ת�����ͼ��
figure
plot3(optical(a:b,1),optical(a:b,2),optical(a:b,3),'-b',optical(a,1),optical(a,2),optical(a,3),'ob',optical(b,1),optical(b,2),optical(b,3),'*b');
hold on
plot3(inertia(a:b,1),inertia(a:b,2),inertia(a:b,3),'-r',inertia(a,1),inertia(a,2),inertia(a,3),'or',inertia(b,1),inertia(b,2),inertia(b,3),'*r');
hold off 
axis equal
title('Translate x-y-z')
axis([-5,5,-5,5 -5 5])
grid on

%�������ƽ�������µ�ת������ת�����⣬ȡ����¶׵���5s����
%ȡǰ120��������У��
for i=1:1:120
    datai(i,:)=inertia(a+(i-1),:);
end
for i=1:1:120
    datao(i,:)=optical(a+(i-1),:);
end
%����õ���Ҫ�Ż���ԭʼ����������Wahba problem��SVD�ⷨ
B=zeros(2,2);
for i =1:1:120
    B=B+datai(i,1:2)'*datao(i,1:2);
end
[U,S,V] = svd (B);
M=[1,0;0,det(U)*det(V)];
R=U*M*V'
%�õ���ת����R�������optical�����ж�����R���任
for i=1:1:max(size(optical))
    opticalnew(i,1:2)=(R*(optical(i,1:2)'))';
    opticalnew(i,3)=optical(i,3);
end
%��֤
figure
axis equal
plot(opticalnew(a:1:b,1),opticalnew(a:1:b,2),'-b',opticalnew(a,1),opticalnew(a,2),'ob',opticalnew(b,1),opticalnew(b,2),'*b');
hold on
plot(inertia(a:1:b,1),inertia(a:b,2),'-r',inertia(a,1),inertia(a,2),'or',inertia(b,1),inertia(b,2),'*r');
hold off
title('sample x-y')
grid on
axis([-5,5,-5,5])
