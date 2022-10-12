<img src = "https://github.com/macinj1/nemo-4.2.0_Puhti/blob/main/figs/Nemo_Logo.png" width = "400"><img src = "https://github.com/macinj1/nemo-4.2.0_Puhti/blob/main/figs/Puhti_logo.png" width = "400">

# NEMO "Nucleus for European Modelling of the Ocean"

NEMO standing for "Nucleus for European Modelling of the Ocean" is a state-of-the-art modelling framework for research activities and forecasting services in ocean and climate sciences, developed in a sustainable way by a European consortium. Source code and better guides that the present one could be found in the official websites: 

https://www.nemo-ocean.eu/ \
https://sites.nemo-ocean.io/user-guide/

I describe here how to compile and use NEMO on Puhti supercomputer (CSC - Finland). At the moment, Puhti is using RHEL8 and therefore the following guide is implemented for the current configuration. As part of the CSC project, I use and describe in what follows the content of a private folder in the supercomputer. Instructions should work on any other system with appropriate fixes base on your local configuration. 

The private folder on Puhti supercomputer contains two different versions of NEMO:

- NEMO 4.0 with Xios 2.5
- NEMO 4.2.0 with Xios trunk

Both versions are already compiled on Puthi RHEL8. In order to compile both NEMO and Xios source codes, you can use the file "build_nemo42_xiostrunk_v2.sh", which simple runs with the command (check your shell language)

```sh
sh build_nemo42_xiostrunk_v2.sh
```

To compile NEMO 4.0 with Xios 2.5, you need to change the names in the previous sh file. Do the same for any other version.
The process includes the compilation of the reference case **ORCA2_ICE_PISCES** using the command 

```sh
./makenemo -r ORCA2_ICE_PISCES -m puhti_intel -j 15
```

and, after successful compilation, one should see the message **Build command finished**. NOTE: the previous command will compile the reference case in the original folder; it would be recommended to create your our _Reference Case_ folder (see below). 

To compile only NEMO, use the file "build-nemo42-puhti.sh". Both files can be executed after correctly defined the local variables. All _build_ files are located in the **BUILDING_NEMO_XIOS** folder.

In order to compile a different reference case and further information, please check the following link https://sites.nemo-ocean.io/user-guide/cfgs.html.

## Compiling and Running a Reference Case

Reference cases are updated before each new NEMO release and they serve as check points during the update process. All reference cases are located in the folder 

```sh
/nemo-4.2.0/cfgs/
```

As mention previously, one can compile a reference case using the following command 

```sh
./makenemo -r REFERENCE_CASE_NAME -m puhti_intel -n MY_REFERENCE_CASE_NAME -j 15
```

where the option _-r_ is followed by the case's name, _-m_ by the architecture file used during compilation, and _-n_ your new folder with the compilated version of the reference case. For example, we process to compile ORCA2 ICE PISCES (https://sites.nemo-ocean.io/user-guide/cfgs.html#orca2-ice-pisces) in our new folder **MY_ORCA2_ICE_PISCES** 

```sh
./makenemo -r ORCA2_ICE_PISCES -m puhti_intel -n MY_ORCA2_ICE_PISCES -j 15
```

This procedure will create an experiment folder named **EXP00** into **MY_ORCA2_ICE_PISCES**, which contains the simulation configuration in the files **file_def_nemo*.xlm**. Into this folder, we have to place the input files of the simulation, which are released together with the nex NEMO version. Those files can be found in the following link https://zenodo.org/record/3767939. 

Once the case is compiled, a symbolic link to **nemo.exe** is created in the **EXP00** folder, and then we can run the simulation by doing 

```sh
srun ./nemo
```

In Puhti supercomputer, we **have to** place the job on the queue (https://docs.csc.fi/support/tutorials/biojobs-on-puhti/). To do that, create a sh file following the rules here (https://docs.csc.fi/support/tutorials/biojobs-on-puhti/)

```sh
sbatch YOUR_job_FILE.sh
```

To check all possible SI3 sea ice model parameters, see the **namelist_ice_ref** Fortran namelist file. The NEMO ocean model parameters are defined in files **namelist_ref**.

To summarize, I have created the **RUN_NEMO_REFCASE** folder, where the **compile_Reference_Case.sh** compiles the reference case: change the case name you wish to compile. I have also created the folder **INPUT_REF_CASE_ORCA_ICE_PISES**, which contains all the input files needed to run the **ORCA2_ICE_PISES** case. As an example, **run_simulation.sh** allows you to run the case. 

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
