function key = maqQuant(X,n)
%x é o vetor de medidas
%cdf é a função distribuição cumulativa para cada medida
key = [];
%X = info_A;
%%ESTIMANDO A CDF
CDF = zeros(length(X), 1);
% Xord = sort(X);
for i = 1:length(X)
    count = 0;
    for j = 1:length(X)
        
        if(X(j) <= X(i))
            count = count + 1;
        end
    end
    CDF(i) = count/length(X);
end

%n = 4;
CDF = sort(CDF);
Xord = sort(X);
%figure; plot(Xord, CDF)
p = (1:(n-1))/n;

for i = 1:length(p)
    [~,n_index(i)] = min(abs(CDF - p(i)));
end

x_quant = Xord(n_index);


for i = 1:length(X)
     bit = sum(X(i) < x_quant);
     y = bin2gray(bit, 'pam', n);
     key(:,i) = de2bi(y, log2(n));
end
key = key(:);
