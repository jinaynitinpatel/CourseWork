function mat = Jacobian()
    syms t0 t1 t2 t3 l0 l1 d1 l2 d2 l3
    R0 = [cos(t0) -sin(t0) 0 0; sin(t0) cos(t0) 0 0; 0 0 1 0; 0 0 0 1];
    R1 = [1 0 0 0; 0 1 0 0; 0 0 1 l0; 0 0 0 1];
    R2 = [cos(t1) 0 sin(t1) 0; 0 1 0 0; -sin(t1) 0 cos(t1) 0; 0 0 0 1];
    R3 = [1 0 0 l1; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    R4 = [cos(t2) 0 sin(t2) 0; 0 1 0 0; -sin(t2) 0 cos(t2) 0; 0 0 0 1];
    R5 = [1 0 0 0; 0 1 0 d1; 0 0 1 0; 0 0 0 1];
    R6 = [1 0 0 l2; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    R7 = [cos(t3) 0 sin(t3) 0; 0 1 0 0; -sin(t3) 0 cos(t3) 0; 0 0 0 1];
    R8 = [1 0 0 0; 0 1 0 0; 0 1 0 d2; 0 0 0 1];
    R9 = [1 0 0 l3; 0 1 0 0; 0 1 0 0; 0 0 0 1];
    R = R0*R1*R2*R3*R4*R5*R6*R7*R8*R9;
    mat = diff(R(1:end-1,end),t0);
    %mat = diff(R(1:end-1,end),t1);
    %mat = diff(R(1:end-1,end),t2);
    %mat = diff(R(1:end-1,end),t3);
end