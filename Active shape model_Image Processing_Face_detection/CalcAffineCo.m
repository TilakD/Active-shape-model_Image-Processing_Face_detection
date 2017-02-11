function T = CalcAffineCo(sp,dp)
%transform direction: T*sp-->dp

Y =reshape(dp',6,1);   
xr=sp(:,1)';
yr=sp(:,2)';

X=[xr(1),yr(1),0,0,1,0; 
   0,0,xr(1),yr(1),0,1; 
   xr(2),yr(2),0,0,1,0; 
   0,0,xr(2),yr(2),0,1; 
   xr(3),yr(3),0,0,1,0; 
   0,0,xr(3),yr(3),0,1; ];
 
T=X\Y; %T=[a b c d tx ty]