clear all; clc
vid = videoinput('winvideo', 1, 'MJPG_1280x720');%����IDΪ1������ͷ����Ƶ������Ƶ��ʽ�� YUY2_320x240�����ʾ��Ƶ�ķֱ���Ϊ320x240��
set(vid,'ReturnedColorSpace','rgb');
vidRes=get(vid,'VideoResolution');
width=vidRes(1);
height=vidRes(2);
nBands=get(vid,'NumberOfBands');
figure('Name', 'Matlab��������ͷ', 'NumberTitle', 'Off', 'ToolBar', 'None', 'MenuBar', 'None');
hImage=image(zeros(vidRes(2),vidRes(1),nBands));
preview(vid,hImage);    %����ƵԤ����
filename = 'film';       %������Ƶ������
nframe = 25;            %��Ƶ��֡��
nrate = 5;              %ÿ���֡��
preview(vid);            
set(1,'visible','off');
 
writerObj = VideoWriter( [filename '.avi'] );
writerObj.FrameRate = nrate;  
open(writerObj);
 
figure;                   %����Ƶת����ÿ֡��ͼƬ
for ii = 1: nframe
    frame = getsnapshot(vid);
    imshow(frame);
    f.cdata = frame;
    f.colormap = colormap([]) ;
    writeVideo(writerObj,f);
end
close(writerObj);
closepreview

clear all;clc
readerobj = VideoReader('C:\Users\slang\Desktop\film.avi', 'tag', 'myreader1');
    vidFrames = read(readerobj);
    numFrames = get(readerobj, 'numberOfFrames');
    for i=1:numFrames
       mov(i).cdata = vidFrames(:,:,:,i);
       strtemp=strcat('D:\acc\ok',int2str(i),'.','jpg');%��ÿ��ת��jpg��ͼƬ
       imwrite(mov(i).cdata,strtemp,'jpg');
    end
 clc;
clear;
i=imread('D:\\acc\\ok10.jpg');
j=imread('D:\acc\ok25.jpg');    

%��������Ƭ�ҶȻ���ʹ�ñ����ȥ�����౳������ȡ�����Ʋ���
%Ȼ��ʹ��canny��Ե��⹴�������������������ð�ɫ�����������ڲ����

i1=rgb2gray(i); %��ͼƬ��grb����
j1=rgb2gray(j);%�ҶȻ� 
K1=medfilt2(i1,[10 10]);          %��ֵ�˲� (�����)
K2=medfilt2(j1,[10 10]);          %10*10������������ֵ��
s=imsubtract(K2,K1);              %������
figure;
imshow(s);
thresh = graythresh(s);     %�Զ�ȷ����ֵ����ֵ��
I2 = im2bw(s,thresh);       %��ͼ���Զ���ֵ������     
cannyBW=edge(I2,'canny');
figure;
imshow(cannyBW);
title('Canny Edge');
f=s;
bw1=im2bw(f,graythresh(f)); %im2bw�ǽ��Ҷ�ͼ��ת���ɶ�ֵͼ��
bw2=bwmorph(bw1,'remove');  %ɾ���ڲ����أ����±�Ե
bw3=imfill(bw2,'holes');    %����ڲ��ն�
I=bw3;
if length(size(I))>2        
    I = rgb2gray(I);
end
if ~islogical(I)
    imBw = im2bw(I);                        %ת��Ϊ��ֵ��ͼ��
else
    imBw = I;
end
imBw = im2bw(I);                        %ת��Ϊ��ֵ��ͼ��
imLabel = bwlabel(imBw);                %�Ը���ͨ����б��
stats = regionprops(imLabel,'Area');    %�����ͨ��Ĵ�С
area = cat(1,stats.Area);
index = find(area == max(area));        %�������ͨ�������
img = ismember(imLabel,index);    
imshow(img);     
A=img;    
[l,c] = size(A);
figure;
imshow(I)
figure;
imshow(img)
b= zeros(l,1); %���ڴ洢ÿ��������ĸ���
for k1=1:l
  for k2 = 1:c-1 %��Ϊ��ǰ��Ƚϣ���ѭ���������ڶ�λ��ֹͣ
      if A(k1,k2) ~= A(k1,k2+1) %��ÿ�дӵ�һ����ʼǰ���������Ƚϣ������������������1
        b(k1) = b(k1)+1;   %bΪ������
      end
  end
end
b
c
x=b;
y = unique(x);
for i = 1:length(y)
a(i) = sum(x == y(i));%�ҵ�ÿһ���仯�ĵط�  Y(1)�ǲ���ĵط�  Y(2)�Ǳ�õط�
end
%% ��������ӡ
disp('>>�����е�Ԫ�����£�');
y
disp('>>Ԫ�ظ����ֱ�Ϊ��');
a(a<15)=0;
a
y(find(a==0)) =0;
y(y>10)=0;
T=max(y);
t=T/2;
if t>2
    disp('��');
end
if t==2
        disp('����');
end
if t<2
        disp('ʯͷ');
end
N=1;           %��Ҫ��ȡ��ͼƬ������  
num=3;       %ͼƬ��������  
p=randperm(num);%�������1~num���������  
a=p(1:N);         %ȡp��ǰN����  
for i=1:N  
    %��ȡͼƬ��·�������֣�����Ҫ�޸�Ϊ��ͼƬ���·����ע����˫б��  
  imageName=sprintf('D:\\Hand\\%d.jpg',a(i));   
  %fprintf('%s\n',imageName);  
  f=imread(imageName); 
  imshow(f) %��ȡͼƬ  
end  

if t<2
    if a==1    %˳��Ϊʯͷ������
    disp('ƽ��');

    end
    if a==2
            disp('������');
            g=imread('C:\Users\slang\Desktop\lose.jpg');
            imshow(g,[ ])
    end
    if a==3
                disp('��Ӯ��');
                f=imread('C:\Users\slang\Desktop\win1.jpg');
                imshow(f,[ ])
    end
end
       
if t==2
     if a==1
    disp('������');
    g=imread('C:\Users\slang\Desktop\lose.jpg');
    imshow(g,[ ])
     end
     if a==2
            disp('��Ӯ��');
             f=imread('C:\Users\slang\Desktop\win1.jpg');
             imshow(f,[ ])
     end
     if a==3
                disp('ƽ��');
     end
end

if t>2
     if a==1
    disp('��Ӯ��');
     f=imread('C:\Users\slang\Desktop\win1.jpg');
     imshow(f,[ ])
     end
     if a==2
            disp('ƽ��');
     end
     if a==3
                disp('������');
                g=imread('C:\Users\slang\Desktop\lose.jpg');
                imshow(g,[ ])
     end
end
