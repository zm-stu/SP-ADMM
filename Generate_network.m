function [num,PP, dd, Connect_Mat] = Generate_network(anchor, n_fix, CommRange, n_scale)


m = size(anchor,1);
Connect_Mat = zeros(n_fix);
num=0;

while any(sum(Connect_Mat~=0)>2 == 0) % 每个agent至少与3个节点相连（Connect_Mat的第i行除对角线外至少有3个非零元）
    
    agent = n_scale.*rand(n_fix, 2);
    PP = [agent; anchor]';
    
    %% dd <-- the matrix of true distance 
    
    Dist_Mat = zeros(n_fix+m, n_fix+m);
    for i = 1:n_fix+m
        Diff = repmat(PP(:, i), 1, n_fix+m) - PP(:, :);  %Diff由矩阵PP(:, i)复制成1*（n_fix+m）块平铺而成
        Dist_i2All = sqrt(diag(Diff'*Diff));
        Dist_Mat(i, :) = Dist_i2All; % 第i个与其余节点的距离， Dist_Mat的对角线为全为0
    end
    
    Connect_Mat = (Dist_Mat<=CommRange); % 小于等于CommRange的为1，其余为0
    Connect_Mat = Connect_Mat - eye(m+n_fix); % Connect_Mat对角线全为0
    num=num+1;
end
dd = Dist_Mat.*Connect_Mat;