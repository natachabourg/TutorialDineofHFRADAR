# dineof_summer_school
Small tutorial on how to use the algorithm DINEOF (developed by  Alvera-Azcarate et al (2005), please see https://github.com/aida-alvera/DINEOF for more information)) to fill gappy surface water velocity data retrieved by high-frequency radars.


1) run pre_processing.m to create the preprocessed .nc files you want to fill 

2) run run_dineof.sh to execute the algorithm

3) run vector_map_results.m to reconstruct the total current velocity 

4) run plot_results.m to plot a small comparison between true and reconstructed values
