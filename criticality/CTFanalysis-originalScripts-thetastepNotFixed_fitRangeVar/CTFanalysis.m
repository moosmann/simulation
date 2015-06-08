%Analysis of the CTF model for increasing values of the absolute phase
%shift.

clear all
close all hidden

%% Parameters.
printPlots = 0;
filestring = './lena.tif';
blurring = [8 8 1];
energy = 10;
distance = 0.5;
pixelsize = 1.1e-6;
PhotonCountsForPoissonNoise = 0;
%% Read image and pad it with zeros.
paddim = 1/1*1024;
SineArgPreFac = pi*EnergyConverter(energy)*distance/(paddim*pixelsize)^2;
rescalVec = 1:1:512;
MaxPhaseShift = 0.01*rescalVec;
phase0 = zeros(paddim,paddim);
phase0(paddim/2+(-255:256),paddim/2+(-255:256)) = normat(double(imread(filestring)));
tic
for kk = length(MaxPhaseShift):-1:1
    phase = MaxPhaseShift(kk)*normat(phase0);
    %% Blur image.
    if blurring(1) > 0
        hsizex = blurring(1);
        hsizey = blurring(2);
        sigma  = blurring(3);
        phase  = imfilter(phase,fspecial('gaussian',[hsizex hsizey],sigma));
    end;
    %domain(phase,'blurred phase')
    phase = MaxPhaseShift(kk)*normat(phase);
    %% Compute intensity
    int = Propagation(phase,[energy distance pixelsize],2,'symmetric',0);
    if PhotonCountsForPoissonNoise > 0
        counts = PhotonCountsForPoissonNoise;
        if PhotonCountsForPoissonNoise*max(int(:))<2^16,
            int = imnoise(uint16(counts*int),'poisson');
            counts_min = min(int(:));
            counts_max = max(int(:));
            int = 1/counts*double(int);
        else
            fprintf(1,'Warning: Counts exceed 2^16\n');
        end;
    end;
    %domain(int,'Poisson-noised intensity')
    % Substract mean.
    int = int-mean(int(:));
    %% Modulus of Fourier transform of intensity contrast
    fint = fftshift(fft2(int));
    afint = abs(fint);


    %% Integration of absolut of FT of intensity over angular sector which avoid truncation rod.
    % Loop over angular offsets.
    for offsetFac = 5
        % Define angular sectors.
        thetaoffset = offsetFac*0.05;
        thetastep = pi/2*paddim/2;        
        theta = thetaoffset:thetastep:pi/2-thetaoffset;
        theta = cat(1,theta,theta+pi/2,theta+pi,theta+3*pi/2);
        % Loop over points along radial direction.
        for rr = paddim/2:-1:1
            for ii = length(theta):-1:1
                xx(ii) = afint(round(paddim/2+rr*cos(theta(ii))),round(paddim/2+rr*sin(theta(ii))));

            end
            y(rr,kk) = sum(xx)/length(theta);

        end
        % Plot integrated line.
        %figure(kk)
        %plot(1:length(y(:,kk)),y(:,kk))
    end
    %upperLimit =  MaxPhaseShift(kk)*1000;
    %lowerLimit = -MaxPhaseShift(kk)*100;
end
% Check angular range
mask = zeros(size(phase0));
for rr = paddim/2:-1:1
    for ii = length(theta):-1:1
        mask(round(paddim/2+rr*cos(theta(ii))),round(paddim/2+rr*sin(theta(ii))))=1;
    end
end
%ishow(mask)
fprintf('Time for computation of maps: %fs\n',toc)
xMin = 50;
x = xMin:200;
%xMin = 71;
%x = xMin:172;

SinArg = SineArgPreFac*x.^2;
%xMin = 170;
%x = xMin:230;
%% Fit integrated line.
xMax = 160;
tic
for kk = length(MaxPhaseShift):-1:1
    if printPlots(1)
        figure('Name',sprintf('Maximal phase shift: %f',MaxPhaseShift(kk)))
        cf{kk} = FitIntLine(x,y(x,kk),MaxPhaseShift(kk)*1000,-MaxPhaseShift(kk)*100);
        figure('Name',sprintf('Maximal phase shift (ratio): %f',MaxPhaseShift(kk)))
   
        disp(cf{kk})

    else
        cf{kk} = FitIntLineNoPlots(x,y(x,kk),MaxPhaseShift(kk)*1000,-MaxPhaseShift(kk)*100);
        
    end
    % Determine values and positions aof minima and maxima.
    [cfMaxVal(kk), cfMaxPos(kk)] = max(cf{kk}(xMin:xMax));
    [cfMinVal(kk), cfMinPos(kk)] = min(cf{kk}(xMin:xMax));
    
    
end
fprintf('Time for computation of line fits: %fs\n',toc)
%% Values, positions, velocity and ratio of maxima and minima.
% Correct for cut (xMin) in radial direction.
cfMaxPos = cfMaxPos + xMin;
cfMinPos = cfMinPos + xMin;


% Compute velocity of the minima and maxima.
cfMaxValD1 = diff(cfMaxVal);
cfMaxPosD1 = diff(cfMaxPos);
cfMinValD1 = diff(cfMinVal);
cfMinPosD1 = diff(cfMinPos);




% Compute supporting points for velocity vectores.
rescalVecD1 = interp1(1:length(rescalVec),rescalVec,0.5+(1:(length(rescalVec)-1)));
% Substract rescaled ground-state (GS) value from Maximum
cfMaxValn   = cfMaxVal-cfMaxVal(1)*rescalVec;
cfMaxValnD1 = diff(cfMaxValn);


xroi = x;
save('CTFanalysis-workspace.mat')
