function key = maqQuant(X)
%x é o vetor de medidas
%cdf é a função distribuição cumulativa para cada medida
key = [];

%%ESTIMANDO A CDF
CDF = zeros(length(X), 1);
for i = 1:length(X)
    count = 0;
    for j = 1:length(X)
        
        if(abs(X(i)-X(j)) < 0.9)
            count = count + 1;
        end
    end
    CDF(i) = count/length(X);
end
%CDF = sort(CDF);
n_quant = (max(CDF) - min(CDF))/4;
for i = 1:length(X)
     if(min(CDF) <= CDF(i) && CDF(i) < (min(CDF)+ n_quant))
         key = [key; 0; 0];
     elseif((min(CDF) + n_quant) <= CDF(i) && CDF(i) < (min(CDF)+ 2*n_quant))
         key = [key; 0; 1];
     elseif((min(CDF) + 2*n_quant) <= CDF(i) && CDF(i) < (min(CDF)+ 3*n_quant))
         key = [key; 1; 0];
     elseif((min(CDF) + 3*n_quant) <= CDF(i) && CDF(i) <= max(CDF))
         key = [key; 1; 1];
     end
end