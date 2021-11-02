clc; clear all; close all;

addpath('~/Desktop/dineof_summer_school/scripts/functions/');

ini_file1 = '~/Desktop/dineof_summer_school/input_data/PEY_L3_Y2020M06_8.nc';
ini_file2 = '~/Desktop/dineof_summer_school/input_data/POB_L3_Y2020M06_8.nc';

out_file1 = '~/Desktop/dineof_summer_school/my_result_folder/PEY_din_Y2020M06_8.nc';
out_file2 = '~/Desktop/dineof_summer_school/my_result_folder/POB_din_Y2020M06_8.nc';

in_vec = '~/Desktop/dineof_summer_school/input_data/current_L3_vec_Y2020M06_8.nc';
out_vec ='~/Desktop/dineof_summer_school/my_result_folder/currents_din.nc';

idx_missing = [10,11,12,35,36,37,70,71,72];

idx_missing_pey = [35,36,37,70,71,72];
idx_missing_pob = [10,11,12,70,71,72];

titles= {'NO POB'; 'NO POB'; 'NO POB'; 'NO PEY';'NO PEY';'NO PEY';...
    'NOTHING'; 'NOTHING';'NOTHING'};

ini_vr1 = ncread(ini_file1,'v');
ini_vr2 = ncread(ini_file2,'v');

out_vr1 = ncread(out_file1,'v');
out_vr2 = ncread(out_file2,'v');

out_vr1(abs(out_vr1)>10)=NaN;
out_vr2(abs(out_vr2)>10)=NaN;

lon_vr1 = ncread(ini_file1,'lon');
lat_vr1 = ncread(ini_file1,'lat');

lon_vr2 = ncread(ini_file2,'lon');
lat_vr2 = ncread(ini_file2,'lat');


lon_vec = ncread(in_vec,'lon');
lat_vec = ncread(in_vec,'lat');

ini_u_vec = ncread(in_vec,'u');
ini_v_vec = ncread(in_vec,'v');

out_u_vec = ncread(out_vec,'u');
out_v_vec = ncread(out_vec,'v');

step=2;
for idx = 1:length(idx_missing)
    
    i=idx_missing(idx);
    title_fig = titles{idx};
    
    figure;
    hold on;
    subplot(3,2,1)
    pcolor(lon_vr1,lat_vr1,ini_vr1(:,:,i));
    shading flat
    colorbar;
    caxis([-0.6 0.6])
    colormap(jet(30))
    
    subplot(3,2,2)
    pcolor(lon_vr1,lat_vr1,out_vr1(:,:,i));
    shading flat
    colorbar;
    caxis([-0.6 0.6])
    colormap(jet(30))

    subplot(3,2,3)
    pcolor(lon_vr2,lat_vr2,ini_vr2(:,:,i));
    shading flat
    colorbar;
    caxis([-0.6 0.6])
    colormap(jet(30))

    subplot(3,2,4)
    pcolor(lon_vr2,lat_vr2,out_vr2(:,:,i));
    colorbar;    
    shading flat
    caxis([-0.6 0.6])
    colormap(jet(30))
    
    subplot(3,2,5)
    
    pcolor(lon_vr1,lat_vr1,out_vr1(:,:,i)-ini_vr1(:,:,i));
    colorbar;    
    shading flat
    caxis([-0.6 0.6])
    colormap(jet(30))
    
    subplot(3,2,6)
    pcolor(lon_vr2,lat_vr2,out_vr2(:,:,i)-ini_vr2(:,:,i));
    colorbar;    
    shading flat
    caxis([-0.6 0.6])
    colormap(jet(30))
    sgtitle(title_fig)
    hold off;
    
    
    figure
    hold on;
    subplot(2,1,1)
    quiver(lon_vec(1:step:end,1:step:end),lat_vec(1:step:end,1:step:end),...
        ini_u_vec(1:step:end,1:step:end,i),ini_v_vec(1:step:end,1:step:end,i),'k');
    title('True')
    subplot(2,1,2)
    quiver(lon_vec(1:step:end,1:step:end),lat_vec(1:step:end,1:step:end),...
        out_u_vec(1:step:end,1:step:end,i),out_v_vec(1:step:end,1:step:end,i),'k');    
    sgtitle(title_fig)
    title('Reconstructed')
    hold off;
    
end

idxs_ini1 = reshape(ini_vr1(:,:,idx_missing_pey),119*63*6,1);
idxs_out1 = reshape(out_vr1(:,:,idx_missing_pey),119*63*6,1);


idxs_ini2 = reshape(ini_vr2(:,:,idx_missing_pob),151*58*6,1);
idxs_out2 = reshape(out_vr2(:,:,idx_missing_pob),151*58*6,1);

si=3;

figure
subplot(2,1,1)
hold on;
grid on ;
scatter(idxs_ini1,idxs_out1,si,abs(idxs_ini1-idxs_out1))
plot(linspace(-0.6,0.6),linspace(-0.6,0.6),'k')
cbar=colorbar;
cbar.Limits = [0 0.6];
ylabel(cbar,'Absolute difference [m/s]')
title('PEY')
xlabel('initial')
ylabel('reconstructed')
hold off

subplot(2,1,2)
hold on;
grid on;
scatter(idxs_ini2,idxs_out2,si,abs(idxs_ini2-idxs_out2))
plot(linspace(-0.6,0.6),linspace(-0.6,0.6),'k')

cbar=colorbar;
colormap(parula(30))
title('POB')
xlabel('initial')
ylabel('reconstructed')
cbar.Limits = [0 0.6];
ylabel(cbar,'Absolute difference [m/s]')
hold off;




nbins=50;
[N,Xbins,Ybins]=hist2d(idxs_ini1,idxs_out1,nbins);


figure
subplot(2,1,1)
hold on;
grid on ;
pcolor(Xbins,Ybins,N)
colormap(jet(30))
plot(linspace(-0.3,0.3),linspace(-0.3,0.3),'k')
title('PEY')
xlabel('initial')
ylabel('reconstructed')
hold off




[N,Xbins,Ybins]=hist2d(idxs_ini2,idxs_out2,nbins);


subplot(2,1,2)
hold on;
grid on ;
pcolor(Xbins,Ybins,N)
colormap(jet(30))
plot(linspace(-0.3,0.3),linspace(-0.3,0.3),'k')
title('POB')
xlabel('initial')
ylabel('reconstructed')
hold off










