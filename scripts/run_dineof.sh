#!/bin/sh 
# Author : Natacha Bourg
# Script to run DINEOF


# Create .init file

cat <<EOF >~/Desktop/dineof_summer_school/dineof-3.0/run_dineof_init.init &&

!  INPUT File for dineof 3.0 

data = ['~/Desktop/dineof_summer_school/input_data/PEY_Y2020M06_8_pre.nc#v','~/Desktop/dineof_summer_school/input_data/POB_Y2020M06_8_pre.nc#v'] 

mask = ['~/Desktop/dineof_summer_school/input_data/PEY_Mask.nc#mask','~/Desktop/dineof_summer_school/input_data/POB_Mask.nc#mask'] 

time = '~/Desktop/dineof_summer_school/input_data/PEY_Y2020M06_8_pre.nc#time' 

alpha = 5.00e-04

numit =  3

nev =  86

neini =   1 

ncv =  91

tol = 1.00e-08 

nitemax = 500

toliter = 1.00e-02

rec = 1 

eof = 1 

norm = 1 

Output = '~/Desktop/dineof_summer_school/my_result_folder/' 

results = ['~/Desktop/dineof_summer_school/my_result_folder/PEY_din_Y2020M06_8.nc#v','~/Desktop/dineof_summer_school/my_result_folder/POB_din_Y2020M06_8.nc#v'] 
seed = 243435 

! END OF PARAMETER FILE 

EOF
echo "init created"

echo "starting dineof... "

# Execute DINEOF
time ~/Desktop/dineof_summer_school/dineof-3.0/dineof ~/Desktop/dineof_summer_school/dineof-3.0/run_dineof_init.init > ~/Desktop/dineof_summer_school/scripts/run_dineof_log.log 2>&1 &&

echo "dineof : done!"
