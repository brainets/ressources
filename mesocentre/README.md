# Configure the mesocentre

[Mesocentre tutorials](https://mesocentre.univ-amu.fr/les-tutoriaux/)

## Login

* **First name :** Roger
* **Last name :** Lebogosse
* **Mesocentre login :** rlebogosse

`ssh rlebogosse@login.mesocentre.univ-amu.fr`

You should configure your ssh RSA keys to make your connection easier !

## Manage your conda environment

Checkout the official conda documentation for [managing environments](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)

### Export a conda environment

**Official reference :** [Exporting the environment.yml file](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#exporting-the-environment-yml-file). First, start by activating it :

```
conda activate myenv
```

Then export it :

```
conda env export --name myenv > environment.yml
```

### Install a conda environment from a yml file

**Official reference :** [Creating an environment from an environment.yml file](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-from-an-environment-yml-file). 

Launch the following line to create an environment based on a yml environment file :

```
conda env create -f environment.yml
```

### Export a conda environment - second way

If somehow the previous method doesn't work (e.g. you don't have Anaconda installed on your PC), 
you can also follow this guide.

Activate your environment trough the command line:

    source activate myenv

Once you're in your environment, you can obtain the list of all your installed packages by executing

    pip freeze > requirements.txt
    
Then install your favourite python environment, activate it, and run the command

    pip install -r requirements.txt

## Create your Python environment

### Load Python modules

Once connected to the mesocentre, run the following commands to load python in the mesocentre :

```
module load userspace/all
module load python3/3.6.3
```

## Create and activate the environment

* Create the environment : `python3 -m venv "py36"`
* Activate the environment : `source ~/py36/bin/activate`

## Manage your data

* [Disk usage per user](https://mesocentre.univ-amu.fr/espaces_disquesn/)
* [Data transfer](https://mesocentre.univ-amu.fr/sauvegarde-donnees/)

### Upload data stored locally

`rsync -rv /path_to_my_files/ rlebogosse@login.mesocentre.univ-amu.fr:/home/rlebogosse/data/`

For a more detailed documentation, see [rsync.md](https://github.com/brainets/ressources/blob/master/mesocentre/attachment/rsync.md)

### Mount mesocentre disk locally

`sshfs rlebogosse@login.mesocentre.univ-amu.fr:/path_to_mount/ /local_path/`

## Submit your job

### Interactive session

30 minutes of interactive session (1 node with 32 cores) :

`srun -p skylake -A b128 --time=00:30:0 -N 1 --ntasks-per-node=32 --pty bash -i`

### Submit a script

**Start by creating an executable submission file**
1. `touch submit.sh`
2. `chmod +x submit.sh`

**Past the following lines inside it : [submit.sh](https://github.com/brainets/ressources/blob/master/mesocentre/script/submit.sh)**
* `#SBATCH -t 01:00:00` : ask fo 1 hour of computations
* `#SBATCH -J example_scipt` : the purpose of your script (compute_power, compute_mi etc.)
* `#SBATCH --mail-user=s.combrissone@gmail.com` : your email adress to be notified when your script start / finish
* `#SBATCH -A b128` : Andrea's project number
* `#SBATCH -p skylake` : the material to use
* `#SBATCH -N 1` : the number of nodes
* `#SBATCH --ntasks-per-node=32` : number of cores per node
* `#SBATCH --mem=100G` : RAM requirements

**Submit your script**

`sbatch submit.sh`

### Checkout that your script is running

`squeue -u rlebogosse`

### Checkout the core usage (per node)

When submitting your jobs you should get two files (skylake032.err and skylake032.out).
* `skylake032` is the node number of the skylake partition
* The \*.out contains print outputs and the \*.err contains "errors" (or logging)

While your script is running, you should be able to connect to the node :

`ssh skylake032`

From this node you can run `htop` to see the usage of each core
