clc; clear all; 
% close all; 
%N = 1e2; 
Nit = 1e4; 
snr = 0:5:30;
M = 4;
k = log2(M);
n = 2^8;
L = 4;
d = 32;
const = [-0.7071 - 0.7071i, -0.7071 + 0.7071i, 0.7071 - 0.7071i, 0.7071 + 0.7071i]; 
mse = zeros(length(snr), 1); 
H_A = zeros(n, Nit);
H_B = zeros(n, Nit);
N = 2^8;
alpha = 0.3;
cont = 0;
barStr = 'Key Generation Simulation';
progbar = waitbar(0, 'Initialization waitBar...', 'Name', barStr);
KDR = zeros(length(snr),1);
c_att = 2;                      % Exponential decay factor
var_ch = exp(-(0:L-1)/c_att);
varch = var_ch/sum(var_ch);    % Channel Power Profile (linear)
KGR = zeros(length(snr),1);

%for u = 1:length(alpha)
    
    for w = 1:length(snr) % Loop de SNR 

        for j = 1:Nit % Loop de média 

            %% Transmissor Alice 
            training_code = randi([0 1], N*k, 1) ;  %sequencia de treinamento de mil bits ou meus "x", preciso montar a matriz de convolução dele e multiplicar com os coeficientes para obter o "y" 
            % Modula os dados: 
            data_training_A = qammod(training_code, M,'bin', ... 
                'InputType','bit','UnitAveragePower',true,... 
                'PlotConstellation',false); 


            %% Canal entre Alice e Bob 
            h = sqrt(1/2)*(randn(L,1) + 1i*randn(L,1)).*sqrt(varch.'); % Gera a resposta ao impulso do canal 
            y_A = filter(h, 1, data_training_A); % Passa pelo canal (representação de um Filtro FIR quando a = 1) 
            rec_data_A = awgn(y_A, snr(w), 'measured'); 

            %% Receptor Bob 
            % Estima o canal: 
            chanest_B = estimation(data_training_A, rec_data_A, L);
            H_A(:,j) = fft(chanest_B, n);

            %% Transmissor Bob 
            training_code_B = randi([0 1], N*k, 1); 
            data_training_B = qammod(training_code_B, M,'bin', ... 
                'InputType','bit','UnitAveragePower',true,... 
                'PlotConstellation',false); 


            %% Canal entre Bob e Alice 

            y_B = filter(h, 1, data_training_B); 
            rec_data_B = awgn(y_B, snr(w), 'measured'); 

            %% Receptor Alice 
            chanest_A = estimation(data_training_B, rec_data_B, L);
            H_B(:,j) = fft(chanest_A, n);

           cont = cont + 1;
           prog = cont/(Nit*length(snr));
           perc = 100*prog;
           waitbar(prog, progbar, sprintf('%.2f%% Concluded', perc));

        end

        info_A = tratamento(H_A, n*Nit, d);
        info_B = tratamento(H_B, n*Nit, d);

        for q = 1:(n*Nit/d)
           threshold_A_max = mean(info_A(:,q)) + alpha*std(info_A(:,q)); 
           threshold_A_min = mean(info_A(:,q)) - alpha*std(info_A(:,q));
           key_A(:,q) = keygenerator(threshold_A_max,threshold_A_min, info_A(:,q));
           threshold_B_max = mean(info_B(:,q)) + alpha*std(info_B(:,q)); 
           threshold_B_min = mean(info_B(:,q)) - alpha*std(info_B(:,q));
           key_B(:,q) = keygenerator(threshold_B_max,threshold_B_min, info_B(:,q)); 
        end

        key_A_final = reshape(key_A, [n*Nit,1]);
        key_B_final = reshape(key_B, [n*Nit,1]);
        idx_B = find(key_B_final == 5);     
        idx_A = find(key_A_final == 5);      
        %% Index Exchange
        idx_C = unique([idx_A(:); idx_B(:)]);        
        %% Dropping Bits
        key_A_final(idx_C) = [];
        key_B_final(idx_C) = [];

        %% Key Disagreement Rate
        [n_err, KDR(w)] = biterr(key_A_final, key_B_final);
        %% Key Generation Rate
        n_equal = length(key_A_final) - n_err;
        
        KGR(w) = n_equal/(n*Nit);


    end

%end
close(progbar);

figure
semilogy(snr, KDR, 'LineWidth', 2);
grid on;
xlabel('SNR');
ylabel('KDR');
title('Key Disagreement Rate - Standard-Deviation Based Quantization - Phase');
legend('KDR');

hold on

figure
semilogy(snr, KGR, 'LineWidth', 2);
grid on;
xlabel('SNR');
ylabel('KGR');
title('Key Generation Rate');
legend('KGR');

%figure
%plot()