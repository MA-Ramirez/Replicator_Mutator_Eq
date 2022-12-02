"""
Replicator equation
Script used to graph the solution of the ODEs that is saved in the data folder.
A timeseries plot is generated.
"""

using DrWatson
@quickactivate "Replicator_Mutator_Eq"

include(srcdir("BaseCode.jl"))

using CSV
using DataFrames
using PyCall
using LaTeXStrings

@pyimport matplotlib.pyplot as plt
@pyimport matplotlib.cm as cm

################################################################################
#                                      Get data                                #
################################################################################

#Reward
R = ARGS[1]

#Dictionary of parameters
params = @strdict R

#From arguments define the name of the file to read
NAMEFILE = "R="*R*".csv"

"""
    getdata() → Matrix{Float64}
Imports data from file and returns it as a matrix
"""
function getdata()
    data = CSV.read(datadir(NAMEFILE), DataFrame,header=false)
    return data
end

################################################################################
#                          Graph generation functions                          #
################################################################################

"""
    graph_data(R,data,mu) → png file
Graphs data and saves it in png file
Param: R reward/punishment in the payoff scheme
Param: data Solution trajectories of the system
Param: mu Mutation strength
Return: png file with plot
"""
function graph_data(data)
    #Establish color map
    cmap = cm.get_cmap("rainbow")
    colors = []
    for i in range(0,stop=1,length=n)
        push!(colors,cmap(i))
    end

    #Plot trajectories
    for i in 1:n
        if i == 1
            plt.plot(data[:,i],color="black",label=string(i+1))
        elseif i == n
            plt.plot(data[:,i],color="deeppink",label=string(i+1))
        else
            plt.plot(data[:,i],color=colors[i],label=string(i+1))
        end
    end

    #title("Claim frequency vs Time")
    plt.xlabel("Time steps (t)")
    plt.ylabel("Claim frequency")
    plt.legend(loc="center left",title="Claim", fontsize = "x-small", bbox_to_anchor=(1,0.5))
    plt.tight_layout()
    plt.savefig(plotsdir(savename(params, "png")))
    plt.clf()
end


################################################################################
#                                  Graph plots                                 #
################################################################################

Data = getdata()
graph_data(Data)
