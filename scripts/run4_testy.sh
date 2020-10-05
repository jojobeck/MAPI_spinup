#!/bin/bash

#SBATCH --qos=priority
#SBATCH --account=sicopolis
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=run4_testy
#SBATCH --output=run4_testy.out
#SBATCH --constraint=haswell

module load cdo
ncks -O -v climatic_mass_balance /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_5ka_500a/check.nc /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_5ka_500a/smb_4500.nc
python /home/beckmann/exp_pism/my_first_runs/spin_up_aschwanden/nc2cdo.py /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_5ka_500a/smb_4500.nc
cdo remapbil,/home/beckmann/icedata/MAR_SMB/MARv3.9/ISMIP6/proj_monthly/results/clim_mean_pism_SMB_4500m.nc /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_5ka_500a/smb_4500.nc /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_500a_50a/smb_4500.nc
ncks -O -v ice_surface_temp /home/beckmann/icedata/MAR_SMB/MARv3.9/ISMIP6/proj_monthly/results/clim_mean_pism_SMB_4500m.nc /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_500a_50a/ST_MAR_4500.nc
cdo -O merge /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_500a_50a/ST_MAR_4500.nc /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_500a_50a/smb_4500.nc /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_500a_50a/impl_smb_ST_MAR.nc
ncatted -O -a calendar,time,o,c,"360_day" /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_500a_50a/impl_smb_ST_MAR.nc
rm /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_500a_50a/ST_MAR_4500.nc
rm /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_500a_50a/smb_4500.nc


srun -n 64 /home/beckmann/gitrepos/pism_v1.2.1/pism/bin/pismr -bootstrap -i /home/beckmann/icedata/pism_greenland_input/BedMachine/pism_Greenland_4500m_mcb_jpl_v_no_bath.nc -regrid_file /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_5ka_500a/gris_4500m.nc  -regrid_vars litho_temp,enthalpy,age,tillwat,bmelt,Href,thk -Mx 352 -My 608 -Mz 251 -Mbz 21 -z_spacing equal -Lz 4000 -Lbz 2000 skip -skip_max 100 -grid.registration center -ys -500 -ye -499 -surface given,forcing,delta_T -force_to_thickness_file /home/beckmann/icedata/pism_greenland_input/BedMachine/pism_Greenland_4500m_mcb_jpl_v_no_bath.nc -surface_delta_T_file /home/beckmann/exp_pism/my_first_runs/spin_up_aschwanden/input_data/pism_dT.nc -sea_level constant,delta_sl -ocean_delta_sl_file /home/beckmann/exp_pism/my_first_runs/spin_up_aschwanden/input_data/pism_dSL.nc -surface_given_file /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_500a_50a/impl_smb_ST_MAR.nc  -surface_given_period 1 -options_left -stress_balance.sia.max_diffusivity 500.0 -calving eigen_calving,vonmises_calving,thickness_calving -eigen_calving_K 1e+16 -thickness_calving_threshold 50 -front_retreat_file /home/beckmann/icedata/pism_greenland_input/BedMachine/pism_Greenland_4500m_mcb_jpl_v_no_bath_front_retreat.nc -stress_balance ssa+sia - vertical_velocity_approximation upstream -sia_e 1.25 -sia_n 3 -ssa_e 1 -ssa_n 3 -pseudo_plastic_q 0.6 -till_effective_fraction_overburden 0.02 -topg_to_phi 5.0,40.0,-700,700 -cfbc -kill_icebergs -part_grid -part_redist -pseudo_plastic -tauc_slippery_grounding_lines -hydrology null -hydrology_null_diffuse_till_water -ts_file /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_500a_50a/ts_gris_4500m.nc -ts_times -500:yearly:-499 -extra_times -500:monthly:-499 -extra_file /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/paleo_500a_50a/check.nc -extra_vars climatic_mass_balance,ice_surface_temp  -o /home/beckmann/exp_pism/alison/spin_up/Marv3.9MIROC_Erainterim/sia_e_1.25/dirty_test_cdf_data/gris_4500m.nc -o_format netcdf4_parallel -o_size medium