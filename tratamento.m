function info = tratamento(a, b, d)
%Fun��o que trata o vetor de coeficientes, extrai a informa��o do canal e
%trata os limites de quantiza��o
%Inputs: 
%   Coeficientes do canal
%   Tamanho do vetor de coeficientes
%   Constante alpha
%Outputs:
%   Limites m�ximo e m�nimo
%   Vetor de informa��o do canal
        h = reshape(a, [b,1]);
        H = real(h);
       % H = zeros(length(h),1);
        %for j=1:2:length(a)
        %for j=1:2:length(H)   %obtendo o fine grained csi
            %H(j) = real(h(j));
            %H(j+1) = imag(h(j));  
       % end
           
        info = reshape(H, [d,b/d]);
        
        
       