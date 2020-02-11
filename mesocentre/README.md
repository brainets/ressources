# Configure the mesocentre

## Login

`ssh ecombrisson@login.mesocentre.univ-amu.fr`

You should configure your ssh RSA keys to make your connection easier !

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

### Upload data stored locally

`rsync -rv /path_to_my_files/ ecombrisson@login.mesocentre.univ-amu.fr:/home/ecombrisson/data/`

### Mount mesocentre disk locally

`sshfs ecombrisson@login.mesocentre.univ-amu.fr:/path_to_mount/ /local_path/`

## Submit your job

### Interactive session

30 minutes of interactive session (1 node with 32 cores) :

`srun -p skylake --time=00:30:0 -N 1 --ntasks-per-node=32 --pty bash -i`

### Submit a script

Start by creating an executable submission file :
1. `touch submit.sh`
2. `chmod +x submit.sh`

Past the following lines inside it :
```bash
#!/bin/bash
#SBATCH -t 01:00:00
#SBATCH -J example_scipt
#SBATCH -o ./%N.%j.%a.out
#SBATCH -e ./%N.%j.%a.err
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=e.combrisson@gmail.com
#SBATCH -A b128
#SBATCH -p skylake
#SBATCH -N 1
#SBATCH --ntasks-per-node=32
#SBATCH --mem=100G

# Load modules :
module load userspace/all
module load python3/3.6.3

# Activate python env :
source /home/ecombrisson/py3/bin/activate

# Run your python file (optimization mode)
python -O /path_to_my_file/script.py
```
