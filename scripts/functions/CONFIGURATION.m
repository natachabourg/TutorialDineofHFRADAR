% MARMAIN - 2014/03/26
% Adaptation pour utilisation du formatage mensuel


%% HOW TO ????

% -RADAR_infos(*).obs_id est le niveau en entree du traitement
%       - L0: conversion en NetCDF des xyv 
%       - L1: retrait des outliers 
%       - L2: interpolation
% N.B.: lors de la conversion en NetCDF des fichiers xyv, le niveau de
% traitement des fichiers de sorties est par défault du type L0
%
% -radial_data_params(*).ProcLev est le niveau en sortie du traitement
%       - L1: retrait des outliers 
%       - L2: interpolation
%
% -cartesian_data_params.ProcLev: idem mais concerne le niveau de
% traitement des resultats de la recombinaison vectorielle (e.g.
% L3_LIar_L1)
%
% -Pa.dates permet de selectionner la periode a traiter.
% Si Pa.dates=[], alors le traitement sera fait de
% maniere mensuelle et se basera sur les dates donnees dans la structure Pa




% 
%% Configuration parameters for the entire program
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% temporal parameters 

% select a temporal range
Pa.dates=[];%['Y2012M01';'Y2019M12'];%['20190160801';'20190312301'];%['20190161501';'20190312301'];%['Y2012M01';'Y2019M12'];%['20190300001';'20191002301'];%['20122170000';'20122222300'];%[];%['20121530000';'20122442300'];%'20000010000'; '20000100000'];%%[];%
%
% OR 
%
% monthly processing used if Pa.dates=[] (radial_data_params(*).dates  =[]
% below)
Pa.NY_START=2020;   %%% year de depart
Pa.NY_END=2020;     %%% year de fin

Pa.NM_START=4;      %%% mois de depart
Pa.NM_END=4;        %%% mois de fin

Pa.ND_START=1;      %%% date de depart - jours dans le mois - ex: 11/12/2012 à 00h-> day=11
Pa.ND_END=31;       %%% date de fin - jours dans le mois - ex: 11/12/2012 à 23h-> day=11

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RADAR sites informations

active_sites = [ 1 2 ];% 3];   % indexes of the RADAR sites to be used
                              % The order is the one of the structure RADAR_infos

                              % active_sites is also used in dineof
                              % processing for radial (compute the
                              % requiered station) or vector (compute u if
                              % 1 or v if 2 or u and v together if 1 2)
                              
                              % !!! pour l'instant la chainedineof complete
                              % fonctionne pour interpoler u et v
                              % simultanément
                              
                              
% Peyras
RADAR_infos(1).name        = 'PEY';     % same as the cll/xyv files suffix
RADAR_infos(1).lon_rx      = 5.861066;  % RX longitude [decimal deg]
RADAR_infos(1).lat_rx      = 43.063078; % RX latitude  [decimal deg]
RADAR_infos(1).lon_tx      = 5.861066;  % TX longitude [decimal deg]
RADAR_infos(1).lat_tx      = 43.063078; % TX latitude  [decimal deg]
RADAR_infos(1).lon0        = 5.861066;  % Origin of the radial grid, longitude [decimal deg]
RADAR_infos(1).lat0        = 43.063078; % Origin of the radial grid, latitude  [decimal deg]
RADAR_infos(1).range       = [10 60];   % range min and max [km]2
RADAR_infos(1).ouv_angle   = 120;       % azimuthal angle   [deg]
RADAR_infos(1).orientation = 270;       % orientation of the RX array wrt the geographic North [deg]
RADAR_infos(1).integr_time = 1;         % integration time (1 for a reference time (no matter the value),
RADAR_infos(1).mono_bi = 1;
RADAR_infos(1).obs_id      ='L3';%'L2_Dineof';%'L1'; %'L2_Dineof';%     % descriptif observation original
                                       % must be the 'L*' identificator of
                                       % the file to load e.g. before
                                       % interpolation or mapping

% Bénat - Porquerolles
RADAR_infos(2).name        = 'POB';     % same as the cll/xyv files suffix
RADAR_infos(2).lon_rx      = 6.357616;  % RX longitude [decimal deg]
RADAR_infos(2).lat_rx      = 43.091933; % RX latitude  [decimal deg]
RADAR_infos(2).lon_tx      = 6.204189;  % TX longitude [decimal deg]
RADAR_infos(2).lat_tx      = 42.983084; % TX latitude  [decimal deg]
RADAR_infos(2).lon0        = 5.861066;  % Origin of the radial grid, longitude [decimal deg]
RADAR_infos(2).lat0        = 43.063078; % Origin of the radial grid, latitude  [decimal deg]
RADAR_infos(2).range       = [10 70];   % range min and max [km]
RADAR_infos(2).ouv_angle   = 120;       % azimuthal angle   [deg]
RADAR_infos(2).orientation = 120;       % orientation of the RX array wrt the geographic North [deg]
RADAR_infos(2).integr_time = 2;         % integration time (1 for a reference time (no matter the value),
RADAR_infos(2).mono_bi = 2;                                           %                   n for n*the_reference_time)
RADAR_infos(2).obs_id      = 'L3';%'L2_Dineof';%'L1';%'L2_Dineof';%      % descriptif observation original
                                        % must be the 'L*' identificator of
                                       % the file to load e.g. before
                                       % interpolation or mapping

%% Bénat
%RADAR_infos(3).name        = 'BEN';     % same as the cll/xyv files suffix
%RADAR_infos(3).lon_rx      = 6.357616;  % RX longitude [decimal deg]
%RADAR_infos(3).lat_rx      = 43.091933; % RX latitude  [decimal deg]
%RADAR_infos(3).lon_tx      = 5.861066;  % TX longitude [decimal deg]
%RADAR_infos(3).lat_tx      = 43.063078; % TX latitude  [decimal deg]
%RADAR_infos(3).lon0        = 5.861066;  % Origin of the radial grid, longitude [decimal deg]
%RADAR_infos(3).lat0        = 43.063078; % Origin of the radial grid, latitude  [decimal deg]
%RADAR_infos(3).range       = [10 70];   % range min and max [km]
%RADAR_infos(3).ouv_angle   = 120;       % azimuthal angle   [deg]
%RADAR_infos(3).orientation = 120;       % orientation of the RX array wrt the geographic North [deg]
%RADAR_infos(3).integr_time = 2;         % integration time (1 for a reference time (no matter the value),
                                          %                   n for n*the_reference_time)
%RADAR_infos(3).mono_bi = 2;       
%RADAR_infos(3).obs_id      ='L1';      % descriptif observation original
                                       % mustWORK be the 'L*' identificator of
                                       % the file to load e.g. before
                                       % interpolation or mapping


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Radial data path and processing options

radial_data_params(1).path_input  = '/mnt/TLNRADAR/ANTARES/Retraitements_2020/PEY';%molcard/RADAR_NEW/COMPARISON/DERDYLAN';%'/mnt/TLNRADAR/ANTARES/Radial/PostPro/PEY/';%

radial_data_params(1).path_cll_xyv = radial_data_params(1).path_input;

radial_data_params(1).path_output = '/data/MIO/natachab/hfr_data/radials_L0_to_L3/'; ;%NB CHNGER  PATH    '/home/molcard/RADAR/CARTO/2012-2019/';%'/home/molcard/RADAR_NEW/CARTO/TOSCA_dylan/';%DINEOF/POST/RUN4/';%CARTO/';%'/home/molcard/HFRADAR/Work/AM/CARTO_RADAR/VECTO/PEY/';%DINEOF/POST/';

radial_data_params(1).path_NetCDF = radial_data_params(1).path_output;

radial_data_params(1).ext          = 'nc';%'xyv';    %              % 'cll' (monostatic) or 'xyv' (bistatic)
radial_data_params(1).name         = RADAR_infos(1).name;   
radial_data_params(1).dates        = Pa.dates;%[];['20122180600'; '20122200600']; 
%%% if radial_data_params(*).dates=[] >>> monthly case
radial_data_params(1).NY_START     =Pa.NY_START;    % year de depart
radial_data_params(1).NY_END       =Pa.NY_END;      % year de fin
radial_data_params(1).NM_START     =Pa.NM_START;    % mois de depart
radial_data_params(1).NM_END       =Pa.NM_END;      % mois de fin
radial_data_params(1).ND_START     =Pa.ND_START;    % jour de depart
radial_data_params(1).ND_END       =Pa.ND_END;      % jour de fin

radial_data_params(1).use_NetCDF   = 1;  %%% 1: use_NetCDF file
radial_data_params(1).path_mask    = '/home/molcard/RADAR/CARTO/grid_PEY2.mat';%'./mask_interp_PEY.mat';
radial_data_params(1).save_current = 1; % 1: save in NetCDF format; 0: does not save

radial_data_params(1).use_radial_mask   = 0;     % apply the radial masks in grid_*.mat; 1: utilise le mask; 0: rien

radial_data_params(1).ProcLev                 = 'L3';%'L1';%'L2_DinMultiSmo';%'L2_DinMultiWindSmo';'L0';% 'L2_LinRegS';%'L1';          % level of processing
                                                     % 'L*' identificator
                                                     % given after the
                                                     % process e.g remove
                                                     % outlier (L1) or
                                                     % interpolation (L2)
radial_data_params(1).outliers.time           = 1;      % outliers based on the statistics of the time-domain gradient of current values ("filtre_t")
                                                        %       1: on, 0: off
radial_data_params(1).outliers.time_method    = 1;      % method for the evaluation of the maximum allowed current velocity time-domain gradient; 1: global; 2:par pixel; 3:fixe
radial_data_params(1).outliers.time_percent   = 1;      % percentage of the maximum pdf of the current velocity time-domain gradient (method == 1)
radial_data_params(1).outliers.time_max_grad  = 0.25;   % hard-coded maximum current velocity time-domain gradient (method == 3) [m/s/h]
radial_data_params(1).outliers.time_tresh_grad_std  = 0; % JM; 0=no use; else value of factor for gradient standard deviation use as treshold
%
radial_data_params(1).outliers.space          = 1;      % outliers based on the statistics of the space-domain gradient of current values ("filtre_t")
                                                        %       1: on, 0: off
radial_data_params(1).outliers.space_method   = 1;      % method for the evaluation of the maximum allowed current velocity space-domain gradient
                                                        %       1: percentage of the maximum overall pdf of the current gradients
                                                        %       2: percentage of the maximum pixel-by-pixedl pdf of the current gradients
                                                        %       3: hard-coded maximum current speed gradient
radial_data_params(1).outliers.space_percent  = 3;     % percentage of the maximum pdf of the current velocity space-domain gradient (method == 1)
radial_data_params(1).outliers.space_max_grad = 0.20;   % hard-coded maximum current velocity space-domain gradient (method == 3) [m/s/km]
radial_data_params(1).outliers.space_tresh_grad_std  = 0; % JM; 0=no use; else value of factor for gradient standard deviation use as treshold
%
radial_data_params(1).fill_holes.time         = 1;      % fill temporal holes through linear regression ("filtre_t")
radial_data_params(1).fill_holes.time_resol   = 3;      % time accuracy for the time interpolation/reconstruction (if fill_holes.time == 1)[hours]
%
radial_data_params(1).fill_holes.space        = 1;  
%
radial_data_params(1).map.plot                = 0;      % plot radial maps right after importing them
radial_data_params(1).map.save                = 0;
radial_data_params(1).map.path                = '~/Work/RADAR/CARTO_RADAR_Julien/HF_RADAR';       % path for saving .png radial maps (only if map.save == 1)
                                                %['/home/marmain/Figure/ECCOP/PEY_RESULTS/' radial_data_params(1).ProcLev '/'];

%%

radial_data_params(2).path_input = '/mnt/TLNRADAR/ANTARES/Retraitements_2020/POB'; %/mnt/TLNRADAR/ANTARES/Retraitements_2019/Radial_2019/POB/'%;'/home/molcard/RADAR_NEW/COMPARISON/DERDYLAN';%'/mnt/TLNRADAR/ANTARES/Radial/PostPro/POB/';%
radial_data_params(2).path_output  = '/data/MIO/natachab/hfr_data/radials_L0_to_L3/';%'/home/molcard/RADAR/CARTO/2012-2019/';%'/home/molcard/RADAR_NEW/CARTO/TOSCA_dylan/';%COMPARISON/DINEOF/POST/RUN4/';%/CARTO/';%/home/molcard/HFRADAR/Work/AM/CARTO_RADAR/VECTO/POB/';%DINEOF/POST/';%

radial_data_params(2).path_cll_xyv = radial_data_params(2).path_input;

radial_data_params(2).path_NetCDF = radial_data_params(2).path_output;

radial_data_params(2).ext          = 'nc';%'xyv';%'nc';%
radial_data_params(2).name         = RADAR_infos(2).name;   
radial_data_params(2).dates        = Pa.dates;%[];['20122180600'; '20122200600'];%%% if radial_data_params(*).dates=[] >>> monthly case
radial_data_params(2).NY_START     =Pa.NY_START;    % year de depart
radial_data_params(2).NY_END       =Pa.NY_END;      % year de fin
radial_data_params(2).NM_START     =Pa.NM_START;    % mois de depart
radial_data_params(2).NM_END       =Pa.NM_END;      % mois de fin
radial_data_params(2).ND_START     =Pa.ND_START;    % jour de depart
radial_data_params(2).ND_END       =Pa.ND_END;      % jour de fin

radial_data_params(2).use_NetCDF   = 1;
radial_data_params(2).path_mask    = '/home/molcard/RADAR/CARTO/grid_POB.mat';%'./mask_interp_POB.mat';
radial_data_params(2).save_current = 1; % 1: save in NetCDF format; 0: does not save

radial_data_params(2).use_radial_mask   = 0;       

radial_data_params(2).ProcLev                 = 'L3';%'L1';%'L2_DinMultiSmo';%'L2_DinMultiWindSmo';'L0';% 'L2_LinRegS';%'L1';          % level of processing
radial_data_params(2).outliers.time           = 1;      
radial_data_params(2).outliers.time_method    = 1;      
radial_data_params(2).outliers.time_percent   = 1;     
radial_data_params(2).outliers.time_max_grad  = 0.25;  
radial_data_params(2).outliers.time_tresh_grad_std  = 0; 
%
radial_data_params(2).outliers.space          = 1;     
                                                        
radial_data_params(2).outliers.space_method   = 1;     
                                                        
radial_data_params(2).outliers.space_percent  = 3;     
radial_data_params(2).outliers.space_max_grad = 0.20;   
radial_data_params(2).outliers.space_tresh_grad_std  = 0;
%
radial_data_params(2).fill_holes.time         = 1;     
radial_data_params(2).fill_holes.time_resol   = 3;     
%
radial_data_params(2).fill_holes.space        = 1;  
%
radial_data_params(2).map.plot                = 0;      % plot radial maps right after importing them
radial_data_params(2).map.save                = 0;
radial_data_params(2).map.path                = '~/Work/RADAR/CARTO_RADAR_Julien/HF_RADAR';       % path for saving .png radial maps (only if map.save == 1)
                                                 %['/home/marmain/Figure/ECCOP/POB_RESULTS/' radial_data_params(2).ProcLev '/'];          % level of processing


% %%
% radial_data_params(3).path_input    = '/mnt/TLNRADAR/ANTARES/Retraitements_2019/Radial_2019/POB/'%'/media/marmain/DATA_JUJU/ECCOP/ANTARES/Radial/BEN/';
% radial_data_params(3).path_output      = '/home/molcard/RADAR_NEW/CARTO/';
% 
% radial_data_params(3).ext          = 'nc';%'xyv';
% radial_data_params(3).name         = RADAR_infos(3).name;   
% radial_data_params(3).dates        = Pa.dates;%['20122180601'; '20122210221'];%%% if radial_data_params(*).dates=[] >>> monthly case
% radial_data_params(3).NY_START     =Pa.NY_START;    % year de depart
% radial_data_params(3).NY_END       =Pa.NY_END;      % year de fin
% radial_data_params(3).NM_START     =Pa.NM_START;    % mois de depart
% radial_data_params(3).NM_END       =Pa.NM_END;      % mois de fin
% radial_data_params(3).ND_START     =Pa.ND_START;    % jour de depart
% radial_data_params(3).ND_END       =Pa.ND_END;      % jour de fin
% 
% radial_data_params(3).use_NetCDF   = 0;
% radial_data_params(3).path_mask    = '/home/molcard/RADAR/CARTO/grid_BEN.mat';%'./mask_interp_BEN.mat';
% radial_data_params(3).use_radial_mask   = 1;      
% radial_data_params(3).save_current = 1; 
% 
% radial_data_params(3).ProcLev                 = 'L1';%'L2_DinMultiSmo';%'L2_DinMultiWindSmo';'L0';% 'L2_LinRegS';%'L1';          % level of processing
% radial_data_params(3).outliers.time           = 1;      
% radial_data_params(3).outliers.time_method    = 1;      
% radial_data_params(3).outliers.time_percent   = 1;      
% radial_data_params(3).outliers.time_max_grad  = 0.25;  
% radial_data_params(3).outliers.time_tresh_grad_std  = 3;
% %
% radial_data_params(3).outliers.space          = 1;      
% radial_data_params(3).outliers.space_method   = 1;     
% radial_data_params(3).outliers.space_percent  = 3;     
% radial_data_params(3).outliers.space_max_grad = 0.20;   
% radial_data_params(3).outliers.space_tresh_grad_std  = 0; 
% %
% radial_data_params(3).fill_holes.time         = 0;1;      
% radial_data_params(3).fill_holes.time_resol   = 3;      
% %
% radial_data_params(3).fill_holes.space        = 0;1;  
% %
% %
% radial_data_params(3).map.plot                = 0;      % plot radial maps right after importing them
% radial_data_params(3).map.save                = 0;
% radial_data_params(3).map.path                = '~/Work/RADAR/CARTO_RADAR_Julien/HF_RADAR';       % path for saving .png radial maps (only if map.save == 1)
%                                                 %['/home/marmain/Figure/ECCOP/BEN_RESULTS/' radial_data_params(3).ProcLev '/'];          % level of processing
%                                                                                   
%             


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% cartesian velocities processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Rectangular cartesian grid for mapping plots
cartesian_grid.lon_lim    = [5.5 6.8]';%[5.7 6.7]'; %%     % longitude limits
cartesian_grid.lat_lim    = [42.15 43.05]';%[42.45 43.05]';%  % latitude limits
cartesian_grid.step       = 1;%2;               % grid step (same for x and y) [km]
cartesian_grid.rot_angle  = 0;               % counterclockwise rotation angle of the grid wrt the WE axis
cartesian_grid.GDOP_thresh = 2.5;            % maximum allowed normalized GDOP error
cartesian_grid.ang_thresh  = 10;             % minimum allowed angle between "radial" directions [deg]


%% Cartesian mapping processing
cartesian_data_params.use_geo_mask      = 1;        % use the geographic mask in grid_cartesian.mat
cartesian_data_params.use_err_mask      = 1;        % use the error mask (GDOP or angle) in grid_cartesian.mat
cartesian_data_params.time_accuracy     = 25;       % maximum allowed time difference to "mix" two radial maps [min]
cartesian_data_params.master_RADAR      = 'PEY';    % Nb. of the master RADAR nb. (1 or 2) used as time reference
cartesian_data_params.mapping.method    = 5;        % Type of mapping algorithm
                                                    %       5: classic interpolation + MSE (local)
                                                    %       6: MSE mapping (local)
cartesian_data_params.mapping.radius    = 3;        % for the mapping step, maximum valid radius to consider a radial velocity in the interpolation process       [km]
cartesian_data_params.map.plot          = 0;        % plot current maps right after computing them
cartesian_data_params.map.save          = 0;        % save current maps in png format (only if map.plot == 1)
cartesian_data_params.map.path          = '/home/natachab/RADAR/';
% cartesian_data_params.map.path          = '~/HF_RADAR/Results/Vector/figures/'; % path for saving .png current maps (only if map.save == 1)
cartesian_data_params.save_currents     = 2;        % save current velocities (the data, not the figure)
                                                    %       0: do not save,
                                                    %       1: in raw binary and ASCII format
                                                    %       2: in NetCDF format
                                                    %       3: in both ASCII and NetCDF formats
cartesian_data_params.path_read_write   = '/data/MIO/natachab/hfr_data/vectors_L3/';%'/home/molcard/RADAR/CARTO/2012-2019/';%'/home/molcard/RADAR_NEW/COMPARISON/DINEOF/';%/CARTO/';%VECTO/';
cartesian_data_params.read_NetCDF       = 0;        % read current maps from a NetCDF file (0: no, so read from ASCII, 1: yes)
cartesian_data_params.NetCDF_filename   = 'current_L3_LIar_L1_Y2014M01.nc'; % name of the NetCDF file to be read for offline plotting of the maps
cartesian_data_params.ProcLev            = 'L3_vec';%'L3_fillxt';%'L3_LIar_L2_Dineof';%'L3_LIar_L1';%'L3_2dVAR_L1';%L3_2dVAR_L2_DinMulti';%'L3_2dVAR_L2_DinMultiSmo';%'L3_2dVAR_L2_DinMultiWindSmo';%'L3_LIar_L1';%'L3_LIar_L2_DinMultiSmo';%'L3_LIar_L2_DinMultiWindSmo';%'L3_2dVAR';%'L3_LIar';%'L3_LIc';%'L3_2dVAR';%            % range of dates to be used


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% diagnostic results  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

diagnostic_param.map.path               = '~/Bureau/CARTO_RADAR/figures/'; %%% chemin d'enregistrement des figures diagnostiques


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot_parameters %%%%%%%%%
plot_param.ste=2;4;                % pas pour fleches de courant
plot_param.sca=0.1;0.4;            % echelle des fleches de courant
plot_param.lw=1;                   % linewidth du gca
plot_param.lwl=1.5;
plot_param.lwc=1.5;                % linewidth des cotes
plot_param.lwb=0.5;                % linewidth bathy
plot_param.fsb=10;                 % fontsize des labels de bathy
plot_param.levels=[50 100 1000];   % isobathes
plot_param.lwcont=0.5;             % linewidth des contours
plot_param.lwfl=0.5;               % linewidth des fleches
plot_param.cax_min=-0.5;  cax_max=0.5;  %caxis des vecteurs projetes (99: pas de caxis)
plot_param.fst=14;                 %fontsize du texte
plot_param.msr=20;                 %markersize des radars
plot_param.lwl=2;                  %linewidth des axes radar lateraux
plot_param.fstl=16;% 8;%   %16             % fontsize du texte axes
plot_param.fstl2=14;               % fontsize du texte legendes
plot_param.pw=15;                   % point width

plot_param.caxis(1).ca=[-0.6 0.6];   %%% caxis des vitesses radiales
plot_param.caxis(2).ca=[-0.6 0.6];
plot_param.caxis(3).ca=[-0.6 0.6];


%% Options for all geographic plots
map.lonlat_xy = 1;              % use 1: lon/lat coordinates
                                %     2: x/y coordinates in km
map.plot_bath=0;% plot isobaths (0 or 1) whose values are in installation/trace_coast.m
map.bath_levels= [-100 -1000 -2000]; % isobaths levels to plot
map.plot_land=0; %%% 0: trace les terres en couleurs; 0: rien

map.lon0      = 5.861066;       % reference lon for x/y maps (only if map.lonlat_xy==2)
map.lat0      = 43.063078;      % reference lat for x/y maps (only if map.lonlat_xy==2)

% map.lon_lim   = [5.1  7.1]';% longitude range of the map [decimal deg]
% map.lat_lim   = [42.1 43.15]';   % latitude range of the map  [decimal deg]
% map.lon_lim   = [2. 8]';% longitude range of the map [decimal deg]
% map.lat_lim   = [41.2 43.9]';   % latitude range of the map  [decimal deg]

%%%radiale:
map.lon_lim   = [5.1  7.1]';% longitude range of the map [decimal deg]
map.lat_lim   = [42.1 43.15]';   % latitude range of the map  [decimal deg]
% %%% vecteur
% map.lon_lim   = [5.6 6.8]';      % longitude limits
% map.lat_lim   = [42.4 43.15]';  % latitude limits


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N.B.: All the plots are done either in lon/lat or in x/y  %
%       coordinates according to the value of map.lonlat_xy %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Some hidden (!) computations
% Invert the order of the radial structures depending on the Master RADAR
if strcmp(cartesian_data_params.master_RADAR,RADAR_infos(1).name)
    % ok
elseif strcmp(cartesian_data_params.master_RADAR,RADAR_infos(2).name)
    RADAR_infos        = RADAR_infos([2 1]);
    radial_data_params = radial_data_params([2 1]);
else
    error('The Master RADAR does not correspond to any of the RADAR_infos sites in CONFIGURATION.m!');
end

for i_radar = 1 : length(RADAR_infos)
    [RADAR_infos(i_radar).x_rx RADAR_infos(i_radar).y_rx] = ...
                    xy2lonlat(RADAR_infos(i_radar).lon_rx,RADAR_infos(i_radar).lat_rx, ...
                              map.lon0,map.lat0,1);
    [RADAR_infos(i_radar).x_tx RADAR_infos(i_radar).y_tx] = ...
                    xy2lonlat(RADAR_infos(i_radar).lon_tx,RADAR_infos(i_radar).lat_tx, ...
                              map.lon0,map.lat0,1);

    if RADAR_infos(i_radar).lon_tx == RADAR_infos(i_radar).lon_rx && ...
       RADAR_infos(i_radar).lat_tx == RADAR_infos(i_radar).lat_rx
        RADAR_infos(i_radar).mono_bi = 1;
    else
        RADAR_infos(i_radar).mono_bi = 2;
    end
    
    radial_data_params(i_radar).name = RADAR_infos(i_radar).name;
end


