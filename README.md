# NEMO "Nucleus for European Modelling of the Ocean" - SI3

https://www.nemo-ocean.eu/ \
https://sites.nemo-ocean.io/user-guide/

The folder contains two different versions of NEMO:

- NEMO 4.0 with Xios 2.5
- NEMO 4.2.0 with Xios trunk

To compile only NEMO, use the file "build-nemo42-puhti.sh", which contains the full instructions. To compile both NEMO and Xios, use the file "build_nemo42_xiostrunk.sh". Both files can be executed after correctly defined the local variables. After compilation, the reference case **ORCA2_ICE_PISCES** will be compile using the following command

```sh
./makenemo -r ORCA2_ICE_PISCES -m puhti_intel -j 15
```

To compile a different reference case and further information, please check the folling link https://sites.nemo-ocean.io/user-guide/cfgs.html.

## Compiling and Running Simulations

The main folder of this section is **NEMO_Simulations**. First once needs to compile the case and this could be done using the file "compile_Simulation.sh". 
In simple terms, the "compile_Simulation.sh" file copy a test case and compile it. Then once can modify the case and run the simulation. As an example, if once wants to ICE advection 2D case, we do it by executing the following command 

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
