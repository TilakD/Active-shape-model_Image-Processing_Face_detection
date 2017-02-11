function result =  imnormal(im)
%This function is used to normalize the image to [0,255]
%im should be gray image

immin = min(min(im));
immax = max(max(im));
result = (im-immin)/(immax-immin)*255;