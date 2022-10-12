#############################################################################
#############################################################################

#!/bin/bash

# NEMO 4.2 (with xios truck): Refence case compilation on Puhti rhel8
#
# 2022-10-12, Jona Mac Intyre, jonatan.macintyre@fmi.fi
# 2022-09-30, Jona Mac Intyre, jonatan.macintyre@fmi.fi

#############################################################################
##### MODULE LOAD ###########################################################
#############################################################################

module load intel-oneapi-compilers-classic
module load intel-oneapi-mpi
module load hdf5/1.12.2-mpi
module load netcdf-c
module load netcdf-fortran
module load boost/1.79.0-mpi

module list 

#############################################################################
##### CASE COMPILATION ######################################################
#############################################################################

# NEMO location
cd /fmi/scratch/project_2006336/nemo-4.2.0

# Reference case compilation:
# ./makenemo -j 16 -m ARCHITECTURE_FILE -r REFERENCE_CASE_NAME -n MY_REFERENCE_CASE_NAME
./makenemo -j 16 -m puhti_intel -r ORCA2_ICE_PISCES -n MY_ORCA2_ICE_PISCES_2 del_key "key_top"

#############################################################################
#############################################################################
