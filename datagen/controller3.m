
function [u1,u2,u3,u4,u5,u6,u7]=controller3(states, wc);


%Input and Design parameters

% wc=0.2;
we=1-wc;


Ts =0.1; %% Sampling Period

%Wr=9000; % weight on R for Q=Wq*wc*Q;
%Wq=3.45;

Wr=900; % weight on R for Q=(Wq+wc)*Q;
Wq=2.205;


%Np=1; % Prediction horizon
pHorizon=200;

%pHorizon=ceil(300/Ts-1); % 5min=300s

% Room Tempareture Set-point
set_point=295.15;

% Constraints
u_max=10.0;
u_min=-10.0;
y_max=350.15;
y_min=0.15;



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



    
Bc =[m1 0 0 0 0 0 0;
     0 m2 0 0 0 0 0;
     0 0 m3 0 0 0 0;
     0 0 0 m4 0 0 0;
     0 0 0 0 m5 0 0;
     0 0 0 0 0 m6 0;
     0 0 0 0 0 0 m7];

  
Cc =[ 1 0 0 0 0 0 0;
      0 1 0 0 0 0 0;
      0 0 1 0 0 0 0;
      0 0 0 1 0 0 0;
      0 0 0 0 1 0 0;
      0 0 0 0 0 1 0;
      0 0 0 0 0 0 1];
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

Co = ctrb(Ap,Bp);
Cunco = length(Ap) - rank(Co);


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
x=i-1;
H(x*Ny+1:x*Ny+Ny,1:Nu)=temp*Bp;
end

for j=2:pHorizon
x=j-1;
H(x*Ny+1:Ny*pHorizon,x*Nu+1:x*Nu+Nu)=H(1:Ny*pHorizon-x*Ny,1:Nu);
end
%H

% Creation of Theta

Theta=zeros(Ny*pHorizon,Nd*pHorizon);

Theta(1:Ny,1:Nd)=Cp*F;
temp=Cp;
for i=2:pHorizon
temp=temp*Ap;
x=i-1;
Theta(x*Ny+1:x*Ny+Ny,1:Nd)=temp*F;
end

for j=2:pHorizon
x=j-1;
Theta(x*Ny+1:Ny*pHorizon,x*Nd+1:x*Nd+Nd)=Theta(1:Ny*pHorizon-x*Ny,1:Nd);
end
%Theta

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Creation of Qp or P
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Qp=zeros(Nu*pHorizon,Nu*pHorizon);

Q=eye(Ny*pHorizon,Ny*pHorizon);
R=eye(Nu*pHorizon,Nu*pHorizon);

Q=(Wq+wc)*Q;
R=(Wr+1000*we)*R;

Qp=H'*Q*H + R;

Qp_inv=inv(Qp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Creation of Fp or q
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fp1=H'*Q*Theta;  
Fp2=H'*Q*Z;
Fp3=H'*Q*Ref;

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

Mp= 0.5 * (states'*Mp1*states) + D'*Mp2*states+ 0.5 *(D'*Mp3*D) - Mp4*states - Mp5*D + 0.5*Mp6;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Creation of Gp or M      [Constraint on state]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assume Nu=Ny

Gp=zeros(2*(Ny+Nu)*pHorizon,Nu*pHorizon);
%Gp=zeros((Ny+Nu)*pHorizon,Nu*pHorizon);

Gp(1:Nu*pHorizon,1:Nu*pHorizon)=eye(Nu*pHorizon,Nu*pHorizon);
Gp(Nu*pHorizon+1:2*Nu*pHorizon,1:Nu*pHorizon)=-1 .*eye(Nu*pHorizon,Nu*pHorizon);
Gp(2*Nu*pHorizon+1:3*Nu*pHorizon,1:Nu*pHorizon)=B_prime;
%Gp(3*Nu*pHorizon+1:4*Nu*pHorizon,1:Nu*pHorizon)=-1 .*B_prime;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Creation of Kp or gamma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assume Nu=Ny

Kp=zeros(2*(Ny+Nu)*pHorizon,1);
%Kp=zeros((Ny+Nu)*pHorizon,1);

Kp(1:Nu*pHorizon,1)=u_max .*ones(Nu*pHorizon,1);
Kp(Nu*pHorizon+1:2*Nu*pHorizon,1)=-u_min .*ones(Nu*pHorizon,1);
Kp(2*Nu*pHorizon+1:3*Nu*pHorizon,1)=(y_max .*ones(Nu*pHorizon,1)) - A_prime * states - F_prime * D;
%Kp(3*Nu*pHorizon+1:4*Nu*pHorizon,1)=(-y_min .*ones(Nu*pHorizon,1)) + A_prime * states + F_prime * D;




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
