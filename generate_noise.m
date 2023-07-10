% nf_all = 0.1
function dd_errork = generate_noise(dd0, nf_all, noisetype)

if numel(nf_all) == 1 % Returns the number of non-zero elements
    nf = nf_all;
elseif numel(nf_all) == 2
    mu = nf_all(1);
    nf = nf_all(2);
end

% for t = 1:2
% 
%     if t == 1
        dd = dd0;
%     else
%         dd = dd_sf;
%     end

    dd_tril = tril(dd); % dd 矩阵的下三角矩阵,其余元素补0。

%     Connect_Idx = find(dd);
    Connect_dd_tril_Idx = find(dd_tril); % 按列将矩阵拉直成向量后，其中不为零元素的序号
    N_Idx = length(Connect_dd_tril_Idx); % 下三角形中非零元素的个数，也即是 边 的个数

    dd_error_1 = dd; % dd:真实的距离矩阵
%     noise = zeros(size(dd));

    switch noisetype
        case 'interval'
            noise_Vec = nf*(rand(N_Idx, 1)-0.5);
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx) + noise_Vec;
        case 'additive normal'
            % noise(Connect_dd_tril_Idx) = noise_Vec;
            noise_Vec = nf*randn(N_Idx, 1); % 距离间的量测噪声：0.1*标准正态分布，服从N(0,0.01)正态分布
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx) + noise_Vec; % 相连接的节点间真实距离加高斯量测噪声
        case 'Gaussian: non-zero mean'
            noise_Vec = mu + nf*randn(N_Idx, 1);
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx) + noise_Vec;
        case 'half normal'
            % noise(Connect_dd_tril_Idx) = noise_Vec;
            noise_Vec = nf*randn(N_Idx, 1);
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx) + abs(noise_Vec);        
        case 'additive Laplacian'
            UnifRnd = rand(N_Idx, 1) - 0.5;
            noise_Vec = nf*sign(UnifRnd).*log(1-2*abs(UnifRnd));
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx) + noise_Vec;
        case 'multiplicative'        
            noise_Vec = nf*randn(N_Idx, 1);
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx).*(1+ noise_Vec);
        case 'log-normal'
            noise_Vec = nf*randn(N_Idx, 1);
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx).*10.^noise_Vec;
    end

    dd_error = tril(dd_error_1) + tril(dd_error_1)';
    dd_error = abs(dd_error);
%     if t == 2   
%         dd_sf_error = dd_error;
%     else
        dd_errork = dd_error;
%     end
% end