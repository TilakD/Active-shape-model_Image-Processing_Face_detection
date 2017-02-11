function facial_point_correction (Xo,Yo,h1,h2,pathname,box,k)
%% move point by two 
while 1
    %figure;
    hold on,    
    title('Select point(left click) or quit(right click)');   
    [xc,yc,button] = ginput(1);

    if (button==3)  %Right leg of the mouse    
     break
    end      
    %select the nearest point
    
    [val,ind]=min((xc-Xo).^2 + (yc-Yo).^2);    
    title('Left click for new position,right click to quit ');   
    [xc,yc,button] = ginput(1);
    Xo(ind)=xc;  
    Yo(ind)=yc;
    
    delete(h1);delete(h2);    
    h1 = plot(Xo(1:17),Yo(1:17),'w-',Xo(18:27),Yo(18:27),'w-',Xo(49:68),Yo(49:68),'w-','Linewidth',1);
    h2=plot(Xo,Yo,'*','Linewidth',4);
    drawnow('expose'); % "flushes the event queue" and updates the figure window
end %while 
point_save(Xo,Yo,pathname,box,k)