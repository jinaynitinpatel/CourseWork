mu = 3.986004418*10^14;
R_T = (6371+500) * 10^3;
n=sqrt(mu/R_T^3);
Ts = 0.2;
%w_p = deg2rad(5);
gamma = deg2rad(20);
r_p = 1.5;
r_tot = 0.1; %0.1;
phi_0 = deg2rad(30);

x_los_1 = linspace(1.28,4.25);
y_los_1 = tan(phi_0+gamma)*x_los_1 - (r_p - r_tot)*sin(gamma)/cos(phi_0+gamma);
x_los_2 = linspace(1.3,5);
y_los_2 = tan(phi_0-gamma)*x_los_2 + (r_p - r_tot)*sin(gamma)/cos(phi_0-gamma);
x_los_3 = linspace(0,3);
y_los_3 = -cot(phi_0)*x_los_3 + r_p/sin(phi_0);
x_bet_1 = linspace(0,4.5);
y_bet_1 = tan(phi_0)*x_bet_1;
x_origin = 0;
y_origin = 0;
x_dock_port = r_p*cos(phi_0);
y_dock_port = r_p*sin(phi_0);
plot(x_los_1, y_los_1, 'r', x_los_2, y_los_2, 'r', x_los_3, y_los_3, 'g', x_bet_1, y_bet_1, ':r', x_origin, y_origin, 'o', x_dock_port, y_dock_port, '-b.','MarkerSize',10, 'Linewidth', 1.3)
legend('LOS line with \phi + \gamma', 'LOS line with \phi - \gamma', 'Half-Plane Constraint', 'Line with \phi slope', 'Orgin', 'Docking Port')
xlim([-1 5])
ylim([-1,5])