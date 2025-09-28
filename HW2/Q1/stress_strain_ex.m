clear all
close all
ef = 1000e-6;
de = ef/1000;
epsil = 0:de:ef;
sf = 10e6;
ds = sf/1000;
sig = 0:ds:sf;

%The following random noise is super-imposed on the linear stress-strain
%relation.  You must comment one of these sets.

%use to generate a uniform distribution of noise
% s_rand1 = sf/10*(-1 + 2*rand(1,length(sig)));
% s_rand2 = sf/20*(-1 + 2*rand(1,length(sig)));
% s_rand3 = sf/50*(-1 + 2*rand(1,length(sig)));


%use to generate a normal distribution of noise
s_rand1 = sf/10*(-1 + 2*randn(1,length(sig)));
s_rand2 = sf/20*(-1 + 2*randn(1,length(sig)));
s_rand3 = sf/50*(-1 + 2*randn(1,length(sig)));

E1 = 1.1*sf/ef;
E2 = E1/1.1;
E3 = 0.9*E1;

s_model1 = E1*epsil;
s_model2 = E2*epsil;
s_model3 = E3*epsil;

figure(1)
axes1 = axes('Parent',figure(1),'FontSize',24);
plot(epsil*1e2,(sig+s_rand1)/1e6,'bo:','MarkerSize',3,'Linewidth',2)
hold on
plot(epsil*1e2,(sig+s_rand2)/1e6,'ko:','MarkerSize',3,'Linewidth',2)
plot(epsil*1e2,(sig+s_rand3)/1e6,'ro:','MarkerSize',3,'Linewidth',2)
% plot(epsil*1e2,s_model1/1e6,'r-','Linewidth',3)
plot(epsil*1e2,s_model2/1e6,'k-','Linewidth',3)
% plot(epsil*1e2,s_model3/1e6,'g-.','Linewidth',3)
hold off
xlabel('\epsilon','FontSize',24)
ylabel('\sigma (MPa)','FontSize',24)
legend('Data','Data','Data','Model')