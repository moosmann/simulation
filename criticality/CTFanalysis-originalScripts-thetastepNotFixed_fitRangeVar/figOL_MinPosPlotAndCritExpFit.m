%Prior to execution the script 'CTFanlaysis.m' needs to be executed or
%CTFanlaysis-workspace.mat' needs to be loaded and 'FitCritExpoScript.m'
%needs to be run.
ca
smaxIndex = 7;
%x0 = 1:600;
x0 = 1:512;
x1 = smin:smax(smaxIndex);
% Create figure
figure1 = figure('Name','Minimum position VS scaling including critical exponent fit');
set(gcf,'position',[0 0, 1600 900])
set(gcf,'defaulttextinterpreter','none')

% Create axes
axes1 = axes('Parent',figure1,'FontSize',18);
xlim(axes1,[0 600]);
ylim(axes1,[144 163]);
box(axes1,'on');
hold(axes1,'all');

% Create plot
plot(x0,cfMinPos(x0),'Marker','.','LineStyle','none');

% Create plot

plot(x1,CritExpFit{smaxIndex}(x1),'LineWidth',2,'Color',[1 0 0]);

% Create label
xlabel('x','FontSize',18);
ylabel('y','FontSize',18);

% Create textarrow
annotation(figure1,'textarrow',[0.455357142857143 0.588499550763702],...
    [0.476780767036059 0.166230366492147],'TextEdgeColor','none','FontSize',18,...
    'String',{'sc'});



set(gcf,'position',[0 0, 1600 900])
saveas(gcf,'./figs/Fig-2.eps','epsc2')
set(gcf,'PaperPositionMode','Auto') 
saveas(gcf,'./figs/Fig-2_nonquadr.eps','epsc2')
saveas(gcf,'./figs/MinPosPlotAndCritExpFit_(Fig-2).eps','epsc2')
