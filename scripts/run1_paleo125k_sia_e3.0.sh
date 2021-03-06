#!/bin/bash

#SBATCH --qos=priority
#SBATCH --account=anthroia
#SBATCH --nodes=8
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=run1_paleo125k_sia_e3.0
#SBATCH --output=run1_paleo125k_sia_e3.0.out
#SBATCH --constraint=haswell


srun -n 128 /home/beckmann/gitrepos/pism_v1.2.1/pism/bin/pismr -i /home/beckmann/icedata/pism_greenland_input/BedMachine/pism_Greenland_18000m_mcb_jpl_v_no_bath.nc -bootstrap  -regrid_file /home/beckmann/exp_pism/alison/spin_up/PISM_1.2.1/MARv3.11.2_CESM2/paleo_1ka_0a_sia_e_3.0/gris_4500m.nc  -regrid_vars litho_temp,enthalpy,age,tillwat,bmelt,Href,thk -Mx 88 -My 152 -Mz 251 -Mbz 21 -z_spacing equal -Lz 4000 -Lbz 2000 skip -skip_max 100 -grid.registration center -ys -125000 -ye -124999 -surface given,forcing,delta_T -surface_delta_T_file /home/beckmann/exp_pism/my_first_runs/spin_up_aschwanden/input_data/pism_dT.nc -sea_level constant,delta_sl -ocean_delta_sl_file /home/beckmann/exp_pism/my_first_runs/spin_up_aschwanden/input_data/pism_dSL.nc -surface_given_file /home/beckmann/icedata/MAR_SMB/Alison/clim_mean/MAR-yr-mean-1961-1990-18km_time_pism.nc -surface_given_period 1 -force_to_thickness_file /home/beckmann/icedata/pism_greenland_input/BedMachine/ftt_18000m.nc -surface.force_to_thickness.ice_free_alpha_factor 1000 -options_left -stress_balance.sia.max_diffusivity 500.0 -calving eigen_calving,vonmises_calving,thickness_calving -eigen_calving_K 1e+16 -thickness_calving_threshold 50 -front_retreat_file /home/beckmann/icedata/pism_greenland_input/BedMachine/pism_Greenland_18000m_mcb_jpl_v_no_bath_front_retreat.nc -sia_e 3.0 -ts_file /home/beckmann/exp_pism/alison/spin_up/PISM_1.2.1/MARv3.11.2_CESM2/paleo_125ka_25ka_sia_e_3.0_run2/ts_gris_18000m.nc -ts_times -125000:yearly:-124999 -extra_times -125000:monthly:-124999 -extra_file /home/beckmann/exp_pism/alison/spin_up/PISM_1.2.1/MARv3.11.2_CESM2/paleo_125ka_25ka_sia_e_3.0_run2/check.nc -extra_vars climatic_mass_balance,ice_surface_temp  -o /home/beckmann/exp_pism/alison/spin_up/PISM_1.2.1/MARv3.11.2_CESM2/paleo_125ka_25ka_sia_e_3.0_run2/gris_18000m.nc -o_format netcdf4_parallel -o_size medium