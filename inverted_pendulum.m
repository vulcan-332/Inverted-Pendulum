set(groot,'defaultLineLineWidth',2.0)
M = 0.5;
m = 0.2;
b = 0.1;
I = 0.006;
g = 9.8;
l = 0.3;
q = (M+m)*(I+m*l^2)-(m*l)^2;
s = tf('s');

P_cart = (((I+m*l^2)/q)*s^2 - (m*g*l/q))/(s^4 + (b*(I + m*l^2))*s^3/q - ((M + m)*m*g*l)*s^2/q - b*m*g*l*s/q);

P_pend = (m*l*s/q)/(s^3 + (b*(I + m*l^2))*s^2/q - ((M + m)*m*g*l)*s/q - b*m*g*l/q);

sys_tf = [P_cart ; P_pend]

inputs = {'u'};
outputs = {'x'; 'phi'};

set(sys_tf,'InputName',inputs)
set(sys_tf,'OutputName',outputs)

sys_tf

p = I*(M+m)+M*m*l^2; %denominator for the A and B matrices

A = [0      1              0           0;
     0 -(I+m*l^2)*b/p  (m^2*g*l^2)/p   0;
     0      0              0           1;
     0 -(m*l*b)/p       m*g*l*(M+m)/p  0];
B = [     0;
     (I+m*l^2)/p;
          0;
        m*l/p];
C = [1 0 0 0;
     0 0 1 0];
D = [0;
     0];

states = {'x' 'x_dot' 'phi' 'phi_dot'};
inputs = {'u'};
outputs = {'x'; 'phi'};

sys_ss = ss(A,B,C,D,'statename',states,'inputname',inputs,'outputname',outputs)

sys_tf = tf(sys_ss)

t=0:0.01:10;
impulse(sys_tf,t)
title('Open-Loop response to an Impulse Input')
set(findall(gcf,'-property','FontSize'),'FontSize',20)
figure 
pzplot(sys_tf)

figure 
t = 0:0.05:10;
u = ones(size(t));
[y,t] = lsim(sys_tf,u,t);
plot(t,y)
grid ON
set(findall(gcf,'-property','FontSize'),'FontSize',20)
title('Open-Loop response to a Step Input') 
xlabel('time')
ylabel('amplitude')
axis([0 10 0 25])
legend('x','phi')
stepinfo = lsiminfo(y,t)
set(findall(gcf,'-property','FontSize'),'FontSize',20)
cart_info = stepinfo(1)
pend_info = stepinfo(2)