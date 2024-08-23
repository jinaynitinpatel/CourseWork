mu = 3.986004418*10^14;
R_T = (6371+500) * 10^3;
n=sqrt(mu/R_T^3);
Ts = 0.2;
w_p = deg2rad(20);
gamma = deg2rad(20);
r_p = 1.5;
r_tot = 0.1; %0.1;
phi_0 = deg2rad(30);
beta = -0.15;
eta = 1;
T = 0:Ts:20;

A = [0 0 1 0; 0 0 0 1; 3*n^2 0 0 2*n; 0 0 -2*n 0]; 
B = [0 0; 0 0; 1 0; 0 1]; 
C = [1 0 0 0; 0 1 0 0];
D = [0 0; 0 0];% 0 0; 0 0];

HCW = ss(A,B,C,D);

p = 30;
m = 20;
mpcObj = mpc(HCW, Ts, p, m);
mpcObj.Weights.OV = [100,1000;1000 200];
mpcObj.Weights.MV = 100*eye(2);
mpcObj.Weights.MVRate = [0.1 0.1];
mpcObj.Weights.ECR = 10000;
%mpcObj.Model.Nominal.Y = [0,0,0,0];

u_mod = 1;
mpcObj.MV(1).Min = -u_mod;
mpcObj.MV(1).Max = u_mod;
mpcObj.MV(2).Min = -u_mod;
mpcObj.MV(2).Max = u_mod;

phi = phi_0;

E = [0,0; 0,0; 0,0];% 1,0; 0,1];
F = [-sin(phi+gamma)/((r_p-r_tot)*sin(gamma)), cos(phi+gamma)/((r_p-r_tot)*sin(gamma)); sin(phi-gamma)/((r_p-r_tot)*sin(gamma)), -cos(phi-gamma)/((r_p-r_tot)*sin(gamma)); -cos(phi)/(r_p*sin(gamma)), -sin(phi)/(r_p*sin(gamma))];%0, 0; 0,0];
G = [-1;-1;-1];%u_mod;u_mod];
setconstraint(mpcObj,E,F,G);

x0 = [5 -5 0 0];
u0 = [0, 0];
x = x0';
u = u0';
xmpc = mpcstate(mpcObj);
ympc = zeros(length(T),size(C,1));
umpc = zeros(length(T),size(B,2));
phi_array = zeros(1,length(T));
simOpt = mpcsimopt(mpcObj);
%simOpt.PlantInitialState = [-8,15,16,2,2,2];
simOpt.Model = HCW;
%y = x0(1:2);
Ad = expm(A*Ts);
Bd = integral(@(t) expm(A.*t),0,Ts, 'ArrayValued', true)*B;


for k = 1:length(T)
    
% Plant equations: output update
    phi_array(1,k) = phi;
    y = C*x + D*u;
    ympc(k,:) = y';
    r = [(r_p)*cos(phi), (r_p)*sin(phi)];
    v = [0];
    %if k == length(T)
    %    r = [(r_p-r_tot)*cos(phi), (r_p-r_tot)*sin(phi)];
    %end
    
    options = mpcmoveopt;
    options.MVMin = [-u_mod,-u_mod];
    options.MVMax = [u_mod, u_mod];
    options.OutputWeights = [100,1000;1000 200];

    options.MVWeights = 10*eye(2);
    %options.MVRateWeights = [0 0];
    options.ECRWeight = 10000;
    %mpcObj.Model.Nominal.Y = [0,0,0,0];
    %options.PredictionHorizon = 30;
    %options.ControlHorizon = 10;
    dist_square = (x(1).^2 + x(2).^2);
    dist = dist_square.^0.5;
    
    
    
    E = [0,0; 0,0; 0,0];% 1,0; 0,1];
    F = [-sin(phi+gamma)/((r_p-r_tot)*sin(gamma)), cos(phi+gamma)/((r_p-r_tot)*sin(gamma)); sin(phi-gamma)/((r_p-r_tot)*sin(gamma)), -cos(phi-gamma)/((r_p-r_tot)*sin(gamma)); -cos(phi)/(r_p*sin(gamma)), -sin(phi)/(r_p*sin(gamma))];%0, 0; 0,0];
    G = [-0.99;-0.99;-0.99];%u_mod;u_mod];
    options.CustomConstraint = struct('E',E,'F',F,'G',G);
    
    [u,info] = mpcmove(mpcObj,xmpc,y',r,[], options);
    umpc(k,:) = u';
    
    %x = info.Xopt(1,1:end-1)';
    % Plant equations: state update
    
    %y = Cd*x + Dd*u;
    
    x = Ad * x + Bd * u;
    phi = phi_0; %+ w_p*Ts;
end

x_los_1 = linspace(-1,4);
y_los_1 = tan(phi_array(end)+gamma)*x_los_1 - (r_p - r_tot)*sin(gamma)/cos(phi_array(end)+gamma);
x_los_2 = linspace(-1,4);
y_los_2 = tan(phi_array(end)-gamma)*x_los_2 + (r_p - r_tot)*sin(gamma)/cos(phi_array(end)-gamma);
x_los_3 = linspace(-1,3);
y_los_3 = -cot(phi_array(end))*x_los_3 + r_p/sin(phi_array(end));
%plot(ympc(:,1),ympc(:,2),'-k', x_los_1, y_los_1, 'r', x_los_2, y_los_2, 'r', x_los_3, y_los_3, 'g')

subplot(4,2,1)
plot(T, ympc(:,1), 'b', T, (r_p-r_tot)*cos(phi_array), ':r', 'LineWidth',1) 
title('Position');
ylabel('X (in m)');
xlabel('Elapsed Time (seconds)')
%legend('Tracking Trajectory', 'Reference Trajectory');
subplot(4,2,2)
plot(T, ympc(:,2), 'b', T, (r_p-r_tot)*sin(phi_array), ':r', 'LineWidth',1)
title('Position');
ylabel('Y (in m)');
xlabel('Elapsed Time (seconds)')
legend('Tracking Trajectory', 'Reference Trajectory');
subplot(4,2,[3,4,5,6])
plot(ympc(:,1),ympc(:,2),'b', x_los_1, y_los_1, 'r', x_los_2, y_los_2, 'r', x_los_3, y_los_3, 'g', 'LineWidth',1)
title('x-y plot');
%ylabel('y (in m)');
%xlabel('x (in m)')
legend('Trajectory', 'LOS lines')
subplot(4,2, [7,8])
stairs(T, umpc, 'LineWidth',1.25)
title('Control Input');
xlabel('Elapsed Time (seconds)')
legend('u1', 'u2')
ylim([-1.2 1.2])

