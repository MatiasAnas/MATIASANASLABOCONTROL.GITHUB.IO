function [sys,x0,str,ts]=doble(t,x,u,flag)
switch flag
    case 0,
        sizes = simsizes;

        sizes.NumContStates  = 0;
        sizes.NumDiscStates  = 0;
        sizes.NumOutputs     = 1;
        sizes.NumInputs      = 1;
        sizes.DirFeedthrough = 1;
        sizes.NumSampleTimes = 1;   % at least one sample time is needed

        sys = simsizes(sizes);
        x0  = [];
        str = [];
        ts  = [0 0];
   case {1,2,4,9,}
      sys=[];
   case 3,
      sys=u*2;
   otherwise
      error(['flag desconocido= ',num2str(flag)]);
 end
   

   
