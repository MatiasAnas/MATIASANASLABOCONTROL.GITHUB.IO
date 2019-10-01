% Ejemplo Identificación Amortiguador de masa (Método ARX AutoRegressive eXogenous)
M1=.1;
M2=.01;                         % M2=10% M1
K=0.01; 
B1=.1;
w=30;
Kr=M2*w*w;                      % w=sqrt(Kr/M2)
B2=0;

% X=[x1 x2 x3 x4]'
% X=[y1 y2 y1' y2']'
A=[
0 0 1 0;
0 0 0 1;
-(K+Kr)/M1 Kr/M1 -(B1+B2)/M1 B2/M1 ;
Kr/M2 -Kr/M2 B2/M2 -B2/M2
];
B=[0 0 1/M1 0]';
C=[1 0 0 0];
D=[0];

sys=tf(ss(A,B,C,D));
Fs=10;                              % Frecuencia muestreo Fs=10Hz
Ts=1/Fs;                            % Tiempo de muestreo
N=100;                              % Nro de muestras
t=[0:N-1]*Ts;                       % Duración muestreo de datos
%u=sin(1*w*t);                      % Senoide a la frec. de resonancia (entrada)
u=idinput(N,'PRBS');                % N muestras de señal binaria pseudo aleatoria (entrada)
disp('Modelo a Ensayar (discreto):')
sysd=c2d(sys,Ts)                    % Discretiza el sistema con Ts por ZOH
e=randn(N,1)/50;                    % ruido de planta en la entrada
y=lsim(sysd,u+e,t);                 % simula sistema discreto y obtiene respuesta a entrada PRBS + ruido de planta
e=randn(N,1)/100;                   % ruido medición en la salida
datos=iddata(y+e,u,Ts);             % crea objeto datos muestreados + ruido medicion p/ identificar con arx
arx1=arx(datos,[4,4,1]);            % Identifica modelo discreto ARX Na=4 Nb=4 Nu=1

%------ Calculo arx Manual -------------------
% Na=4;Nb=4;Nu=1
Sum1=0;
Sum2=0;

for k = 5:N,
    vphi = [-y(k-1) -y(k-2) -y(k-3) -y(k-4) u(k-1) u(k-2) u(k-3) u(k-4)]';
    Sum1 = Sum1 + vphi*vphi';
    Sum2 = Sum2 + vphi*y(k);
end

theta = inv(Sum1)*Sum2; % least-squares fit
Bcoef = [theta(5) theta(6) theta(7) theta(8)];
Acoef = [1 theta(1) theta(2) theta(3) theta(4)];
Hident = tf(Bcoef,Acoef,-1);
%---------------------------------------------

disp('Modelo Identificado (discreto):')
sysid=tf(arx1,1)                    % convierte modelo ARX Y1/U1 a formato TF
%sysi=d2c(sysid);                   % transforma a modelo continuo
%[Ai Bi Ci Di Ki X0]=ssdata(arx1);  % Obtiene {A,B,C,D} modelo discreto 
%sysid=ss(Ai,Bi,Ci,Di,Ts);          % Crea SS VDE
%sysi=d2c(sysid);                   % Transforma a continuo
figure(1)
clf
hold
lsim(sys,u,t)
lsim(sysid,u,t)
lsim(Hident,u,t)
title('SENAL PSEUDO ALEATORIA ENTRADA + RESP. DE PLANTA CONTINUA + RESP. IDENTIFICACION DISCRETA')
figure(2)
clf
subplot(1,2,1)
pzmap(sysd)
title('POLOS y CEROS PLANTA DISCRETA')
subplot(1,2,2)
%pzmap(sysid)
pzmap(Hident)
title('POLOS y CEROS IDENTIFICACION DISCRETA')
figure(3)
clf
subplot(1,2,1)
bode(sysd,{1e-3,1e2})
title('BODE PLANTA A ENSAYAR')
subplot(1,2,2)
bode(sysid,{1e-3,1e2})
title('BODE PLANTA IDENTIFICADA')
