clc; clear variables; % close all;

%% Par�metros da modula��o
Nit = 1e4;      % N�mero de itera��es
SNR = 0:5:30;   % Valores de SNR para simular
M = 4;          % Ordem da modula��o
k = log2(M);    % N�mero de bits em cada s�mbolo
N = 2^3;        % N�mero de portadoras e tamanho da FFT/IFFT
Nst = N;        % N�mero de s�mbolos de treinamento
Nbt = Nst*k;    % N�mero de bits de treinamento 

const = [-0.7071 - 0.7071i, -0.7071 + 0.7071i, 0.7071 - 0.7071i, 0.7071 + 0.7071i];
% mse = zeros(length(SNR), 1);

%% Par�metros do canal
L = 6;                      % Comprimento do canal
c_att = 2;                  % Fator de decaimento exponencial
pdp = exp(-(0:L-1)/c_att);
pdp = pdp'/sum(pdp);        % Channel Power Profile (linear)
method = 'real';

%% Par�metros do Quantizador
d = 32;                 % Tamanho de cada bloco
H_A = zeros(N, Nit);    % Vetor para armazenar medidas em Alice
H_B = zeros(N, Nit);    % Vetor para armazenar medidas em Bob

%% Inicializando simula��o
cont = 0;
barStr = 'Key Generation Simulation';
progbar = waitbar(0, 'Initialization waitBar...', 'Name', barStr);
KDR = zeros(length(SNR),1);
KGR = zeros(length(SNR),1);

    
for iSNR = 1:length(SNR) % Loop de SNR

    for iIt = 1:Nit % Loop de m�dia

        %% Transmissor Alice
        training_code = randi([0 1], Nbt, 1) ; % Sequencia de treinamento
        % Modula os dados:
        data_training_A = qammod(training_code, M, 'bin', ...
            'InputType', 'bit', ...
            'UnitAveragePower', true, ...
            'PlotConstellation', false);

        %% Canal entre Alice e Bob
        h = sqrt(0.5*pdp).*(randn(L, 1) + 1i*randn(L, 1)); % Gera a resposta ao impulso do canal
        y_A = filter(h, 1, data_training_A); % Passa pelo canal (representa��o de um Filtro FIR quando a = 1)
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
        prog = cont/(Nit*length(SNR));
        perc = 100*prog;
        waitbar(prog, progbar, sprintf('%.2f%% Concluded', perc));

    end

    %% Quantiza��o
    info_A = tratamento(H_A, 'fine-grained'); % Obtem informa��o em Alice
    info_B = tratamento(H_B, 'fine-grained'); % Obtem informa��o em Bob

    key_A = maqQuant(info_A,2); % Quantiza em Alice
    key_B = maqQuant(info_B,2); % Quantiza em Bob


    %% Key Disagreement Rate
   [n_err, KDR(iSNR)] = biterr(key_A, key_B);

    %% Key Generation Rate
   n_equal = length(key_A);
   KGR(iSNR) = n_equal/(2*Nst*Nit);


end
    


close(progbar);

%% Plota figuras
% KDR:
figure
h = semilogy(SNR, KDR, 'LineWidth', 2);
h.LineWidth = 2;
hold on;

grid on;
xlabel('SNR');
ylabel('KDR');
title('Key Disagreement Rate - Multibit Adaptive Quantization');
legend;
 
% KGR:
figure
h = semilogy(SNR, KGR, 'LineWidth', 2);
h.LineWidth = 2;
hold on;
grid on;
xlabel('SNR');
ylabel('KGR');
title('Key Generation Rate - Multibit Adaptive Quantization');
legend;

%% Salvar dados
fileStr = ['Results/RES_QPSK_MSDQ_VARALPHA_' method];
save(fileStr, 'SNR', 'info_A', 'info_B', 'KGR', 'KDR', 'key_A', 'key_B');