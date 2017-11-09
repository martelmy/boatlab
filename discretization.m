% Discretizing the system
A = [0 1 0 0 0; -omega_0^2 -2*lambda*omega_0 0 0 0;
    0 0 0 1 0; 0 0 0 -1/T -1/K; 0 0 0 0 0];
B = [0; 0; 0; K/T; 0];
C = [0 1 1 0 0];
E = [0 0; K_w 0; 0 0; 0 0; 0 1];
fs = 10;
T_s = 1/fs;

[A_d, B_d] = c2d(A,B,T_s);
[A_d, E_d] = c2d(A,E,T_s);
