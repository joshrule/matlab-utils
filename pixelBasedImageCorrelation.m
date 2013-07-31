function [totalCosts,pairStats,ssdStats] = pixelBasedImageCorrelation(img1,img2,maxSize)
% [totalCosts,pairStats,ssdStats] = pixelBasedImageCorrelation(img1,img2,maxSize)
%
% a function scavenged from provided code to calculate the correlation  between
% two images based on their raw pixel values.
%
% img1, img2: strings, the filenames of the images to compare
% maxSize: scalar, max edge length to permit when reading the images
%
% totalCosts: scalar, the correlation score
% pairStats: unknown
% ssdStats: unknown
    pairStats = calcPairStats(img1,img2,maxSize);
    ssdStats = getSSDJosh(img1,img2,maxSize);
    % totalCosts = 1.6(ssd_local)+sc_cost+0.3(E) 
    totalCosts = 1.6*ssdStats(:)+pairStats(:,1)+0.3*pairStats(:,2);
end

function pairStats = calcPairStats(img1,img2,maxSize)
    [temp1x, temp1y] = bdry_extract_S(grayImage(uint8(resizeImage(double(imread(img1)),maxSize))));
    [temp2x, temp2y] = bdry_extract_S(grayImage(uint8(resizeImage(double(imread(img2)),maxSize))));
    X = [temp1x temp1y];
    Y = [temp2x temp2y];
    clear temp1* temp2*;

    % hacked arguments!
    mean_dist_global=[]; % use [] to estimate scale from the data
    nbins_theta=12;
    nbins_r=5;
    nsamp1=size(X,1);
    nsamp2=size(Y,1);
    ndum1=0;
    ndum2=0;
    if nsamp2>nsamp1 % as is the case in the outlier test
        ndum1=ndum1+(nsamp2-nsamp1);
    end
    eps_dum=0.15;
    r_inner=1/8;
    r_outer=2;
    n_iter=6;
    r=1; % annealing rate
    beta_init=1;  % initial regularization parameter (normalized)

    % initialize transformed version of model pointset
    Xk=X; 
    % initialize counters
    k=1;
    s=1;
    % out_vec_{1,2} track estimated outliers on each iteration
    out_vec_1=zeros(1,nsamp1); 
    out_vec_2=zeros(1,nsamp2);
    while s
       % compute shape contexts for (transformed) model
       [BH1,mean_dist_1]=sc_compute(Xk',zeros(1,nsamp1),mean_dist_global,nbins_theta,nbins_r,r_inner,r_outer,out_vec_1);

       % compute shape contexts for target, using the scale estimate from
       % the warped model
       % Note: this is necessary only because out_vec_2 can change on each
       % iteration, which affects the shape contexts.  Otherwise, Y does
       % not change.
       [BH2,mean_dist_2]=sc_compute(Y',zeros(1,nsamp2),mean_dist_1,nbins_theta,nbins_r,r_inner,r_outer,out_vec_2);

       % compute regularization parameter
       beta_k=(mean_dist_1^2)*beta_init*r^(k-1);

       % compute pairwise cost between all shape contexts
       costmat=hist_cost_2(BH1,BH2);
       % pad the cost matrix with costs for dummies
       nptsd=nsamp1+ndum1;
       costmat2=eps_dum*ones(nptsd,nptsd);
       costmat2(1:nsamp1,1:nsamp2)=costmat;
       cvec=hungarian(costmat2);

       % update outlier indicator vectors
       [a,cvec2]=sort(cvec);
       out_vec_1=cvec2(1:nsamp1)>nsamp2;
       out_vec_2=cvec(1:nsamp2)>nsamp1;

       % format versions of Xk and Y that can be plotted with outliers'
       % correspondences missing
       X2=NaN*ones(nptsd,2);
       X2(1:nsamp1,:)=Xk;
       X2=X2(cvec,:);
       X2b=NaN*ones(nptsd,2);
       X2b(1:nsamp1,:)=X;
       X2b=X2b(cvec,:);
       Y2=NaN*ones(nptsd,2);
       Y2(1:nsamp2,:)=Y;

       % extract coordinates of non-dummy correspondences and use them
       % to estimate transformation
       ind_good=find(~isnan(X2b(1:nsamp1,1)));
       n_good=length(ind_good);
       X3b=X2b(ind_good,:);
       Y3=Y2(ind_good,:);

       % estimate regularized TPS transformation
       [cx,cy,E]=bookstein(X3b,Y3,beta_k);

       % calculate affine cost
       A=[cx(n_good+2:n_good+3,:) cy(n_good+2:n_good+3,:)];
       s=svd(A);
       aff_cost=log(s(1)/s(2));
       
       % calculate shape context cost
       [a1,b1]=min(costmat,[],1);
       [a2,b2]=min(costmat,[],2);
       sc_cost=max(mean(a1),mean(a2));
       
       % warp each coordinate
       fx_aff=cx(n_good+1:n_good+3)'*[ones(1,nsamp1); X'];
       d2=max(dist2(X3b,X),0);
       U=d2.*log(d2+eps);
       fx_wrp=cx(1:n_good)'*U;
       fx=fx_aff+fx_wrp;

       fy_aff=cy(n_good+1:n_good+3)'*[ones(1,nsamp1); X'];
       fy_wrp=cy(1:n_good)'*U;
       fy=fy_aff+fy_wrp;

       % update Xk for the next iteration
       Z=[fx; fy]';
       Xk=Z;
       
       % stop early if shape context score is sufficiently low
       if k==n_iter
          s=0;
       else
          k=k+1;
       end
    end
    pairStats = [sc_cost E];
end
