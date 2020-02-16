
function [u1,u2,u3,u4,u5,u6,u7]=controller1(states, wc);


%Input and Design parameters

% wc=0.1;
we=1-wc;

Ts =0.3; %% Sampling Period

Wr=100; % weight on R
Wq=50;

%Np=1; % Prediction horizon
pHorizon=1;

% Room Tempareture Set-point
set_point=295.15;

% Constraints
u_max=10.0;
u_min=-10.0;
y_max=305.15;
y_min=280.15;



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



    
Bc = [0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0;
     m1 0 0 0 0 0 0;
     0 m2 0 0 0 0 0;
     0 0 m3 0 0 0 0;
     0 0 0 m4 0 0 0;
     0 0 0 0 m5 0 0;
     0 0 0 0 0 m6 0;
     0 0 0 0 0 0 m7];

  
Cc = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
Dc = [0];



%%%%%%%%%%%%%%% F matrix
%% Should populate here




sys_ss = ss(Ac,Bc,Cc,Dc);



%% Dicritize 
sys_d = c2d(sys_ss,Ts,'zoh');
Ap = sys_d.a;
Bp = sys_d.b;
Cp = sys_d.c;
Dp = sys_d.d;

%Co = ctrb(Ap,Bp);
%Cunco = length(Ap) - rank(Co)


[Ny,Nx]=size(Cp); % Ny=> no. of outputs; Nx=>no. of states; Nu=>no. on inputs
[Nx,Nu]=size(Bp);
%[Nx,Nd]=size(F); % Nd=> no. of distrurbance


%%%%%%%%%%%%%%% F matrix
F=zeros(Nx,1);


[Nx,Nd]=size(F); % Nd=> no. of distrurbance

%%%%%%%%%%%% Ref vector

% Room Tempareture Set-point
Ref=zeros(Ny*pHorizon,1);
for i=1:Ny*pHorizon
Ref(i,1)=set_point;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Current State
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Take from arument

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Disturbance Vector		% may be zero%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D=zeros(Nd*pHorizon,1);
%D=randi(5,Nd*pHorizon,1);
%D=D+308.15;


% Creation of A_prime

A_prime=zeros(Nx*pHorizon,Nx);

A_prime(1:Nx,1:Nx)=Ap;
for i=2:pHorizon
z=i-1;
x=i-2;
A_prime(z*Nx+1:z*Nx+Nx,1:Nx)=A_prime(x*Nx+1:x*Nx+Nx,1:Nx)*Ap;
end
%A_prime


% Creation of B_prime
B_prime=zeros(Nx*pHorizon,Nu*pHorizon);

B_prime(1:Nx,1:Nu)=Bp;
for i=2:pHorizon
z=i-1;
x=i-2;
B_prime(z*Nx+1:z*Nx+Nx,1:Nu)=Ap*B_prime(x*Nx+1:x*Nx+Nx,1:Nu);
end

for j=2:pHorizon
z=j-1;
B_prime(z*Nx+1:Nx*pHorizon,z*Nu+1:z*Nu+Nu)=B_prime(1:Nx*pHorizon-z*Nx,1:Nu);
end
%B_prime


% Creation of F_prime
F_prime=zeros(Nx*pHorizon,Nd*pHorizon);

F_prime(1:Nx,1:Nd)=F;
for i=2:pHorizon
z=i-1;
x=i-2;
F_prime(z*Nx+1:z*Nx+Nx,1:Nd)=Ap*F_prime(x*Nx+1:x*Nx+Nx,1:Nd);
end

for j=2:pHorizon
z=j-1;
F_prime(z*Nx+1:Nx*pHorizon,z*Nd+1:z*Nd+Nd)=F_prime(1:Nx*pHorizon-z*Nx,1:Nd);
end


% Creation of Z

Z=ones(Ny*pHorizon,Nx);

Z(1:Ny,1:Nx)=Cp*Ap;
for i=2:pHorizon
y=i-1;
x=i-2;
Z(y*Ny+1:y*Ny+Ny,1:Nx)=Z(x*Ny+1:x*Ny+Ny,1:Nx)*Ap;
end


% Creation of H

H=zeros(Ny*pHorizon,Nu*pHorizon);

H(1:Ny,1:Nu)=Cp*Bp;
temp=Cp;
for i=2:pHorizon
temp=temp*Ap;
z=i-1;
H(z*Ny+1:z*Ny+Ny,1:Nu)=temp*Bp;
end

for j=2:pHorizon
z=j-1;
H(z*Ny+1:Ny*pHorizon,z*Nu+1:z*Nu+Nu)=H(1:Ny*pHorizon-z*Ny,1:Nu);
end
%H

% Creation of Theta

Theta=zeros(Ny*pHorizon,Nd*pHorizon);

Theta(1:Ny,1:Nd)=Cp*F;
temp=Cp;
for i=2:pHorizon
temp=temp*Ap;
z=i-1;
Theta(z*Ny+1:z*Ny+Ny,1:Nd)=temp*F;
end

for j=2:pHorizon
z=j-1;
Theta(z*Ny+1:Ny*pHorizon,z*Nd+1:z*Nd+Nd)=Theta(1:Ny*pHorizon-z*Ny,1:Nd);
end
%Theta

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Creation of Qp or P
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Qp=zeros(Nu*pHorizon,Nu*pHorizon);

Q=eye(Ny*pHorizon,Ny*pHorizon);
R=eye(Nu*pHorizon,Nu*pHorizon);

Q=Wq*wc*Q;
R=Wr*we*R;

Qp=H'*Q*H + R;

Qp_inv=inv(Qp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Creation of Fp or q
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fp1=H'*Q*Theta;  
Fp2=H'*Q*Z;
Fp3=0.5 .* H'*Q*Ref;

 Fp=Fp1*D+Fp2*states-Fp3;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Creation of Mp or r
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mp1=Z'*Q*Z;
Mp2=Theta'*Q*Z;
Mp3=Theta'*Q*Theta;
Mp4=Ref'*Q*Z;
Mp5=Ref'*Q*Theta;
Mp6=Ref'*Q*Ref;

Mp= 0.5 .* states'*Mp1*states + D'*Mp2*states+ 0.5 .*D'*Mp3*D - 0.5 .*Mp4*states - 0.5 .*Mp5*D + 0.5*Mp6;
Mp=2*Mp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Creation of Gp or M
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assume Nu=Ny

Gp=zeros(2*(Ny+Nu)*pHorizon,Nu*pHorizon);
%Gp=zeros((Ny+Nu)*pHorizon,Nu*pHorizon);

Gp(1:Nu*pHorizon,:)=eye(Nu*pHorizon,Nu*pHorizon);
Gp(Nu*pHorizon+1:2*Nu*pHorizon,:)=-1 .*eye(Nu*pHorizon,Nu*pHorizon);
Gp(2*Nu*pHorizon+1:3*Nu*pHorizon,:)=H;
%Gp(3*Nu*pHorizon+1:4*Nu*pHorizon,:)=-1 .*H;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Creation of Kp or gamma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assume Nu=Ny

Kp=zeros(2*(Ny+Nu)*pHorizon,1);
%Kp=zeros((Ny+Nu)*pHorizon,1);

Kp(1:Nu*pHorizon,:)=u_max .*ones(Nu*pHorizon,1);
Kp(Nu*pHorizon+1:2*Nu*pHorizon,:)=-u_min .*ones(Nu*pHorizon,1);
Kp(2*Nu*pHorizon+1:3*Nu*pHorizon,:)=y_max .*ones(Nu*pHorizon,1) - Z * states - Theta * D;
%Kp(3*Nu*pHorizon+1:4*Nu*pHorizon,:)=-y_min .*ones(Nu*pHorizon,1) + Z * states + Theta * D;



%U=quadprog(Qp,Fp)

options = optimoptions('quadprog',...
    'Algorithm','interior-point-convex','Display','iter','MaxIterations',100000);
eta=quadprog(Qp,Fp,Gp,Kp,[],[],[],[],[],options);


%eta=quadprog(Qp,Fp,Gp,Kp);

u1=eta(1,1);
u2=eta(2,1);
u3=eta(3,1);
u4=eta(4,1);
u5=eta(5,1);
u6=eta(6,1);
u7=eta(7,1);





end
