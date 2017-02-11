%detects eyes and mouth
function eyesmouthdetection(img,filename,meyemouth,meanshape68,pathname,k)

%run this to get the face features such as eyes and mouth....
[f1_eye1,f1_eye2,f1_mouth,f1show] = Face_detection(img);
imshow1 = reddot(img,[f1_eye1;f1_eye2;f1_mouth]);
a = imshow(imshow1,[]);impixelinfo(gcf,a);title('Face');
mat = [f1_eye1(2) f1_eye1(1);f1_eye2(2) f1_eye2(1);f1_mouth(2) f1_mouth(1)];
facial_dots(img,mat,filename,meyemouth,meanshape68,pathname,k);