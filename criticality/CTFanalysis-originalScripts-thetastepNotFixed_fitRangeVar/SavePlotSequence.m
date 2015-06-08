%% run CTFanalysis.m before, BUT ORIGINAL VERSION

plotFolder = sprintf('plots_fitRange_%03u-%03u',x(1),x(end));
CheckAndMakePath(plotFolder)

xfull = 1:size(y, 1);
nmax = size(y, 2);
for nn = 1:nmax
    plot(xfull, y(:,nn), '.b', ...
        xroi, cf{nn}(xroi), '-r', ...
        cfMinPos(nn), cfMinVal(nn), 'og')
    axis tight
    legend({sprintf('%u of %u\n$\\phi_{max} = $ %4.03g', nn, nmax, MaxPhaseShift(nn)),'fit',sprintf('MinPos: %5.3g',cfMinPos(nn))},'Interpreter','latex')
    saveas(gcf, sprintf('./%s/plot_%03u', plotFolder, nn), 'png')
    %pause(10/512)
end

xplot = 10:numel(MaxPhaseShift);
S = 1:numel(MaxPhaseShift);
plot(S(xplot),cfMinPos(xplot), '.')
axis tight
saveas(gcf, sprintf('./%s/MinPos_vs_S.png', plotFolder), 'png')
