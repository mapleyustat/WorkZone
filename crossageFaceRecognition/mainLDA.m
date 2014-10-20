clc;
clear all;
%%
data_sz=1342;%size of the train data
vect_len = 64*64;% dimension of the image
loc='E:\VigneshP\modules\PR\part II\proj2\train\';%change according to your working folder where the train folder is present
namePair = 'E:\VigneshP\modules\PR\part II\proj2\train\*.bmp';%change according to your working folder where the train folder is present(along with *.bmp)
flnames = dir(namePair);
descVec=zeros(1360,64,64);
dataTrain=zeros(data_sz,4096);
for i=1:data_sz
img_nm=strcat(loc,flnames(i).name);
descVec(i,:,:)=imread(img_nm);
end
 for j=1:data_sz
     datap=reshape(descVec(j,:,:),vect_len,1);
     dataTrain(j,:)=datap;
 end
%  dataTrain = dataTrain';
datamn=mean(dataTrain);
meanmat=repmat(datamn,data_sz,1);
A=dataTrain-meanmat;
[U,S,V] = svd(A*A');
coeff = V'*A;
coeffT = coeff/norm(coeff); 
coeffT = coeffT(1:data_sz,:)';



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
testData_sz=1201;%size of the test data
vect_lenTest=64*64;%dimension of test data
label = zeros(testData_sz,1);
loct='E:\VigneshP\modules\PR\part II\proj2\test\';%change according to your working folder where the test folder is present.
namePairt = 'E:\VigneshP\modules\PR\part II\proj2\test\*.bmp';%change according to your working folder where the test folder is present(along with *.bmp)
flnamest = dir(namePairt);
testVec=zeros(testData_sz,64,64);
dataTest=zeros(testData_sz,vect_lenTest);
for i=1:testData_sz
img_nm=strcat(loct,flnamest(i).name);
testVec(i,:,:)=imread(img_nm);
end
for j=1:testData_sz
    datapTest=reshape(testVec(j,:,:),vect_lenTest,1);
    dataTest(j,:)=datapTest;
end
%dataTest = dataTest';

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


%% for accuracy comparison
incValue=0;
redDimValue=301;
for redDim =1:20:redDimValue
coeffkk = coeffT(:,1:redDim); 
coeffkk = coeffkk';
mul = zeros(data_sz,4096);
for ii=1:data_sz
mul(ii,:) = dataTrain(ii,:)-datamn;
end
mul = mul';
PC=coeffkk*mul;
traindata = PC';

%classification of test
PCcoeff=zeros(redDim,testData_sz);

%Get coefficients in eigen space
for ii=1:testData_sz
    datacov=(dataTest(ii,:)-datamn)';
    PCcoeff(:,ii) = coeffkk*datacov;
end
PCcoeff = PCcoeff';


knn=3;
% Perform KNN classification
%[output] = knn_cut(traindata,PCcoeff,label,knn);
[n1,l1]=size(traindata);
[n2,l2]=size(PCcoeff);
knnmat=zeros(n2,1); %holds labels of k nearest neighbours
for i=1:n2
    pix=PCcoeff(i,:);
    % find nearest neighbour
    pixMat=repmat(pix,n1,1);
    DiffData=sqrt((traindata-pixMat).^2);

    DiffData=sum(DiffData,2);
    %find k nearest neighbours
    knntemp=zeros(1,knn);
    knnclass=zeros(1,knn);
    k=285;
    while(k) % get k-least entries
        [knntemp(k),pos] = min(DiffData);
        knnclass(k) = TrainLabel(pos); DiffData(pos)=1;
        k=k-1;
    end
    % find k min
    class=median(knnclass);
    knnmat(i,:)=class; 
end

%Accuracy calculation
knnMismatch=0;
for ii=1:testData_sz
    if(knnmat(ii)~=label(ii))
        knnMismatch=knnMismatch+1;
    end
end

incValue=incValue+1;
knnSelfCodedAccuracyPCA(incValue)=((testData_sz-knnMismatch)/testData_sz)*100;
end

%%
%pca
redDim=500;
coeffkk = coeffT(:,1:redDim); 
coeffkk = coeffkk';
mul = zeros(data_sz,4096);
for ii=1:data_sz
mul(ii,:) = dataTrain(ii,:)-datamn;
end
mul = mul';
PC=coeffkk*mul;
traindata = PC';

%classification of test
PCcoeff=zeros(redDim,testData_sz);

%Get coefficients in eigen space
for ii=1:testData_sz
    datacov=(dataTest(ii,:)-datamn)';
    PCcoeff(:,ii) = coeffkk*datacov;
end
PCcoeff = PCcoeff';

%%
%LDA - for multiclass
Z=0;
    W=0;
    X=traindata';
    Y=TrainLabel;
    r=284;
    [d,n]=size(X);
    [nY,dum]=size(Y);
    
    if(nY ~= n)
        return
    end 
    i=1;
 
    ClsLbls=unique(Y');
    NumberOfClasses = size(ClsLbls,2);
    if(nargin==2)
        r=NumberOfClasses-1;
    end
    
    LocalMu = cell(1,NumberOfClasses);
    CovVal = cell(1,NumberOfClasses);
    sizeC=zeros(1,NumberOfClasses);
    % Compute local Mu, cov matrix, and number of observation of
    % for each class class
    for clsLbl=unique(Y')
        Xc=X(:,Y==clsLbl);
        LocalMu(i) = {mean(Xc,2)};
        CovVal(i) = {cov(Xc')};
        sizeC(i)=size(Xc,2);
        i=i+1;
    end
    
 
    %Computing  the Global Mu
    Global_Mu = zeros(d,1);
    
    for i = 1:NumberOfClasses
        Global_Mu = Global_Mu+LocalMu{i};
    end
    Global_Mu=Global_Mu./NumberOfClasses;
    %SB: Betweeness class scatter matrix
    %SW: Scatter Class Matrix
    
    SB = zeros(d,d);
    SW = zeros(d,d);
    
    for i = 1:NumberOfClasses
        SB = SB + sizeC(i).*(LocalMu{i}-Global_Mu)*(LocalMu{i}-Global_Mu)';
        SW = SW+CovVal{i};
    end
    
    invSw = inv(SW);
    invSw_by_SB = invSw * SB;

    [V,D] = eig(invSw_by_SB);
    eigval=diag(D);
    % Sort invSw_by_SB (which is a matrix of eigen vectors) and then select 
    % the top vectors associated with the top eigen values as follows
    
    % Sorting
    [sort_eigval,sort_eigval_index]=sort(eigval,'descend');
    % Selecting the top vectors
    W=V(:,sort_eigval_index(1:redDim));
   
    % Now Z has the dimentional reduced data sample X.
    Z = W'*X;
    [dZ,nZ]=size(Z);
    
    %%
    %Fisher faces
    %Display fisher faces

figure(1);
for kk=1:10
face=Z'*coeffkk;
eigface=face(kk,:);
minval=min(eigface);
eigface=eigface-minval;
eigface=eigface*255/max(eigface);
facep=reshape(eigface,64,64);
subplot(2,10,kk);
imshow(uint8(facep));
title(kk);
end
axes('Position',[0 0 1 1],'Visible','off');
text(0.45,0.95,'Fischer Faces')
axes('Position',[0 0 1 1],'Visible','off');
text(0.1,0.95,'3. a)')
    
%%
dupDataMn=datamn;

len=size(dataTest);
datamn = repmat(datamn,len(1),1);

redDimValue=301;
incValue=0;
for redDim =1:20:redDimValue
coeffkk = coeffT(:,1:redDim); 
coeffkk = coeffkk';
mul = zeros(data_sz,4096);
for ii=1:data_sz
mul(ii,:) = dataTrain(ii,:)-dupDataMn;
end
mul = mul';
PC=coeffkk*mul;
traindata = PC';

%classification of test
PCcoeff=zeros(redDim,testData_sz);

%Get coefficients in eigen space
for ii=1:testData_sz
    datacov=(dataTest(ii,:)-dupDataMn)';
    PCcoeff(:,ii) = coeffkk*datacov;
end
PCcoeff = PCcoeff';

%LDA
Z=0;
    W=0;
    X=traindata';
    Y=TrainLabel;
    r=284;
    [d,n]=size(X);
    [nY,dum]=size(Y);
  
    if(nY ~= n)
  
        return
    end 
    i=1;
 
    ClsLbls=unique(Y');
    NumberOfClasses = size(ClsLbls,2);
    if(nargin==2)
        r=NumberOfClasses-1;
    end
   
    LocalMu = cell(1,NumberOfClasses);
    CovVal = cell(1,NumberOfClasses);
    sizeC=zeros(1,NumberOfClasses);
    % Compute local Mu, cov matrix, and number of observation of
    % for each class class
    for clsLbl=unique(Y')
        Xc=X(:,Y==clsLbl);
        LocalMu(i) = {mean(Xc,2)};
        CovVal(i) = {cov(Xc')};
        sizeC(i)=size(Xc,2);
        i=i+1;
    end
      
    %Computing  the Global Mu
    Global_Mu = zeros(d,1);
    
    for i = 1:NumberOfClasses
        Global_Mu = Global_Mu+LocalMu{i};
    end
    Global_Mu=Global_Mu./NumberOfClasses;
    %SB: Betweeness class scatter matrix
    %SW: Scatter Class Matrix
    
    SB = zeros(d,d);
    SW = zeros(d,d);
    
    for i = 1:NumberOfClasses
        SB = SB + sizeC(i).*(LocalMu{i}-Global_Mu)*(LocalMu{i}-Global_Mu)';
        SW = SW+CovVal{i};
    end
    
    invSw = inv(SW);
    invSw_by_SB = invSw * SB;

    [V,D] = eig(invSw_by_SB);
    eigval=diag(D);
    % Sort invSw_by_SB (which is a matrix of eigen vectors) and then select 
    % the top vectors assocaited with the top eigen values as follows
    
    % Sorting
    [sort_eigval,sort_eigval_index]=sort(eigval,'descend');
    % Selecting the top vectors
    W=V(:,sort_eigval_index(1:redDim));
   
    % Now Z has the dimentional reduced data sample X.
    Z = W'*X;
    [dZ,nZ]=size(Z);
    

    
dataTest1=(dataTest-datamn)*coeffkk';  % project into coeff space
dataTest1= dataTest1 * W;

knn=3;
% Perform KNN classification
[n1,l1]=size(traindata);
[n2,l2]=size(dataTest1);
knnmat=zeros(n2,1); %holds labels of k nearest neighbours
for i=1:n2
    pix=dataTest1(i,:);
    % find nearest neighbour
    pixMat=repmat(pix,n1,1);
    DiffData=sqrt((traindata-pixMat).^2);

    DiffData=sum(DiffData,2);
    %find k nearest neighbours
    knntemp=zeros(1,knn);
    knnclass=zeros(1,knn);
    k=285;
    while(k) % get k-least entries
        [knntemp(k),pos] = min(DiffData);
        knnclass(k) = TrainLabel(pos); DiffData(pos)=1;
        k=k-1;
    end
    % find k min
    class=median(knnclass);
    knnmat(i,:)=class; 
end

%Accuracy calculation
knnMismatch=0;
for ii=1:testData_sz
    if(knnmat(ii)~=label(ii))
        knnMismatch=knnMismatch+1;
    end
end

incValue=incValue+1;
knnSelfCodedAccuracyLDA(incValue)=((testData_sz-knnMismatch)/testData_sz)*100;

end
%%
jjx=1:20:redDimValue;
fignum=2; 
figure(fignum);
plot(jjx,knnSelfCodedAccuracyPCA,'-r','Marker','.'); hold on;
plot(jjx,knnSelfCodedAccuracyLDA,'-b','Marker','.');hold off;
axis([1 301 0 10]);
title('Face verification accuracies over different dimension-reduced feature dimensions(Comparison PCA & LDA)');
xlabel('Reduced dimensions');
ylabel('Accuracies with dimension-reduced data using PCA & LDA');
legend('PCA','LDA');
axes('Position',[0 0 1 1],'Visible','off');
text(0.1,0.95,'3. b)')
[maxval1,maxloc]=max(knnSelfCodedAccuracyPCA);
[maxval2,maxloc]=max(knnSelfCodedAccuracyLDA);
disp(sprintf('Best accuracy in pca= %3.3f',maxval1))
disp(sprintf('Best accuracy in lda= %3.3f',maxval2))

