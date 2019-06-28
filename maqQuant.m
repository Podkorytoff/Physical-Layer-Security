function key = maqQuant(X)
%x � o vetor de medidas
%cdf � a fun��o distribui��o cumulativa para cada medida
key = [];

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
CDF = sort(CDF);
% Xord = sort(X);
% figure; plot(Xord, CDF)
n_quant = (max(CDF) - min(CDF))/4;
for i = 1:length(X)
     if(min(CDF) <= X(i) && X(i) < (min(CDF)+ n_quant))
         key = [key; 0; 0];
     elseif((min(CDF) + n_quant) <= X(i) && X(i) < (min(CDF)+ 2*n_quant))
         key = [key; 0; 1];
     elseif((min(CDF) + 2*n_quant) <= X(i) && X(i) < (min(CDF)+ 3*n_quant))
         key = [key; 1; 0];
     elseif((min(CDF) + 3*n_quant) <= X(i) && X(i) <= max(CDF))
         key = [key; 1; 1];
     end
end