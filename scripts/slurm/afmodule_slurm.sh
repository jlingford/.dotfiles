#!/bin/bash
#SBATCH --job-name="AlphaFold"
#SBATCH --account=rp24
#SBATCH --time=4:00:00
#SBATCH --partition=bdi
#SBATCH --qos=bdiq
#SBATCH --gres=gpu:A100:1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=100000
#SBATCH --mail-user=james.lingford@monash.edu
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_OUT,TIME_OUT_50,TIME_OUT_90
#SBATCH --chdir="/home/jamesl/rp24/scratch_nobackup/jamesl/afjob"
#SBATCH --output=slurmlog-%j.out
#SBATCH --error=slurmlog-%j.err

# Source
# in-built module in M3
# run `run_alphafold --help`

# Must provide .fasta file as an argument after script.sh
FILE=$1

module purge
source /etc/profile.d/modulecmd.sh
module load alphafold
module list

run_alphafold \
-d /mnt/reference/alphafold/alphafold_20211129 \
-o /home/jamesl/rp24/scratch_nobackup/jamesl/afjob \
-f /home/jamesl/rp24/scratch_nobackup/jamesl/afjob/$FILE \
-t 2022-01-13 \
-g true \
-a 0 \
-c full_dbs \
-m multimer \
-p false \
-b false \
-l true \
