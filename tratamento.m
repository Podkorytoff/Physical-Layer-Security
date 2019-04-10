function info = tratamento(a, mode)
% Função que trata o vetor de coeficientes, extrai a informação e separa em
% blocos menores, nos quais será realizada, individualmente, a quantização.
% Inputs:
%   a: Coeficientes do canal
%   mode: 'real' para obter os valores reais
%         'magnitude' para obter os valores de magnitude
%         'phase' para obter os valores de fase
%         'fine-grained' para obter o fine-graines CSI
% Outputs:
%   info: Valores a serem utilizados para quantização

a = a.';
h = a(:);

switch(mode)
    case('real')
        info = real(h);
    case('magnitude')
        info = abs(h);
    case('phase')
        info = phase(h);
    case('fine-grained')
        XA = [real(h).'; imag(h).'];
        XA = XA(:);
        info = XA;
end

end


