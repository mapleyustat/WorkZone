%organizing script
%Run this script each time for train and test respectively
%Make sure this script is present in the folder of the entire dataset.
[filename] = textread('E:\VigneshP\modules\PR\part II\proj2\cross_age_face\test.txt','%s');% Give your directory in which test.txt/train.txt is present
mkdir('E:\VigneshP\modules\PR\part II\proj2\LDA\test') % Give your working directory where the new folder has to be created with new folder name at the last
%size of test = 1201;
%size of train = 1342;
sz=1201; % give the size of train/test images 
for i=1:sz 
name=filename(i);
s = char(name);
copyfile(s,'E:\VigneshP\modules\PR\part II\proj2\LDA\test');% Give the same directory path where the new folder was created above.
end