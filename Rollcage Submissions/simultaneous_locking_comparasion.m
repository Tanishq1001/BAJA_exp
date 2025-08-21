%brake bias is set using specific fric coeff here for (70:30) 0.8 is used 
f = 0.8;
R=0.2921;%radius in metre
m = 290;% mass of vehicle
rear_bias=0.6;
g=9.81;
cog_height= 0.5;
wb= 1.3 ;%wheel base
x = cog_height/wb;
wf=@(a) ((1-rear_bias)+a.*x).*m.*g;%dynamic load transfer front
wr=@(a) ((rear_bias)-a.*x).*m.*g;%dynamic load transfer rear
Tbf_max=@(a) ((1-rear_bias)+a.*x).*f.*R.*m.*g;%SI units  (at diff a)
Tbr_max=@(a) ((rear_bias)-a.*x).*f.*R.*m.*g;%SI units (at diff a)
kbf=0.70;%front_biasing
kbr=0.30;%rear_biasing
fbf_max=((1-rear_bias)+0.8*x)*0.8*m.*g;%in SI units
fbr_max=((rear_bias)-0.8*x)*0.8.*m.*g;%in SI units
v=11.11;
Fb=f*g;%total maxiumum possible friction
To= fbf_max*R/kbf;% calculation of To in SI units
s=@(a) v^2/(2*a*g);%in metre
Tbf=@(a) kbf.*To.*a./0.8;%present friction at front at particular acc
Tbr=@(a) kbr.*To.*a./0.8;%SI units y= mx
%graph
figure;
fplot(Tbf_max,[0,f],"r-.","Linewidth",2)
hold on;
fplot(Tbr_max,[0,f],"b-.","Linewidth",2)
fplot(Tbf,[0,f],"r","Linewidth",2)
fplot(Tbr,[0,f],"b","Linewidth",2)
title(f);
xlabel("acceleration")
ylabel("torque")
grid on;

