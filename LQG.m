M = 0.5;
m = 0.2;
b = 0.1;
I = 0.006;
g = 9.8;
l = 0.3;

P = I*(M+m)+M*m*l^2; %denominator for the A and B matrices

A = [0      1              0           0;
     0 -(I+m*l^2)*b/P  (m^2*g*l^2)/P   0;
     0      0              0           1;
     0 -(m*l*b)/P       m*g*l*(M+m)/P  0];
B = [     0;
     (I+m*l^2)/P;
          0;
        m*l/P];
C = [1 0 0 0;
     0 0 1 0];
D = [0;
     0];
 
H=ss(A,B,C,D)

p=size(C,1)
[n_,m_]=size(B)

Q = C'*C;
R = 1;
Q(1,1)=50000;
Q(3,3)=1000;
K = lqr(A,B,Q,R)
Bnoise=eye(n_);
W=eye(n_);
V=0.01*eye(m_);
Estss=ss(A,[B Bnoise],C,[0]);
[Kess, Ke]=kalman(Estss,W,V)

