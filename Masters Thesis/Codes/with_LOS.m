mu = 3.986004418*10^14;
R_T = 10000 * 10^3;
n=sqrt(mu/R_T^3);
Ts = 0.1;
w_p = deg2rad(5);
gamma = deg2rad(20);
r_p = 1.5;
r_tot = 0; %0.1;
phi = deg2rad(45);
beta = -0.15;
eta = 1;

c11 = sin(phi+gamma)/((r_p - r_tot)*sin(gamma));
c12 = -cos(phi+gamma)/((r_p - r_tot)*sin(gamma));
c21 = -sin(phi-gamma)/((r_p - r_tot)*sin(gamma));
c22 = cos(phi-gamma)/((r_p - r_tot)*sin(gamma));
c31 = cos(phi)/(r_p*sin(gamma));
c32 = sin(phi)/(r_p*sin(gamma));
c43 = 0;
c44 = 0;
c47 = 0;
c48 = 0;

%A = [0 0 1 0 0 0 0 0; 0 0 0 1 0 0 0 0; 3*n^2 0 0 2*n 0 0 0 0; 0 0 -2*n 0 0 0 0 0; 0 0 0 0 1 0 0 0; 0 0 0 0 0 1 0 0; 1 0 0 0 -1 0 0 0; 0 1 0 0 0 -1 0 0];
%B = [0 0; 0 0; 1 0; 0 1; 0 0; 0 0; 0 0; 0 0];
A = [0 0 1 0; 0 0 0 1; 3*n^2 0 0 2*n; 0 0 -2*n 0]; %0 0 0 0 cos(w_p*Ts) -sin(w_p*Ts) 0 0; 0 0 0 0 sin(w_p*Ts) cos(w_p*Ts) 0 0; 1 0 0 0 -1 0 0 0; 0 1 0 0 0 -1 0 0];
B = [0 0; 0 0; 1 0; 0 1]; %0 0; 0 0; 0 0; 0 0];
%C = [c11 c12 0 0 0 0 0 0; c21 c22 0 0 0 0 0 0; c31 c32 0 0 0 0 0 0; 0 0 c43 c44 0 0 c47 c48];
C = [1 0 0 0; 0 1 0 0; 0 0 0 0; 0 0 0 0];
D = [0 0; 0 0; 0 0; 0 0];

HCW = ss(A,B,C,D, Ts);

%Q = [10^5*eye(2) zeros(2,2); zeros(2,2) 10^3*eye(2)];
%R = 100*eye(2);
%[K,Qp,~] = lqry(HCW,Q,R);
%L = chol(Qp);
%newPlant = HCW;
%set(newPlant,'C',[C;L],'D',[D;zeros(3,2)]);

p = 20;
m = 10;
%mpcObj = mpc(newPlant, Ts, p, m);
mpcObj = mpc(HCW, Ts, p, m);
E = [0,0; 0,0; 0,0];
F = [-sin(phi+gamma)/((r_p-r_tot)*sin(gamma)), cos(phi+gamma)/((r_p-r_tot)*sin(gamma)), 0, 0; sin(phi-gamma)/((r_p-r_tot)*sin(gamma)), -cos(phi-gamma)/((r_p-r_tot)*sin(gamma)), 0, 0; -cos(phi)/(r_p*sin(gamma)), -sin(phi)/(r_p*sin(gamma)), 0, 0];
G = [-1;-1;-1];
setconstraint(mpcObj, E, F, G);

%ywt = sqrt(diag(Q))';
%uwt = sqrt(diag(R))';
mpcObj.Weights.OV = [10000 0 0 0; 10000 0 10000 0; 10000 100000 0 0]; %[10000 10000 0 0 ; 10000 1000 1 1; 1000 10000 1 1];
mpcObj.Weights.MV = 100*eye(2);
mpcObj.Weights.MVRate = [0.1 0.1];
mpcObj.Weights.ECR = 10000;
mpcObj.Model.Nominal.Y = [0,0,0];

u_mod = 0.8;
mpcObj.MV(1).Min = -u_mod;
mpcObj.MV(1).Max = u_mod;
mpcObj.MV(2).Min = -u_mod;
mpcObj.MV(2).Max = u_mod;

simOpt = mpcsimopt(mpcObj);
x_init = 20;
y_init = -10;
simOpt.PlantInitialState = [x_init, y_init, 0, 0];
Tstop = 30;
%r = [1.5, 0, 0, 0, 0, 0, 0, 0];
v= [];
r = [0,0,0,0];
[x, t, u] = sim(mpcObj, ceil(Tstop/Ts), r, simOpt);

%dist_square = (x(1:end, 1)).^2 + (x(1:end, 2)).^2 + (x(1:end, 3).^2);
dist_square = (x(1:end, 1)).^2 + (x(1:end, 2)).^2;
dist = dist_square.^0.5;

x_los_1 = linspace(-2,10);
y_los_1 = tan(phi+gamma)*x_los_1 - (r_p - r_tot)*sin(gamma)/cos(phi+gamma);
x_los_2 = linspace(-2,10);
y_los_2 = tan(phi-gamma)*x_los_2 + (r_p - r_tot)*sin(gamma)/cos(phi-gamma);
x_los_3 = linspace(-20,20);
y_los_3 = -cot(phi)*x_los_3 + r_p*sin(gamma)/sin(phi);
plot(x(1:end, 1), x(1:end, 2), x_los_1, y_los_1, 'r', x_los_2, y_los_2, 'r', x_los_3, y_los_3, 'g')