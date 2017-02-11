function MouthMask = MMask(im,eye1,eye2)
%This function is used to generate a mask to help detect the mouth in the
%face
eye1x = eye1(1);
eye1y = eye1(2);
eye2x = eye2(1);
eye2y = eye2(2);
[M,N,P] = size(im);
eyem = round((eye1+eye2)/2);
dis = round(sqrt((eye1x-eye2x)^2+(eye1y-eye2y)^2))*1.2;
mouthtemp = [eyem(1)+dis,eyem(2)];
MouthMask= zeros(M,N);
% templ = uint8(round(N/4));
templ = round(N/4);
l1 = uint16(mouthtemp(1)-templ);
l2 = uint16(mouthtemp(1)+templ);
r1 = uint16(mouthtemp(2)-templ);
r2 = uint16(mouthtemp(2)+templ);
if l1<=1
    l1=1;
end
if l2>M
    l2=M;
end
if r1<=1
    r1=1;
end
if r2>N
    r2=N;
end
MouthMask(l1:l2,r1:r2) = 1;

