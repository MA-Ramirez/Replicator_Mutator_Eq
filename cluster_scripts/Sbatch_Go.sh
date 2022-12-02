#!/bin/bash

#SBATCH --job-name=MAR 		                 #Name of the job
#SBATCH --nodes=1				                   #Required nodes, Default=1
#SBATCH --ntasks-per-node=1				         #Tasks per node
#SBATCH --cpus-per-task=40		               #Cores per task
#SBATCH --mem=65536		                    #Memory in Mb per CPU
#SBATCH --mail-user=ramirez@mis.mpg.de
#SBATCH --mail-type=FAIL                  #Send email at BEGIN, END, FAIL, REQUEUE, ALL

module load julia/1.7.0
  julia scripts/SolveRepMut.jl $1 $2
  #julia scripts/GraphRepMut.jl $1 $2
  #julia scripts/Quantifiers.jl $1 $2
module unload julia/1.7.0
