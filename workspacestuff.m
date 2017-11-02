%% Ex 1
%Finding T and K
omega_1 = 0.005;
omega_2 = 0.05;
ampl1 = 29.3485;
ampl2 = 0.8295;
T = sqrt((ampl2^2*omega_2^2 - ampl1^2*omega_1^2)/(ampl1^2*omega_1^4 - ampl2^2*omega_2^4));
K = omega_1*ampl1*sqrt((T*omega_1)^2+1);

%%
% Plotting compass
plot(compass.time, compass.data);
grid on;
xlabel('time');
ylabel('compass [deg]')



%%
% Plotting North East of the boat
plot(y.data,x.data);
xlabel('x');
ylabel('y');
title('North East plot')
axis([-5000 5000 -5000 5000]);
grid on;


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
