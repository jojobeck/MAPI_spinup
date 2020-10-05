#!/bin/bash
#SBATCH --time=23:49:00
#SBATCH --qos=short
#SBATCH --account=anthroia
#SBATCH --nodes=8
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=run4_paleo_1ka_0a_sia_e_3.0_sia_e3.0_run5
#SBATCH --output=run4_paleo_1ka_0a_sia_e_3.0_sia_e3.0_run5.out
#SBATCH --constraint=haswell


srun -n 128 /home/beckmann/gitrepos/pism_v1.2.1/pism/bin/pismr -bootstrap  -i /home/beckmann/icedata/pism_greenland_input/BedMachine/pism_Greenland_4500m_mcb_jpl_v_no_bath.nc -regrid_file /home/beckmann/exp_pism/alison/spin_up/PISM_1.2.1/MARv3.11.2_CESM2/paleo_5ka_1ka_sia_e_3.0_run5/gris_4500m.nc  -regrid_vars litho_temp,enthalpy,age,tillwat,bmelt,Href,thk -Mx 352 -My 608 -Mz 251 -Mbz 21 -z_spacing equal -Lz 4000 -Lbz 2000 skip -skip_max 100 -grid.registration center -ys -1000 -ye 0 -surface given,forcing,delta_T -surface_delta_T_file /home/beckmann/exp_pism/my_first_runs/spin_up_aschwanden/input_data/pism_dT.nc -sea_level constant,delta_sl -ocean_delta_sl_file /home/beckmann/exp_pism/my_first_runs/spin_up_aschwanden/input_data/pism_dSL.nc -surface_given_file /home/beckmann/icedata/MAR_SMB/Alison/clim_mean/MAR-yr-mean-1961-1990-4.5km-4_time_pism.nc  -surface_given_period 1 -force_to_thickness_file /home/beckmann/icedata/pism_greenland_input/BedMachine/ftt_4500m.nc -surface.force_to_thickness.ice_free_alpha_factor 1000 -options_left -stress_balance.sia.limit_diffusivity yes -stress_balance.sia.max_diffusivity 1000.0 -stress_balance.ssa.fd.max_speed 30.0e3 -calving eigen_calving,vonmises_calving,thickness_calving -eigen_calving_K 1e+16 -thickness_calving_threshold 50 -front_retreat_file /home/beckmann/icedata/pism_greenland_input/BedMachine/pism_Greenland_4500m_mcb_jpl_v_no_bath_front_retreat.nc -stress_balance ssa+sia - vertical_velocity_approximation upstream -sia_e 3.0 -sia_n 3 -ssa_e 1 -ssa_n 3 -pseudo_plastic_q 0.6 -till_effective_fraction_overburden 0.02 -topg_to_phi 5.0,40.0,-700,700 -cfbc -kill_icebergs -part_grid -part_redist -pseudo_plastic -tauc_slippery_grounding_lines -hydrology null -hydrology_null_diffuse_till_water -ts_file /home/beckmann/exp_pism/alison/spin_up/PISM_1.2.1/MARv3.11.2_CESM2/paleo_1ka_0a_sia_e_3.0_run5/ts_gris_4500m.nc -ts_times -1000:yearly:0 -extra_times -1:monthly:0 -extra_file /home/beckmann/exp_pism/alison/spin_up/PISM_1.2.1/MARv3.11.2_CESM2/paleo_1ka_0a_sia_e_3.0_run5/check.nc -extra_vars climatic_mass_balance,ice_surface_temp -save_file /home/beckmann/exp_pism/alison/spin_up/PISM_1.2.1/MARv3.11.2_CESM2/paleo_1ka_0a_sia_e_3.0_run5/snapshots.nc -save_times -1000:250:0 -o /home/beckmann/exp_pism/alison/spin_up/PISM_1.2.1/MARv3.11.2_CESM2/paleo_1ka_0a_sia_e_3.0_run5/gris_4500m.nc -o_format netcdf4_parallel -o_size medium