% Finding the observability of the system
A = [0 1 0 0 0; -omega_0^2 -2*lambda*omega_0 0 0 0;
    0 0 0 1 0; 0 0 0 -1/T -1/K; 0 0 0 0 0];
C = [0 1 1 0 0];
Ob = obsv(A, C);
unob = length(A)-rank(Ob);