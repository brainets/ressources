# Launching Python scripts in parallel using SLURM sbatch array
​
This document is a small guide on how to launch python script for parameter sweeping using bash scriptsand sbatch arrays (by [Vinicius Lima](https://github.com/ViniciusLima94)).

Additional ressources : https://slurm.schedmd.com/job_array.html
​

## 1. Setting up the bash script
​
To create a general bash script you can follow the example shown below.
​
```shell
    #!/bin/bash
    #SBATCH -J test              # Job name
    #SBATCH -o job.%j.out        # Name of stdout output file (%j expands to jobId)
    #SBATCH -N 2                 # Total number of nodes requested
    #SBATCH -n 16                # Total number of mpi tasks requested
    #SBATCH -t 01:30:00          # Run time (hh:mm:ss) - 1.5 hours# Launch
    python script.py
```
​
For a more complete list of the parameters that can be specified at the top of your bash script see Section 3.
​

In the present tutorial we are particularly interested on the parameter called SBATCH array (-a,--array), that  can  be  used  to  send  jobs  across  different  computational  nodes.   In  the  sample  code  bellow  there  is  anexample on how to define this parameter.
​
```shell
    #!/bin/bash
    #SBATCH -J test        # Job name
    #SBATCH -o job.%j.out  # Name of stdout output file (%j expands to jobId)
    #SBATCH -N 1           # Total number of nodes requested
    #SBATCH -n 1           # Total number of mpi tasks requested
    #SBATCH --array=0-100  # Array from 0 to 100.
    python3 script.py $SLURM_ARRAY_TASK_ID
```

In  the  bash  script  above  the  variable `$SLURM_ARRAY_TASK_ID`  will  assume  values  from  0  to  100  (to  see alternative forms of defining the SBATCH array see Section 4), and launch script.py for each of those values in different cores (i.e., submitting 101 jobs).
​

The interesting thing is that you can use the values of the array you defined as command line arguments to  run  the  python  script  for  different  values.   However,  if  you  need  to  swap  for  the  combination  of  multiple parameters there is a small trick that can be done to launch the script, and I will discuss it in the next section.
​

## 2. Creating the python script
​
Suppose that you have a python script where you define a function that should be run for different parametercombinations across multiple computational nodes.
​

In order to use the sbatch arrays for parameter sweeping using the sample script defined in Section 1, insideyour python script you have to define a grid with all the parameter combinations you wish to use as indicated in the python script bellow.
​
```python
    import numpy as np
    import sys
    # Command line argument to acess the specific parameter combination to use
    idx = int(sys.argv[-1])
    # Defining the parameters
    i, j = 10, 20
    parameter_1 = np.linspace(10, 100, i)
    parameter_2 = np.linspace(5,  35,  j)
    # Create a grid with the parameters
    grid = np.meshgrid(parameter_1, parameter_2)
    # The combination of prameters
    parameters = np.reshape(grid, (2,i,j)).T
    def function(par1, par2):
        print('Do something')
    # Calling function
    function(parameters[idx,0], parameters[idx,1])
```

In the script above, the variable *idx* will store the value of $SLURM_ARRAY_TASK_ID, *parameters* is  an  array  that  contains  all  the  combinations  of *parameter_1*,  and *parameter_2*,  and  *function*  is  the  Python method  that  will  be  run  for  multiple  combinations  of  the  already  mentioned  *parameters*.   Note  that,  when calling *function* the variable *idx* is used to index a specific parameter combination in *parameters*.
​
## 3. List of SBATCH job parameters
​
Here, every SBATCH statement specify job parameters. Below is some of the useful parameters that can be used to submit jobs.:
​

* **-J, --job-name (jobname)** : Specify a name for the job allocation.  When not specified it defaults to the script file name
* **-o, --output (filename pattern)** : Specify filename to store standard output and standard error messages.  When not specified, it defaultsto ”slurm-%j.out” or ”slurm-%A%a.out”, where the latter is for job arrays which will be explained later.<filename pattern>can contain one or more replacement symbols, which are a percent sign ”%” followedby a letter (e.g.  %j). Allowed symbols are as follows:
    - **%%** : The character "%".
    - **%A** : Job array’s master job allocation number.
    - **%a** : Job array ID (index) number.
    - **%J** : jobid.stepid of the running job.  (e.g.  ”128.0”).
    - **%j** : jobid of the running job.
    - **%N** : short hostname.  This will create a separate IO file per node.
    - **%n** : Node identifier relative to current job (e.g.  ”0” is the first node of the running job) This will createa separate IO file per node.
    - **%s** : stepid of the running job.
    - **%t** : task identifier (rank) relative to current job.  This will create a separate IO file per task.
    - **%u** : User name.
    - **%x** : Job name.
    - A number placed between the percent character and format specifier may be used to zero-pad the resultin the IO filename (e.g.  job-%4j.out for job ID 32 will result in job-0032.out).  This number is ignored if the format specifier corresponds to non-numeric data (%N for example).
* **-e, --error (filename pattern)** : Specify filename to store standard error messages.
* **-N, --nodes (minnodes[-maxnodes])** : Request that a minimum of minnodes nodes be allocated to this job.  A maximum node count may also bespecified with maxnodes.  If only one number is specified, this is used as both the minimum and maximumnode count.
* **-n, --ntasks (number)** : sbatch does not launch tasks, it requests an allocation of resources and submits a batch script.  This optionadvises the Slurm controller that job steps run within the allocation will launch a maximum of numbertasks and to provide for sufficient resources.  The default is one task per node.
* **-t, --time (time)** : Set a limit on the total run time of the job allocation.  A time limit of zero requests that no time limitbe  imposed.   Acceptable  time  formats  include  ”minutes”,  ”minutes:seconds”,  ”hours:minutes:seconds”,”days-hours”, ”days-hours:minutes” and ”days-hours:minutes:seconds”.  When the time limit is reached,each task in each job step is sent SIGTERM followed by SIGKILL.
* **-w, --nodelist (node name list)** : Request a specific list of hosts.  The job will contain all of these hosts and possibly additional hosts asneeded to satisfy resource requirements.  The list may be specified as a comma-separated list of hosts, arange of hosts (c[01-03,05,07],clusterneuromat for example), or a filename.  You may specifyclusterneu-romatto  use  the  front  node  for  jobs  that  requires  extensive  read/write  actions.   Please  avoid  runningsimulations directly on the front node outside of the job manager to avoid oversubscription, and thereforeslowing down of execution, or even worst, crashing the front node.
* **-c, --cpus-per-task (ncpus)** : Advise  the  Slurm  controller  that  ensuing  job  steps  will  require  ncpus  number  of  processors  per  task.Without this option, the controller will just try to allocate one processor per task.  Use this option to runhybrid (MPI + OpenMP) jobs.  The number of cpus requested per task is stored inSLURMCPUSPERTASKenvironment variable.
* **-a, --array (indexes)** : Submit a job array, multiple jobs to be executed with identical parameters.  The indexes specification iden-tifies what array index values should be used.  Multiple values may be specified using a comma separatedlist and/or a range of values with a ”-” separator.  For example, ”--array=0-15” or ”--array=0,6,16-32”.  Astep function can also be specified with a suffix containing a colon and number.  For example, ”--array=0-15:4” is equivalent to ”--array=0,4,8,12”.  A maximum number of simultaneously running tasks from thejob array may be specified using a ”%” separator.  For example ”--array=0-15%4” will limit the numberof simultaneously running tasks from this job array to 4.
* **--exclusive** : The job allocation can not share nodes with other running jobs.
* **--mem (size[units])** : Specify the real memory required per node.  Default units are megabytes.  Different units can be specifiedusing the suffix [K|M|G|T]. When not specified, it will allocate 1G per CPU.
* **-x, --exclude (node name list)** : Explicitly exclude certain nodes from the resources granted to the job.
​

## 4. Alternative ways of defining the SBATCH array
​
```shell
SBATCH -–array=0-7      # $SLURM_ARRAY_TASK_ID takes values from 0 to 7 inclusive;
SBATCH -–array=1,3,5,7  # $SLURM_ARRAY_TASK_ID takes the listed values;
SBATCH -–array=1-7:2    # Step-size of 2, same as the previous example;
SBATCH -–array=1-100%10 # Allows no more than 10 of the jobs to run simultaneously.
```


## 5. Example : compute the HGA on multiple subjects on the mesocentre

Submission script for computing the HGA on 10 subjects, one per node, where each node is using 32 cores :

```shell
    #!/bin/bash
    #SBATCH -t 03:00:00
    #SBATCH -J compute_hga_multi_nodes
    #SBATCH -o ./%N.%j.%a.out
    #SBATCH -e ./%N.%j.%a.err
    #SBATCH --mail-type=BEGIN,END
    #SBATCH --mail-user=rlebogosse@login.mesocentre.univ-amu.fr
    #SBATCH -A b128
    #SBATCH -p skylake
    #SBATCH -N 1
    #SBATCH --ntasks-per-node=32
    #SBATCH --mem=100G
    #SBATCH --array=0-9

    python -O compute_hga_meg.py --subject=$SLURM_ARRAY_TASK_ID
```

Associated `compute_hga_meg.py` python script :

```python
    import argparse
    import mne
    import numpy

    if __name__ == '__main__':
        # get input arguments
        parser = argparse.ArgumentParser()
        parser.add_argument("--subject", help="Subject number {0-9}")
        args = parser.parse_args()
        # get the subject number
        subject_nb = int(args.subject)

        # compute hga on the selected subject
        compute_hga(subject=subject_nb)
```
