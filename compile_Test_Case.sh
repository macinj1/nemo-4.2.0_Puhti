#############################################################################
#############################################################################

#!/bin/bash

# NEMO 4.2 (with xios truck): Test case compilation on Puhti rhel8
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
cd project_number/nemo-4.2.0

# Reference case compilation:
# ./makenemo -j 16 -m ARCHITECTURE_FILE -a TEST_CASE_NAME -n MY_TEST_CASE_NAME
./makenemo -j 16 -m puhti_intel -a ICE_ADV2D -n MY_ICE_ADV2D

#############################################################################
#############################################################################
