clc;
clear all;
%%
redDimValue = 20; %Specify the reduced dimension you need ranging from(1-286) 
%%
%creating train vector
data_sz=1342; %size of the train data
vect_len = 64*64; % dimension of the image
loc='E:\VigneshP\modules\PR\part II\proj2\train\'; %change according to your working folder where the train folder is present
namePair = 'E:\VigneshP\modules\PR\part II\proj2\train\*.bmp'; %change according to your working folder where the train folder is present(along with *.bmp)
flnames = dir(namePair);
descVec=zeros(64,64,data_sz);
dataTrain=zeros(vect_len,data_sz);
for i=1:data_sz
img_nm=strcat(loc,flnames(i).name);
descVec(:,:,i)=imread(img_nm);
end
for j=1:data_sz
    datap=reshape(descVec(:,:,j),vect_len,1);
    dataTrain(1:vect_len,j)=datap;
end
dataTrain = dataTrain';


%labelling train data
oldS4='001';numt=1;
TrainLabel=zeros(data_sz,1);
for i=1:data_sz
img_nm=strcat(loc,flnames(i).name);
simg = size(img_nm);
lastIndex=simg(1,2);
firstIndex=simg(1,1);
kk=1;
for ii = lastIndex :-1 : firstIndex
    if (img_nm(:,ii)=='\')
        break;
    end
    temp(kk) = img_nm(:,ii);
    kk=kk+1;
end
sz=size(temp);
lastInd = sz(1,2);
newval(1,1) = temp(lastInd);
newval(1,2) = temp(lastInd-1);
newval(1,3) = temp(lastInd-2);
clear temp;
s4=newval;
TrainLabel(i,:) = str2num(s4);
end



%%
%Creating the test Vector
testData_sz=1201; %size of the test data
vect_lenTest=64*64; %dimension of test data
label = zeros(testData_sz,1);
loct='E:\VigneshP\modules\PR\part II\proj2\test\'; %change according to your working folder where the test folder is present
namePairt = 'E:\VigneshP\modules\PR\part II\proj2\test\*.bmp'; %change according to your working folder where the test folder is present(along with *.bmp)
flnamest = dir(namePairt);
testVec=zeros(64,64,testData_sz);
dataTest=zeros(vect_lenTest,testData_sz);
for i=1:testData_sz
img_nm=strcat(loct,flnamest(i).name);
testVec(:,:,i)=imread(img_nm);
end
for j=1:testData_sz
    datapTest=reshape(testVec(:,:,j),vect_lenTest,1);
    dataTest(1:vect_len,j)=datapTest;
end
dataTest = dataTest';

%labelling test
oldS3='001';num=1;
for i=1:testData_sz
img_nm=strcat(loct,flnamest(i).name);
simg = size(img_nm);
lastIndex=simg(1,2);
firstIndex=simg(1,1);
kk=1;
for ii = lastIndex :-1 : firstIndex
    if (img_nm(:,ii)=='\')
        break;
    end
    temp(kk) = img_nm(:,ii);
    kk=kk+1;
end
sz=size(temp);
lastInd = sz(1,2);
newval(1,1) = temp(lastInd);
newval(1,2) = temp(lastInd-1);
newval(1,3) = temp(lastInd-2);
clear temp;
s3=newval;
label(i,:) = str2num(s3);
end

%%
%PCA - generate PCs
dataMean=mean(dataTrain);
meanmat=repmat(dataMean,data_sz,1);
A=dataTrain-meanmat;
[U,S,V] = svd(A*A');
coeff = V'*A;
coeffT = coeff/norm(coeff); 
coeffT = coeffT(1:data_sz,:)';

%%
%get PCs
coeffkk = coeffT(:,1:499); 
coeffkk = coeffkk';
mul = zeros(data_sz,4096);
for ii=1:data_sz
mul(ii,:) = dataTrain(ii,:)-dataMean;
end
mul = mul';
PC=coeffkk*mul;
traindata = PC';
%%
%calculates mean & cvarience matrices for 8(K) components
%classifies data(X) into 8 classes indicated by 'label'
K=8;
X=traindata;
% X=rand(20,4)*100;
% K=3;
% X random variables N x D
% N vectors in D dimensions
% k clusters
%Assume equal probabilities for all clusters
[N D]=size(X);
GMMtresh = 0.03;
%Initialization
MeanK=zeros(K,D);
CovK=zeros(D,D,K);
% for ii=1:K
% CovK(:,:,ii)=eye(D);
% end
Z=zeros(N,K);
ratio=int32(N/K);
for ii=1:N
    loc=(ii/ratio)+1;
%     if loc == 2
%         loc=1;
%     end
    if(loc>K)
        loc=K;
    end
    Z(ii,loc)=1;
end
for ii=1:N
    locNew=find(Z(ii,:)==1);
    MeanK(locNew,:)=MeanK(locNew,:)+X(ii,:);
end
Zvertsum=sum(Z,1);
for jj=1:K
MeanK(jj,:)=MeanK(jj,:)/Zvertsum(jj);
end
for jj=1:K
    endClust=Zvertsum(jj);
    CovKtemp=zeros(D,D,endClust);
    for ii=1:endClust
        difftemp=X(ii,:)-MeanK(jj,:);
        CovKtemp(:,:,ii)=difftemp'*difftemp;
    end
    CovK(:,:,jj)=sum(CovKtemp,3)/endClust;
end

% CovK must be positive definite(& non-singular)
% Hence use only diagonal elements-variance (for initial estimate)
for jj=1:K
    CovK(:,:,jj)=diag(diag(CovK(:,:,jj)));
end

countGMM=0;
maxP=0;
maxDiff=GMMtresh+1; %init
while(maxDiff>GMMtresh)
    % E-step
    for ii=1:N
        Pxw=zeros(K,1);
        for jj=1:K
            Pxw(jj) = mvnpdf(X(ii,:),MeanK(jj,:),permute(CovK(:,:,jj),[1 2])); % P(Xi|Wj,ujt)
    %         Pw=1/8; fixed
        end
        Px=sum(Pxw);
        %Expectation
        for jj=1:K
            Z(ii,jj)=(Pxw(jj)/Px);
        end   
    %     jloc=find(Z(ii,:),1);
    %     Z(ii,jloc)=Pxw(jloc)/Px;
    end
    Z(isnan(Z))=0;
    % M-step
    % Estimate Mean
    for jj=1:K
        sum1=0;sum2=0;
        for ii=1:N
            sum1=sum1+Z(ii,jj)*X(ii,:);
            sum2=sum2+Z(ii,jj);
        end
        MeanK(jj,:)=sum1/sum2;
    end

    % Estimate Covariance
    for jj=1:K
        sum2=0; 
        Covsum=zeros(D,D,N);
        for ii=1:N
            Xtemp=X(ii,:);
            Covsum(:,:,ii)=Z(ii,jj)*(Xtemp-MeanK(jj,:))'*(Xtemp-MeanK(jj,:));
            sum2=sum2+Z(ii,jj);
        end
        sum1=sum(Covsum,3);
        Cov(:,:,jj)=sum1/sum2;
    end
maxZ=max(Z,[],2);
maxDiff=maxZ-maxP;
maxDiff=mean(maxDiff);
maxP=maxZ;

countGMM=countGMM+1;
disp(sprintf('GMM iteration num = %d',countGMM))
end
[val labels]=max(Z,[],2);


%%
%Display gmm means/centers
fignum=1;
figure(fignum); 
for ii=1:8
    mult=MeanK(ii,:)*coeffkk;
    x=mult+dataMean;
    minval=min(x);
    x=x-minval;
    x=x*255/max(x);
    facep=reshape(x(1:vect_len),64,64);
    subplot(1,8,ii);
    imshow(uint8(facep));
    title(ii);
end
axes('Position',[0 0 1 1],'Visible','off');
text(0.40,0.95,'8 centers/means of the components(GMM)')
axes('Position',[0 0 1 1],'Visible','off');
text(0.1,0.95,'4. a)')