

%% network parameter------------------------------
test8_20_struct = load('test8-20.mat');
m = test8_20_struct.m;
PP = test8_20_struct.PP;
dd_error = test8_20_struct.dd_error;
range = test8_20_struct.range;
n_fix = size(PP,2)-m;
agent = PP(:,1:n_fix)';
anchor = PP(:,n_fix+1:end)'; 
[ix,jy] = find(dd_error);
link = cell(n_fix+m,1);
sum_link =zeros(n_fix,1);
for i = 1:n_fix+m
    link{i} = ix(find(jy==i));
    sum_link(i) = length(link{i});
end
%% Network structure------------------------------
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
%% algorithm parameter-----------------------------------
u0 = 0;
a0 = 0;
c=0.14;
rho=c;
step = 200; 
N_MC = 20; 
n_scale = 1; 
RMSE_SP_ADMM=zeros(step,N_MC);

for i_MC = 1:N_MC
    rng(i_MC)
    x0 =[n_scale.*unifrnd(-1,1,n_fix,2);anchor];
    rmse_sp = sp_admm(agent,sum_link,link,c,rho,u0,a0,x0,step,n_fix,m,dd_error);
    RMSE_SP_ADMM(:,i_MC) = rmse_sp;
end

mean_RMSE_SP_ADMM=mean(RMSE_SP_ADMM,2);

colo1=[246,83,20]./255;
ttp=[1,20:20:step];
figure()
semilogy(1:step,mean_RMSE_SP_ADMM,'-s','Color',colo1,'MarkerIndices',ttp,'MarkerFaceColor',colo1,'LineWidth',2,'MarkerSize',7)
grid on
legend('SP-ADMM')
xlabel('Iteration Number','FontSize',25)
ylabel('RMSE','FontSize',25)  

