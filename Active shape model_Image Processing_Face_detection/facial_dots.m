function facial_dots(img,mat,filename,meyemouth,meanshape68,pathname,k)
[M,wid] = size(img);

%figure;imshow(img,[]); 
landmarkfile = [filename(1:find(filename=='.')-1),'.m'];

box = ones(1,4);
box(3:4) = [size(img,2)-1,size(img,1)-1];
if( isempty(dir( [landmarkfile] )) )
%mark a new face
   title('Select center of eyes and mouth');
   
    %input eyes and mouth center
    %mat = ginput(3); 
    %mat
    bx = max(mat(:,1)) - min(mat(:,1));
    by = max(mat(:,2)) - min(mat(:,2));
    box = [max(1,mat(1,1)-bx) , max(1,mat(1,2)-by) , 3*bx,3*by ];
    mat = mat-[1;1;1]*box(1:2)+1; 
    
    T = CalcAffineCo(meyemouth,mat);

    Xo = T(1)*meanshape68(:,1) + T(2)*meanshape68(:,2)+T(5);
    Yo = T(3)*meanshape68(:,1) + T(4)*meanshape68(:,2)+T(6);
else 
    
%load .txt and edit it
    sh=load([landmarkfile]);
    bx = max(sh(:,1))-min(sh(:,1)); bx =  bx /4;
    by = max(sh(:,2))-min(sh(:,2)); by =  by /4;
    box(1:2) = [ max(1,min(sh(:,1))-bx),max(1,min(sh(:,2))-by) ];
    box(3:4) = [ min(wid,max(sh(:,1))+bx-box(1))-1,min(M,max(sh(:,2))+by-box(2))-1 ];

    Xo = sh(:,1)-box(1)+1;
    Yo = sh(:,2)-box(2)+1;
end

im = imcrop(img,box);
figure; imshow(im,[]);
hold on,
h1 = plot(Xo(1:17),Yo(1:17),'r-',Xo(18:27),Yo(18:27),'c-',Xo(49:68),Yo(49:68),'k-','Linewidth',1);
h2 = plot(Xo,Yo,'x','Linewidth',4);

facial_point_correction(Xo,Yo,h1,h2,pathname,box,k);
