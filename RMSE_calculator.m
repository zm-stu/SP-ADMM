%%*************************************************************************
%%   Input:  X_hat: estimated positions
%%           X: true positions
%%           MC: #(independent Monte Carlo runs)
%%
%%   Output: RMSE: root-mean-squared error
%%
%%*************************************************************************

function [RMSE] = RMSE_calculator(X_hat, X)

if numel(size(X_hat)) == 2
    n_fix = size(X_hat, 2);
    RMSE = sqrt(1/n_fix*trace((X_hat - X)'*(X_hat - X)));
elseif numel(size(X_hat)) == 3
    n_MC = size(X_hat, 1); 
    X_ext(1, :, :) = X;
    X_diff = X_hat - repmat(X_ext, n_MC, 1, 1);
    RMSE = sqrt(mean(mean(sum( X_diff.^2, 2), 3), 1));
end


