clear variables; %close all;

%% Reading data
fileStr = {
    'RES_QPSK_MSDQ_VARBLOCO'
    };

load(char(fileStr));

%% Parameters for figure setup
mark_vec = {'o', '+', '*', 'x', 's', '^', 'v'};
color_vec = {'b', 'r', 'g', 'c', 'k', 'y', 'm'};
left = 10; botton = 5; width = 9; height = 7; % Sizes for IEEE article
fontSize = 8;
labelFontName = 'Times New Roman';
axisFontName = 'Times New Roman';
lineWidth = 1.0;

%% KGR variando o bloco
figure
for k = 1:length(bloco)
    h = semilogy(SNR, KGR(:, k));
    h.DisplayName = ['bloco = ' num2str(bloco(k))];
    h.Marker = char(mark_vec(k));
    h.Color = char(color_vec(k));
    h.LineWidth = lineWidth;
    hold on;
end
grid on;
xlabel('SNR (dB)')
ylabel('KGR')
axis([SNR(1) SNR(end) 1e-6 1]);

%% Setting the figure up
% Setting figure properties:
fig = gcf;
fig.Units = 'centimeters';
fig.Position = [left botton width height];
fig.PaperPositionMode = 'auto';

% Setting axis properties:
ax = gca; % current axes
ax.FontName = axisFontName;
ax.FontSize = fontSize;

% Setting legend:
lgd = legend;
lgd.Interpreter = 'tex';
lgd.FontSize = fontSize;
lgd.FontName = labelFontName;
lgd.Location = 'best';

%% Saving figure
print('Figures/FIG_KGR_MSQ_VARBLOCO.eps', '-depsc2')
print('Figures/FIG_KGR_MSQ_VARBLOCO.png', '-dpng')