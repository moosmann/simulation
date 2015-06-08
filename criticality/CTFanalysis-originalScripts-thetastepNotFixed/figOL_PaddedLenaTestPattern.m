%Prior to execution the script 'CTFanlaysis.m' needs to be executed or
%CTFanlaysis-workspace.mat' needs to be loaded and 'FitCritExpoScript.m'
%needs to be run.


ca
% Create figure
figure1 = figure('Name','Padded Lena test pattern');
colormap('gray');
%set(gcf,'position',[0 0, 900 900])
set(gcf,'defaulttextinterpreter','none')

% Create axes
axes1 = axes('Parent',figure1,'YTick',[0 200 400 600 800 1000],...
    'YAxisLocation','right',...
    'YDir','reverse',...
    'XTick',[0 200 400 600 800 1000],...
    'TickDir','out',...
    'Layer','top',...
    'FontSize',18,...
    'DataAspectRatio',[1 1 1],...
    'CLim',[0 0.01]);

xlim(axes1,[1 1024]);
ylim(axes1,[1 1024]);
box(axes1,'on');
hold(axes1,'all');

% Create image
image(phase,'Parent',axes1,'CDataMapping','scaled');

saveas(gcf,'./figs//Fig-1a.eps','epsc2')
set(gcf,'PaperPositionMode','Auto') 
saveas(gcf,'./figs//Fig-1a_nonquadr.eps','epsc2')
saveas(gcf,'./figs//LenaTestPatternPadded_(Fig-1a).eps','epsc2')