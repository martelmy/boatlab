
function output = discKalmanFilter(compass, system, rudder)
    %x_pri P_pri A_d B_d C_d E_d Q R
    
    % Initializing
    A_d = system.A_d;
    B_d = system.B_d;
    C_d = system.C_d;
    E_d = system.E_d;
    x_pri = system.x_pri;
    P_pri = system.P_pri;
    Q = system.Q;
    R = system.R;
    I = eye(5); % Identity matrix with n=5
    
    % Kalman gain L
    L = P_pri*C_d.'*inv(C_d*P_pri*C_d.'+R);
    
    % Updating the estimate and the error covariance
    x_post = x_pri + L*(compass - C_d*x_pri);
    P_post = (I - L*C_d)*P_pri*(I - L*C_d).' + L*R*L.';
    
    % Project ahead
    x_next = A_d*x_post + B_d*rudder;
    P_next = A_d*P_post*A_d.' + E_d*Q*E_d.';
    
    % Initializing new a priori
    x_pri = x_next;
    P_pri = P_next;
    
    
    output = [x_post(3); x_post(5)] ;

end
