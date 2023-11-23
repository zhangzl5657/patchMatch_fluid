function [BBS,FeaCorrMat] = computeNearsBBS(I,searchI,T,gamma, pz,locationY,locationX,Ix,Iy,Tx,Ty)
%------------
%��Ŀ���������ڵ�������Ѱ�����ƥ���
%BBS:�洢ÿ��λ�ã�colI��rowI����Ӧ�ļ����������ж��ٸ�������ƥ��
%FeaCorrMat:�洢ÿ��λ�ã�colI��rowI����Ӧ�ļ����������໥ƥ���������֮��Ķ�Ӧ��ϵ
%--------------
szI = size(I);
szT = size(T);

sezI = size(searchI); %���������С
% SSD = NaN(szI(1:2));
% LB_T2I  = NaN(szI(1:2));
% LB_I2T  = NaN(szI(1:2));
BBS = zeros(szI(1:2));

mi = mod(szI(1:2),pz);
mt = mod(szT(1:2),pz);

if(any(mi) | any(mt))
   fprintf('The image and template should be divided by the patch size');
   return;
end



%% generate near-neighbor areas of searching
% nearPN = 20; %�ڶ��������ڽ��в���
% leftTopX = max(1,locationX - pz*nearPN);
% leftTopY = max(1,locationY - pz*nearPN);
% rightBottomX = min(locationX+szT(2)-1+pz*nearPN,szI(2));
% rightBottomY = min(locationY+szT(1)-1+pz*nearPN,szI(1));
% searchI = I(leftTopY:rightBottomY,leftTopX:rightBottomX,:);
% 
% % ����searchI�Ĵ�С��ʹ���ܱ�pz����
% szSI = size(searchI);
% mi = mod(szSI(1:2),pz);
% if(any(mi))
%     searchI = searchI(1:end-mi(1),1:end-mi(2),:); 
%     rightBottomX = rightBottomX - min(2);
%     rightBottomY = rightBottomY - min(1);
%     szSI = size(searchI);
% end
% 
% % ������������������ͼ���е�λ�ã���patch��Ϊ���꣬��������������Ͻ�����ͼ��ĵڼ���patch��
% patchLocationX = floor(leftTopX/pz); %patchLocationX Ϊ���Ͻ����ڵ�X�����ϵ�patch����
% patchLocationY = floor(leftTopY/pz); %patchLocationY Ϊ���Ͻ����ڵ�Y�����ϵ�patch����
%% ����RGB��������
[h,w,d] = size(T);
for c=1:d
    TMat(:,:,c) = im2col(T(:,:,c), [pz,pz], 'distinct');
    IMat(:,:,c) = im2col(searchI(:,:,c), [pz,pz], 'distinct');
end
N = size(TMat,2);

FeaCorrMat=zeros(szI(1),szI(2),N*N);

%% ����HOG��������
hogT = getHOGForRegion(Tx,Ty,pz);
hogI = getHOGForRegion(Ix,Iy,pz);
[hogH,hogW,hogD] = size(hogT);
for h_c = 1: hogD
    temHogT = hogT(:,:,h_c);
    hogTMat(:,:,h_c) = temHogT(:)';
    
    temHogI = hogI(:,:,h_c);
    hogIMat(:,:,h_c) = temHogI(:)';
end

% for col=1:N
%    for c=1:szT(3)
%        Tcenter=TMat(round(pz*pz/2),col,c);
%        Icenter=IMat(round(pz*pz/2),col,c);
%        TMat(:,col,c)=TMat(:,col,c)-TMat(round(pz*pz/2),col,c);
%        IMat(:,col,c)=IMat(:,col,c)-IMat(round(pz*pz/2),col,c);
%        TMat(round(pz*pz/2),col,c)=Tcenter;
%        IMat(round(pz*pz/2),col,c)=Icenter;
%    end
% end


%�����˲���
f = fspecial('gaussian', [pz pz], 0.6);
FMat = repmat(f(:), [1 N 3]);

% ind = im2col(reshape([1:szI(1)*szI(2)], [szI(1),szI(2)]), [pz pz], 'distinct');
% INDX = ind(floor(end/2)+1,:)';
INDX = 1:size(IMat,2);
IndMat = reshape(INDX, [sezI(1:2)/pz]);

% pre compute spatial distance component
Dxy = zeros(N);
[xx,yy] = meshgrid([0:pz:szT(2)-1]*0.0039,[0:pz:szT(1)-1]*0.0039);
X = xx(:);
Y = yy(:);
for ii = 1:length(X)
    Dxy(:,ii) = (X-X(ii)).^2+(Y-Y(ii)).^2;
end


%% RGB ��������洢����
Drgb = zeros(N);

Drgb_buffer = zeros(size(Drgb,1),size(Drgb,2),szI(1)-szT(1));

%% HOG��������洢����
DHog = zeros(N);
DHog_buffer = zeros(size(DHog,1),size(DHog,2),szI(1)-szT(1));

% loop over image pixels����patch���л���
for colI = 1:sezI(2)/pz-szT(2)/pz+1
    for rowI = 1:sezI(1)/pz-szT(1)/pz+1
        
        if (rowI==1 && colI==1) % compute full distance matrix for first image patch
           ind = IndMat(rowI:rowI+szT(1)/pz-1, rowI:rowI+szT(2)/pz-1);
           
            PMat = IMat(:,ind(:),:); %RGB����
            HogMat = hogIMat(:,ind(:),:);
            % compute distance matrix
            for idxP = 1:N  
                Temp = (bsxfun(@minus, PMat(:,idxP,:), TMat).*FMat).^2;
                Drgb(:,idxP) =  sum(sum(Temp,3));
                
                hogTemp = (bsxfun(@minus, HogMat(:,idxP,:), hogTMat)).^2;
                DHog(:,idxP) = sum(sum(hogTemp,3));
            end
            
                        
        elseif (rowI>1 && colI==1) % along first image col we have a new patch row with each step
            % use data computed for previous candidates
            % Push the computed values one row up (pixel (2,1)-->(1,1))
            Drgb(:,1:end-1) = Drgb(:,2:end);
            DHog(:,1:end-1) = DHog(:,2:end);
            % compute missing data -- new row
            ind = IndMat(rowI+szT(1)/pz-1,colI:colI+szT(2)/pz-1);
            R = IMat(:,ind,:); % new row
            HogR = hogIMat(:,ind,:);
            idxP = szT(1)/pz;
            % loop over candidate
            for colP = 1:szT(2)/pz
                Temp = (bsxfun(@minus, R(:,colP,:), TMat).*FMat).^2;
                Drgb(:,idxP) =  sum(sum(Temp,3));
                
                hogTemp = (bsxfun(@minus, HogR(:,colP,:), hogTMat)).^2;
                DHog(:,idxP) = sum(sum(hogTemp,3));
                
                idxP = idxP+szT(1)/pz; % jumps of szT(1) due to indexing
            end
            
        elseif (rowI==1 && colI>1) % starting a new image col compute full new patch col
            % use data computed for previous candidates
            Drgb_prev = Drgb_buffer(:,:,1);
            
            DHog_prev = DHog_buffer(:,:,1);
            % push the computed values: szT(1)+1 is the pixel (1,colI)
            Drgb(:,1:end-szT(1)/pz) = Drgb_prev(:,szT(1)/pz+1:end);
            DHog(:,1:end-szT(1)/pz) = DHog_prev(:,szT(1)/pz+1:end);
            % compute missing data - new col
            ind = IndMat(rowI:rowI+szT(1)/pz-1,colI+szT(2)/pz-1,:); % new col
            C = IMat(:,ind,:);
            HogC = hogIMat(:,ind,:);
            
            idxP = szT(1)/pz*(szT(2)/pz-1)+1;
            % loop over candidate
            for rowP = 1:szT(1)/pz
                Temp = (bsxfun(@minus, C(:,rowP,:), TMat).*FMat).^2;
                Drgb(:,idxP) = sum(sum(Temp,3));
                
                hogTemp = (bsxfun(@minus, HogC(:,rowP,:), hogTMat)).^2;
                DHog(:,idxP) = sum(sum(hogTemp,3));
                
                idxP = idxP+1;
            end
        else % only 1 new pixel
            % use data computed for previous candidates
            % Drgb holds the computation of the patch above
            Drgb(:,1:end-1) = Drgb(:,2:end); % push the values of the patch above one row up
            DHog(:,1:end-1) = DHog(:,2:end);
            
            Drgb_prev = Drgb_buffer(:,:,rowI); % take the patch to the left
            DHog_prev = DHog_buffer(:,:,rowI);
            
            Drgb(:,szT(1)/pz:szT(1)/pz:end-szT(1)/pz) = Drgb_prev(:,2*szT(1)/pz:szT(1)/pz:end); %update the last row
            DHog(:,szT(1)/pz:szT(1)/pz:end-szT(1)/pz) = DHog_prev(:,2*szT(1)/pz:szT(1)/pz:end);
            
            ind = IndMat(rowI+szT(1)/pz-1,colI+szT(2)/pz-1,:); %new pixel
            p = IMat(:,ind,:);
            HogP = hogIMat(:,ind,:);
            
            Temp = (bsxfun(@minus, p, TMat).*FMat).^2;
            Drgb(:,end) = sum(sum(Temp,3));
            
            hogTemp = (bsxfun(@minus, HogP, hogTMat)).^2;
            DHog(:,end) = sum(sum(hogTemp,3));
        end
        
        % update buffer
        Drgb_buffer(:,:,rowI) = Drgb;
        DHog_buffer(:,:,rowI) = DHog;
        
        % compute final distance matrix
        wRgb = 0.5;
        wHog = 1;
        %% ֻ����λ�þ������ɫ����
%         D = gamma*Dxy + Drgb; %D��ÿ�ж�ӦĿ���T��һ������patch��ÿ�ж�Ӧ���������һ��patch
       %% ����λ�þ��롢��ɫ�����HOG����
        D = gamma*Dxy + wRgb*Drgb + wHog*DHog;
        
        D(D < 1e-4) = 0;
        % compute SSD
        %SSD(rowI,colI) = trace(D);
        
        % compute lower bounds
        [minVal1, idx1] = min(D,[],2) ;
        [minVal2, idx2] = min(D) ;
        
        ii1 = my_sub2ind([N,N], 1:N, idx1');
        ii2 = my_sub2ind([N,N], idx2, 1:N);
        IDX_MAT1 = zeros(N,N);
        IDX_MAT2 = Inf(N,N);
        IDX_MAT1(ii1) = 1;
        IDX_MAT2(ii2) = 1;
        Temp = IDX_MAT2 ==IDX_MAT1;
       
        %������ת��������ͼ��
        patchY = rowI + locationY - 1;
        patchX = colI + locationX - 1;
        %�洢�ж��ٸ�������ƥ��
        BBS(patchY,patchX) = sum(Temp(:));
        %�洢������֮��Ķ�Ӧ��ϵ
        %c=IDX_MAT1 & IDX_MAT2;
        FeaCorrMat(patchY,patchX,:) = Temp(:);
              
        %[minVal1,~] = min(D,[],2);
        %LB_I2T(rowI,colI) = sum(minVal2);
        
    end % for rowI
end % for colI

BBS = BBS/N;


