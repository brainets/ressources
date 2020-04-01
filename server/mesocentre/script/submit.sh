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
