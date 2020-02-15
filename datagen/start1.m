% Seven Room Building


%Input and Design parameters

kf=1.675; %fan effeciency

Ts =0.3; %% Sampling Period


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
To=285;
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

R1 = (2*hi*a1*a1*k)/(2*k*a1 + hi*a1*l);
R2 = (2*hi*a2*a2*k)/(2*k*a2 + hi*a2*l);
R3 = (2*hi*a3*a3*k)/(2*k*a3 + hi*a3*l);
R4 = (2*hi*a4*a4*k)/(2*k*a4 + hi*a4*l);
R5 = (2*hi*a5*a5*k)/(2*k*a5 + hi*a5*l);
R6 = (2*hi*a6*a6*k)/(2*k*a6 + hi*a6*l);
R7 = (2*hi*a7*a7*k)/(2*k*a7 + hi*a7*l);
R8 = (2*hi*a8*a8*k)/(2*k*a8 + hi*a8*l);
R9 = (2*hi*a9*a9*k)/(2*k*a9 + hi*a9*l);
R10 = (2*hi*a10*a10*k)/(2*k*a10 + hi*a10*l);
R11 = (2*hi*a11*a11*k)/(2*k*a11 + hi*a11*l);
R12 = (2*hi*a12*a12*k)/(2*k*a12 + hi*a12*l);
R13 = (2*hi*a13*a13*k)/(2*k*a13 + hi*a13*l);
R14 = (2*hi*a14*a14*k)/(2*k*a14 + hi*a14*l);
R15 = (2*hi*a15*a15*k)/(2*k*a15 + hi*a15*l);
R16 = (2*hi*a16*a16*k)/(2*k*a16 + hi*a16*l);
R17 = (2*hi*a17*a17*k)/(2*k*a17 + hi*a17*l);
R18 = (2*hi*a18*a18*k)/(2*k*a18 + hi*a18*l);
R19 = (2*hi*a19*a19*k)/(2*k*a19 + hi*a19*l);
R20 = (2*hi*a20*a20*k)/(2*k*a20 + hi*a20*l);
R21 = (2*hi*a21*a21*k)/(2*k*a21 + hi*a21*l);
R22 = (2*hi*a22*a22*k)/(2*k*a22 + hi*a22*l);


R_1 = ((2*hi*a1*a1*k)/(2*k*a1 + hi*a1*l)) + ((2*ho*a1*a1*k)/(2*k*a1 + ho*a1*l));
R_2 = ((2*hi*a2*a2*k)/(2*k*a2 + hi*a2*l)) + ((2*ho*a2*a2*k)/(2*k*a2 + ho*a2*l));
R_3 = ((2*hi*a3*a3*k)/(2*k*a3 + hi*a3*l)) + ((2*ho*a3*a3*k)/(2*k*a3 + ho*a3*l));
R_4 = ((2*hi*a4*a4*k)/(2*k*a4 + hi*a4*l)) + ((2*ho*a4*a4*k)/(2*k*a4 + ho*a4*l));
R_5 = ((2*hi*a5*a5*k)/(2*k*a5 + hi*a5*l)) + ((2*ho*a5*a5*k)/(2*k*a5 + ho*a5*l));
R_6 = ((2*hi*a6*a6*k)/(2*k*a6 + hi*a6*l)) + ((2*ho*a6*a6*k)/(2*k*a6 + ho*a6*l));
R_7 = ((2*hi*a7*a7*k)/(2*k*a7 + hi*a7*l)) + ((2*ho*a7*a7*k)/(2*k*a7 + ho*a7*l));
R_8 = ((2*hi*a8*a8*k)/(2*k*a8 + hi*a8*l)) + ((2*ho*a8*a8*k)/(2*k*a8 + ho*a8*l));
R_9 = ((2*hi*a9*a9*k)/(2*k*a9 + hi*a9*l)) + ((2*ho*a9*a9*k)/(2*k*a9 + ho*a9*l));
R_10 = ((2*hi*a10*a10*k)/(2*k*a10 + hi*a10*l)) + ((2*ho*a10*a10*k)/(2*k*a10 + ho*a10*l));
R_11 = ((2*hi*a11*a11*k)/(2*k*a11 + hi*a11*l)) + ((2*ho*a11*a11*k)/(2*k*a11 + ho*a11*l));
R_12 = ((2*hi*a12*a12*k)/(2*k*a12 + hi*a12*l)) + ((2*ho*a12*a12*k)/(2*k*a12 + ho*a12*l));
R_13 = ((2*hi*a13*a13*k)/(2*k*a13 + hi*a13*l)) + ((2*ho*a13*a13*k)/(2*k*a13 + ho*a13*l));
R_14 = ((2*hi*a14*a14*k)/(2*k*a14 + hi*a14*l)) + ((2*ho*a14*a14*k)/(2*k*a14 + ho*a14*l));
R_15 = ((2*hi*a15*a15*k)/(2*k*a15 + hi*a15*l)) + ((2*ho*a15*a15*k)/(2*k*a15 + ho*a15*l));
R_16 = ((2*hi*a16*a16*k)/(2*k*a16 + hi*a16*l)) + ((2*ho*a16*a16*k)/(2*k*a16 + ho*a16*l));
R_17 = ((2*hi*a17*a17*k)/(2*k*a17 + hi*a17*l)) + ((2*ho*a17*a17*k)/(2*k*a17 + ho*a17*l));
R_18 = ((2*hi*a18*a18*k)/(2*k*a18 + hi*a18*l)) + ((2*ho*a18*a18*k)/(2*k*a18 + ho*a18*l));
R_19 = ((2*hi*a19*a19*k)/(2*k*a19 + hi*a19*l)) + ((2*ho*a19*a19*k)/(2*k*a19 + ho*a19*l));
R_20 = ((2*hi*a20*a20*k)/(2*k*a20 + hi*a20*l)) + ((2*ho*a20*a20*k)/(2*k*a20 + ho*a20*l));
R_21 = ((2*hi*a21*a21*k)/(2*k*a21 + hi*a21*l)) + ((2*ho*a21*a21*k)/(2*k*a21 + ho*a21*l));
R_22 = ((2*hi*a22*a22*k)/(2*k*a22 + hi*a22*l)) + ((2*ho*a22*a22*k)/(2*k*a22 + ho*a22*l));

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

cw1=1/(pw*vw1*cpw);
cw2=1/(pw*vw2*cpw);
cw3=1/(pw*vw3*cpw);
cw4=1/(pw*vw4*cpw);
cw5=1/(pw*vw5*cpw);
cw6=1/(pw*vw6*cpw);
cw7=1/(pw*vw7*cpw);
cw8=1/(pw*vw8*cpw);
cw9=1/(pw*vw9*cpw);
cw10=1/(pw*vw10*cpw);
cw11=1/(pw*vw11*cpw);
cw12=1/(pw*vw12*cpw);
cw13=1/(pw*vw13*cpw);
cw14=1/(pw*vw14*cpw);
cw15=1/(pw*vw15*cpw);
cw16=1/(pw*vw16*cpw);
cw17=1/(pw*vw17*cpw);
cw18=1/(pw*vw18*cpw);
cw19=1/(pw*vw19*cpw);
cw20=1/(pw*vw20*cpw);
cw21=1/(pw*vw21*cpw);
cw22=1/(pw*vw22*cpw);



p11=R_1*cw1;
p22=R_2*cw2;
p33=R_3*cw3;
p44=R_4*cw4;
p55=R_5*cw5;
p66=R_6*cw6;
p77=R_7*cw7;
p88=R_8*cw8;
p99=R_9*cw9;
p1010=R_10*cw10;
p1111=R_11*cw11;
p1212=R_12*cw12;
p1313=2*R13*cw13; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Inner Wall start
p1414=2*R14*cw14;
p1515=2*R15*cw15;
p1616=2*R16*cw16;
p1717=2*R17*cw17;
p1818=2*R18*cw18;
p1919=2*R19*cw19;
p2020=2*R20*cw20;
p2121=2*R21*cw21;
p2222=2*R22*cw22;



p_1=R1*cw1;
p_2=R2*cw2;
p_3=R3*cw3;
p_4=R4*cw4;
p_5=R5*cw5;
p_6=R6*cw6;
p_7=R7*cw7;
p_8=R8*cw8;
p_9=R9*cw9;
p_10=R10*cw10;
p_11=R11*cw11;
p_12=R12*cw12;
p_13=R13*cw13;
p_14=R14*cw14;
p_15=R15*cw15;
p_16=R16*cw16;
p_17=R17*cw17;
p_18=R18*cw18;
p_19=R19*cw19;
p_20=R20*cw20;
p_21=R21*cw21;
p_22=R22*cw22;




%% State Space Model of Plant
Ac = [-p11 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 p_1 0 0 0 0 0 0;
     0 -p22 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 p_2 0 0 0 0 0 0;
     0 0 -p33 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 p_3 0 0 0 0 0;
     0 0 0 -p44 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 p_4 0 0 0 0;
     0 0 0 0 -p55 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 p_5 0 0 0 0;
     0 0 0 0 0 -p66 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 p_6 0 0 0;
     0 0 0 0 0 0 -p77 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 p_7;
     0 0 0 0 0 0 0 -p88 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 p_8;
     0 0 0 0 0 0 0 0 -p99 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 p_9 0;
     0 0 0 0 0 0 0 0 0 -p1010 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 p_10 0 0;
     0 0 0 0 0 0 0 0 0 0 -p1111 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 p_11 0 0;
     0 0 0 0 0 0 0 0 0 0 0 -p1212 0 0 0 0 0 0 0 0 0 0 0 0 0 p_12 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 -p1313 0 0 0 0 0 0 0 0 0 p_13 p_13 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 -p1414 0 0 0 0 0 0 0 0 p_14 0 0 p_14 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 -p1515 0 0 0 0 0 0 0 0 p_15 p_15 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -p1616 0 0 0 0 0 0 0 p_16 0 p_16 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -p1717 0 0 0 0 0 0 0 p_17 p_17 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -p1818 0 0 0 0 0 0 0 p_18 p_18 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -p1919 0 0 0 0 0 0 0 p_19 p_19 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -p2020 0 0 0 0 0 p_20 0 p_20 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -p2121 0 0 0 0 0 0 p_21 p_21;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -p2222 0 0 0 p_22 0 0 p_22;
     cr1*R1 cr1*R2 0 0 0 0 0 0 0 0 0 0 cr1*R13 cr1*R14 0 0 0 0 0 0 0 0 a 0 0 0 0 0 0;
     0 0 cr2*R3 0 0 0 0 0 0 0 0 0 cr2*R13 0 cr2*R15 cr2*R16 0 0 0 0 0 0 0 b 0 0 0 0 0;
     0 0 0 cr3*R4 cr3*R5 0 0 0 0 0 0 0 0 0 cr3*R15 0 cr3*R17 0 0 0 0 0 0 0 c 0 0 0 0;
     0 0 0 0 0 cr4*R6 0 0 0 0 0 cr4*R12 0 cr4*R14 0 cr4*R16 cr4*R17 cr4*R18 0 cr4*R20 0 cr4*R22 0 0 0 d 0 0 0;
     0 0 0 0 0 0 0 0 0 cr5*R10 cr5*R11 0 0 0 0 0 0 cr5*R18 cr5*R19 0 0 0 0 0 0 0 e 0 0;
     0 0 0 0 0 0 0 0 cr6*R9 0 0 0 0 0 0 0 0 0 cr6*R19 cr6*R20 cr6*R21 0 0 0 0 0 0 f 0;
     0 0 0 0 0 0 cr7*R7 cr7*R8 0 0 0 0 0 0 0 0 0 0 0 0 cr7*R21 cr7*R22 0 0 0 0 0 0 g];





m1=cp*cr1*(To - Temp);
m2=cp*cr2*(To - Temp);
m3=cp*cr3*(To - Temp);
m4=cp*cr4*(To - Temp);
m5=cp*cr5*(To - Temp);
m6=cp*cr6*(To - Temp);
m7=cp*cr7*(To - Temp);

%Disturbance matrix

f1=((2*ho*a1*a1*k)/(2*k*a1 + ho*a1*l)) * cw1
f2=((2*ho*a2*a2*k)/(2*k*a2 + ho*a2*l)) * cw2;
f3=((2*ho*a3*a3*k)/(2*k*a3 + ho*a3*l)) * cw3;
f4=((2*ho*a4*a4*k)/(2*k*a4 + ho*a4*l)) * cw4;
f5=((2*ho*a5*a5*k)/(2*k*a5 + ho*a5*l)) * cw5;
f6=((2*ho*a6*a6*k)/(2*k*a6 + ho*a6*l)) * cw6;
f7=((2*ho*a7*a7*k)/(2*k*a7 + ho*a7*l)) * cw7;
f8=((2*ho*a8*a8*k)/(2*k*a8 + ho*a8*l)) * cw8;
f9=((2*ho*a9*a9*k)/(2*k*a9 + ho*a9*l)) * cw9;
f10=((2*ho*a10*a10*k)/(2*k*a10 + ho*a10*l)) * cw10;
f11=((2*ho*a11*a11*k)/(2*k*a11 + ho*a11*l)) * cw11;
f12=((2*ho*a12*a12*k)/(2*k*a12 + ho*a12*l)) * cw12;
f13=0;
f14=0;
f15=0;
f16=0;
f17=0;
f18=0;
f19=0;
f20=0;
f21=0;
f22=0;
f23=0;
f24=0;
f25=0;
f26=0;
f27=0;
f28=0;
f29=0;

F=[f1;f2;f3;f4;f5;f6;f7;f8;f9;f10;f11;f12;f13;f14;f15;f16;f17;f18;f19;f20;f21;f22;f23;f24;f25;f26;f27;f28;f29];
%Fd=ss(F,Ts)




    
Bc =[0 0 0 0 0 0 0 f1;
     0 0 0 0 0 0 0 f2;
     0 0 0 0 0 0 0 f3;
     0 0 0 0 0 0 0 f4;
     0 0 0 0 0 0 0 f5;
     0 0 0 0 0 0 0 f6;
     0 0 0 0 0 0 0 f7;
     0 0 0 0 0 0 0 f8;
     0 0 0 0 0 0 0 f9;
     0 0 0 0 0 0 0 f10;
     0 0 0 0 0 0 0 f11;
     0 0 0 0 0 0 0 f12;
     0 0 0 0 0 0 0 f13;
     0 0 0 0 0 0 0 f14;
     0 0 0 0 0 0 0 f15;
     0 0 0 0 0 0 0 f16;
     0 0 0 0 0 0 0 f17;
     0 0 0 0 0 0 0 f18;
     0 0 0 0 0 0 0 f19;
     0 0 0 0 0 0 0 f20;
     0 0 0 0 0 0 0 f21;
     0 0 0 0 0 0 0 f22;
     m1 0 0 0 0 0 0 f23;
     0 m2 0 0 0 0 0 f24;
     0 0 m3 0 0 0 0 f25;
     0 0 0 m4 0 0 0 f26;
     0 0 0 0 m5 0 0 f27;
     0 0 0 0 0 m6 0 f28;
     0 0 0 0 0 0 m7 f29];

  
Cc = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
Dc = [0];



sys_ss = ss(Ac,Bc,Cc,Dc);



%% Dicritize 
sys_d = c2d(sys_ss,Ts,'zoh');
Ap = sys_d.a;
Bp = sys_d.b
Cp = sys_d.c;
Dp = sys_d.d;

%Co = ctrb(Ap,Bp);
%Sunco = length(Ap) - rank(Co)



[Nx,Nu]=size(Bp); % Nx=> no. of states Nu=> no. of control inputs
[Ny,Nx]=size(Cp); % Ny=> no. of outputs

% Initial State

states=zeros(Nx,1);
%states=randi(5,Nx,1);
states=states+303.15;


states_old=zeros(Nx,1);
y=zeros(Ny,1); % outputs vector



fileID=fopen('weather.txt','r');
weather=fscanf(fileID,'%f');
fclose(fileID);

[N_sim, column]=size(weather);

%N_sim=1;

%%%%%%%%%%%%%%%% Data structure to store data
states_data=zeros(Nx,N_sim);
y_data=zeros(Ny,N_sim);
u_data=zeros(Nu,N_sim);
power_data=zeros(1,N_sim);
energy_data=zeros(1,N_sim);
temp_diff_data=zeros(Ny,N_sim);


sample_time=300; % simulation sample time =5min
Iner_N_sim=ceil(sample_time/Ts-1);


states_data(:,1)=states;

for k=1:N_sim;
	%%%%%%% call controller

	[u1,u2,u3,u4,u5,u6,u7]=controller1(states);


	m=u1+u2+u3+u4+u5+u6+u7;
	u=zeros(Nu,1);
	dis=273.15+weather(k,1);
	u=[u1;u2;u3;u4;u5;u6;u7;dis];

	


	%%%%%%% Plant simulation
	%for i=1:Iner_N_sim;
		states_old=states;

		states=Ap*states_old + Bp*u;
		y=Cp*states;
	%end

	%%%%%% Calculate Power & Energy consumption
	power=kf*m*m;


	%%%%%% store data for plot
	states_data(:,k+1)=states;
	y_data(:,k)=y;
	u_data(:,k)=u;
	power_data(:,k)=power;
	%energy_data(:,k)=
	temp_diff_data(:,k)=Ref-y;

end

%%%%%% Dump data into file

	fileID=fopen('States_Data.txt','w');
	fprintf(fileID,'%f ',states_data);
	fclose(fileID);
	fileID=fopen('States_Data.txt','a');
	fprintf(fileID,'%s','#');
	fclose(fileID);
    save('states_data.mat', 'states_data');


	fileID=fopen('Room_Temp_Data.txt','w');
	fprintf(fileID,'%f ',y_data);
	fclose(fileID);
	fileID=fopen('Room_Temp_Data.txt','a');
	fprintf(fileID,'%s','#');
	fclose(fileID);
    save('Room_Temp_Data.mat', 'y_data');


	fileID=fopen('Air_Flow_Rate_Data.txt','w');
	fprintf(fileID,'%f ',u_data);
	fclose(fileID);
	fileID=fopen('Air_Flow_Rate_Data.txt','a');
	fprintf(fileID,'%s','#');
	fclose(fileID);
    save('Air_Flow_Rate_data.mat', 'u_data');
    

	fileID=fopen('Temp_Diff_Desire_Data.txt','w');
	fprintf(fileID,'%f ',temp_diff_data);
	fclose(fileID);
	fileID=fopen('Temp_Diff_Desire_Data.txt','a');
	fprintf(fileID,'%s','#');
	fclose(fileID);
    save('Temp_Diff_Desire_Data.mat', 'temp_diff_data');



	fileID=fopen('Power_Data.txt','w');
	fprintf(fileID,'%f ',power_data);
	fclose(fileID);
	fileID=fopen('Power_Data.txt','a');
	fprintf(fileID,'%s','#');
	fclose(fileID);
    save('Power_Data.mat', 'power_data');
