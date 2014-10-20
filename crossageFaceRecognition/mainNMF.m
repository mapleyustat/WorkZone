clear all;
clc;
%%
%creating train vector
data_sz=1342;%size of the train data
vect_len = 64*64;% dimension of the image
loc='E:\VigneshP\modules\PR\part II\proj2\train\';%change according to your working folder where the train folder is present
namePair = 'E:\VigneshP\modules\PR\part II\proj2\train\*.bmp';%change according to your working folder where the train folder is present(along with *.bmp)
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

%%
numNMF = 50;
repl1=10;
display('2. NMF Training');
opt = statset('MaxIter',5);
[W0,H0] = nnmf(dataTrain,numNMF,'replicates',repl1,...
                   'options',opt,...
                   'algorithm','mult');

%nmf Test
%Generates 2 matrices
% W=N x numNMF all +ve
% H=numNMF x 4096 (bases)
opt = statset('Maxiter',1000);
[W,NmfDisp] = nnmf(dataTrain,numNMF,'w0',W0,'h0',H0,...
             'options',opt,...
             'algorithm','als');


% a)
% display the 50 bases, with numNMF = 50
display('a) Display NMF bases');
fignum=1;
figure(fignum); fignum=fignum+1;
for ii=1:50
    dispface=NmfDisp(ii,:);
    minval=min(dispface);
    dispface=dispface-minval;
    dispface=dispface*255/max(dispface);
    face=reshape(dispface,64,64);
    subplot(5,10,ii);
    imshow(uint8(face));
    title(ii);
end
axes('Position',[0 0 1 1],'Visible','off');
text(0.45,0.95,'NMF bases')
axes('Position',[0 0 1 1],'Visible','off');
text(0.1,0.95,'2. a)')

% b)
% re-run twice more with random initializations
%1st iteration
repl2=4;
display('b) NMF testing with differnt initializations');
opt = statset('MaxIter',5);
[W1,H1] = nnmf(dataTrain,numNMF,'replicates',repl2,...
                   'options',opt,...
                   'algorithm','mult');
               
%Generates 2 matrices
% W=N x numNMF all +ve
% H=numNMF x 4096 (bases)
opt = statset('Maxiter',1000);
[W,disp1] = nnmf(dataTrain,numNMF,'w0',W1,'h0',H1,...
             'options',opt,...
             'algorithm','als');
NmfDiff1=(NmfDisp-disp1);

fignum=2;
figure(fignum); fignum=fignum+1;
for ii=1:50
    dispface=NmfDiff1(ii,:);
    minval=min(dispface);
    dispface=dispface-minval;
    dispface=dispface*255/max(dispface);
    face=reshape(dispface,64,64);
    subplot(5,10,ii);
    imshow(uint8(face));
    title(ii);
end
axes('Position',[0 0 1 1],'Visible','off');
text(0.45,0.95,'NMF bases difference')

%2nd iteration
repl3 = 20;
opt = statset('MaxIter',5);
[W2,H2] = nnmf(dataTrain,numNMF,'replicates',repl3,...
                   'options',opt,...
                   'algorithm','mult');
%Generates 2 matrices
% W=N x numNMF all +ve
% H=numNMF x 4096 (bases)
opt = statset('Maxiter',1000);
[W,disp2] = nnmf(dataTrain,numNMF,'w0',W2,'h0',H2,...
             'options',opt,...
             'algorithm','als');
NmfDiff2=(NmfDisp-disp2);
fignum=3;
figure(fignum); fignum=fignum+1;
for ii=1:50
    dispface=NmfDiff2(ii,:);
    minval=min(dispface);
    dispface=dispface-minval;
    dispface=dispface*255/max(dispface);
    face=reshape(dispface,64,64);
    subplot(5,10,ii);
    imshow(uint8(face));
    title(ii);
end
axes('Position',[0 0 1 1],'Visible','off');
text(0.45,0.95,'NMF bases difference')
