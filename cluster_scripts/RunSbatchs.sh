input="cluster_scripts/Parameters.txt"
while IFS= read -r line
do
  sbatch cluster_scripts/Sbatch_Go.sh $line
done < "$input"
