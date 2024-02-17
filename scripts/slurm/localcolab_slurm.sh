#!/bin/bash
#SBATCH --job-name="localcolabfold"
#SBATCH --account=rp24
#SBATCH --time=18:00:00
#SBATCH --partition=bdi
#SBATCH --qos=bdiq
#SBATCH --gres=gpu:A100:2
#SBATCH --cpus-per-task=12
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=600000
#SBATCH --mail-user=james.lingford@monash.edu
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_OUT
#SBATCH --chdir="/home/jamesl/rp24/scratch_nobackup/jamesl/localcolabfold"
#SBATCH --output=log-%j.out
#SBATCH --error=log-%j.err

# Source
# https://github.com/YoshitakaMo/localcolabfold

module purge
export PATH="/home/jamesl/rp24/scratch_nobackup/jamesl/localcolabfold/colabfold-conda/bin:$PATH"

#log
echo "localcolab_slurm.sh"
cat slurm_A100.sh
nvidia-smi
colabfold_batch --help

colabfold_batch \
    --model-type=alphafold2_multimer_v3 \
    --num-recycle 3 \
    --zip \
    input/B62_Njord.fasta \
    output/b62_njordredo
