clc; clear variables; % close all;

%% Parâmetros da modulação
Nit = 1e4;      % Número de iterações
SNR = 0:5:30;   % Valores de SNR para simular
M = 4;          % Ordem da modulação
k = log2(M);    % Número de bits em cada símbolo
N = 2^8;        % Número de portadoras e tamanho da FFT/IFFT
Nst = N;        % Número de símbolos de treinamento
Nbt = Nst*k;    % Número de bits de treinamento 

const = [-0.7071 - 0.7071i, -0.7071 + 0.7071i, 0.7071 - 0.7071i, 0.7071 + 0.7071i];
% mse = zeros(length(SNR), 1);

%% Parâmetros do canal
L = 6;                      % Comprimento do canal
c_att = 2;                  % Fator de decaimento exponencial
pdp = exp(-(0:L-1)/c_att);
pdp = pdp'/sum(pdp);        % Channel Power Profile (linear)

%% Parâmetros do Quantizador
alpha = 0:0.2:0.8;      % Valores de alpha para simular
d = 32;                 % Tamanho de cada bloco
H_A = zeros(N, Nit);    % Vetor para armazenar medidas em Alice
H_B = zeros(N, Nit);    % Vetor para armazenar medidas em Bob

%% Inicializando simulação
cont = 0;
barStr = 'Key Generation Simulation';
progbar = waitbar(0, 'Initialization waitBar...', 'Name', barStr);
KDR = zeros(length(SNR), length(alpha));
KGR = zeros(length(SNR), length(alpha));

for iAlpha = 1:length(alpha) % Loop de alpha
    
    for iSNR = 1:length(SNR) % Loop de SNR
        
        for iIt = 1:Nit % Loop de média
            
            %% Transmissor Alice
            training_code = randi([0 1], Nbt, 1) ; % Sequencia de treinamento
            % Modula os dados:
            data_training_A = qammod(training_code, M, 'bin', ...
                'InputType', 'bit', ...
                'UnitAveragePower', true, ...
                'PlotConstellation', false);
            
            %% Canal entre Alice e Bob
            h = sqrt(0.5*pdp).*(randn(L, 1) + 1i*randn(L, 1)); % Gera a resposta ao impulso do canal
            y_A = filter(h, 1, data_training_A); % Passa pelo canal (representação de um Filtro FIR quando a = 1)
            rec_data_A = awgn(y_A, SNR(iSNR), 'measured');
            
            %% Receptor Bob
            % Estima o canal:
            chanest_B = estimation(data_training_A, rec_data_A, L);
            H_A(:, iIt) = fft(chanest_B, N);
            
            %% Transmissor Bob
            training_code_B = randi([0 1], Nbt, 1);
            data_training_B = qammod(training_code_B, M, 'bin', ...
                'InputType', 'bit', ...
                'UnitAveragePower', true, ...
                'PlotConstellation', false);
            
            %% Canal entre Bob e Alice
            y_B = filter(h, 1, data_training_B);
            rec_data_B = awgn(y_B, SNR(iSNR), 'measured');
            
            %% Receptor Alice
            chanest_A = estimation(data_training_B, rec_data_B, L);
            H_B(:, iIt) = fft(chanest_A, N);
            
            cont = cont + 1;
            prog = cont/(Nit*length(SNR)*length(alpha));
            perc = 100*prog;
            waitbar(prog, progbar, sprintf('%.2f%% Concluded', perc));
            
        end
        
        %% Quantização
        info_A = tratamento(H_A, 'fine-grained'); % Obtem informação em Alice
        info_B = tratamento(H_B, 'fine-grained'); % Obtem informação em Bob
        
        key_A = msdQuant(info_A, alpha(iAlpha), d); % Quantiza em Alice
        key_B = msdQuant(info_B, alpha(iAlpha), d); % Quantiza em Bob
        
        idx_B = find(key_B == 5); % Índices a serem descartados em Alice
        idx_A = find(key_A == 5); % Índices a serem descartados em Bob
        
        %% Index Exchange
        idx_C = unique([idx_A(:); idx_B(:)]);
        
        %% Dropping Bits
        key_A(idx_C) = []; % Descarta bits em Alice
        key_B(idx_C) = []; % Descarta bits em Bob
        
        %% Key Disagreement Rate
        [n_err, KDR(iSNR, iAlpha)] = biterr(key_A, key_B);
        
        %% Key Generation Rate
        n_equal = length(key_A);
        KGR(iSNR, iAlpha) = n_equal/(2*Nst*Nit);
        
        fprintf('Para SNR %d dB e alpha %d foi obtida uma KDR de %d.\n', SNR(iSNR), alpha(iAlpha), KDR(iSNR, iAlpha))
        
    end
    
end

close(progbar);

%% Plota figuras
% KDR:
figure
for k = 1:length(alpha)
    h = semilogy(SNR, KDR(:, k), 'LineWidth', 2);
    h.LineWidth = 2;
    h.DisplayName = ['\alpha = ' num2str(alpha(k))];
    hold on;
end
grid on;
xlabel('SNR');
ylabel('KDR');
title('Key Disagreement Rate - Standard-Deviation Based Quantization - Phase');
legend;

% KGR:
figure
for k = 1:length(alpha)
    h = semilogy(SNR, KGR(:, k), 'LineWidth', 2);
    h.LineWidth = 2;
    h.DisplayName = ['\alpha = ' num2str(alpha(k))];
    hold on;
end
grid on;
xlabel('SNR');
ylabel('KGR');
title('Key Generation Rate');
legend;

%% Salvar dados
fileStr = 'Results/RES_QPSK_MSDQ_VARALPHA.m'
save(fileStr, 'SNR', 'alpha', 'KDR', 'KGR');