#!/bin/bash

#SBATCH --qos=priority
#SBATCH --account=anthroia
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=run1
#SBATCH --output=run1.out
#SBATCH --constraint=haswell


srun -n 64 /home/beckmann/exp_pism/my_first_runs/bin/pismr -i /home/beckmann/icedata/pism_greenland_input/BedMachine/pism_Greenland_18000m_mcb_jpl_v_no_bath.nc -bootstrap -Mx 88 -My 152 -Mz 251 -Mbz 21 -z_spacing equal -Lz 4000 -Lbz 2000 skip -skip_max 100 -grid.registration center -ys -125000 -ye -124999 -surface given,forcing,delta_T -force_to_thickness_file /home/beckmann/icedata/pism_greenland_input/BedMachine/pism_Greenland_18000m_mcb_jpl_v_no_bath.nc -surface_delta_T_file /home/beckmann/exp_pism/my_first_runs/spin_up_aschwanden/input_data/pism_dT.nc -sea_level constant,delta_sl -ocean_delta_sl_file /home/beckmann/exp_pism/my_first_runs/spin_up_aschwanden/input_data/pism_dSL.nc -surface_given_file /home/beckmann/icedata/MAR_SMB/MARv3.9/ISMIP6/proj_monthly/results/clim_mean_pism_SMB_18000m.nc  -surface_given_period 1 -options_left -stress_balance.sia.max_diffusivity 500.0 -calving vonmises_calving,ocean_kill -ocean_kill_file /home/beckmann/icedata/pism_greenland_input/BedMachine/pism_Greenland_18000m_mcb_jpl_v_no_bath.nc -sia_e 1.25 -ts_file /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_125ka_25ka/ts_gris_18000m.nc -ts_times -125000:yearly:-124999 -extra_times -125000:monthly:-124999 -extra_file /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_125ka_25ka/check.nc -extra_vars climatic_mass_balance,ice_surface_temp  -o /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_125ka_25ka/gris_18000m.nc -o_format netcdf4_parallel -o_size medium