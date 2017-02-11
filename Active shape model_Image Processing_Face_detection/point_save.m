function point_save(Xo,Yo,pathname,box,k)
%% uncomment this is u want control over the saving part--%

ButtonName = questdlg('Do you want to save the changes?','ASM/AAM training','OK','NO','NO');
if( strcmp(ButtonName,'NO') )
   %close all;
   return; 
end
close all;

%% save to a file 
filename = strcat(pathname, num2str(k), '.ppm');
X = Xo+box(1)-1;
Y = Yo+box(2)-1; 
%figure;subplot(121);plot(Xo,Yo);subplot(122);plot(X,Y);
landmarkfile = [filename(1:find(filename=='.')-1),'.m'];
fid = fopen( [landmarkfile], 'w'); %open file for writing; discard existing contents
fprintf(fid,'%6.2f %6.2f\r\n', [X,Y]');
fclose(fid);
