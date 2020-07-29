%EDITBAT  edit a NETCDF bathymetry file under a graphical environment.
%
%
%   EDITBAT() open a browser to select the NETCDF bathymetry and
%   coastline file. At least the bathymetry file must be selected.
%
%   EDITBATHYMETRY(BATHYMETRYFILE)  BATHYMETRYFILE the NETCDF file.
%                   Example: 'example/etopo1_Arica.nc'
%
%   EDITBATHYMETRY(BATHYMETRYFILE, COASTLINEFILE) COASTLINEFILE a simple
%   table of two columns in text file format with the points of coastline.
%   The load() function read it.
%                   Example: 'example/coastline_norte.dat'
%
%   EDITBATHYMETRY returns nothing.
%
%   Version 1.0


%--------------------------------------------------------------------------
%  EDITBATHYMETRY is free software; you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published
%  by the Free Software Foundation; either version 2 of the License,
%  or (at your option) any later version.
%
%  EDITHBATIMETRY is distributed in the hope that it will be useful, but
%  WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program; if not, write to the Free Software
%  Foundation, Inc., 59 Temple Place, Suite 330, Boston,
%  MA  02111-1307  USA
%
%  Copyright (c) 2008
%  Andres Sepulveda, e-mail: andres@dgeo.udec.cl
%  Christian Torregrosa, e-mail: chtorregrosa@gmail.com
%  Osvaldo Artal, e-mail: oartal@oasc.cl (8,sept,2011)
%
%  Adaptado por Natalia Catalina Carrera Avila (DGEO-UdeC)
%--------------------------------------------------------------------------

function editlanduse_V03(cmin,cmax,bathymetryfile,coastlinefile)

% handles of the GUI elements
global handles;

% Handling the arguments

% if have not input the name of coast file, assume it is not available.
if (nargin < 4)
    coastlinefile = [];
end

% if there is no argument input, a browser appear to search the files
if (nargin < 3)
    [fn,pth]=uigetfile('*.nc','Select geo_em file ...');
    if (~fn),
        return,
    else
        bathymetryfile = [pth,fn];
    end
    % select a coast line is optional and can be omitted pressing cancel
    [fn,pth]=uigetfile([pth '*mask.mat'],'Select coastline file (Optional) ...');
    if (fn),
        coastlinefile = [pth,fn];
    end
end
if (nargin < 2)
    cmin=1;
    cmax=25;
end

% this function load the bathymetry
[xx,yy,zz] = load_landuse(bathymetryfile);

if isempty(coastlinefile)
    % Create coastline of crude resolution by default
    res = 'f'; %  !if you want, change this resolution
    coastlinefile = ['coastfile_',res,'_mask.mat'];
    create_coastline(xx,yy,res)
    [costax,costay] = load_coastline(coastlinefile);
else
    [costax,costay] = load_coastline(coastlinefile);
end

% Initialize the GUI, just create the handles
handles = CreateGUI(bathymetryfile);

% Determine the position of the elements of GUI
DrawGUI(handles);


% Draw the map in [Lon,Lat] coordinates
DrawMap(xx, yy, zz, ...
    costax,costay,[cmin cmax],...
    bathymetryfile);

% Setting the CALLBACK functions
set(gcf,'WindowButtonMotionFcn',@fcn_MouseMove);
set(gcf,'WindowButtonUpFcn',@fcn_UnClickOnImage);
set(handles.axis.colorbar.control,'ButtonDownFcn',@fcn_ClickOnColorBar);
set(handles.image,'ButtonDownFcn',@fcn_ClickOnImage);
set(handles.coast,'ButtonDownFcn',@fcn_ClickOnImage);
set(handles.info.selected.control,'Callback',@fcn_TypeDepth);
%DrawSteepness(xx,yy,zz);

end


%--------------------------------------------------------------------------
% Calculating the steepness
%--------------------------------------------------------------------------

% function DrawSteepness(xx,yy,zz)
% figure;
% [px,py] = gradient(zz);
% r_value = hypot(px,py);
% imagesc(unique(xx),unique(yy),r_value);
% set(gca,'Ydir','normal');
% xlabel('Latitude');
% ylabel('Longitude');
% title('Steepness');
% colorbar;
% end


% @fcn_QuitButton
%
% @fcn_SaveButton
%
% @fcn_OpenButton

%--------------------------------------------------------------------------
% Function called when the user press Quit Button
%--------------------------------------------------------------------------
function fcn_QuitButton(hObject, eventdata)
global handles;
option = questdlg('Are you sure to quit?');
if strcmp(option,'Yes')
    close(handles.figure);
end
end

%--------------------------------------------------------------------------
% Function called when the user press Save Button
%--------------------------------------------------------------------------

function fcn_SaveButton(hObject, eventdata)
global handles;
% [name,directory] = uiputfile('*.nc','Save File As:');
%
%
% % obtain the filename
% grdname = strcat(directory,name);
%
%
% % create NETCDF file
% nw=netcdf(grdname,'clobber');
% redef(nw);
%
% % create dimensions
% xdata = get(handles.image,'xdata');
% ydata = get(handles.image,'ydata');
%
% nw('eta_rho') = length(xdata);
% nw('xi_rho') = length(ydata);
%
% % Create variables and attributes
% nw{'lon_rho'}  = ncfloat('lon');
% nw{'lat_rho'}  = ncfloat('lat');
% nw{'topo'} = ncfloat('lat','lon');
%
% endef(nw);
%
% nw.title = grdname;
% nw.date  = date;
% nw.type  = 'ROMS topo file';
%
% close(nw);

% Fill in the data
option = questdlg('Are you sure to save?');
if strcmp(option,'Yes')
    cdata = get(handles.image,'cdata');
    cdata(isnan(cdata)==1)=0;
    nc=netcdf(handles.name,'write');
    nc{'LU_INDEX'}(:)=cdata;
    close(nc)
end

% set(handles.axis.panel,'Title',sprintf('File: %s',name));
end

%--------------------------------------------------------------------------
% Function called when the user press Open Button
%--------------------------------------------------------------------------

function fcn_OpenButton(hObject, eventdata)
global handles;

[fn,pth]=uigetfile('*.nc','Select geo_em file ...');
if (~fn),
    return,
else
    bathymetryfile = [pth,fn];
end

[xx,yy,zz] = load_landuse(bathymetryfile);

% select a coast line is optional and can be omitted pressing cancel
[fn,pth]=uigetfile([pth '*mask.mat'],'Select coastline file (Optional) ...');
if (fn),
    coastlinefile = [pth,fn];
else
    coastlinefile = [];
end

% loading linecoast data
if isempty(coastlinefile)
    % Create coastline of crude resolution by default
    res = 'c'; %  !if you want, change this resolution
    coastlinefile = ['coastfile_',res,'_mask.mat'];
    create_coastline(xx,yy,res)
    [costax,costay] = load_coastline(coastlinefile);
else
    [costax,costay] = load_coastline(coastlinefile);
end

cmin=50;
cmax=200;

cla(handles.image);
cla(handles.axis.colorbar.control);

% Draw the map in [Lon,Lat] coordinates
DrawMap(xx, yy, zz,...
    costax,costay,[cmin cmax],...
    bathymetryfile);

set(handles.axis.colorbar.control,'ButtonDownFcn',@fcn_ClickOnColorBar);
set(handles.image,'ButtonDownFcn',@fcn_ClickOnImage);
set(handles.coast,'ButtonDownFcn',@fcn_ClickOnImage);

end

%--------------------------------------------------------------------------
% Function called when the user type the Depth manually
%--------------------------------------------------------------------------
function fcn_TypeDepth(hObject, eventdata)

global handles;

ypos = str2double(get(hObject,'String'));

if isnan(ypos)
    ypos = 0;
end

AdjustColorEditDepth(handles.info.selected.control, ...
    handles.axis.colorbar.control, ypos);

end


%--------------------------------------------------------------------------
% Function called when the user select a color clicking on the colorbar
%--------------------------------------------------------------------------
function fcn_ClickOnColorBar(hObject, eventdata)

global handles;

handles.data.MouseButtonPressed = 1;

pt = get(gca,'CurrentPoint');
ypos = pt(1,2);
ypos = floor(ypos);
if ypos < 1 ;
 ypos = 1;
end

AdjustColorEditDepth(handles.info.selected.control, ...
    handles.axis.colorbar.control, ypos);

%keyboard
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function AdjustColorEditDepth(hObject, hColorbar, value)

invertcolor = 0.75;

rangocolor = get(hColorbar,'ylim');
mapacolores = colormap(jet(24));


color_index = fix((value-min(rangocolor))/...
    (max(rangocolor)-min(rangocolor))*size(mapacolores,1))+1;

if (color_index > size(mapacolores,1))
    color_index = size(mapacolores,1);
elseif (color_index < 1)
    color_index = 1;
end

set(hObject,'String',sprintf('%.02f', value),...
    'Background',mapacolores(color_index,:));

hsvcolor = rgb2hsv(mapacolores(color_index,:));

if (hsvcolor(3) < invertcolor)
    set(hObject,'ForegroundColor',[1 1 1]);
else
    set(hObject,'ForegroundColor',[0 0 0]);
end

end

%--------------------------------------------------------------------------
% Function called when a mouse move event occur
%--------------------------------------------------------------------------
function fcn_MouseMove(hObject, eventdata)
global handles

pt = get(handles.axis.graph.control,'CurrentPoint');
xpos = pt(1,1);
ypos = pt(1,2);

xdata = get(handles.image,'xdata');
ydata = get(handles.image,'ydata');

% Get the axes limits of the graph control

xLim = [min(xdata) max(xdata)];
yLim = [min(ydata) max(ydata)];

eje = axis(handles.axis.graph.control);

% Get the size of the data
max_i = length(ydata);
max_j = length(xdata);

% Check if its within axes limits
if (xpos > eje(1)) && (xpos < eje(2)) && ...
        (ypos > eje(3)) && (ypos < eje(4)) && ...
        (xpos > xLim(1)) && (xpos < xLim(2)) && ...
        (ypos > yLim(1)) && (ypos < yLim(2))
    
    i = round((ypos-yLim(1))*(max_i-1)/(yLim(2)-yLim(1))+1);
    j = round((xpos-xLim(1))*(max_j-1)/(xLim(2)-xLim(1))+1);
    handles.data.ij = [i j];
    cdata = get(handles.image,'cdata');
    
    set(handles.info.coord.control,'string',sprintf('%.0f , %.0f',i,j));
    set(handles.info.lon.control,'string',sprintf('%.2f°',xpos));
    set(handles.info.lat.control,'string',sprintf('%.2f°',ypos));
    set(handles.info.depth.control,'string',sprintf('%.2f',cdata(i,j)));
    
    if (handles.data.MouseButtonPressed)
        fcn_ClickOnImage(hObject, eventdata);
    end
else
    % ELSE if its within colorbar limits and mouse button pressed,
    % change the depth selected
    
    pt = get(handles.axis.colorbar.control,'CurrentPoint');
    xpos = pt(1,1);
    ypos = pt(1,2);
    
    xLim = get(handles.axis.colorbar.control, 'XLim');
    yLim = get(handles.axis.colorbar.control, 'YLim');
    
    if (xpos > xLim(1)) & (xpos < xLim(2)) & ...
            (ypos > yLim(1)) & (ypos < yLim(2)) & ...
            (handles.data.MouseButtonPressed == 1) %#ok<AND2>
        AdjustColorEditDepth(handles.info.selected.control, ...
            handles.axis.colorbar.control, ypos);
    end
end

end

%--------------------------------------------------------------------------
% When occur a click on image, the pixel must change
%--------------------------------------------------------------------------
function fcn_ClickOnImage(hObject, eventdata)

global handles;

handles.data.MouseButtonPressed = 1;

ButtonPressed = get(gcf,'SelectionType');

cdata = get(handles.image,'cdata');

i = handles.data.ij(1);
j = handles.data.ij(2);

if strcmp(ButtonPressed,'normal')
    cdata(i,j) = str2double(get(handles.info.selected.control,'String'));
    set(handles.image, 'cdata', cdata);
elseif strcmp(ButtonPressed,'alt')
    AdjustColorEditDepth(handles.info.selected.control, ...
        handles.axis.colorbar.control, cdata(i,j));
end
drawnow;
end

function fcn_UnClickOnImage(hObject, eventdata)
global handles;
handles.data.MouseButtonPressed = 0;
end

%--------------------------------------------------------------------------
% Loading NETDCF file.
%--------------------------------------------------------------------------
function [xx,yy,zz] = load_landuse(archivo_batimetria)
nc=netcdf(archivo_batimetria,'w');
xx=nc{'XLONG_M'}(1,1,:);
yy=nc{'XLAT_M'}(1,:,1);
zz=nc{'LU_INDEX'}(1,:,:);
close(nc);
xx=xx';
end

%--------------------------------------------------------------------------
% Make linecoast file
%-------------------------------------------------------------------------
function create_coastline(xx,yy,res)
% Make the coastfile
lonmin=min(min(xx));
lonmax=max(max(xx));
latmin=min(min(yy));
latmax=max(max(yy));
dl=.1*max(lonmax-lonmin,latmax-latmin);
lonmin=lonmin-dl;
lonmax=lonmax+dl;
latmin=latmin-dl;
latmax=latmax+dl;
m_proj('mercator',...
    'lon',[lonmin lonmax],...
    'lat',[latmin latmax]);
fname=['coastfile_',res,'.mat'];
if res=='c',
    m_gshhs_c('save',fname);
end;

if res=='l',
    m_gshhs_l('save',fname);
end;

if res=='i',
    m_gshhs_i('save',fname);
end;

if res=='h',
    m_gshhs_h('save',fname);
end;

if res=='f',
    m_gshhs_f('save',fname);
end;
% Save cstline data in lon,lat form to be used in editmask
load(fname)
lon=ncst(:,1);
lat=ncst(:,2);
fname2=['coastfile_',res,'_mask.mat'];
eval(['save ',fname2,' lon lat']);
end



%--------------------------------------------------------------------------
% Loading coastline file
%--------------------------------------------------------------------------
function [costa_lon, costa_lat] = load_coastline(archivo_costa)
eval(['load ', archivo_costa])
costa_lon = lon;
costa_lat = lat;
end

%--------------------------------------------------------------------------
% Ploting
%--------------------------------------------------------------------------
function DrawMap(xx,yy,zz,costax,costay,rango_colores,bathymetryfile)
global handles;
%mask(mask==0)=NaN;
handles.image = imagesc(xx,yy,zz,'Parent',handles.axis.graph.control);
handles.axis.colorbar.control = colorbar;
eje = axis;
hold on;
handles.coast = plot(costax,costay,'k');
hold off;
axis equal;
axis(eje);
set(gca,'YDir', 'normal');      % invert Y axis

% adjust the file name. remove the path.
justname = strtok(bathymetryfile(end:-1:1),'/');
justname = strtok(justname,'\');
justname = justname(end:-1:1);

set(handles.axis.panel,'title',sprintf('File: %s', justname));
xlabel(handles.axis.graph.control,'Longitude');
ylabel(handles.axis.graph.control,'Latitude');
ylabel(handles.axis.colorbar.control,'Depth [meters]');

caxis(rango_colores);

end


%--------------------------------------------------------------------------
% Function CreateGUI and DrawGUI, create and redraw respectively, the
% Graphic User Interface.
%
% struct handles:
%
%         handles.figure
%
%         handles.data.MouseButtonPressed
%         handles.data.ij
%
%         handles.tools.panel
%         handles.tools.quit.control
%         handles.tools.save.control
%         handles.tools.open.control
%
%         handles.axis.panel
%         handles.axis.graph.control
%         handles.axis.colorbar.control
%
%         handles.info.coord.panel
%         handles.info.lat.panel
%         handles.info.lon.panel
%         handles.info.selected.panel
%
%         handles.info.coord.control
%         handles.info.lat.control
%         handles.info.lon.control
%         handles.info.selected.control
%
%         handles.coast
%         handles.axis.colorbar.control
%         handles.image
%
%--------------------------------------------------------------------------


function handles = CreateGUI(name)

%--------------------------------------------------------------------------
% Global Data
%--------------------------------------------------------------------------
handles.name = name;
handles.data.MouseButtonPressed = [];
handles.data.ij = [];

%--------------------------------------------------------------------------
% Figure
%--------------------------------------------------------------------------
handles.figure = figure;
set(handles.figure, 'Units','normal','Position',[0.3 0.2 0.5633 0.6],...
    'Color',[0.8 0.8 0.8]);
set(handles.figure,'Units','pixel');

%--------------------------------------------------------------------------
% Tools
%--------------------------------------------------------------------------
handles.tools.panel = uipanel('Title','Tools',...
    'Background',[0.8 0.8 0.8]);

handles.tools.quit.control = uicontrol('Style','pushbutton','String','Quit',...
    'Callback', @fcn_QuitButton);

handles.tools.save.control = uicontrol('Style','pushbutton','String','Save',...
    'Callback', @fcn_SaveButton);

handles.tools.open.control = uicontrol('Style','pushbutton','String','Open',...
    'Callback', @fcn_OpenButton);

%--------------------------------------------------------------------------
% Graphics
%--------------------------------------------------------------------------
handles.axis.panel = uipanel('Title','File Name', ...
    'Background',[0.8 0.8 0.8]);

% create the axis (area used by bathymetry)
handles.axis.graph.control = axes('Position', [0.1 0.1 0.6 0.6]);
handles.axis.colorbar.control = colorbar;
%--------------------------------------------------------------------------
% Info
%--------------------------------------------------------------------------
handles.info.coord.panel = uipanel('Title','Coordinates',...
    'Background',[0.8 0.8 0.8]);

handles.info.coord.control = uicontrol('Style','Text',...
    'Background',[0.8 0.8 0.8]);

%--------------------------------------------------------------------------
handles.info.lat.panel = uipanel('Title','Latitude',...
    'Background',[0.8 0.8 0.8]);

handles.info.lat.control = uicontrol('Style','Text',...
    'Background',[0.8 0.8 0.8]);

%--------------------------------------------------------------------------
handles.info.lon.panel = uipanel('Title','Longitude',...
    'Background',[0.8 0.8 0.8]);

handles.info.lon.control = uicontrol('Style','Text',...
    'Background',[0.8 0.8 0.8]);

%--------------------------------------------------------------------------
handles.info.depth.panel = uipanel('Title','Depth',...
    'Background',[0.8 0.8 0.8]);

handles.info.depth.control = uicontrol('Style','Text',...
    'Background',[0.8 0.8 0.8]);

%--------------------------------------------------------------------------
handles.info.selected.panel = uipanel('Title','Selected',...
    'Background',[0.8 0.8 0.8]);

handles.info.selected.control = uicontrol('Style','edit',...
    'Background',[0.8 0.8 0.8]);

%--------------------------------------------------------------------------

handles.info.lon.value = 0;
handles.info.lat.value = 0;
handles.info.selected.value = 0;



%--------------------------------------------------------------------------
% adding toolbar to the figure, this can help to
% make zoom in/out to the image.
set(handles.figure,'toolbar','figure');

end

%--------------------------------------------------------------------------
% Resize the elements of the GUI
%--------------------------------------------------------------------------
function DrawGUI(hObject, eventdata)

global handles;

%--------------------------------------------------------------------------
% Parameters
%--------------------------------------------------------------------------
border = 20;                    % space between controls
border2 = 10;                   % space between margin and edit
border3 = 40;                   % space between margin and graph
border4 = 5;                    % space between buttons
widthtools = 80;                % width of tools area, height follow window
widthinfo = 100;                % width of information area
heightinfo = 50;                % height of information area
heightbutton = 30;              % height of a button
SizeWindow = get(handles.figure,'Position'); % get the size of window

%--------------------------------------------------------------------------
% Global Data
%--------------------------------------------------------------------------

handles.data.KeyPressed = 0;
handles.data.ij = [1 1];

%--------------------------------------------------------------------------
% Tools
%--------------------------------------------------------------------------
set(handles.tools.panel,'Units','pixel',...
    'Position',[border border widthtools SizeWindow(4)-border]);
%    'Position',[border border widthtools SizeWindow(4)-2*border]);


set(handles.tools.quit.control,'Units', 'pixel', ...
    'Position',[border+border2,border+border2,widthtools-2*border2,heightbutton]);

set(handles.tools.save.control,'Units', 'pixel', ...
    'Position',[border+border2,border+border2+border4+heightbutton,...
    widthtools-2*border2,heightbutton]);

set(handles.tools.open.control,'Units', 'pixel', ...
    'Position',[border+border2,border+border2+2*(border4+heightbutton),...
    widthtools-2*border2,heightbutton]);

%--------------------------------------------------------------------------
% Graphic
%--------------------------------------------------------------------------
pos = [2*border+widthtools,2*border+heightinfo,...
    SizeWindow(3)-3*border-widthtools,...
    SizeWindow(4)-3*border-heightinfo];
set(handles.axis.panel,'Units','pixel','Position',pos);

set(handles.axis.graph.control,'Units','pixel',...
    'Position',[pos(1)+border3, pos(2)+border3, ...
    pos(3)-40-2*border3, pos(4)-1.5*border3]);

%--------------------------------------------------------------------------
% Info
%--------------------------------------------------------------------------
% Defining COORDINATES
pos = [2*border+widthtools, border, widthinfo, heightinfo];
set(handles.info.coord.panel,'Units','pixel','Position',pos);

set(handles.info.coord.control,'Units','pixel', ...
    'Position',[pos(1)+border2, pos(2)+border2-3, ...
    pos(3)-2*border2, pos(4)-10-2*border2]);

%--------------------------------------------------------------------------
% Defining LATITUDE
pos = [2*(2*border+widthtools), border, widthinfo, heightinfo];
set(handles.info.lat.panel,'Units','pixel','Position',pos);

set(handles.info.lat.control,'Units','pixel',...
    'Position',[pos(1)+border2, pos(2)+border2-3, ...
    pos(3)-2*border2, pos(4)-10-2*border2]);

%--------------------------------------------------------------------------
% Defining LONGITUDE
pos = [3*(2*border+widthtools), border, widthinfo, heightinfo];
set(handles.info.lon.panel,'Units','pixel','Position',pos);

set(handles.info.lon.control,'Units','pixel',...
    'Position',[pos(1)+border2, pos(2)+border2-3, ...
    pos(3)-2*border2, pos(4)-10-2*border2]);

%--------------------------------------------------------------------------
% Defining DEPTH
pos = [4*(2*border+widthtools), border, widthinfo, heightinfo];
set(handles.info.depth.panel,'Units','pixel','Position',pos);

set(handles.info.depth.control,'Units','pixel',...
    'Position',[pos(1)+border2, pos(2)+border2-3, ...
    pos(3)-2*border2, pos(4)-10-2*border2]);

%--------------------------------------------------------------------------
% Defining SELECTED
pos = [5*(2*border+widthtools), border, widthinfo, heightinfo];
set(handles.info.selected.panel,'Units','pixel','Position',pos);

set(handles.info.selected.control,'Units','pixel',...
    'Position',[pos(1)+border2, pos(2)+border2, ...
    pos(3)-2*border2, pos(4)-10-2*border2]);
end
