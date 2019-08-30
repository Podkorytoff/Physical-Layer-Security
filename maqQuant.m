function key = maqQuant(X, n)
%x ? o vetor de medidas
%cdf ? a fun??o distribui??o cumulativa para cada medida
key = [];
%X = info_A;
%%ESTIMANDO A CDF
% CDF = zeros(length(X), 1);
% Xord = sort(X);
% for i = 1:length(X)
%     fprintf('Estimando a CDF.\n')
%     i
%     count = 0;
%     for j = 1:length(X)
%         
%         if(X(j) <= X(i))
%             count = count + 1;
%         end
%     end
%     CDF(i) = count/length(X);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimando a CDF (versão Pedro)
L = length(X);
fprintf('Estimando a CDF.\n')
x = linspace(min(X), max(X), 100);
CDF = sum(X < x)/L;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%n = 4;
CDF = sort(CDF);
% Xord = sort(X);
%figure; plot(Xord, CDF)
p = (1:(n-1))/n;

for i = 1:length(p)
    [~, n_index(i)] = min(abs(CDF - p(i)));
end

x_quant = x(n_index);

fprintf('Quantizando.\n')
key = zeros(log2(n), length(X));
for i = 1:length(X)
    bit = sum(X(i) < x_quant);
    y = bin2gray(bit, 'pam', n);
    key(:,i) = de2bi(y, log2(n));
end
key = key(:);