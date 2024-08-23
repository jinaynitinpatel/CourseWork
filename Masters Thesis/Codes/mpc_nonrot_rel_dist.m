
mu = 3.986004418*10^14;
R_T = 10000 * 10^3;
n=sqrt(mu/R_T^3);
w_p = deg2rad(5);
gamma = deg2rad(30);
r_p = 0;
r_tot = 0; %0.1;
phi = deg2rad(45);
beta = -0.15;
eta = 1;
A = [0, 0, 0, 1, 0, 0; 0, 0, 0, 0, 1, 0; 0, 0, 0, 0, 0, 1; 3*n^2, 0, 0, 0, 2*n, 0; 0, 0, 0, -2*n, 0, 0; 0, 0, -n^2, 0, 0, 0];
B = [0, 0, 0; 0, 0, 0; 0, 0, 0; 1, 0, 0; 0, 1, 0; 0, 0, 1];
C = [1, 0, 0, 0, 0, 0; 0, 1, 0, 0, 0, 0; 0, 0, 1, 0, 0, 0];
D = [0, 0, 0; 0, 0, 0; 0, 0, 0];
Ts = 0.2;
HCW = ss(A,B,C,D);
p = 30;
m = 10;
mpcObj = mpc(HCW, Ts, p, m);
mpcObj.Weights.OV = [100000,10000,1; 100000 10000 1; 100000 10000 1];
mpcObj.Weights.MV = 5000*eye(3);
mpcObj.Weights.MVRate = [0.1 0.1 0.1];
mpcObj.Weights.ECR = 10000;
mpcObj.Model.Nominal.Y = [0,0,0];

Q = mpcObj.Weights.OV;
R = mpcObj.Weights.MV;

%[~,S,~] = lqr(HCW,Q,R); %riccati equation solution 

u_mod = 0.8;
mpcObj.MV(1).Min = -u_mod;
mpcObj.MV(1).Max = u_mod;
mpcObj.MV(2).Min = -u_mod;
mpcObj.MV(2).Max = u_mod;
mpcObj.MV(3).Min = -u_mod;
mpcObj.MV(3).Max = u_mod;

% mpcObj.OV(1).Min = -u_mod;
% mpcObj.OV(1).Max = u_mod;
% mpcObj.OV(2).Min = -u_mod;
% mpcObj.OV(2).Max = u_mod;
% mpcObj.OV(3).Min = -u_mod;
% mpcObj.OV(3).Max = u_mod;


E = [0.0001,0.0001,0.0001; 0.0001,0.0001,0.0001; 0.0001,0.0001,0.0001];
F = [-sin(phi+gamma)/((r_p-r_tot)*sin(gamma)), cos(phi+gamma)/((r_p-r_tot)*sin(gamma)), 0; sin(phi-gamma)/((r_p-r_tot)*sin(gamma)), -cos(phi-gamma)/((r_p-r_tot)*sin(gamma)), 0; -cos(phi)/(r_p*sin(gamma)), -sin(phi)/(r_p*sin(gamma)), 0];
G = [-1;-1;-1];
setconstraint(mpcObj, E, F, G);

simOpt = mpcsimopt(mpcObj);
simOpt.PlantInitialState = [-8,15,0,0,0,0];
Tstop = 30;
r = [0, 0, 0];
v= [];
[x, t, u] = sim(mpcObj, ceil(Tstop/Ts), r, simOpt);

dist_square = (x(1:end, 1)).^2 + (x(1:end, 2)).^2 + (x(1:end, 3).^2);
dist = dist_square.^0.5;
%plot(t, x(1:end, 1), 'r') 
%plot(t, u, 'b')
%plot(t, dist)

subplot(3,3,1)
plot(t, x(1:end, 1), 'b', t, zeros(length(x)), ':r') 
title('Position');
ylabel('X (in m)');
xlabel('Elapsed Time (seconds)')
legend('Tracking Trajectory', 'Reference Trajectory');
subplot(3,3,2)
plot(t, x(1:end, 2), 'b', t, zeros(length(x)), ':r')
title('Position');
ylabel('Y (in m)');
xlabel('Elapsed Time (seconds)')
legend('Tracking Trajectory', 'Reference Trajectory');
subplot(3,3,3)
plot(t, x(1:end, 3), 'b', t, zeros(length(x)), ':r')
title('Position');
ylabel('Z (in m)');
xlabel('Elapsed Time (seconds)')
legend('Tracking Trajectory', 'Reference Trajectory');
subplot(3,3,[4,5,6])
plot(t, dist)
title('Relative Distance');
ylabel('Dist (in m)');
xlabel('Elapsed Time (seconds)')
subplot(3,3, [7,8,9])
%stairs(t, u)
%title('Control Input');
%xlabel('Elapsed Time (seconds)')
%legend('u1', 'u2', 'u3')
plot(x(1:end,1), x(1:end,2))