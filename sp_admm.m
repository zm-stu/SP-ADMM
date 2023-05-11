function rmse_sp = sp_admm(agent,sum_link,link,c,rho,u0,a0,x0,step,n_fix,m,dd_error)


ATA = cell(n_fix+m,1);
QTD = cell(n_fix+m,1);
cAA2QQ = cell(n_fix+m,1);
W_inv = cell(n_fix+m,1);
I_Wtilde = cell(n_fix+m,1);
Wtide = cell(n_fix+m,1);
xtilde_t = cell(1,n_fix+m);
x = cell(1,n_fix+m);
u = cell(1,n_fix+m);
alpha = cell(1,n_fix+m);
rmse_sp=zeros(step,1);
rmse_sp(1)=RMSE_calculator(x0(1:n_fix,:)', agent');

%-------------initialization----------------------------------------------------
for i = 1:n_fix+m
    a = sum_link(i);
    x_0 = [x0(i,:);ones(a,1)*x0(i,:);x0(link{i},:)]';
    x{1,i} = x_0(:);
    odd=1:2:2*a-1;
    ove=2:2:2*a;   
    alpha{1,i} = sparse([odd,ove,1:2*a],[ones(1,a),2.*ones(1,a),3:2*a+2],[ones(2*a,1);-ones(2*a,1)],2*a,(2*a+1)*2)'*(a0.*ones(a*2,1));
    ATA{i,1} = sparse([odd,2*a+1,ove,2*a+2,ones(1,a),2.*ones(1,a),3:2*a+2],[ones(1,a+1),2.*ones(1,a+1),3:2:2*a+1,4:2:2*a+2,3:2*a+2],[a;-ones(a,1);a;-ones(3*a,1);ones(2*a,1)],(2*a+1)*2,(2*a+1)*2);
    b1 = repmat(1./[(c+2)*2*a,(2*c).*ones(1,a),4.*ones(1,a)],2,1);
    W_inv{i,1} = spdiags(b1(:),0,(2*a+1)*2,(2*a+1)*2);
    b2 = repmat([1,2*c/(4+2*c).*ones(1,a),4/(4+2*c).*ones(1,a)],2,1);
    Wtide{i,1} = spdiags(b2(:),0,(2*a+1)*2,(2*a+1)*2);
    I_Wtilde{i,1} = spdiags(1-b2(:),0,(2*a+1)*2,(2*a+1)*2);
    Q = sparse([odd,ove,1:2*a],[ones(1,a),2.*ones(1,a),(a+1)*2+1:(2*a+1)*2],[ones(2*a,1);-ones(2*a,1)],2*a,(2*a+1)*2);
    b3=repmat(full(dd_error(i,link{i})),2,1);
    QTD{i,1} = Q'* spdiags(b3(:),0,2*a,2*a);
    cAA2QQ{i,1} = c.*ATA{i,1}+2.*Q'*Q;
    u{1,i} = u0.*ones(a*2,1);
end
%-------------update----------------------------------------------------

for t = 2:step
    tic;   
        for i = 1:n_fix+m
               eta = -2.*QTD{i,1}*u{1,i}+cAA2QQ{i,1}*x{1,i}+alpha{1,i};
              xtilde_t{1,i} = x{1,i}-W_inv{i,1}*eta;
             if i > n_fix
                xtilde_t{1,i}(1:2,:) = x0(i,:)';
             end
        end 
        %-------------------broadcast---------------------------------------- 
        for i = 1:n_fix+m 
            HWz = zeros(size(xtilde_t{1,i}));   
            br = sum_link(i);
            for j = 1:br
                nei = find(i==link{link{i}(j)});
                N_j = sum_link(link{i}(j));
                HWz(2*j+1:2*j+2,1) = xtilde_t{1,link{i}(j)}((1+N_j+nei)*2-1:(1+N_j+nei)*2,1);
                HWz((1+br+j)*2-1:(1+br+j)*2,1) = xtilde_t{1,link{i}(j)}(2*nei+1:2*nei+2);
            end
            x{1,i} = Wtide{i,1}*xtilde_t{1,i}+I_Wtilde{i,1}*HWz;
        end
        %------------------------update---lambda-u-------
        esti = zeros(n_fix,2);
        for i = 1:n_fix+m 
             alpha{1,i} = alpha{1,i} + c.*(ATA{i,1}*x{1,i});
             u{1,i} = u{1,i} + 2/rho.*(QTD{i,1})'*x{1,i};
             for jj = 1:sum_link(i)
                 u{1,i}(2*jj-1:2*jj) = u{1,i}(2*jj-1:2*jj)./max(norm(u{1,i}(2*jj-1:2*jj),2),1);
             end
             if i<=n_fix
                 esti(i,:) = x{1,i}(1:2,1)';
             end
        end
        rmse_sp(t)=RMSE_calculator(esti', agent');
        
end






       
