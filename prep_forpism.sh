#! /bin/bash

#SBATCH --qos=priority
#SBATCH --job-name=work_job
#SBATCH --account=megarun
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-user=beckmann@pik-potsdam.de
#SBATCH --output=forpismout.out
##SBATCH --error=out.err
#SBATCH --time=01:00:00

module load cdo
# module load gdal
# PATH_TO_MAR=/home/beckmann/icedata/data_greenland/SMB/MARv3.9/ISMIP6/GrIS/ERA_1958-2017

# infile=MAR_1950_4.5km.cdf
# infile= MAR-yr-mean-1961-1990-:wq
# Name=MAR-yr-mean-1961-1990-4.5km_time
# Name=MAR-yr-mean-1961-1990-4.5km-4_time
# Name=MAR-yr-mean-1961-1990-9km-4_time
Name=MAR-yr-mean-1961-1990-18km-4_time


infile=${Name}.nc


tmp_file=test.nc
ncks -O -v SMB $infile $tmp_file
ncks -A -v ST $infile $tmp_file
outfile3=${Name}_pism.nc
outfile=MAR_1950_4.5km_pism3.nc
outfile2=MAR_1950_4.5km_pism2.nc
outfile1=MAR_1950_4.5km_pism1.nc
ncap2 -O -s "climatic_mass_balance=SMB" $tmp_file $outfile

ncatted -O -a standard_name,climatic_mass_balance,o,c,"land_ice_surface_specific_mass_balance" $outfile
ncatted -O -a units,climatic_mass_balance,o,c,"kg m-2 year-1" $outfile
ncap2 -O -s "ice_surface_temp=ST+273.15" $tmp_file $outfile2
ncatted -O -a units,ice_surface_temp,o,c,Kelvin $outfile2
ncks -A -v ice_surface_temp $outfile2 $outfile
ncatted -O -a calendar,time,o,c,"365_day" $outfile
ncatted -O -a units,time,o,c,"years since 1-1-1" $outfile
ncap2 -O -s 'time=array(0,1,$time)' $outfile $outfile
ncap2 -O -s time=time*365 $outfile $outfile
ncap2 -Oh -s 'time@bounds="time_bnds";defdim("bnds",2);time_bnds[$time,$bnds]=0.0;*time_dff=1*(365);time_bnds(:,0)=time;time_bnds(:,1)=time+time_dff;' $outfile $outfile
# ncap2 -Oh -s 'time@bounds="time_bnds";defdim("bnds",2);time_bnds[$time,$bnds]=0.0;*time_dff=1*(time(1)-time(0));time_bnds(:,0)=time;time_bnds(:,1)=time+time_dff;' $outfile $outfile
ncatted -O -a units,time,o,c,"days since 1-1-1" $outfile
# ncatted -O -a 'time=array(0,1,1)' $outfile $outfile
# ncap2 -O -s 'time=array(0,1,1)' $outfile $outfile
# ncap2 -O -s 'x=x*4500 + -676400 -4500' $outfile $outfile
# ncap2 -O -s 'y=y*4500 + -3369350 -4500' $outfile $outfile
# ncap2 -O -s 'x=x*9000 - 683150.0' $outfile $outfile
# ncap2 -O -s 'y=y*9000 -3376100.0' $outfile $outfile
ncap2 -O -s 'x=x*18000 -687650' $outfile $outfile
ncap2 -O -s 'y=y*18000 -3380600' $outfile $outfile
# ncks -O -x -v RF $otfile $outfile
# ncks -O -x -v SF $outfile $outfile
# ncks -O -x -v SMB $outfile $outfile
# ncatted -O -a calendar,time,o,c,"360_day" $outfile
# ncap2 -O -s 'time=array(0,1,$time)' $outfile $outfile
# ncap2 -O -s time=time*30 $outfile $outfile
# ncap2 -Oh -s 'time@bounds="time_bnds";defdim("bnds",2);time_bnds[$time,$bnds]=0.0;*time_dff=1*(time(1)-time(0));time_bnds(:,0)=time;time_bnds(:,1)=time+time_dff;' $outfile $outfile
# ncatted -O -a units,time,o,c,"days since 1-1-1" $outfile
cdo -O setmissval,273 $outfile $outfile1
ncks -O -v ice_surface_temp $outfile1 $outfile3
ncks -A -v climatic_mass_balance $outfile1 $outfile3
rm $outfile
rm $outfile1
rm $outfile2
rm $tmp_file

