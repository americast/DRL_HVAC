function []=start3(done)
% Seven Room Building
if count(py.sys.path,'') == 0
    insert(py.sys.path,int32(0),'');
end

%Input and Design parameters
kf=1.675; %fan effeciency

Ts =0.1; %% Sampling Period

initial=303.15;


fileID=fopen('data/weather.txt','r');
weather=fscanf(fileID,'%f');
fclose(fileID);

[N_sim, column]=size(weather);

%N_sim=1;


n_in= 7; % no of input to the plant; it should be varry w.r.t plant


% Room Tempareture Set-point
r1_temp=295.15;
r2_temp=295.15;
r3_temp=295.15;
r4_temp=295.15;
r5_temp=295.15;
r6_temp=295.15;
r7_temp=295.15;

Ref=[r1_temp;r2_temp;r3_temp;r4_temp;r5_temp;r6_temp;r7_temp];





%% Plant Parameter

cp=1.006;
To=285.15;
Temp=0; % Set point temperature; included in B matrix; to exclude from B matrix set to 0


hi=3;
ho=10;

k=100;
l=0.3;

pa=1.05;
cpa=1.007;

v1=80;
v2=100;
v3=140;
v4=192;
v5=140;
v6=100;
v7=80;

pw=1.5;
cpw=1;

vw1=6;
vw2=4.8;
vw3=6;
vw4=8.4;
vw5=6;
vw6=3.6;
vw7=6;
vw8=4.8;
vw9=6;
vw10=8.4;
vw11=6;
vw12=3.6;
vw13=6;
vw14=4.8;
vw15=6;
vw16=6;
vw17=8.4;
vw18=8.4;
vw19=6;
vw20=6;
vw21=6;
vw22=4.8;

a1=20;
a2=16;
a3=20;
a4=28;
a5=20;
a6=12;
a7=20;
a8=16;
a9=20;
a10=28;
a11=20;
a12=12;
a13=20;
a14=16;
a15=20;
a16=20;
a17=28;
a18=28;
a19=20;
a20=20;
a21=20;
a22=16;

R1 = (hi*ho*k*a1)/(ho*k+hi*k+hi*ho*l);
R2 = (hi*ho*k*a2)/(ho*k+hi*k+hi*ho*l);
R3 = (hi*ho*k*a3)/(ho*k+hi*k+hi*ho*l);
R4 = (hi*ho*k*a4)/(ho*k+hi*k+hi*ho*l);
R5 = (hi*ho*k*a5)/(ho*k+hi*k+hi*ho*l);
R6 = (hi*ho*k*a6)/(ho*k+hi*k+hi*ho*l);
R7 = (hi*ho*k*a7)/(ho*k+hi*k+hi*ho*l);
R8 = (hi*ho*k*a8)/(ho*k+hi*k+hi*ho*l);
R9 = (hi*ho*k*a9)/(ho*k+hi*k+hi*ho*l);
R10 = (hi*ho*k*a10)/(ho*k+hi*k+hi*ho*l);
R11 = (hi*ho*k*a11)/(ho*k+hi*k+hi*ho*l);
R12 = (hi*ho*k*a12)/(ho*k+hi*k+hi*ho*l);
R13 = (hi*k*a13)/(2*k+hi*l);
R14 = (hi*k*a14)/(2*k+hi*l);
R15 = (hi*k*a15)/(2*k+hi*l);
R16 = (hi*k*a16)/(2*k+hi*l);
R17 = (hi*k*a17)/(2*k+hi*l);
R18 = (hi*k*a18)/(2*k+hi*l);
R19 = (hi*k*a19)/(2*k+hi*l);
R20 = (hi*k*a20)/(2*k+hi*l);
R21 = (hi*k*a21)/(2*k+hi*l);
R22 = (hi*k*a22)/(2*k+hi*l);




cr1=1/(pa*v1*cpa);
cr2=1/(pa*v2*cpa);
cr3=1/(pa*v3*cpa);
cr4=1/(pa*v4*cpa);
cr5=1/(pa*v5*cpa);
cr6=1/(pa*v6*cpa);
cr7=1/(pa*v7*cpa);

a=(-1)*cr1*(R1 + R2 + R13 + R14);
b=(-1)*cr2*(R3 + R13 + R15 + R16);
c=(-1)*cr3*(R4 + R5 + R15 + R17);
d=(-1)*cr4*(R6 + R12 + R14 + R16 + R17 + R18 + R20 + R22);
e=(-1)*cr5*(R10 + R11 + R18 + R19);
f=(-1)*cr6*(R9 + R19 + R20 + R21);
g=(-1)*cr7*(R7 + R8 + R21 + R22);







%% State Space Model of Plant
Ac =[a cr1*R13 0 cr1*R14 0 0 0 ;
     cr2*R13 b cr2*R15 cr2*R16 0 0 0 ;
     0 cr3*R15 c cr3*R17 0 0 0 ;
     cr4*R14 cr4*R16 cr4*R17 d cr4*R18 cr4*R20 cr4*R22 ;
     0 0 0 cr5*R18 e cr5*R19 0 ;
     0 0 0 cr6*R20 cr6*R19 f cr6*R21 ;
     0 0 0 cr7*R22 0 cr7*R21 g ];





m1=cp*cr1*(Temp - To);
m2=cp*cr2*(Temp - To);
m3=cp*cr3*(Temp - To);
m4=cp*cr4*(Temp - To);
m5=cp*cr5*(Temp - To);
m6=cp*cr6*(Temp - To);
m7=cp*cr7*(Temp - To);

%Disturbance matrix

f1=cr1*(R1+R2);
f2=cr2*R3;
f3=cr3*(R4+R5);
f4=cr4*(R6+R12);
f5=cr5*(R10+R11);
f6=cr6*R9;
f7=cr7*(R7+R8);


F=[f1;f2;f3;f4;f5;f6;f7];





    
Bc =[m1 0 0 0 0 0 0 f1;
     0 m2 0 0 0 0 0 f2;
     0 0 m3 0 0 0 0 f3;
     0 0 0 m4 0 0 0 f4;
     0 0 0 0 m5 0 0 f5;
     0 0 0 0 0 m6 0 f6;
     0 0 0 0 0 0 m7 f7];

  
Cc =[ 1 0 0 0 0 0 0;
      0 1 0 0 0 0 0;
      0 0 1 0 0 0 0;
      0 0 0 1 0 0 0;
      0 0 0 0 1 0 0;
      0 0 0 0 0 1 0;
      0 0 0 0 0 0 1];
Dc = [0];



sys_ss = ss(Ac,Bc,Cc,Dc);



%% Dicritize 
sys_d = c2d(sys_ss,Ts,'zoh');
Ap = sys_d.a;
Bp = sys_d.b;
Cp = sys_d.c;
Dp = sys_d.d;

Co = ctrb(Ap,Bp);
Sunco = length(Ap) - rank(Co)



[Nx,Nu]=size(Bp); % Nx=> no. of states Nu=> no. of control inputs
[Ny,Nx]=size(Cp); % Ny=> no. of outputs

% Initial State

states=zeros(Nx,1);
%states=randi(5,Nx,1);
states=states+initial;


states_old=zeros(Nx,1);
y=zeros(Ny,1); % outputs vector





%%%%%%%%%%%%%%%% Data structure to store data
states_data=zeros(Nx,N_sim);
y_data=zeros(Ny,N_sim);
u_data=zeros(Nu-1,N_sim);
power_data=zeros(1,N_sim);
energy_data=zeros(1,N_sim);
temp_diff_data=zeros(Ny,N_sim);


sample_time=300; % simulation sample time =5min
Iner_N_sim=ceil(sample_time/Ts-1);


states_data(:,1)=states;

for k=1:N_sim;
	%%%%%%% call controller
%     to_send = py.list({num2str(states(1)), num2str(states(2)), num2str(states(3)), num2str(states(4)), num2str(states(5)), num2str(states(6)), num2str(states(7))});
	l = py.caller.hello(py.list({states(1), states(2), states(3), states(4), states(5), states(6), states(7), done}));
    u1 = l{1};
    u2 = l{2};
    u3 = l{3};
    u4 = l{4};
    u5 = l{5};
    u6 = l{6};
    u7 = l{7};


	
	dis=273.15+weather(k,1);
	u=[-u1;-u2;-u3;-u4;-u5;-u6;-u7;dis];

	


	%%%%%%% Plant simulation
	for i=1:Iner_N_sim;
		states_old=states;

		states=Ap*states_old + Bp*u;
		y=Cp*states;
	end

	%%%%%% Calculate Power & Energy consumption
	if u1<0
	  u1=-1*u1;
	end

	if u2<0
	  u2=-1*u2;
	end

	if u3<0
	  u3=-1*u3;
	end

	if u4<0
	  u4=-1*u4;
	end

	if u5<0
	  u5=-1*u5;
	end

	if u6<0
	  u6=-1*u6;
	end

	if u7<0
	  u7=-1*u7;
	end

	u=[u1;u2;u3;u4;u5;u6;u7];
	m=u1+u2+u3+u4+u5+u6+u7;
	
	power_f=kf*m*m;

	ret_air_temp=(u1*y(1,1) + u2*y(2,1) + u3*y(3,1) + u4*y(4,1) + u5*y(5,1) + u6*y(6,1) + u7*y(7,1))/m;
	frac=0.9;
	%supply_air_temp=(1-frac)*dis + frac*ret_air_temp;
	supply_air_temp=ret_air_temp;

	eta=4;
	power_ch=eta*cp*m*(supply_air_temp - To);

	power=power_f + power_ch;


	%%%%%% store data for plot
	states_data(:,k+1)=states;
	y_data(:,k)=y;
	u_data(:,k)=u;
	power_data(:,k)=power;
	%energy_data(:,k)=
	temp_diff_data(:,k)=Ref-y;

end

%%%%%% Dump data into file

% 	fileID=fopen('States_Data.txt','w');
% 	fprintf(fileID,'%f ',states_data);
% 	fclose(fileID);
% 	fileID=fopen('States_Data.txt','a');
% 	fprintf(fileID,'%s','#');
% 	fclose(fileID);

% 	fileID=fopen('Room_Temp_Data.txt','w');
% 	fprintf(fileID,'%f ',y_data);
% 	fclose(fileID);
% 	fileID=fopen('Room_Temp_Data.txt','a');
% 	fprintf(fileID,'%s','#');
% 	fclose(fileID);
% 
% 
% 	fileID=fopen('Air_Flow_Rate_Data.txt','w');
% 	fprintf(fileID,'%f ',u_data);
% 	fclose(fileID);
% 	fileID=fopen('Air_Flow_Rate_Data.txt','a');
% 	fprintf(fileID,'%s','#');
% 	fclose(fileID);
% 
% 	fileID=fopen('Temp_Diff_Desire_Data.txt','w');
% 	fprintf(fileID,'%f ',temp_diff_data);
% 	fclose(fileID);
% 	fileID=fopen('Temp_Diff_Desire_Data.txt','a');
% 	fprintf(fileID,'%s','#');
% 	fclose(fileID);
% 
% 
% 
% 	fileID=fopen('Power_Data.txt','w');
% 	fprintf(fileID,'%f ',power_data);
% 	fclose(fileID);
% 	fileID=fopen('Power_Data.txt','a');
% 	fprintf(fileID,'%s','#');
% 	fclose(fileID);

%     save('./data/states_data.mat', 'states_data');
%     save('./data/Room_Temp_data.mat', 'y_data');
%     save('./data/Air_Flow_Rate_data.mat', 'u_data');
%     save('./data/Temp_Diff_Desire.mat', 'temp_diff_data');
%     save('./data/Power_data.mat', 'power_data');
