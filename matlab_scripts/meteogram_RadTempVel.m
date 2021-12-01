function [H] = meteogram_RadTempVel(nfile, name, inicio, rlon, rlat, t1, t2)

% nfile  : nombre archivo
% name   : nombre del lugar a evaluar
% inicio : fecha inicio simulacion en formato datenum
% rlon   : longitud a evaluar en la grilla mas cercana
% rlat   : latitud a evaluar en la grilla mas cercana, e.g. % rlon=[-71]; rlat=[-36]
% t1     : fecha inicial a evaluar en formato datenum
% t2     : fecha final a evaluar en formato datenum 

% ultima modificacion : 01/12/2021 chsegura

%% No modificar hacia abajo!

XLAT = ncread(nfile, 'XLAT');% latitud (sur negativo)
XLONG = ncread(nfile, 'XLONG');% longitud (oeste negativo)

XLAT = double(XLAT);
XLAT = squeeze(XLAT(:, :, 1));

XLONG = double(XLONG);
XLONG = squeeze(XLONG(:, :, 1));

lat = XLAT(1, :);
lat = lat';
lon = XLONG(:, 1);

x = lon;% 
y = lat;% 

clear minimox positionx minimoy positiony mas_cercanox mas_cercanoy
for i=1:length(rlon)
    [minimox(i), positionx(i)] = min(abs(x - rlon(i)));
    [minimoy(i), positiony(i)] = min(abs(y - rlat(i)));
    mas_cercanox(i) = x(positionx(i));
    mas_cercanoy(i) = y(positiony(i));
end

disp('Información sobre el lugar a evaluar')
disp(' ')
disp(['grilla más cercana lon: ', num2str(positionx),', valor: ', num2str(mas_cercanox)])
disp(['grilla más cercana lat: ', num2str(positiony),', valor: ', num2str(mas_cercanoy)])
disp(' ')

%% Fileinfo

TITLE      = ncreadatt(nfile, '/', 'TITLE');
START_DATE = ncreadatt(nfile, '/', 'START_DATE');
WE         = ncreadatt(nfile, '/', 'WEST-EAST_GRID_DIMENSION');
SN         = ncreadatt(nfile, '/', 'SOUTH-NORTH_GRID_DIMENSION');
Levels     = ncreadatt(nfile, '/', 'BOTTOM-TOP_GRID_DIMENSION');
DX         = ncreadatt(nfile, '/', 'DX');
DY         = ncreadatt(nfile, '/', 'DY');
Phys_Opt   = ncreadatt(nfile, '/', 'MP_PHYSICS');
PBL_Opt    = ncreadatt(nfile, '/', 'BL_PBL_PHYSICS');
Cu_Opt     = ncreadatt(nfile, '/', 'CU_PHYSICS');

%% Read data surface

myVar = 'XTIME';% minutos desde iniciada la simulación
data = ncread(nfile,myVar);
out1 = minutes(diff(datetime([datestr(inicio, 'yyyy-mm-dd HH:MM:SS'); datestr(t1, 'yyyy-mm-dd HH:MM:SS')])));
out2 = minutes(diff(datetime([datestr(inicio, 'yyyy-mm-dd HH:MM:SS'); datestr(t2, 'yyyy-mm-dd HH:MM:SS')])));

idx = (floor(data)>=out1 & floor(data)<=out2);
valid_time = datenum(inicio + minutes(data(idx)));

auxnum = find(idx==1);
auxs = auxnum(1);
auxe = auxnum(end);
auxdif = auxe - auxs + 1;

myVar = 'T2';% temperatura a 2 metros
data = ncread(nfile, myVar, [positionx positiony auxs ], [1 1 auxdif]);
T2 = double(data) - 273.15;% kelvin a grados celcius
T2 = squeeze(T2);

myVar = 'PSFC';% surface pressure
data = ncread(nfile, myVar, [positionx positiony auxs ], [1 1 auxdif]);
PSFC = double(data)./100;% Pa to hPa
PSFC = squeeze(PSFC);

myVar = 'U10';% 
data = ncread(nfile, myVar, [positionx positiony auxs ], [1 1 auxdif]);
U10 = double(data);% 
U10 = squeeze(U10);

myVar = 'V10';% 
data = ncread(nfile, myVar, [positionx positiony auxs ], [1 1 auxdif]);
V10 = double(data);% 
V10 = squeeze(V10);

WND = sqrt(U10.^2 + V10.^2);

myVar = 'RAINC';% convective precip
data = ncread(nfile, myVar, [positionx positiony auxs ], [1 1 auxdif]);
RAINC = double(data);
RAINC = squeeze(RAINC);

myVar = 'RAINNC';% non-convective precip
data = ncread(nfile, myVar, [positionx positiony auxs ], [1 1 auxdif]);
RAINNC = double(data);
RAINNC = squeeze(RAINNC);

%% Read data vertical

myVar = 'PH';% 
data = ncread(nfile, myVar, [positionx positiony 1 auxs ], [1 1 Inf auxdif]);
PH = double(data);
PH = squeeze(PH);

myVar = 'PHB';% 
data = ncread(nfile, myVar, [positionx positiony 1 auxs ], [1 1 Inf auxdif]);
PHB = double(data);
PHB = squeeze(PHB);

myVar = 'P';% 
data = ncread(nfile, myVar, [positionx positiony 1 auxs ], [1 1 Inf auxdif]);
P = double(data);
P = squeeze(P);

myVar = 'PB';% 
data = ncread(nfile, myVar, [positionx positiony 1 auxs ], [1 1 Inf auxdif]);
PB = double(data);
PB = squeeze(PB);

PT = (P+PB)';

Z = (PH+PHB)./9.81;% altura 
Z = squeeze(Z)';
Z(:, 1) = [];

myVar = 'T';% perturbacion temperatura potencial
data = ncread(nfile, myVar, [positionx positiony 1 auxs ], [1 1 Inf auxdif]);
T = double(data) + 300;% theta + t0
T = squeeze(T)';

TEMP = T.*((PT./100000).^(2/7));
TEMPC = TEMP - 273.15;% temperatura celcius

myVar = 'QVAPOR';% 
data = ncread(nfile, myVar, [positionx positiony 1 auxs ], [1 1 Inf auxdif]);
QVAPOR = double(data);
QVAPOR = squeeze(QVAPOR)';

es = 6.112.*exp(17.67.*(TEMP-273.15)./(TEMP-29.65));
e = QVAPOR .* PT./100./(QVAPOR + 0.622);
RH = e./es;

zq = 500:500:10000;
for i=1:size(T,1)
    TEMPCn(i, :) = interp1(Z(i, :), TEMPC(i, :), zq);
    RHn(i, :) = interp1(Z(i, :), RH(i, :), zq);
end

CRAINNC = zeros(size(RAINC));
CRAINC = zeros(size(RAINC));

for i=1:length(RAINC)-1
    CRAINNC(i + 1) = RAINNC(i + 1) - RAINNC(i);
    CRAINC(i + 1) = RAINC(i + 1) - RAINC(i);
end

[X Y] = meshgrid(valid_time, zq);

%% set figure

cmap = colormap('jet');
cmap = flipud(cmap);
close all

H = figure('Position', [100, 100, 1150, 950]);

%% axes top

ax(1) = subplot(5, 2, [1 2 3 4]);

pcolor(X, Y, RHn'.*100)
shading interp
hold on
xlim([valid_time(1) valid_time(end)])

cb = colorbar('northoutside', 'FontWeight', 'bold', 'Linewidth', 1);
ylabel(cb, 'HR [%]', 'FontSize', 10);
caxis(ax(1), [0 100])
colormap(ax(1), cmap);

[C,h] = contour(X, Y, TEMPCn', 'k', 'LineWidth', 1);
clabel(C, h)

% xaxis settigns
xlim(ax(1), [valid_time(1) valid_time(end)])

% general settings
set(ax(1), 'TickDir', 'out')
grid(ax(1), 'on')
set(ax(1), 'xticklabel', [])

ylabel(ax(1), 'Height [m]', 'FontSize', 12)

posax1 = ax(1).Position;
poscb = cb.Position;
cb.Position(1) = posax1(1) + posax1(3)*0.5;
cb.Position(2) = posax1(2) + posax1(4) + 0.03;
cb.Position(3) = poscb(3)*0.5;
ax(1).Position = posax1;

%% axes middle

ax(2) = subplot(5, 2, [5 6]);

yyaxis right
p = plot(valid_time, T2, '-', 'color', [0.8 0 0], 'linewidth', 2, 'MarkerFaceColor', 'r');
hold on
xlim([valid_time(1) valid_time(end)])

yyaxis left
aux = bar(ax(2), valid_time, [CRAINNC CRAINC], 'stacked');
set(aux, {'FaceColor'}, {'b';'cyan'});
hold on
xlim([valid_time(1) valid_time(end)])

% xaxis settigns
xlim(ax(2), [valid_time(1) valid_time(end)])

% general settings
set(ax(2), 'TickDir', 'out')
grid(ax(2), 'on')
set(ax(2), 'xticklabel', [])

ax(2).YAxis(1).Label.String = 'PP [mm hr-1]';
ax(2).YAxis(1).Label.FontSize = 10;
ax(2).YAxis(1).Color = 'k';

ax(2).YAxis(2).Label.String = 'Temperature [°C]';
ax(2).YAxis(2).Label.FontSize = 10;
ax(2).YAxis(2).Color = 'k';

legend(aux, 'non-convective precip', 'convective precip')

%% axes bottom

ax(3) = subplot(5, 2, [7 8]);

yyaxis left
aux(1) = plot(valid_time, PSFC, '-k', 'linewidth', 2, 'MarkerFaceColor', 'k');
hold on
xlim([valid_time(1) valid_time(end)])

yyaxis right
plot(valid_time, zeros(size(valid_time)), '-', 'color', [0 0 0], 'linewidth', 1)
escala_c = 90/1;% escala para direccion del viento
hg2 = stickvect(valid_time, escala_c, U10, V10, numel(valid_time)/1);
set(hg2, 'LineWidth', 1, 'Color', 'b', 'LineStyle', '-');
hold on
aux(2) = plot(valid_time, WND, '-', 'color', [0.5 0.5 0.5], 'linewidth', 2, 'MarkerFaceColor', 'b');
hold on
xlim([valid_time(1) valid_time(end)])

% xaxis settigns
xlim(ax(3), [valid_time(1) valid_time(end)])
datetick('x', 'mmm.dd, HH:MM', 'keeplimits', 'keepticks')

% general settings
set(ax(3), 'TickDir', 'out')
grid(ax(3), 'on')
% set(ax(3), 'xticklabel', [])

ax(3).YAxis(1).Label.String = 'Pressure [hPa]';
ax(3).YAxis(1).Label.FontSize = 10;
ax(3).YAxis(1).Color = 'k';

ax(3).YAxis(2).Label.String = 'Wind Magnitude [m/s]';
ax(3).YAxis(2).Label.FontSize = 10;
ax(3).YAxis(2).Color = 'k';

legend([aux hg2], 'Press.', 'wnd mag.', 'wnd dir.')

%% settings info

dis = 0.1;
ax(1).Position(2) = ax(1).Position(2) - dis;
ax(2).Position(2) = ax(2).Position(2) - dis;
ax(3).Position(2) = ax(3).Position(2) - dis;
cb.Position(2) = cb.Position(2) - dis;

posfig = ax(1).Position;

dim = [0.2 0.5 0.3 0.3];
str = {['Ref time    : ', START_DATE], ['Local time : ', datestr(datenum(valid_time(1) - duration(3, 0, 0)), 'yyyy-mm-dd_HH:MM:SS')]};
an = annotation('textbox', dim, 'String', str, 'FitBoxToText', 'on', 'Interpreter', 'none');
an.FontSize = 9;
an.FontWeight = 'b';
an.EdgeColor = 'none';
pause(1)
an.Position(1) = posfig(1) + posfig(3) - an.Position(3)*0.92;
an.Position(2) = posfig(2) + posfig(4) + 0.1;

posfig = ax(3).Position;

dim = [0.2 0.5 0.3 0.3];
str = {[TITLE], [' WE = ', num2str(WE), '; SN = ', num2str(SN), '; Levels = ', num2str(Levels), '; Dis = ', num2str(DX), '; Phys Opt = ', num2str(Phys_Opt), '; PBL Opt = ', num2str(PBL_Opt), '; Cu Opt = ', num2str(Cu_Opt)]};
an = annotation('textbox', dim, 'String', str, 'FitBoxToText', 'on', 'Interpreter', 'none');
an.FontSize = 9;
an.FontWeight = 'b';
an.EdgeColor = 'none';
pause(1)
an.Position(1) = posfig(1);
an.Position(2) = posfig(2) - an.Position(4) - 0.055;

if (rlon>0 | rlon==0)
    nlon = [num2str(abs(rlon)), ' °E'];
elseif rlon<0
    nlon = [num2str(abs(rlon)), ' °W'];
end

if rlat>0
    nlat = [num2str(abs(rlat)), ' °N'];
elseif rlat<0
    nlat = [num2str(abs(rlat)), ' °S'];
elseif rlat==0
    nlat = ['EQ'];
end

tname = title(ax(1), {[name], ['Lon: ', nlon, ', Lat: ', nlat]}, 'FontWeight', 'n', 'FontSize', 12);  
set(tname, 'horizontalAlignment', 'left')
set(tname, 'units', 'normalized')
t1 = get(tname, 'position');
set(tname, 'position', [0 t1(2)+0.1 t1(1)]);

set(ax(1), 'xminorgrid', 'on', 'yminorgrid', 'on')
set(ax(1), 'XMinorTick', 'on', 'YMinorTick', 'on')

set(ax(2), 'xminorgrid', 'on', 'yminorgrid', 'on')
set(ax(2), 'XMinorTick', 'on', 'YMinorTick', 'on')

set(ax(3), 'xminorgrid', 'on', 'yminorgrid', 'on')
set(ax(3), 'XMinorTick', 'on', 'YMinorTick', 'on')

end
