%--14-march-2014----
%---Tilak and Harish----
clear all; clc;

% Give the path of the database
pathname='C:\Users\Tilak\Desktop\ASM_FINAL\Database\';
% C:\Users\...\Downloads\ASM\Database\

Database_size = input('Enter the Database size: ');
while 1
number_imgs = input('How many images do you want to train? ');

while 1
if number_imgs > Database_size
    disp('Value exceeded the Database size ');
    disp('Enter a value less than the Database size');
    break;
end

close all
meanshape68 = load('meanshapecmu.m');
meyemouth = ([meanshape68([29,35,63],:)]+[meanshape68([32,38,67],:)])/2;

for k =1:number_imgs
  filename = strcat(pathname, num2str(k), '.ppm');
  img = imread(filename);
  imfinfo(filename);
  figure;
  b = imshow(img);impixelinfo(gcf,b);title('Input image');
  figure;
  
 %{ 
  %----uncomment this for manual image selection----%

check if pathname exists
if(isempty(whos('pathname')) || isequal(pathname,0) ) 
    pathname=[]; 
end    
[filename, pathname] = uigetfile([pathname,'*.bmp;*.jpg;*.png;*.ppm'], 'Select an image');

if isequal(filename,0) || isequal(pathname,0)    
    clear all
    return;
end
img = imread([pathname,filename]);
%}
  %%  Do you want to manully select the feature points
ButtonName = questdlg('Do you want to manully select the feature points?','ASM/AAM training','YES','NO','NO');
if( strcmp(ButtonName,'NO') )
   %eyes and mouth detection, also facial dots 
eyesmouthdetection(img,filename,meyemouth,meanshape68,pathname,k);
end  %if
close all;
if( strcmp(ButtonName,'YES') )
   %eyes and mouth manual detection, also facial dots 
manual_asm(img,filename,meyemouth,meanshape68,pathname,k);
end  %if

end %for

%%  Do you want to train more
ButtonName = questdlg('Do you want to train more?','ASM/AAM training','YES','NO','NO');
if( strcmp(ButtonName,'NO') )
   close all;
   clc;
   return; 
end  %if
close all;
end %while
%% Do you want to exit
ButtonName = questdlg('Will you give a correct number or shall i exit?','ASM/AAM training','Exit','I will give a correct value','I will give a correct value');
if( strcmp(ButtonName,'Exit') )
   close all;
   clc;
   return; 
end  %for
close all;
end %while