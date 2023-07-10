

colo=[246,83,20;124,187,0;0,70,222]./255;
ttp=[1,20:20:step];

%% plot RMSE line
figure()
semilogy(1:step,RMSE_SP_ADMM_ave(:,1),'-s','Color',colo(1,:),'MarkerIndices',ttp,'MarkerFaceColor',colo(1,:),'LineWidth',2,'MarkerSize',7)
grid on
leg2=legend('SP-ADMM');
axis([-10,step+10 0.001 2])
xlabel('Iteration Number','FontSize',25)
ylabel('RMSE','FontSize',25) 
set(leg2,'FontSize',25)


%% plot feasibility gap and stationarity gap
figure()
semilogy(1:step,S_ave(:,1),'-s','Color',colo(2,:),'MarkerIndices',ttp,'MarkerFaceColor',colo(2,:),'LineWidth',2,'MarkerSize',7)
hold on
semilogy(1:step,U_ave(:,1),'-s','Color',colo(3,:),'MarkerIndices',ttp,'MarkerFaceColor',colo(3,:),'LineWidth',2,'MarkerSize',7)
semilogy(1:step,P_ave(:,1),'-s','Color',colo(1,:),'MarkerIndices',ttp,'MarkerFaceColor',colo(1,:),'LineWidth',2,'MarkerSize',7)
grid on
leg1=legend('S(t)','U(t)','P(t)');
set(leg1,'FontSize',25)
xlabel('Iteration Number','FontSize',25)  %'\bf'是加粗的意思
ylabel('Gap','FontSize',25)
axis([-10 410 10^-3 5*10^4]);

%% plot Position estimates
figure()
plot(agent(:,1),agent(:,2),'r+','MarkerSize', 10);
hold on
plot(x_estimate_last(:,1),x_estimate_last(:,2),'go','MarkerSize', 10);
plot(anchor(:,1),anchor(:,2),'ks','MarkerFaceColor','k','MarkerSize', 10);
ylabel('\bf{x-position}','FontSize',10.508)  %'\bf'是加粗的意思
xlabel('\bf{y-position}','FontSize',10.508)  %'\bf'是加粗的意思
gplot([zeros(n_fix),eye(n_fix);eye(n_fix),zeros(n_fix)],[agent;x_estimate_last],'k-');
ho=legend('true agent','estimated agent','anchors');
set(ho,'Orientation','horizon')
grid on
axis([-0.1,1.1 -0.1 1.1])
title('Position Estimates')


%% plot Network structure
colo=[11,93,55]/159;
figure()
plot(agent(:,1),agent(:,2),'o','Color',colo,'MarkerFaceColor',colo,'MarkerSize', 9);
hold on
plot(anchor(:,1),anchor(:,2),'sk','MarkerFaceColor','r','MarkerSize', 9);
gplot(dd_error,[agent;anchor],'k-');
box on
grid on
ylabel('Y[m]','FontSize',25)  %'\bf'是加粗的意思
xlabel('X[m]','FontSize',25)  %'\bf'是加粗的意思
title('Sensor Network')
hl=legend('agent','anchor');
set(hl,'Orientation','horizon')
set(gca,'MinorGridAlpha',1);
set(gca,'FontSize',23)
axis([-0.1 1.1 -0.1 1.15]);
