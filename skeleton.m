function [] = skeleton(train_num,sub)
%train_num�Ǹ�˹ģ���Ĵ������Է��ִ�100��500����û��ʲô�仯 
%sub�ǰ��ݶȵ���ͼƬʱ����С�ݶȣ��������Ӱ��Ƚϴ󣬿�ȡ17~1
%��ͼƬ��·��D:/chen/photo1.jpgдͼƬ��·��D:/chen/show��D:/chen/show_xian
    
    original_g=imread('smoke2.png');%��ȡͼƬ�ļ�·��
    gray_g=rgb2gray(original_g);            %��ɻҶ�ͼ
    [x,y]=size(gray_g);
    G = fspecial('gaussian', [5 5], 16);%����fspecial����һ����˹�˲�����imfilterʹ�ø��˲�������ͼƬ
%     gray_gao_g = imfilter(gray_g,G,'same');
    gray_gao_g=gray_g;
    %��˹ģ��
     for i=1:train_num
%         gray_gao_g = imfilter(gray_gao_g,G,'same');
        %gray_gao_g (gray_gao_g <20)=0;
         gray_gao_g=imguidedfilter(gray_gao_g);%�����˲�
     end
   
    %�ݶȼ���
    [Fx,Fy]=gradient(double(gray_gao_g));
    Fx=abs(Fx);
    Fy=abs(Fy);
    show(x,y)=0;

    %���е���
    for i=1:x
        for j=1:y
            if Fx(i,j)>=sub
                show(i,j)=255;
            end
        end
    end
    %���е���
    for j=1:y
        for i=1:x
            if Fy(i,j)>=sub
                show(i,j)=255;
            end
        end
    end

    %figure(1);
    %imshow(show);

    %���Ի����裬����ͼƬshow�˹���Ԥ���˴�ѡ�������м��
    sub_num=1;
    show_xian(x,y)=0;
%     for i=1:x
%         for j=1:y
%            if show(i,j)~=255
%                if num255>=sub_num
%                    % show_xian(i,j-1-floor(num255/2))=255;
%                end
%                num255=0;%������255�ж�
%                continue;
%            end
%            %���ڵ���������һ��255
%            num255=num255+1;
%         end
%     end

    num255=0;
    for j=1:y%��
        for i=1:x%��
           if show(i,j)~=255
               if num255>=sub_num
                   if (j-1-floor(num255/2))>0
                        show_xian(i,j-1-floor(num255/2))=255;
                   end
               end
               num255=0;%������255�ж�
               continue;
           end
           %���ڵ���������һ��255
           num255=num255+1;
        end
    end
   % figure(2);
   imshow(show_xian);
%дͼƬ
%     imwrite(show,strcat(strcat(strcat(strcat('D:/chen/show/',num2str(train_num)),'-'),num2str(sub)),'.jpg'),'jpg');
%     imwrite(show_xian,strcat(strcat(strcat(strcat('D:/chen/show_xian/',num2str(train_num)),'-'),num2str(sub)),'.jpg'),'jpg');


end

