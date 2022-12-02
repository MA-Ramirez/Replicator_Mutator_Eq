# Replicator-Mutator Equation

The code numerically solves the equation. In addition, it graphs and analyses the results.

### 1. ODEs system
The main goal of the code is to numerically solve the set of differential equations that describe the replicator-mutator equation (see eqs 2 and 3) for the Traveler's Dilemma (see Figure 1).
The replicator-mutator equation is the generalizaton of the replicator dynamics. When no mutations are allowed ( $q=0$ ), the replicator-mutator equation is equivalent to the replicator dynamics.
The main parameters to explore are `R` (reward value) and `q` (mutation strength).

> Note: `q` is also named `Mu` in the code.

-To solve the replicator-mutator equations and obtain the data: `julia scripts/SolveRepMut.jl R Mu`

-To solve the replicator dynamics system and obtain the data: `julia scripts/SolveRepMut.jl R 0`

or `julia scripts/SolveRep.jl R`

-To graph the solution of the replicator-mutator equations as a timeseries: `julia scripts/GraphRepMut.jl R Mu`

-To graph the solution of the replicator dynamics as a timeseries: `julia scripts/GraphRepMut.jl R 0`

or `julia scripts/GraphRep.jl R`

-To measure the quantifiers to characterise the solution of the replicator-mutator equation: `julia scripts/Quantifiers.jl R Mu`

-To measure the quantifiers to characterise the solution of the replicator dynamics: `julia scripts/Quantifiers.jl R 0`

### 2. Cluster runs
To run the code in batch.

-To set the parameters to be explored: `cluster_scripts/ParametersToRun.jl`
(it returns the file `Parameters.txt`)

-To run the scripts to solve and graph the system for the parameters set in Parameters.txt: `bash cluster_scripts/RunSbatchs.sh`

-To run Quantifiers.jl for the entire parameter set: `sbatch cluster_scripts/SbatchCompact.sh`

-To graph the quantifiers contour plot for the entire parameter set: `julia process_cluster/ClusterGraphData`

## Reproducibility
This code base is using the Julia Language and [DrWatson](https://juliadynamics.github.io/DrWatson.jl/stable/)
to make a reproducible scientific project named
> Replicator_Mutator_Eq

It is authored by Maria Alejandra Ramirez.

To (locally) reproduce this project, do the following:

0. Download this code base. Notice that raw data are typically not included in the
   git-history and may need to be downloaded independently.
1. Open a Julia console and do:
   ```
   julia> using Pkg
   julia> Pkg.add("DrWatson") # install globally, for using `quickactivate`
   julia> Pkg.activate("path/to/this/project")
   julia> Pkg.instantiate()
   ```

This will install all necessary packages for you to be able to run the scripts and
everything should work out of the box, including correctly finding local paths.
