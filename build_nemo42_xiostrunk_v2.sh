#############################################################################
#####  XIOS&NEMO COMPILATION  ###############################################
#############################################################################
#
# Compilation of Xios trunk and Nemo 4.2.0 in Puhti (CSC - Finland)
# 2020-09-30, Jona Mac Intyre, FMI - Puhti RHEL8
# 2020-09-02, Jona Mac Intyre, FMI - login1
#
#############################################################################
#############################################################################

#!/bin/bash

#############################################################################
##### Variables and modules for RHEL8 #######################################
#############################################################################

Project_ID=project_number

cd /fmi/scratch/${Project_ID}

nemo_version=4.2.0
xios_version=trunk

NEMO_FOLDER=nemo-${nemo_version}
XIOS_FOLDER=xios-${xios_version}

compiler=intel-oneapi-compilers-classic
compiler_version=2021.6.0

mpi=intel-oneapi-mpi
mpi_version=2021.6.0

net_cdf=netcdf-c
net_cdf_version=4.8.1

net_cdf_fortran=netcdf-fortran
net_cdf_fortran_version=4.5.4

library=hdf5
library_version=1.12.2-mpi

boost=boost
boost_version=1.79.0

## MODULES ##
module purge

# Load modules
module load StdEnv 
# module load gcc/11.3.0  openmpi/4.1.4 # Needed to use netcdf on puhti-login11

module load ${compiler}/${compiler_version}
module load ${mpi}/${mpi_version} 
module load ${library}/${library_version}
module load ${net_cdf}/${net_cdf_version}
module load ${net_cdf_fortran}/${net_cdf_fortran_version}
module load ${boost}/${boost_version}

# Show modules
module list 

#############################################################################
#####  XIOS TRUNK  ##########################################################
#############################################################################

echo _#######################################################################
echo "Create and compile Xios Trunk"
echo _#######################################################################

svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/trunk ${XIOS_FOLDER}

cd /fmi/scratch/${Project_ID}/${XIOS_FOLDER}

#############################################################################
#############################################################################

## Create files in arch 

cat > arch/arch-puhti_intel.env <<EOF
module load ${compiler}/${compiler_version}
module load ${mpi}/${mpi_version} 
module load ${library}/${library_version}
module load ${net_cdf}/${net_cdf_version}
module load ${net_cdf_fortran}/${net_cdf_fortran_version}
module load ${boost}/${boost_version}
EOF

#############################################################################
#############################################################################

cat > arch/arch-puhti_intel.fcm <<EOF
################################################################################
###################                Projet XIOS               ###################
################################################################################
 
%CCOMPILER      mpiicc
%FCOMPILER      mpif90
%LINKER         mpif90 -nofor-main
 
%BASE_CFLAGS    -diag-disable 1125 -diag-disable 279 -std=c++11
%PROD_CFLAGS    -O2 -D BOOST_DISABLE_ASSERTS -xHost
%DEV_CFLAGS     -g -traceback -xHost -fp-model precise
%DEBUG_CFLAGS   -DBZ_DEBUG -g -traceback -fno-inline -xHost -fp-model precise
 
%BASE_FFLAGS    -D__NONE__
%PROD_FFLAGS    -O2
%DEV_FFLAGS     -g -O2 -traceback -xHost -fp-model precise
%DEBUG_FFLAGS   -g -traceback
 
%BASE_INC       -D__NONE__
%BASE_LD        -lstdc++
 
%CPP            mpicc -EP
%FPP            cpp -P
%MAKE           make
EOF

#############################################################################
#############################################################################

cat > arch/arch-puhti_intel.path <<EOF
NETCDF_LIB="-lnetcdff -lnetcdf"
HDF5_LIB="-lhdf5_hl -lhdf5"
EOF

#############################################################################
##### Compile Xios ##########################################################
#############################################################################

./make_xios --arch puhti_intel --prod --full --job 16

#############################################################################
##### NEMO 4.2.0  ###########################################################
#############################################################################

echo _#######################################################################
echo "Create and compile NEMO-4.2.0"
echo _#######################################################################

cd /fmi/scratch/${Project_ID}

git clone https://forge.nemo-ocean.eu/nemo/nemo.git ${NEMO_FOLDER}
## svn co https://forge.ipsl.jussieu.fr/nemo/svn/NEMO/releases/release-4.0

cd /fmi/scratch/${Project_ID}/${NEMO_FOLDER}

#############################################################################
#############################################################################

cat > arch/arch-puhti_intel.fcm <<EOF
%CC                  mpicc
%CFLAGS              -O2 -march=native -mtune=native
%CPP                 cpp
%FC                  mpif90 -c -cpp -fpp
%FCFLAGS             -g -i4 -r8 -O2 -fp-model precise -march=native -mtune=native -qoverride-limits -fno-alias -qopt-report=4 -align array64byte -traceback
%FFLAGS              %FCFLAGS
%LD                  mpif90
%LDFLAGS             -lstdc++
%FPPFLAGS            -P -traditional 
%AR                  ar
%ARFLAGS             rs
%MK                  make

%XIOS_HOME           /fmi/scratch/${Project_ID}/${XIOS_FOLDER}

%NCDF_INC            
%NCDF_LIB            -lnetcdff -lnetcdf -lhdf5_hl -lhdf5
%XIOS_INC            -I%XIOS_HOME/inc
%XIOS_LIB            -L%XIOS_HOME/lib -lxios -lstdc++

%USER_INC            %XIOS_INC %NCDF_INC
%USER_LIB            %XIOS_LIB %NCDF_LIB
EOF

#############################################################################
##### Compile one Reference Case ############################################
#############################################################################
 
./makenemo -r ORCA2_ICE_PISCES -m puhti_intel -j 15

#############################################################################
#############################################################################
