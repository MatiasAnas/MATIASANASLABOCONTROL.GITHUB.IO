function [sys,x0,str,ts] = Nombre(t,x,u,flag,p1,p2)
%   La forma general de una M-File S-Function es:
%       [SYS,X0,STR,TS] = SFUNC(T,X,U,FLAG,P1,...,Pn)
switch flag,

  case 0,
    sizes = simsizes;
    sizes.NumContStates  = 0;
    sizes.NumDiscStates  = 0;
    sizes.NumOutputs     = 1;
    sizes.NumInputs      = 1;
    sizes.DirFeedthrough = 1;
    sizes.NumSampleTimes = 1;   % Al menos uno es necesario
    sys = simsizes(sizes);
    x0  = [];
    str = [];
    ts  = [0 0];
    
  case {1,2,4}   % derivadas,update,prox. hit
    sys = [];

  case 3,   % salida
    sys = u*p1+p2;

  case 9,   % terminacion
    sys = [];

  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end
