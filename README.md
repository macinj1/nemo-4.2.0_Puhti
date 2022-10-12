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

Similar to the previous section, here I describe how to run a particular case or your simulation in NEMO 4.2. The main folder of this section is **RUN_NEMO_SIMULATION**. In contrast to the previous section, test cases _are not_ revised previous release the new NEMO version, those are described https://sites.nemo-ocean.io/user-guide/tests.html and located in

```sh
/nemo-4.2.0/tests/
```
In general, NEMO provides a README file for each test case located in the **EXPREF** folder that exaplains how to run the simulation. In general, there are three steps: 

1 - Compile the case once; \
2 - Create the initial mesh with Python script; \
3 - Run the simulation a second time to obtain the time evolution and data. 

In the **RUN_NEMO_SIMULATION** folder, there are two _sh_ files to compile and run the test case **compile_Test_Case.sh** and **run_test_simulation.sh** (**run_test_simulation_MESH.sh**), respectively. 

As in the reference case, one can compile a test case using the following command 

```sh
./makenemo -a TEST_CASE_NAME -m puhti_intel -n MY_TEST_CASE_NAME -j 15
```

where the option _-a_ is followed by the case's name, _-m_ by the architecture file used during compilation, and _-n_ your new folder with the compilated version of the test case located now in _/nemo-4.2.0/tests/_. For example, we process to compile **ICE_ADV2D** case in our new folder **MY_ICE_ADV2D** 

```sh
./makenemo -a ICE_ADV2D -m puhti_intel -n MY_ICE_ADV2D -j 15
```
Again, we need to submit the simulation to the queue by using a "job.sh" file, which run the simulation with the command

```sh
mpirun ./nemo 
```
or 
```sh
srun ./nemo 
```

Once the simulation ends, the data will be located in the folder of our case. In our example, the data will be located in **MY_ICE_ADV2D**. 
