###########################################################################
###########################################################################

#!/bin/bash

#SBATCH --job-name=nemo_test
#SBATCH --account=project_2006336
#SBATCH --partition=fmi
#SBATCH --time=00:10:00
#SBATCH --ntasks=20
#SBATCH --mem-per-cpu=4G
#SBATCH -o stdout.log
#SBATCH -e stderr.log

###########################################################################
##### MODULE LOAD #########################################################
###########################################################################

module load intel-oneapi-compilers-classic
module load intel-oneapi-mpi
module load hdf5/1.12.2-mpi
module load netcdf-c
module load netcdf-fortran
module load boost/1.79.0-mpi

###########################################################################
##### RUN SIMULATION ######################################################
###########################################################################

# NEMO location
cd /fmi/scratch/project_2006336/nemo-4.2.0/tests/ICE_ADV2D/EXP00

srun ./nemo

###########################################################################
##### CREATE MESH #########################################################
###########################################################################

module load python 

# NEMO location
cd /fmi/scratch/project_2006336/nemo-4.2.0/tests/ICE_ADV2D/EXP00

python3 make_INITICE.py

###########################################################################
##### RUN SIMULATION ######################################################
###########################################################################

# NEMO location
cd /fmi/scratch/project_2006336/nemo-4.2.0/tests/ICE_ADV2D/EXP00

srun ./nemo

###########################################################################
###########################################################################
