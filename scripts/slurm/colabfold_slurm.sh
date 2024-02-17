#!/bin/bash
#SBATCH --job-name="colabsing"
#SBATCH --account=rp24
#SBATCH --time=0:05:00
#SBATCH --partition=bdi
#SBATCH --qos=bdiq
#SBATCH --nodelist=m3u021
#SBATCH --gres=gpu:A100:1
#SBATCH --cpus-per-task=12
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=200000
#SBATCH --mail-user=james.lingford@monash.edu
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_OUT
#SBATCH --chdir="/home/jamesl/rp24/scratch_nobackup/jamesl/ColabFold"
#SBATCH --output=log-%j.out
#SBATCH --error=log-%j.err

# Source
# https://github.com/sokrypton/ColabFold/wiki/Running-ColabFold-in-Docker

# log
cat slurm.sh
echo 'running colabfold:1.5.5-cuda12.2.2'
nvcc --version
nvidia-smi

# setup singularity
module purge
module load singularity
export SINGULARITY_CACHEDIR="/home/jamesl/rp24/scratch_nobackup/jamesl"

# download singularity container and alphafold weights
singularity pull docker://ghcr.io/sokrypton/colabfold:1.5.5-cuda12.2.2

singularity run -B /home/jamesl/rp24/scratch_nobackup/jamesl/cache:/cache \
    colabfold_1.5.5-cuda12.2.2.sif \
    python -m colabfold.download

# run colabfold help
singularity run --nv \
    colabfold_1.5.5-cuda12.2.2.sif \
    colabfold_batch --help

# run colabfold prediction
singularity run --nv \
    -B /home/jamesl/rp24/scratch_nobackup/jamesl:/cache -B $(pwd):/work \
    colabfold_1.5.5-cuda12.2.2.sif \
    colabfold_batch /work/A173.fasta /work/output
