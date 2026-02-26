#!/bin/bash
#SBATCH --qos=low
#SBATCH --array=0-9
#SBATCH --job=trident
#SBATCH --output=logs/%x/%A_%a.out
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=50G
#SBATCH --gpus=1
#SBATCH --time=1-00:00:00
#SBATCH --requeue
#SBATCH --exclude=dlc-mewtwo,dlc-electabuzz
#SBATCH --container-image="ghcr.io/siemdejong/trident-docker:latest"
# Make sure to add mounts via --container-mounts
python run_batch_of_slides.py --task all --wsi_dir ./wsis --job_dir ./trident_processed --patch_encoder uni_v1 --mag 20 --patch_size 256
