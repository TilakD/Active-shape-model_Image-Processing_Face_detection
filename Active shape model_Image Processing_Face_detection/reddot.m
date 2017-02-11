%part of face morphing
function result = reddot(im,p)
%This function is usded to make one pixel in the image show green

x = p(:,1);
y = p(:,2);
for i = 1:length(y)
    im(x(i),y(i),1) = 255;    
    im(x(i),y(i),2) = 255;
    im(x(i),y(i),3) = 255;
end
result = im;
%plot(x,y,'x','Linewidth',4);
%figure;