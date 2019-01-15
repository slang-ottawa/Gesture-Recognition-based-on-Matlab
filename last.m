clear all; clc
vid = videoinput('winvideo', 1, 'MJPG_1280x720');%创建ID为1的摄像头的视频对象，视频格式是 YUY2_320x240，这表示视频的分辨率为320x240。
set(vid,'ReturnedColorSpace','rgb');
vidRes=get(vid,'VideoResolution');
width=vidRes(1);
height=vidRes(2);
nBands=get(vid,'NumberOfBands');
figure('Name', 'Matlab调用摄像头', 'NumberTitle', 'Off', 'ToolBar', 'None', 'MenuBar', 'None');
hImage=image(zeros(vidRes(2),vidRes(1),nBands));
preview(vid,hImage);    %打开视频预览窗
filename = 'film';       %保存视频的名字
nframe = 25;            %视频的帧数
nrate = 5;              %每秒的帧数
preview(vid);            
set(1,'visible','off');
 
writerObj = VideoWriter( [filename '.avi'] );
writerObj.FrameRate = nrate;  
open(writerObj);
 
figure;                   %将视频转换成每帧的图片
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
       strtemp=strcat('D:\acc\ok',int2str(i),'.','jpg');%将每祯转成jpg的图片
       imwrite(mov(i).cdata,strtemp,'jpg');
    end
 clc;
clear;
i=imread('D:\\acc\\ok10.jpg');
j=imread('D:\acc\ok25.jpg');    

%将两张照片灰度化后，使用背景差法去除多余背景，提取出手势部分
%然后使用canny边缘检测勾画出手势外轮廓，并用白色将手势轮廓内部填充

i1=rgb2gray(i); %对图片的grb处理
j1=rgb2gray(j);%灰度化 
K1=medfilt2(i1,[10 10]);          %中值滤波 (搞清楚)
K2=medfilt2(j1,[10 10]);          %10*10的像素邻域中值数
s=imsubtract(K2,K1);              %背景差
figure;
imshow(s);
thresh = graythresh(s);     %自动确定二值化阈值；
I2 = im2bw(s,thresh);       %对图像自动二值化即可     
cannyBW=edge(I2,'canny');
figure;
imshow(cannyBW);
title('Canny Edge');
f=s;
bw1=im2bw(f,graythresh(f)); %im2bw是将灰度图像转化成二值图像
bw2=bwmorph(bw1,'remove');  %删除内部像素，留下边缘
bw3=imfill(bw2,'holes');    %填充内部空洞
I=bw3;
if length(size(I))>2        
    I = rgb2gray(I);
end
if ~islogical(I)
    imBw = im2bw(I);                        %转换为二值化图像
else
    imBw = I;
end
imBw = im2bw(I);                        %转换为二值化图像
imLabel = bwlabel(imBw);                %对各连通域进行标记
stats = regionprops(imLabel,'Area');    %求各连通域的大小
area = cat(1,stats.Area);
index = find(area == max(area));        %求最大连通域的索引
img = ismember(imLabel,index);    
imshow(img);     
A=img;    
[l,c] = size(A);
figure;
imshow(I)
figure;
imshow(img)
b= zeros(l,1); %用于存储每行特征点的个数
for k1=1:l
  for k2 = 1:c-1 %因为是前后比较，故循环到倒数第二位则停止
      if A(k1,k2) ~= A(k1,k2+1) %即每行从第一个开始前后两数做比较，如果不相等则计数器加1
        b(k1) = b(k1)+1;   %b为计数器
      end
  end
end
b
c
x=b;
y = unique(x);
for i = 1:length(y)
a(i) = sum(x == y(i));%找到每一个变化的地方  Y(1)是不变的地方  Y(2)是变得地方
end
%% 结果输出打印
disp('>>向量中的元素如下：');
y
disp('>>元素个数分别为：');
a(a<15)=0;
a
y(find(a==0)) =0;
y(y>10)=0;
T=max(y);
t=T/2;
if t>2
    disp('布');
end
if t==2
        disp('剪刀');
end
if t<2
        disp('石头');
end
N=1;           %需要抽取的图片的数量  
num=3;       %图片的总数量  
p=randperm(num);%随机生成1~num个随机整数  
a=p(1:N);         %取p的前N个数  
for i=1:N  
    %读取图片的路径和名字，你需要修改为你图片库的路径，注意用双斜线  
  imageName=sprintf('D:\\Hand\\%d.jpg',a(i));   
  %fprintf('%s\n',imageName);  
  f=imread(imageName); 
  imshow(f) %读取图片  
end  

if t<2
    if a==1    %顺序为石头布剪刀
    disp('平局');

    end
    if a==2
            disp('你输了');
            g=imread('C:\Users\slang\Desktop\lose.jpg');
            imshow(g,[ ])
    end
    if a==3
                disp('你赢了');
                f=imread('C:\Users\slang\Desktop\win1.jpg');
                imshow(f,[ ])
    end
end
       
if t==2
     if a==1
    disp('你输了');
    g=imread('C:\Users\slang\Desktop\lose.jpg');
    imshow(g,[ ])
     end
     if a==2
            disp('你赢了');
             f=imread('C:\Users\slang\Desktop\win1.jpg');
             imshow(f,[ ])
     end
     if a==3
                disp('平局');
     end
end

if t>2
     if a==1
    disp('你赢了');
     f=imread('C:\Users\slang\Desktop\win1.jpg');
     imshow(f,[ ])
     end
     if a==2
            disp('平局');
     end
     if a==3
                disp('你输了');
                g=imread('C:\Users\slang\Desktop\lose.jpg');
                imshow(g,[ ])
     end
end
