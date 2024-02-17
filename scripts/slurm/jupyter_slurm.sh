#!/bin/bash
#SBATCH --job-name="jupyter notebook"
#SBATCH --account=rp24
#SBATCH --time=4:00:00
#SBATCH --partition=bdi
#SBATCH --qos=bdiq
#SBATCH --nodelist=m3u022
#SBATCH --gres=gpu:A100:1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=100000
#SBATCH --mail-user=james.lingford@monash.edu
#SBATCH --chdir="/home/jamesl/rp24/scratch_nobackup/jamesl/jupyter"
#SBATCH --error=log_jupyter_%j.err

# Source
# https://www.jameslingford.com/blog/colabfold-hpc-ssh-howto/

module purge
source /home/jamesl/rp24/scratch_nobackup/jamesl/miniconda/bin/activate

export XDG_RUNTIME_DIR=""
login_node="m3.massive.org.au"
port=37798

jupyter notebook \
    --NotebookApp.allow_origin='https://colab.research.google.com' \
    --port=${port} \
    --NotebookApp.port_retries=0
wait
