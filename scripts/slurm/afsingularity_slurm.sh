#!/bin/bash
#SBATCH --job-name="AF2_singularity"
#SBATCH --account=rp24
#SBATCH --time=1:00:00
#SBATCH --partition=bdi
#SBATCH --qos=bdiq
#SBATCH --gres=gpu:A100:1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=100000
#SBATCH --mail-user=james.lingford@monash.edu
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_OUT
#SBATCH --chdir="/home/jamesl/rp24/scratch_nobackup/jamesl/alphafold"
#SBATCH --output=log-%j.out
#SBATCH --error=log-%j.err

# Source
# https://github.com/dialvarezs/alphafold

# Must provide .fasta file as an argument after script.sh
FILE=$1

module purge
module load singularity
export SINGULARITY_CACHEDIR="/home/jamesl/rp24/scratch_nobackup/jamesl/alphafold"

./run_alphafold_singularity.py \
--data-dir /mnt/reference/alphafold/alphafold_20210726 \
--output-dir /home/jamesl/rp24/scratch_nobackup/jamesl/alphafold/output \
--fasta-paths /home/jamesl/rp24/scratch_nobackup/jamesl/alphafold/input/$FILE \
