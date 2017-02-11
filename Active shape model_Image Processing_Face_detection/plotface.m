function plotface(img,X,Y,tri)

figure(img);
hold on,
for i=1:size(tri,1)
    plot( [X(tri(i,:));X(tri(i,1))], [Y(tri(i,:));Y(tri(i,1))],'w-','Linewidth',2)
end
plot(X,Y,'b*','Linewidth',4);


