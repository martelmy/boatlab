%% Ex 1
%Finding T and K
omega_1 = 0.005;
omega_2 = 0.05;
ampl1 = 29.3485;
ampl2 = 0.8295;
T = sqrt((ampl2^2*omega_2^2 - ampl1^2*omega_1^2)/(ampl1^2*omega_1^4 - ampl2^2*omega_2^4));
K = omega_1*ampl1*sqrt((T*omega_1)^2+1);
simconst = 700;

%%

% Plotting compass
hold on;
plot(compass1.time, compass1.data,'--r');
plot(compass.time, compass.data,'b');
grid on;
xlabel('time');
ylabel('compass [deg]')
saveas(gcf,'5_5compassKalman','epsc')

%% 5.5d
hold on;
plot(compass1.time, compass1.data,'--r');
plot(compass.time, compass.data,'b');
plot(bias.time, bias.data, 'm');
plot(rudder_inp.time, rudder_inp.data, 'g');
grid on;
xlabel('time');
ylabel('angle [deg]');
legend('reference', 'compass', 'bias', 'rudder input');
saveas(gcf,'5_5currentCompassKalman','epsc');

%%
hold on;
plot(rudder_inp.time, rudder_inp.data);
plot(bias.time, bias.data);
grid on;
xlabel('time');
ylabel('angle [deg]');
legend('rudder', 'bias');
saveas(gcf,'5_5erudderbias','epsc');

%%
% Measured compass and filtered compass plot
hold on;
plot(compass1.time, compass1.data,'--r');
plot(compass.time, compass.data,'g');
plot(compass_filt.time, compass_filt.data,'m');
grid on;
xlabel('time');
ylabel('angle [deg]');
legend('reference', 'measured compass', 'filtered compass');
saveas(gcf,'5_5emesfiltcompass','epsc');

%%
% Actual wave and estimated wave plot
hold on;
plot(psi_w(1,:), psi_w(2,:), 'r');
plot(psi_w_est.time, psi_w_est.data, 'b')'
axis([0 700 -5 5]);
grid on;
xlabel('time');
ylabel('angle [deg]');
legend('actual wave', 'estimated wave');
saveas(gcf, '5_5eactmeaswave','epsc');

%%
% Plotting North East of the boat
plot(y.data,x.data);
xlabel('x');
ylabel('y');
title('North East plot')
axis([-700 700 0 1400]);
grid on;
saveas(gcf,'5_5NEKalman','epsc')

%% Ex 2
%5.2a
%PSD estimator
clf;
fs = 10;
window = 4096;
[pxx,f] = pwelch(psi_w(2,:).*pi/180, window, [], [], fs);  
pxx = pxx/(2*pi);
f = f*2*pi;

%5.2b ->
plot(f, pxx, 'b');
xlabel('f');
ylabel('pxx');
axis([0 3 0 0.0016]);
grid on;
hold on;

% Actual SPD eq
pxx_max = max(pxx);
sigma = sqrt(pxx_max);
omega_0 = 0.7823;
lambda = 0.075;
q = 1;
K_w = 2*lambda*omega_0*sigma;
P = @(omega)(omega^2*K_w^2*q)/((omega_0^2 - omega^2)^2+(omega*2*lambda*omega_0)^2);
fplot (P, 'r');
xlabel('\omega');
ylabel('S, P');
legend('S', 'P')
grid on;


%%
% Ex 3

psi_r = 30;
T_d = T;
omega_c = 0.1;
pm = 50*pi/180;
T_f = -1/(omega_c*tan(pi-pm));
K_pd = (omega_c*sqrt(1+(T_f*omega_c)^2))/K;

%%
% Ex 4
omega_0 = 0.7823;
lambda = 0.075;

A_1 = [0 1; 0 -1/T];
C_1 = [1 0];
Ob_1 = obsv(A_1, C_1);
unob_1 = length(A_1)-rank(Ob_1);

A_2 = [0 1 0; 0 -1/T -K/T; 0 0 0];
C_2 = [1 0 0];
Ob_2 = obsv(A_2, C_2);
unob_2 = length(A_2)-rank(Ob_2);

A_3 = [0 1 0 0; -omega_0^2 -2*lambda*omega_0 0 0; 0 0 0 1; 0 0 0 -1/T];
C_3 = [0 1 1 0];
Ob_3 = obsv(A_3, C_3);
unob_3 = length(A_3)-rank(Ob_3);

A_4 = [0 1 0 0 0; -omega_0^2 -2*lambda*omega_0 0 0 0; 0 0 0 1 0; 0 0 0 -1/T -K/T; 0 0 0 0 0];
C_4 = [0 1 1 0 0];
Ob_4 = obsv(A_4, C_4);
unob_4 = length(A_4)-rank(Ob_4);


%%
%Ex 5

A = A_4;
B = [0; 0; 0; K/T; 0];
E = [0 0; K_w 0; 0 0; 0 0; 0 1];
C = C_4;
T_s = 1/fs;

[A_d, B_d] = c2d(A,B,T_s);
[A_d, E_d] = c2d(A,E,T_s);
C_d = C;


estimate_var = 6.013282621421814e-07;

%%
% Ex 5c
R = estimate_var*fs;
x0 = [0; 0; 0; 0; 0];
Q = [30 0; 0 1e-06];
P0 = [1 0 0 0 0; 0 0.013 0 0 0; 0 0 pi^2 0 0; 0 0 0 1 0; 0 0 0 0 2.5e-03];


system = struct('A_d', A_d, 'B_d', B_d, 'C_d', C_d, 'E_d', E_d, ...
    'x_pri', x0, 'P_pri', P0, 'Q', Q, 'R', R);