function [] = skeleton(train_num,sub)
%train_num是高斯模糊的次数测试发现从100到500基本没有什么变化 
%sub是按梯度点亮图片时的最小梯度，这个参数影响比较大，可取17~1
%读图片的路径D:/chen/photo1.jpg写图片的路径D:/chen/show和D:/chen/show_xian
    
    original_g=imread('smoke2.png');%读取图片文件路径
    gray_g=rgb2gray(original_g);            %变成灰度图
    [x,y]=size(gray_g);
    G = fspecial('gaussian', [5 5], 16);%其中fspecial生成一个高斯滤波器，imfilter使用该滤波器处理图片
%     gray_gao_g = imfilter(gray_g,G,'same');
    gray_gao_g=gray_g;
    %高斯模糊
     for i=1:train_num
%         gray_gao_g = imfilter(gray_gao_g,G,'same');
        %gray_gao_g (gray_gao_g <20)=0;
         gray_gao_g=imguidedfilter(gray_gao_g);%导向滤波
     end
   
    %梯度计算
    [Fx,Fy]=gradient(double(gray_gao_g));
    Fx=abs(Fx);
    Fy=abs(Fy);
    show(x,y)=0;

    %按行点亮
    for i=1:x
        for j=1:y
            if Fx(i,j)>=sub
                show(i,j)=255;
            end
        end
    end
    %按列点亮
    for j=1:y
        for i=1:x
            if Fy(i,j)>=sub
                show(i,j)=255;
            end
        end
    end

    %figure(1);
    %imshow(show);

    %线性化步骤，根据图片show人工干预，此处选择按列找中间点
    sub_num=1;
    show_xian(x,y)=0;
%     for i=1:x
%         for j=1:y
%            if show(i,j)~=255
%                if num255>=sub_num
%                    % show_xian(i,j-1-floor(num255/2))=255;
%                end
%                num255=0;%连续的255中断
%                continue;
%            end
%            %现在的坐标下是一个255
%            num255=num255+1;
%         end
%     end

    num255=0;
    for j=1:y%列
        for i=1:x%行
           if show(i,j)~=255
               if num255>=sub_num
                   if (j-1-floor(num255/2))>0
                        show_xian(i,j-1-floor(num255/2))=255;
                   end
               end
               num255=0;%连续的255中断
               continue;
           end
           %现在的坐标下是一个255
           num255=num255+1;
        end
    end
   % figure(2);
   imshow(show_xian);
%写图片
%     imwrite(show,strcat(strcat(strcat(strcat('D:/chen/show/',num2str(train_num)),'-'),num2str(sub)),'.jpg'),'jpg');
%     imwrite(show_xian,strcat(strcat(strcat(strcat('D:/chen/show_xian/',num2str(train_num)),'-'),num2str(sub)),'.jpg'),'jpg');


end

