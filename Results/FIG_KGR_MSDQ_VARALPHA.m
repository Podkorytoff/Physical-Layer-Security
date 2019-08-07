clear variables; %close all;

%% Reading data
fileStr = {
    'RES_QPSK_MSDQ_VARALPHA'
    };

load(char(fileStr));

%% Parameters for figure setup
mark_vec = {'o', '+', '*', 'x', 's', '^', 'v'};
color_vec = {'b', 'r', 'g', 'c', 'k', 'y', 'm'};
left = 10; botton = 5; width = 9; height = 5; % Sizes for IEEE article
fontSize = 8;
labelFontName = 'Times New Roman';
axisFontName = 'Times New Roman';
lineWidth = 1.0;

%% KGR variando o alpha
figure
for k = 1:length(alpha)
    h = semilogy(SNR, KGR(:, k));
    h.DisplayName = ['\alpha = ' num2str(alpha(k))];
    h.Marker = char(mark_vec(k));
    h.Color = char(color_vec(k));
    h.LineWidth = lineWidth;
    hold on;
end
grid on;
xlabel('SNR (dB)')
ylabel('KGR')
axis([SNR(1) SNR(end) 0.3 1]);

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
print('Figures/FIG_KGR_MSQ_VARALPHA.eps', '-depsc2')
print('Figures/FIG_KGR_MSQ_VARALPHA.png', '-dpng')