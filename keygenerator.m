function key = keygenerator(threshold_max, threshold_min, phase)
%Função para gerar as chaves a partir da informação do canal
%Inputs:
%   Limites máximo e mínimo
%   Vetor de informação do canal
%Outputs:
%   Chave

        key = zeros(length(phase), 1);        
               
        for i = 1:length(phase) 
            if phase(i) > threshold_max 
                key(i) = 1; 
            elseif phase(i) < threshold_min
                key(i) = 0;
            else
                key(i) = 5;
            end 
        end
       