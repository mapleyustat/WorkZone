clear all;
clc;
load mnist_sub;
%%
tot=8000; 
trtot = 800;

testtot = 2000;
ttot=200; %size of each test data

%%

%train labelling
labelTrain=zeros(tot,1);
labelTrain((trtot*1)+1:(trtot*2))=1;
labelTrain((trtot*2)+1:(trtot*3))=2;
labelTrain((trtot*3)+1:(trtot*4))=3;
labelTrain((trtot*4)+1:(trtot*5))=4;
labelTrain((trtot*5)+1:(trtot*6))=5;
labelTrain((trtot*6)+1:(trtot*7))=6;
labelTrain((trtot*7)+1:(trtot*8))=7;
labelTrain((trtot*8)+1:(trtot*9))=8;
labelTrain((trtot*9)+1:(trtot*10))=9;

%test labelling
label=zeros(testtot,1);
label((ttot*1)+1:(ttot*2))=1;
label((ttot*2)+1:(ttot*3))=2;
label((ttot*3)+1:(ttot*4))=3;
label((ttot*4)+1:(ttot*5))=4;
label((ttot*5)+1:(ttot*6))=5;
label((ttot*6)+1:(ttot*7))=6;
label((ttot*7)+1:(ttot*8))=7;
label((ttot*8)+1:(ttot*9))=8;
label((ttot*9)+1:(ttot*10))=9;

%%

descVec=zeros(tot,784);
for i=1:trtot
    curImg=train0(i,:);
    descVec(i,:)= curImg;
end
for i=1:trtot
    curImg=train1(i,:);
    descVec(i+trtot,:)= curImg;
end
for i=1:trtot
    curImg=train2(i,:);
    descVec(i+(trtot*2),:)= curImg;
end
for i=1:trtot
    curImg=train3(i,:);
    descVec(i+(trtot*3),:)= curImg;
end
for i=1:trtot
    curImg=train4(i,:);
    descVec(i+(trtot*4),:)= curImg;
end
for i=1:trtot
    curImg=train5(i,:);
    descVec(i+(trtot*5),:)= curImg;
end
for i=1:trtot
    curImg=train6(i,:);
    descVec(i+(trtot*6),:)= curImg;
end
for i=1:trtot
    curImg=train7(i,:);
    descVec(i+(trtot*7),:)= curImg;
end
for i=1:trtot
    curImg=train8(i,:);
    descVec(i+(trtot*8),:)= curImg;
end
for i=1:trtot
    curImg=train9(i,:);
    descVec(i+(trtot*9),:)= curImg;
end

%%
%PCA
meanTrain = mean(descVec,1);
[coeff,score]= princomp(descVec);
a=32;
for i=1:tot
   for j=1:a
        score10(i,j) = score(i,j);
   end
end
meanScore = mean(score10,1);

%%
%mean0
set0=zeros(trtot,a);
for i=1:trtot
    set0(i,:) = score10(i,:);
end
mean0 = mean(set0);

%mean1
set1=zeros(trtot,a);
for i=1:trtot
    set1(i,:) = score10(i+(1*trtot),:);
end
mean1 = mean(set1);

%mean2
set2=zeros(trtot,a);
for i=1:trtot
    set2(i,:) = score10(i+(2*trtot),:);
end
mean2 = mean(set2);

%mean3
set3=zeros(trtot,a);
for i=1:trtot
    set3(i,:) = score10(i+(3*trtot),:);
end
mean3 = mean(set3);

%mean4
set4=zeros(trtot,a);
for i=1:trtot
    set4(i,:) = score10(i+(4*trtot),:);
end
mean4 = mean(set4);

%mean5
set5=zeros(trtot,a);
for i=1:trtot
    set5(i,:) = score10(i+(5*trtot),:);
end
mean5 = mean(set5);

%mean6
set6=zeros(trtot,a);
for i=1:trtot
    set6(i,:) = score10(i+(6*trtot),:);
end
mean6 = mean(set6);

%mean7
set7=zeros(trtot,a);
for i=1:trtot
    set7(i,:) = score10(i+(7*trtot),:);
end
mean7 = mean(set7);

%mean8
set8=zeros(trtot,a);
for i=1:trtot
    set8(i,:) = score10(i+(8*trtot),:);
end
mean8 = mean(set8);

%mean9
set9=zeros(trtot,a);
for i=1:trtot
    set9(i,:) = score10(i+(9*trtot),:);
end
mean9 = mean(set9);

%%
%bayes classification
%Assume random variables are independent
%Collect only diagonal elements, variance = sigma^2
%covariance 0
CovMat0=zeros(trtot,a,a);
for i=1:trtot
Diff=score10(i,:)-mean0;
transDiff =Diff';
CovMat0(i,:,:)=transDiff*Diff;
end
Cov0=mean(CovMat0);
Cov0=permute(Cov0,[2,3,1]);

Cov0=diag(Cov0);
Cov0=Cov0';

%covariance 1
CovMat1=zeros(trtot,a,a);
for i=1:trtot
Diff=score10(i+(1*trtot),:)-mean1;
transDiff =Diff';
CovMat1(i,:,:)=transDiff*Diff;
end
Cov1=mean(CovMat1);
Cov1=permute(Cov1,[2,3,1]);

Cov1=diag(Cov1);
Cov1=Cov1'; 

%covariance 2
CovMat2=zeros(trtot,a,a);
for i=1:trtot
Diff=score10(i+(2*trtot),:)-mean2;
transDiff =Diff';
CovMat2(i,:,:)=transDiff*Diff;
end
Cov2=mean(CovMat2);
Cov2=permute(Cov2,[2,3,1]);

Cov2=diag(Cov2);
Cov2=Cov2'; 

%covariance 3
CovMat3=zeros(trtot,a,a);
for i=1:trtot
Diff=score10(i+(3*trtot),:)-mean3;
transDiff =Diff';
CovMat3(i,:,:)=transDiff*Diff;
end
Cov3=mean(CovMat3);
Cov3=permute(Cov3,[2,3,1]);

Cov3=diag(Cov3);
Cov3=Cov3'; 

%covariance 4
CovMat4=zeros(trtot,a,a);
for i=1:trtot
Diff=score10(i+(4*trtot),:)-mean4;
transDiff =Diff';
CovMat4(i,:,:)=transDiff*Diff;
end
Cov4=mean(CovMat4);
Cov4=permute(Cov4,[2,3,1]);

Cov4=diag(Cov4);
Cov4=Cov4'; 

%covariance 5
CovMat5=zeros(trtot,a,a);
for i=1:trtot
Diff=score10(i+(5*trtot),:)-mean5;
transDiff =Diff';
CovMat5(i,:,:)=transDiff*Diff;
end
Cov5=mean(CovMat5);
Cov5=permute(Cov5,[2,3,1]);

Cov5=diag(Cov5);
Cov5=Cov5'; 

%covariance 6
CovMat6=zeros(trtot,a,a);
for i=1:trtot
Diff=score10(i+(6*trtot),:)-mean6;
transDiff =Diff';
CovMat6(i,:,:)=transDiff*Diff;
end
Cov6=mean(CovMat6);
Cov6=permute(Cov6,[2,3,1]);

Cov6=diag(Cov6);
Cov6=Cov6'; 

%covariance 7
CovMat7=zeros(trtot,a,a);
for i=1:trtot
Diff=score10(i+(7*trtot),:)-mean7;
transDiff =Diff';
CovMat7(i,:,:)=transDiff*Diff;
end
Cov7=mean(CovMat7);
Cov7=permute(Cov7,[2,3,1]);

Cov7=diag(Cov7);
Cov7=Cov7'; 

%covariance 8
CovMat8=zeros(trtot,a,a);
for i=1:trtot
Diff=score10(i+(8*trtot),:)-mean8;
transDiff =Diff';
CovMat8(i,:,:)=transDiff*Diff;
end
Cov8=mean(CovMat8);
Cov8=permute(Cov8,[2,3,1]);

Cov8=diag(Cov8);
Cov8=Cov8'; 

%covariance 9
CovMat9=zeros(trtot,a,a);
for i=1:trtot
Diff=score10(i+(9*trtot),:)-mean9;
transDiff =Diff';
CovMat9(i,:,:)=transDiff*Diff;
end
Cov9=mean(CovMat9);
Cov9=permute(Cov9,[2,3,1]);

Cov9=diag(Cov9);
Cov9=Cov9'; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%test0
testVec=zeros(testtot,784);
for i=1:ttot
    curImg=test0(i,:);
    testVec(i,:)= curImg;
end
for i=1:ttot
    curImg=test1(i,:);
    testVec(i+ttot,:)= curImg;
end
for i=1:ttot
    curImg=test2(i,:);
    testVec(i+(ttot*2),:)= curImg;
end
for i=1:ttot
    curImg=test3(i,:);
    testVec(i+(ttot*3),:)= curImg;
end
for i=1:ttot
    curImg=test4(i,:);
    testVec(i+(ttot*4),:)= curImg;
end
for i=1:ttot
    curImg=test5(i,:);
    testVec(i+(ttot*5),:)= curImg;
end
for i=1:ttot
    curImg=test6(i,:);
    testVec(i+(ttot*6),:)= curImg;
end
for i=1:ttot
    curImg=test7(i,:);
    testVec(i+(ttot*7),:)= curImg;
end
for i=1:ttot
    curImg=test8(i,:);
    testVec(i+(ttot*8),:)= curImg;
end
for i=1:ttot
    curImg=test9(i,:);
    testVec(i+(ttot*9),:)= curImg;
end

%%
%PCA
meanTrain = repmat(meanTrain,testtot,1);
testVec=testVec-meanTrain;
testVecPca=testVec*coeff;
for i=1:testtot
   for j=1:a
        testVecPca10(i,j) = testVecPca(i,j);
   end
end


%%
%bayes self coded
%Maximum likelihood estimate, since priors are same & cost is same
output=zeros(testtot,1);
for i=1:testtot;
pix=testVecPca10(i,:);
% find log likelihood w.r.t each class
%class0
temp1=-0.5*(((pix-mean0).^2)./Cov0);
temp2=-1*log(sqrt(2*pi*Cov0));
temp1=temp1+temp2;
tempRes(1)=sum(temp1);

%class1
temp1=-0.5*(((pix-mean1).^2)./Cov1);
temp2=-1*log(sqrt(2*pi*Cov1));
temp1=temp1+temp2;
tempRes(2)=sum(temp1);

%class2
temp1=-0.5*(((pix-mean2).^2)./Cov2);
temp2=-1*log(sqrt(2*pi*Cov2));
temp1=temp1+temp2;
tempRes(3)=sum(temp1);

%class3
temp1=-0.5*(((pix-mean3).^2)./Cov3);
temp2=-1*log(sqrt(2*pi*Cov3));
temp1=temp1+temp2;
tempRes(4)=sum(temp1);

%class4
temp1=-0.5*(((pix-mean4).^2)./Cov4);
temp2=-1*log(sqrt(2*pi*Cov4));
temp1=temp1+temp2;
tempRes(5)=sum(temp1);

%class5
temp1=-0.5*(((pix-mean5).^2)./Cov5);
temp2=-1*log(sqrt(2*pi*Cov5));
temp1=temp1+temp2;
tempRes(6)=sum(temp1);

%class6
temp1=-0.5*(((pix-mean6).^2)./Cov6);
temp2=-1*log(sqrt(2*pi*Cov6));
temp1=temp1+temp2;
tempRes(7)=sum(temp1);

%class7
temp1=-0.5*(((pix-mean7).^2)./Cov7);
temp2=-1*log(sqrt(2*pi*Cov7));
temp1=temp1+temp2;
tempRes(8)=sum(temp1);

%class8
temp1=-0.5*(((pix-mean8).^2)./Cov8);
temp2=-1*log(sqrt(2*pi*Cov8));
temp1=temp1+temp2;
tempRes(9)=sum(temp1);

%class9
temp1=-0.5*(((pix-mean9).^2)./Cov9);
temp2=-1*log(sqrt(2*pi*Cov9));
temp1=temp1+temp2;
tempRes(10)=sum(temp1);

[val,pos] = max(tempRes); %Largest log likelihood
clear tempRes;  
output(i,:)=pos-1; 
end

%Accuracy calculation
dataTest_sz = testtot;
mismatch=0;
for ii=1:dataTest_sz
    if(output(ii)~=label(ii))
        mismatch=mismatch+1;
    end
end

selfCodedBayesAccuracy =((dataTest_sz-mismatch)/dataTest_sz)*100;
display(selfCodedBayesAccuracy);
bayesErrorRate = 100-selfCodedBayesAccuracy;
display(bayesErrorRate);

%%
%bayes confusion matrix
bayesConfusionMatrix=zeros(10,10);
rowval=1;
value=0;
for c=1:testtot
    if c==(ttot+1)
        rowval=rowval+1;
    end
    if c==((ttot*2)+1)
        rowval=rowval+1;
    end
    if c==((ttot*3)+1)
        rowval=rowval+1;
    end
    if c==((ttot*4)+1)
        rowval=rowval+1;
    end
    if c==((ttot*5)+1)
        rowval=rowval+1;
    end
    if c==((ttot*6)+1)
        rowval=rowval+1;
    end
    if c==((ttot*7)+1)
        rowval=rowval+1;
    end
    if c==((ttot*8)+1)
        rowval=rowval+1;
    end
    if c==((ttot*9)+1)
        rowval=rowval+1;
    end
    if output(c)==label(c)
    bayesConfusionMatrix(rowval,rowval) = bayesConfusionMatrix(rowval,rowval)+1;
    end
    if output(c)~=label(c)
    value = output(c);
    bayesConfusionMatrix(rowval,value+1)=bayesConfusionMatrix(rowval,value+1)+1;
    end
end
display(bayesConfusionMatrix);

%%
%knn classification
knn=3;
n1=tot; %size of traindata
n2=testtot; %size of testdata
knnmat=zeros(n2,1); %holds labels of k nearest neighbours
for i=1:testtot
    pixKnn=testVecPca10(i,:);
    % find nearest neighbour
    pixMat=repmat(pixKnn,n1,1);
    DiffData=sqrt((score10-pixMat).^2);

    DiffData=sum(DiffData,2);
    %find k nearest neighbours
    knntemp=zeros(1,knn);
    knnclass=zeros(1,knn);
    k=10;
    while(k) % get k-least entries
        [knntemp(k),pos1] = min(DiffData);
        knnclass(k) = labelTrain(pos1); DiffData(pos1)=1;
        k=k-1;
    end
    % find k min
    class=median(knnclass);
    knnmat(i,:)=class; 
end

%Accuracy calculation
knnMismatch=0;
for ii=1:dataTest_sz
    if(knnmat(ii)~=label(ii))
        knnMismatch=knnMismatch+1;
    end
end

knnSelfCodedAccuracy=((dataTest_sz-knnMismatch)/dataTest_sz)*100;
display(knnSelfCodedAccuracy);
knnErrorRate = 100-knnSelfCodedAccuracy;
display(knnErrorRate);

%%
%knn confusion matrix
knnConfusionMatrix=zeros(10,10);
rowval=1;
valuek=0;
for c=1:testtot
    if c==(ttot+1)
        rowval=rowval+1;
    end
    if c==((ttot*2)+1)
        rowval=rowval+1;
    end
    if c==((ttot*3)+1)
        rowval=rowval+1;
    end
    if c==((ttot*4)+1)
        rowval=rowval+1;
    end
    if c==((ttot*5)+1)
        rowval=rowval+1;
    end
    if c==((ttot*6)+1)
        rowval=rowval+1;
    end
    if c==((ttot*7)+1)
        rowval=rowval+1;
    end
    if c==((ttot*8)+1)
        rowval=rowval+1;
    end
    if c==((ttot*9)+1)
        rowval=rowval+1;
    end
    if knnmat(c)==label(c)
    knnConfusionMatrix(rowval,rowval) = knnConfusionMatrix(rowval,rowval)+1;
    end
    if knnmat(c)~=label(c)
    valuek = output(c);
    knnConfusionMatrix(rowval,valuek+1)=knnConfusionMatrix(rowval,valuek+1)+1;
    end
end
display(knnConfusionMatrix);
