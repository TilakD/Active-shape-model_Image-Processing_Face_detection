function [eye1,eye2,mouth,showim] = Face_detection(im)
[M,N,C] = size(im); 
imycbcr = rgb2ycbcr(im);

Y = double(imycbcr(:,:,1));
y = uint8(Y);
y = imnormal(y); 
Cb = double(imycbcr(:,:,2));
cb = uint8(Cb);
cb = imnormal(cb);
Cr = double(imycbcr(:,:,3));
cr = uint8(Cb);
cr = imnormal(cr); 

%-----------------------Compute the Eye Map C-------------
%Cr^2
Cr_sq = imnormal(Cr.^2);     
cr_sq =uint8(Cr_sq);

%Cb^2
Cb_sq = imnormal((255-Cr).^2);        
cb_sq =uint8(Cb_sq);
                         
%Cb/Cr
Cb_Cr = imnormal(Cb./Cr);            
cb_cr =uint8(Cb_Cr);
EyeMapC = (Cr_sq + Cb_sq + Cb_Cr)/3;    %average

%EyeMapC
EyeMapC = imnormal(EyeMapC); 
eyemapc = uint8(EyeMapC);
%Use histogram equalization to enhance the result
eyemapc_hist_eq = double(histeq(eyemapc));
eyemapc_hist_eq_invert = uint8(eyemapc_hist_eq);
%-----------------------End of Computing the Eye Map C-------------

%-----------------------Compute the Eye Map L----------------------
se = strel('disk',5);               %disk of radius 5
                
 % dialate  
Y_dia = imdilate(Y,se);             
y_dia =uint8(Y_dia);

 % erode
Y_ero = imerode(Y,se);             
y_ero =uint8(Y_ero);

%EyeMapL
EyeMapL = Y_dia./(Y_ero+0.1);
EyeMapL = imnormal(EyeMapL);
eyemapl = uint8(EyeMapL);
%Use histogram equalization to enhance the result
eyemapl_hist_eq = double(histeq(eyemapl));
eyemapl_hist_eq_invert = uint8(eyemapl_hist_eq);

%-----------------------End of Computing the Eye Map L-------------

%------------------------Combine as Eye Map--------------------
initial_eyemap = imnormal(EyeMapC.*EyeMapL);
initial_eyemap = uint8(initial_eyemap);
%Dilate 
EyeMap = imdilate(initial_eyemap,strel('disk',3));
eyemap_hist_eq = double(histeq(EyeMap));
eyemap_hist_eq_invert = uint8(eyemap_hist_eq);
e_map = double(eyemap_hist_eq_invert);
%------------------------End of Combine as Eye Map--------------------

%-------------Masked, normally eyes appear in the following area-----
mask = zeros(M,N);
left = round(N/6);
right = round(5*N/6);
GRx = 1:M;
GRy = normpdf(GRx,round(M/2.5),M/4);
mask(:,left:right)=repmat(GRy',1,right-left+1);
GCx = repmat(1:left,M,1);
GCy = normpdf(GCx,0,left/3);
for i=1:M
    GCy(i,:) = GCy(i,:)/GCy(i,1)*mask(i,left);
end
[tempM,tempN]=size(GCy);
mask(:,right:(right+tempN-1)) = GCy;
mask(:,(left-tempN+1):left) = fliplr(GCy);
mEyeMap = imnormal(e_map.*mask);
subplot(4,5,16);imshow(mEyeMap,[]);title('Eye Area');
 %figure;imshow(mEyeMap,[]);
 %figure;imshow(mEyeMap,[]);

%---------------------eye area-------------
template = ones(5,5);
mEyeMap = conv2(mEyeMap,template,'same');
% figure;imshow(mEyeMap,[]);
[tempinx,tempiny] = find(mEyeMap == max(max(mEyeMap)));
index_e1x = tempinx(1);
index_e1y = tempiny(1);

%Mask out the first eye and mark the second eye
halfm = round(N/7);
masktemp = ones(M,N);
masktemp((index_e1x-halfm):(index_e1x+halfm),(index_e1y-halfm):(index_e1y+halfm)) = 0;
mEyeMap= mEyeMap.*masktemp;
[tempinx,tempiny] = find(mEyeMap == max(max(mEyeMap)));
index_e2x = tempinx(1);
index_e2y = tempiny(1);

%change the eye index
if index_e2y < index_e1y
    temp = index_e2y;
    index_e2y = index_e1y;
    index_e1y = temp;
    temp = index_e2x;
    index_e2x = index_e1x;
    index_e1x = temp;
end

theta = atan((index_e1x-index_e2x)/(index_e2y-index_e1y));
%retangle to mark the eyes
halfl = round(N/9);
halfw = round(N/18);
luc = [index_e1x-halfw,index_e1y-halfl];
ruc = [index_e1x-halfw,index_e1y+halfl];
llc = [index_e1x+halfw,index_e1y-halfl];
rlc = [index_e1x+halfw,index_e1y+halfl];
showim = im;
showim = redrectangle(showim,luc,ruc,llc,rlc,theta);
% figure;imshow(im,[]);
luc = [index_e2x-halfw,index_e2y-halfl];
ruc = [index_e2x-halfw,index_e2y+halfl];
llc = [index_e2x+halfw,index_e2y-halfl];
rlc = [index_e2x+halfw,index_e2y+halfl];
showim = redrectangle(showim,luc,ruc,llc,rlc,theta);

% Use mouth map to detect mouth automatically
term1 = imnormal(Cr.^2);
term2 = imnormal(Cr./Cb);
MouthMap = term1.*(term1-0.2*term2).^2;
MouthMap = imnormal(imdilate(MouthMap,strel('disk',3)));
subplot(4,5,18);imshow(MouthMap,[]);title('Mouth Area');
% figure;imshow(MouthMap,[]);

eye1 = [index_e1x,index_e1y];
eye2 = [index_e2x,index_e2y];
MouthMask = MMask(im,eye1,eye2);
MouthMap = MouthMap.*MouthMask;
% figure;imshow(MouthMap,[]);
[tempinx,tempiny] = find(MouthMap == max(max(MouthMap)));
index_mx = tempinx(1);
index_my = tempiny(1);

mouth = [index_mx,index_my];

halfw = round(1.2*halfw);
halfl = round(1.8*halfl);
luc = [index_mx-halfw,index_my-halfl];
ruc = [index_mx-halfw,index_my+halfl];
llc = [index_mx+halfw,index_my-halfl];
rlc = [index_mx+halfw,index_my+halfl];
showim = redrectangle(showim,luc,ruc,llc,rlc,theta);

 %----------display ------------
subplot(4,5,1);imshow(im);title('Input image');
subplot(4,5,2);imshow(imycbcr);title('ycbcr');
subplot(4,5,3);imshow(y);title('Y');
subplot(4,5,4);imshow(cb);title('Cb');
subplot(4,5,5);imshow(cr);title('Cr');
subplot(4,5,6);imshow(cr_sq);title('Cr^2');
subplot(4,5,7);imshow(cb_sq);title('Cb^2');
subplot(4,5,8);imshow(cb_cr);title('Cb/Cr');
subplot(4,5,9);imshow(eyemapc_hist_eq_invert);title('EyeMapC');
subplot(4,5,10);imshow(y_dia);title('Y Dialate');
subplot(4,5,11);imshow(y_ero);title('Y Erode');
subplot(4,5,12);imshow(eyemapl_hist_eq_invert);title('EyeMapL');
subplot(4,5,13);imshow(initial_eyemap);title('Initial eyemap');
subplot(4,5,14);imshow(eyemap_hist_eq_invert);title('EyeMap');
subplot(4,5,15);imshow(mask,[]);title('Mask');
subplot(4,5,17);imshow(mEyeMap,[]);title('Masked Eye');
subplot(4,5,19);imshow(MouthMap,[]);title('Masked Mouth');
subplot(4,5,20);imshow(showim,[]);title('EYES & MOUTH');
figure ; imshow(showim,[]);title('EYES & MOUTH');
figure;

%------------------End of Display---------------
