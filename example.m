
% Illustration: The following code demonstrates the generation of sensor network data 
% and the estimation of sensor positions using Algorithm 1, as proposed in Article 
% ¡°Distributed Scaled Proximal ADMM Algorithms for Cooperative Localization in WSNs¡±. 
% The figures in the Numerical Results section of the article aim to investigate 
% the influence of a network parameter and algorithm parameter on the positioning accuracy. 
% To generate the figures, you can incorporate a for loop that allows the variation of the 
% parameter of interest while keeping other network variables fixed. For instance, in the provided code, 
% an external for loop can be implemented to adjust the measurement noise variance. 
% Furthermore, modifying the communication range of the network enables control over the Average Number of Neighbors (D_{avg}). 

%% Network Parameter------------------------------
%% (1). Load network data(public data or your personal data)
% test8_20_struct = load('test8-20.mat');
% m = test8_20_struct.m;
% PP = test8_20_struct.PP;
% dd_error = test8_20_struct.dd_error;
% range = test8_20_struct.range;
% n_fix = size(PP,2)-m;
% agent = PP(:,1:n_fix)';
% anchor = PP(:,n_fix+1:end)'; 
%% (2). Generate network data
n_scale = 1;
noise_variance = 0.01;
n_variance = length(noise_variance);
anchor = [0, 0; 0, 0.5; 0, 1; 0.5, 0; 0.5, 1; 1, 0; 1, 0.5; 1, 1].*n_scale;
n_fix = 40;
range =0.4*n_scale;
m = length(anchor);
%% SP-ADMM Algorithm parameter-----------------------------------
u0 = 0.3;%0.3
a0 = 0;
c=0.12;%0.12
rho=c;
step = 400; 
N_MC = 1; 
RMSE_SP_ADMM=zeros(step,1);
RMSE_SP_ADMM_ave=zeros(step,n_variance);
S=zeros(step,1);
U=zeros(step,1);
P=zeros(step,1);
S_ave=zeros(step,n_variance);
U_ave=zeros(step,n_variance);
P_ave=zeros(step,n_variance);
% x_position=zeros(2*n_fix,1);
% x_position_ave=zeros(2*n_fix,1);

for ii = 1:n_variance 
    nf_noise = noise_variance(ii);
    for i_MC = 1:N_MC
        rng(i_MC)
        %% generate network 
        [num,PP, dd, ~] = Generate_network(anchor, n_fix, range, n_scale); 
        agent = PP(:,1:n_fix)';
        %% generate noise
        noise_type = 'additive normal';
    %   noise_type = 'multiplicaTtive';
        dd_error = generate_noise(dd, nf_noise, noise_type); 
        %% store neighbor nodes index
        [ix,jy] = find(dd_error);
        link = cell(n_fix+m,1);
        sum_link =zeros(n_fix,1);
        for i = 1:n_fix+m
        link{i} = ix(find(jy==i));
        sum_link(i) = length(link{i});
        end
        %% run SP-ADMM algorithm
        x0 =[n_scale.*unifrnd(-1,1,n_fix,2);anchor];
        [rmse_sp,S_sum,U_sum,P_sum,x_estimate_last] = sp_admm(agent,sum_link,link,c,rho,u0,a0,x0,step,n_fix,m,dd_error);
        RMSE_SP_ADMM = RMSE_SP_ADMM+rmse_sp;
        S = S+S_sum;
        U = U+U_sum;
        P = P+P_sum;
%         x_position = x_position+x_estimate_last(:);
    end
    RMSE_SP_ADMM_ave(:,ii)=RMSE_SP_ADMM./N_MC;
    S_ave(:,ii)=S./N_MC;
    U_ave(:,ii)=U./N_MC;
    P_ave(:,ii)=P./N_MC;
%     x_position_ave(:,ii)=x_position./N_MC;
end


Plot_figure

