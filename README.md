# NEMO "Nucleus for European Modelling of the Ocean"

NEMO standing for "Nucleus for European Modelling of the Ocean" is a state-of-the-art modelling framework for research activities and forecasting services in ocean and climate sciences, developed in a sustainable way by a European consortium. Source code and better guides that the present one could be found in the official websites: 

https://www.nemo-ocean.eu/ \
https://sites.nemo-ocean.io/user-guide/

I describe here how to compile and use NEMO on Puhti supercomputer (CSC - Finland). At the moment, Puhti is using RHEL8 and therefore the following guide is implemented for the current configuration. As part of the CSC project, I use and describe the content of a private folder in the supercomputer. Instructions should work on any other system with appropriate fixes base on your local configuration. 

The private folder on Puhti supercomputer contains two different versions of NEMO:

- NEMO 4.0 with Xios 2.5
- NEMO 4.2.0 with Xios trunk

Both versions are already compiled on Puthi RHEL8. In order to compile both NEMO and Xios source codes, you can use the file "build_nemo42_xiostrunk_v2.sh", which simple runs with the command (check your shell language)

```sh
sh build_nemo42_xiostrunk_v2.sh
```

The process includes the compilation of the reference case **ORCA2_ICE_PISCES** with the command 

```sh
./makenemo -r ORCA2_ICE_PISCES -m puhti_intel -j 15
```

and, after successful compilation, one should see the message **Build command finished**. To compile only NEMO, use the file "build-nemo42-puhti.sh". Both files can be executed after correctly defined the local variables. All build files are located in the **BUILDING_NEMO_XIOS** folder.

In order to compile a different reference case and further information, please check the following link https://sites.nemo-ocean.io/user-guide/cfgs.html.

## Compiling and Running a Reference Case

Reference cases are updated before each new NEMO release and they serve as check points during the compilation process. They are located in the folder 

```sh
/nemo-4.2.0/cfgs/
```

As mention previously, one can compile a reference case using the command 

```sh
./makenemo -r REFERENCE_CASE_NAME -m puhti_intel -j 15
```

where the option -r is followed by the case's name and -m by the architecture file used during compilation. 

```sh
./makenemo -r ORCA2_ICE_PISCES -m puhti_intel -j 15
```

https://zenodo.org/record/3767939

## Compiling and Running Simulations

The main folder of this section is **NEMO_Simulations**. First one have to compile the case and this could be done using the file "compile_Simulation.sh". 
In simple terms, the "compile_Simulation.sh" file copy a test case and compile it. Then you can modify the case and run the simulation. As an example, if you wants to ICE advection 2D case, we do it by executing the following command 

```sh
./makenemo -n ICE_ADV2D -a ICE_ADV2D_MINE_CASE -m puhti_intel -j 15
```

The compiled case will be located in the tests folder in NEMO 

```sh
/nemo-4.2.0/tests/
```

Once the case is copied, we can run it. In the folder "/nemo-4.2.0/tests/" will be now a new folder called **ICE_ADV2D_MINE_CASE**, which will be our case to be run. 
In general, NEMO provides a README file for each tests case located in the **EXPREF** folder that exaplains how to run the simulation. In general, there are three steps: 

1 - Compile the case once; \
2 - Create the initial mesh with Python script; \
3 - Run the simulation a second time to obtain the time evolution and data. 

To run each different test case, I have created different folders in the **NEMO_Simulations** folder. In each folder, the output file indicate case information and the error file errors during the running. Each folder contain a file called "job.sh" that submits the case to the CSC queue and run it with the command  

```sh
mpirun ./nemo 
```
or 
```sh
srun ./nemo 
```

_WARNING_: modify the SBATCH option in the "job.sh" accordingly to your wishes. 

Once the simulation ends, the data will be located in the folder of our case. In our example, the data will be located in **ICE_ADV2D_MINE_CASE**. 
