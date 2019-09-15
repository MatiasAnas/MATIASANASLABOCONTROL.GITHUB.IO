function dx = f(t, x)
    C = 1;
    v = 1;
    L = 1;
    R = 100;
    
    vc = x(1);
    ic = x(2);

    dx = [ic / C; - vc / L - ic * R / L + v]; 
end