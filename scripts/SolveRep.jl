"""
Replicator Equation
Script used to solve ODEs and save the solution in data folder.
"""

using DrWatson
@quickactivate "Replicator_Mutator_Eq"

include(srcdir("BaseCode.jl"))

using DynamicalSystems
using DelimitedFiles

################################################################################
#                                 Set parameters                               #
################################################################################


#Reward
R = parse(Int64,ARGS[1])

#Dictionary of parameters
params = @strdict R

################################################################################
#                        Initial conditions definition                         #
################################################################################

"""
    ini_con() → Vector{Float64}
Define initial conditions
Return: Array of initial conditions
"""
function ini_con()
    ini_con = zeros(n)
    for i in 1:n
        ini_con[i] = 1/n
    end
    return ini_con
end

################################################################################
#                    Obtain and save solution of the equation                  #
################################################################################

"""
    obtain_data(R,ini,mu) → DataSet
Obtains solution trajectories of the system
Param: R reward/punishment in the payoff scheme
Param: ini array with initial conditions
Param: mu Mutation strength
Return: dataset Solution trajectories of the system
"""
function obtain_data(r,ini)
    M = payoff_matrix(r)
    #Paramaters
    p = [M]

    #Generate dynamical system
    #   ContinuousDynamicalSystem(f, state, p; t0 = 0.0)
    #Returns generalized dynsys from dyn rule
    ds = ContinuousDynamicalSystem(replicator_eq!, ini_con(), p)

    #Time evolution of the system
    #   trajectory(ds::GeneralizedDynamicalSystem, T; kwargs...) → dataset
    #Returns dataset containing trajectory of system ds, after evolving for a total time T
    data = trajectory(ds, 30; Δt = 0.1)

    return Matrix(data)
end

"""
    save_data(indata) → csv file
Save solution of the ODEs system
The solution is saved in data folder
"""
function save_data(indata)
    writedlm(datadir(savename(params, "csv")), indata)
end

################################################################################
#                                   Run it                                    #
################################################################################

Data = obtain_data(R,ini_con())
save_data(Data)
