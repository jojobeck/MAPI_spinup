#!/bin/bash
#SBATCH --time=23:49:00
#SBATCH --qos=short
#SBATCH --account=anthroia
#SBATCH --nodes=16
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=run2
#SBATCH --output=run2.out
#SBATCH --constraint=haswell

module load cdo
ncks -O -v climatic_mass_balance /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_125ka_25ka/check.nc /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_125ka_25ka/smb_18000.nc
python /home/beckmann/exp_pism/my_first_runs/spin_up_aschwanden/nc2cdo.py /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_125ka_25ka/smb_18000.nc
cdo remapbil,/home/beckmann/icedata/MAR_SMB/MARv3.9/ISMIP6/proj_monthly/results/clim_mean_pism_SMB_9000m.nc /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_125ka_25ka/smb_18000.nc /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_25ka_5ka/smb_9000.nc
ncks -O -v ice_surface_temp /home/beckmann/icedata/MAR_SMB/MARv3.9/ISMIP6/proj_monthly/results/clim_mean_pism_SMB_9000m.nc /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_25ka_5ka/ST_MAR_9000.nc
cdo -O merge /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_25ka_5ka/ST_MAR_9000.nc /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_25ka_5ka/smb_9000.nc /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_25ka_5ka/impl_smb_ST_MAR.nc
ncatted -O -a calendar,time,o,c,"360_day" /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_25ka_5ka/impl_smb_ST_MAR.nc
rm /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_25ka_5ka/ST_MAR_9000.nc
rm /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_25ka_5ka/smb_9000.nc


srun -n 256 /home/beckmann/exp_pism/my_first_runs/bin/pismr -bootstrap -i /home/beckmann/icedata/pism_greenland_input/BedMachine/pism_Greenland_9000m_mcb_jpl_v_no_bath.nc -regrid_file /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_125ka_25ka/gris_18000m.nc  -regrid_vars litho_temp,enthalpy,age,tillwat,bmelt,Href,thk -Mx 176 -My 304 -Mz 251 -Mbz 21 -z_spacing equal -Lz 4000 -Lbz 2000 skip -skip_max 100 -grid.registration center -ys -25000 -ye -5000 -surface given,forcing,delta_T -force_to_thickness_file /home/beckmann/icedata/pism_greenland_input/BedMachine/pism_Greenland_9000m_mcb_jpl_v_no_bath.nc -surface_delta_T_file /home/beckmann/exp_pism/my_first_runs/spin_up_aschwanden/input_data/pism_dT.nc -sea_level constant,delta_sl -ocean_delta_sl_file /home/beckmann/exp_pism/my_first_runs/spin_up_aschwanden/input_data/pism_dSL.nc -surface_given_file /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_25ka_5ka/impl_smb_ST_MAR.nc  -surface_given_period 1 -options_left -stress_balance.sia.max_diffusivity 500.0 -calving vonmises_calving,ocean_kill -ocean_kill_file /home/beckmann/icedata/pism_greenland_input/BedMachine/pism_Greenland_9000m_mcb_jpl_v_no_bath.nc -sia_e 1.25 -ts_file /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_25ka_5ka/ts_gris_9000m.nc -ts_times -25000:yearly:-5000 -extra_times -5001:monthly:-5000 -extra_file /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_25ka_5ka/check.nc -extra_vars climatic_mass_balance,ice_surface_temp -save_file /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_25ka_5ka/snapshots.nc -save_times -25000:5000:-5000 -o /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_25ka_5ka/gris_9000m.nc -o_format netcdf4_parallel -o_size medium