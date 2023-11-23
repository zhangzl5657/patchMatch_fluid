% Originally was [SSD,LB_T2I, LB_I2T,BB ] = compute_EMD_lower_bound_full_reuse_fast_tali4(I,T,gamma, pz)
function [BBS,FeaCorrMat] = computeBBS(I,T,gamma, pz)
%------------
%BBS:存储每个位置（colI，rowI）对应的检索区域内有多少个特征点匹配
%FeaCorrMat:存储每个位置（colI，rowI）对应的检索区域内相互匹配的特征点之间的对应关系
%--------------
szI = size(I);
szT = size(T);

% SSD = NaN(szI(1:2));
% LB_T2I  = NaN(szI(1:2));
% LB_I2T  = NaN(szI(1:2));
BBS = zeros(szI(1:2));

%% 判断图像和模板大小是否能被pz整除
mi = mod(szI(1:2),pz);
mt = mod(szT(1:2),pz);

if(any(mi) | any(mt))
   fprintf('The image and template should be divided by the patch size');
   return;
end

%构造特征矩阵
for c=1:szT(3)
    TMat(:,:,c) = im2col(T(:,:,c), [pz,pz], 'distinct');
    IMat(:,:,c) = im2col(I(:,:,c), [pz,pz], 'distinct');
end

N = size(TMat,2);

FeaCorrMat=zeros(szI(1),szI(2),N*N);

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


%构造滤波核
f = fspecial('gaussian', [pz pz], 0.6);
FMat = repmat(f(:), [1 N 3]);

% ind = im2col(reshape([1:szI(1)*szI(2)], [szI(1),szI(2)]), [pz pz], 'distinct');
% INDX = ind(floor(end/2)+1,:)';
INDX = 1:size(IMat,2);
IndMat = reshape(INDX, [szI(1:2)/pz]);

% pre compute spatial distance component
Dxy = zeros(N);
[xx,yy] = meshgrid([0:pz:szT(2)-1]*0.0039,[0:pz:szT(1)-1]*0.0039);
X = xx(:);
Y = yy(:);
for ii = 1:length(X)
    Dxy(:,ii) = (X-X(ii)).^2+(Y-Y(ii)).^2;
end



Drgb = zeros(N);

Drgb_buffer = zeros(size(Drgb,1),size(Drgb,2),szI(1)-szT(1));

% loop over image pixels
for colI = 1:szI(2)/pz-szT(2)/pz+1
    for rowI = 1:szI(1)/pz-szT(1)/pz+1
        
        if (rowI==1 && colI==1) % compute full distance matrix for first image patch
           ind = IndMat(rowI:rowI+szT(1)/pz-1, rowI:rowI+szT(2)/pz-1);
           
            PMat = IMat(:,ind(:),:);
            % compute distance matrix
            for idxP = 1:N  
                Temp = (bsxfun(@minus, PMat(:,idxP,:), TMat).*FMat).^2;
                Drgb(:,idxP) =  sum(sum(Temp,3));
            end
            
                        
        elseif (rowI>1 && colI==1) % along first image col we have a new patch row with each step
            % use data computed for previous candidates
            % Push the computed values one row up (pixel (2,1)-->(1,1))
            Drgb(:,1:end-1) = Drgb(:,2:end);
            % compute missing data -- new row
            ind = IndMat(rowI+szT(1)/pz-1,colI:colI+szT(2)/pz-1);
            R = IMat(:,ind,:); % new row
            idxP = szT(1)/pz;
            % loop over candidate
            for colP = 1:szT(2)/pz
                Temp = (bsxfun(@minus, R(:,colP,:), TMat).*FMat).^2;
                Drgb(:,idxP) =  sum(sum(Temp,3));
                idxP = idxP+szT(1)/pz; % jumps of szT(1) due to indexing
            end
            
        elseif (rowI==1 && colI>1) % starting a new image col compute full new patch col
            % use data computed for previous candidates
            Drgb_prev = Drgb_buffer(:,:,1);
            % push the computed values: szT(1)+1 is the pixel (1,colI)
            Drgb(:,1:end-szT(1)/pz) = Drgb_prev(:,szT(1)/pz+1:end);
            % compute missing data - new col
            ind = IndMat(rowI:rowI+szT(1)/pz-1,colI+szT(2)/pz-1,:); % new col
            C = IMat(:,ind,:);
            idxP = szT(1)/pz*(szT(2)/pz-1)+1;
            % loop over candidate
            for rowP = 1:szT(1)/pz
                Temp = (bsxfun(@minus, C(:,rowP,:), TMat).*FMat).^2;
                Drgb(:,idxP) = sum(sum(Temp,3));
                idxP = idxP+1;
            end
        else % only 1 new pixel
            % use data computed for previous candidates
            % Drgb holds the computation of the patch above
            Drgb(:,1:end-1) = Drgb(:,2:end); % push the values of the patch above one row up
            Drgb_prev = Drgb_buffer(:,:,rowI); % take the patch to the left
            Drgb(:,szT(1)/pz:szT(1)/pz:end-szT(1)/pz) = Drgb_prev(:,2*szT(1)/pz:szT(1)/pz:end); %update the last row
            ind = IndMat(rowI+szT(1)/pz-1,colI+szT(2)/pz-1,:); %new pixel
            p = IMat(:,ind,:);
            Temp = (bsxfun(@minus, p, TMat).*FMat).^2;
            Drgb(:,end) = sum(sum(Temp,3));
        end
        
        % update buffer
        Drgb_buffer(:,:,rowI) = Drgb;
        
        % compute final distance metrix
        D = gamma*Dxy + Drgb;
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
       
        %存储有多少个特征的匹配
        BBS(rowI,colI) = sum(Temp(:));
        %存储特征点之间的对应关系
        c=IDX_MAT1 & IDX_MAT2;
        FeaCorrMat(rowI,colI,:)=c(:);
              
        %[minVal1,~] = min(D,[],2);
        %LB_I2T(rowI,colI) = sum(minVal2);
        
    end % for rowI
end % for colI

BBS = BBS/N;
