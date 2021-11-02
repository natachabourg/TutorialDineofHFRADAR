% @ Julien Marmain 
% Script to pre process radial current file 
%to a format accepted by DINEOF algorithm
% % Variables to change :
% %
% - PATH_NC_in : path where the HFR radial file to fill is located
% - ncname_in : name of the HFR radial file to fill
% - PATH_NC : path where to put the preprocessed nc file 
% - ncname : name of the preprocessed nc file
% - STA : Name of your station
% - DATEtime_origin : the origin of your time variable in string format
% (only for meta data purposes)
% %
% 

clc; clear all; close all;

addpath('~/Desktop/dineof_summer_school/scripts/functions/');


stations = {'PEY','POB'};

for i = 1:2
    STA = stations{i};
    

    %%% NetCDF path of your input file 
    PATH_NC_in = '~/Desktop/dineof_summer_school/input_data/';

    %%% Name of your input file 
    ncname_in = [STA '_L3_Y2020M06_8.nc'];

    input_file = fullfile(PATH_NC_in,ncname_in);

    if ~exist(input_file,'file')
        disp('File in input not found');
    end

    %%% NetCDF path of your output file 
    PATH_NC = '~/Desktop/dineof_summer_school/input_data/';

    %%% Name of your output file 
    ncname = [STA '_Y2020M06_8_pre.nc'];

    ncfile = fullfile(PATH_NC,ncname);


    if ~exist(PATH_NC,'dir')
        mkdir(PATH_NC);
    end

    if exist(ncfile,'file')
        delete(ncfile);
    end

    

    %% data
    xr      = ncread(input_file,'xr');
    yr      = ncread(input_file,'yr');           
    angr    = ncread(input_file,'ang');     
    lonr    = ncread(input_file,'lon');    
    latr    = ncread(input_file,'lat');      
    time    = ncread(input_file,'time');
    DATEtime_origin=ncreadatt(input_file,'time','time_origin');

    vr = ncread(input_file,'v');
    
    if i==1
        vr(:,:,35:37)=NaN;
    elseif i==2
        vr(:,:,10:12)=NaN;
    end
    
    vr(:,:,70:72)= NaN;
    
    %%% Creation
    s = size(xr);
    nccreate(ncfile,'xr',...
        'Dimensions',{'x',s(1),'y',s(2)}, 'Format','classic');
    nccreate(ncfile,'yr',...
        'Dimensions',{'x',s(1),'y',s(2)}, 'Format','classic');
    nccreate(ncfile,'dist',...
        'Dimensions',{'x',s(1),'y',s(2)}, 'Format','classic');
    nccreate(ncfile,'ang',...
        'Dimensions',{'x',s(1),'y',s(2)}, 'Format','classic');
    nccreate(ncfile,'ang_rx',...
        'Dimensions',{'x',s(1),'y',s(2)}, 'Format','classic');
    nccreate(ncfile,'lon',...
        'Dimensions',{'x',s(1),'y',s(2)}, 'Format','classic');
    nccreate(ncfile,'lat',...
        'Dimensions',{'x',s(1),'y',s(2)}, 'Format','classic');
    nccreate(ncfile,'time',...
        'Dimensions',{'time',length(time)}, ...
        'Format','classic');
    nccreate(ncfile,'v',...
        'Dimensions',{'x',s(1),'y',s(2),'time',length(time)}, ...
        'Format','classic')

    %%% Attributes
    ncwriteatt(ncfile,'xr','long_name',char('Abscisse'));
    ncwriteatt(ncfile,'xr','units',    char('km'));

    ncwriteatt(ncfile,'yr','long_name',char('Ordinate'));
    ncwriteatt(ncfile,'yr','units',    char('km'));

    ncwriteatt(ncfile,'dist','long_name',char('Bistatic distance'));
    ncwriteatt(ncfile,'dist','units',    char('km'));

    ncwriteatt(ncfile,'ang','long_name',char('"Radial" direction (toward the RADAR base line)'));
    ncwriteatt(ncfile,'ang','units',    char('deg'));



    ncwriteatt(ncfile,'lon','long_name',char('Longitude'));
    ncwriteatt(ncfile,'lon','units',    char('decimal deg'));

    ncwriteatt(ncfile,'lat','long_name',char('Latitude'));
    ncwriteatt(ncfile,'lat','units',    char('decimal deg'));

    ncwriteatt(ncfile,'time','long_name',char('Valid Time'));
    ncwriteatt(ncfile,'time','units',char(['days since ' DATEtime_origin]));
    ncwriteatt(ncfile,'time','time_origin',DATEtime_origin);

    ncwriteatt(ncfile,'v','long_name',   char(['Radial velocity from ' STA]));
    ncwriteatt(ncfile,'v','units',       char('m/s'));

    %%% Write variables
    ncwrite(ncfile,'xr',xr);
    ncwrite(ncfile,'yr',yr);
    ncwrite(ncfile,'ang',angr);
    ncwrite(ncfile,'lon',lonr);
    ncwrite(ncfile,'lat',latr);
    ncwrite(ncfile,'time',time);
    ncwrite(ncfile,'v',vr); 
    disp(['Processing done for ' STA]); 

end
