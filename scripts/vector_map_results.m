
clc; clear all; close all;

addpath('~/Desktop/dineof_summer_school/scripts/functions/');

ini_file = {'~/Desktop/dineof_summer_school/input_data/PEY_L3_Y2020M06_8.nc';...
 '~/Desktop/dineof_summer_school/input_data/POB_L3_Y2020M06_8.nc'};


out_file = {'~/Desktop/dineof_summer_school/my_result_folder/PEY_din_Y2020M06_8.nc';...
    '~/Desktop/dineof_summer_school/my_result_folder/POB_din_Y2020M06_8.nc'};

STA = {'PEY','POB'};

%Gather information needed for the mapping
for i =1:2
    xr = ncread(ini_file{i},'xr');
    yr = ncread(ini_file{i},'yr');
    lonr = ncread(ini_file{i},'lon');
    latr = ncread(ini_file{i},'lat');
    angr = ncread(ini_file{i},'ang');
    DATEjulian = ncread(ini_file{i},'time');
    vr = ncread(out_file{i},'v');
    vr(abs(vr)>10)=NaN;
    
    tmp = ncreadatt(ini_file{i},'/','grid origin coordinates');
    [tmp1 tmp2] = strtok(tmp,',');
    lon0  = str2double(strtok(tmp1,'lon:'));
    lat0  = str2double(strtok(tmp2,', lat:'));
    time0 = ncreadatt(ini_file{i},'time','units');
    time0 = time0(end-18:end);
    
    data.name    = STA{i};
    data.xr      = xr;
    data.yr      = yr;
    data.lonr    = lonr;
    data.latr    = latr;
    data.mask    = ones(size(lonr));
    % data.distr   = distr;
    data.angr    = angr;
    % data.angr_rx = angr_rx;
    data.time    = DATEjulian;
    data.vr      = vr;
    data.lon0    = lon0;
    data.lat0    = lat0;
    data.time0   = time0;

    radial_data(i)=data;
end

% load parameters 
CONFIGURATION;

% construct the total velocity
[currents grid] = vector_mapping(radial_data,cartesian_data_params);

%% write to NetCDF file

lon = grid.lon;
lat = grid.lat;


N_times = length(currents);
[N_y, N_x] = size(currents(1).u);

u = nan(N_times,N_y,N_x);
v = nan(N_times,N_y,N_x);

for i_time = 1 : N_times
    u(i_time,:,:) = currents(i_time).u;
    v(i_time,:,:) = currents(i_time).v;
end


time                  = [currents.time];
x                     = grid.x;
y                     = grid.y;
lon                   = grid.lon;
lat                   = grid.lat;

% Define the attributes to be written
time0               = currents(1).time0;  % time attribute
lon0                = grid.lon0;          % global attribute
lat0                = grid.lat0;          % global attribute
grid_resol          = grid.step;          % global attribute

%% Arrange data according to Ferret's convention (x,y,z,t)
%  (the data are in Matlab's spatial convention (y,x))
u                     = permute(u,[3,2,1]);                  %%% (t,y,x) -> (x,y,t)
v                     = permute(v,[3,2,1]);                  %%% (t,y,x) -> (x,y,t)
x                     = x';                                  %%% (y,x)   -> (x,y)
y                     = y';                                  %%% (y,x)   -> (x,y)
lon                   = lon';                                %%% (y,x)   -> (x,y)
lat                   = lat';                                %%% (y,x)   -> (x,y)

ncfile = '/data/MIO/natachab/dineof_summer_school/my_result_folder/currents_din.nc';

if exist(ncfile,'file')
    delete(ncfile);
end
nccreate(ncfile,'xv',...
         'Dimensions',{'x',N_x,'y',N_y},'Format','classic');
nccreate(ncfile,'yv',...
         'Dimensions',{'x',N_x,'y',N_y},'Format','classic');
nccreate(ncfile,'lon',...
         'Dimensions',{'x',N_x,'y',N_y},'Format','classic');
nccreate(ncfile,'lat',...
         'Dimensions',{'x',N_x,'y',N_y},'Format','classic');
nccreate(ncfile,'u',...
         'Dimensions',{'x',N_x,'y',N_y,'time',N_times}, 'Format','classic');
nccreate(ncfile,'v',...
         'Dimensions',{'x',N_x,'y',N_y,'time',N_times}, 'Format','classic');
nccreate(ncfile,'time',...
         'Dimensions',{'time',N_times},'Format','classic');
     

ncwriteatt(ncfile,'xv','long_name', char('x-coordinate'));
ncwriteatt(ncfile,'xv','units',     char('km'));

ncwriteatt(ncfile,'yv','long_name', char('y-coordinate'));
ncwriteatt(ncfile,'yv','units',     char('km'));

ncwriteatt(ncfile,'lon','long_name', char('Longitude'));
ncwriteatt(ncfile,'lon','units',     char('decimal deg'));

ncwriteatt(ncfile,'lat','long_name', char('Latitude'));
ncwriteatt(ncfile,'lat','units',     char('decimal deg'));


ncwriteatt(ncfile,'u','long_name',    char('Zonal current speed component'));
ncwriteatt(ncfile,'u','units',        char('m/s'));

ncwriteatt(ncfile,'v','long_name',    char('Meridional current speed component'));
ncwriteatt(ncfile,'v','units',        char('m/s'));

ncwriteatt(ncfile,'time','long_name', char('Valid Time'));

YYYYo = time0(1:4);
MMo   = time0(6:7);
DDo   = time0(9:10);
hho   = time0(12:13);
mmo   = time0(15:16);
sso   = time0(18:19);
ncwriteatt(ncfile,'time','units', ...
    char(['days since ' YYYYo '-' MMo '-' DDo ' ' hho ':' mmo ':' sso]));

ncwrite(ncfile,'xv',x);
ncwrite(ncfile,'yv',y);
ncwrite(ncfile,'lon',lon);
ncwrite(ncfile,'lat',lat);


ncwrite(ncfile,'u',u);
ncwrite(ncfile,'v',v);
ncwrite(ncfile,'time',time);





