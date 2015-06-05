%% run CTFanalysis.m before, BUT ORIGINAL VERSION

xfull = 1:size(y, 1);
nmax = size(y, 2);
for nn = 1:nmax
    plot(xfull, y(:,nn), '.b', ...
        xroi, cf{nn}(xroi), '-r', ...
        cfMinPos(nn), cfMinVal(nn), 'og')
    axis tight
    legend({sprintf('%u of %u\n$\\phi_{max} = $ %4.02g', nn, nmax, MaxPhaseShift(nn))},'Interpreter','latex')
    saveas(gcf, sprintf('./plots/plot_%03u', nn), 'png')
    pause(10/512)
end