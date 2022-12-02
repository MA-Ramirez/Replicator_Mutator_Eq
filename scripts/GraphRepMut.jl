"""
Replicator-Mutator equation
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
#Mutation strength
Mu = ARGS[2]

#Dictionary of parameters
params = @strdict R Mu

#From arguments define the name of the file to read
NAMEFILE = "Mu="*Mu*"_R="*R*".csv"

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

    #Plot full strategies
    cc = 1
    Names = ["[2-10]","[11-20]","[21-30]","[31-40]","[41-50]","[51-60]","[61-70]",
    "[71-80]","[81-90]","[91-100]"]
    #Plot trajectories
    for i in 1:n
        if mod(i,10) == 9
            plt.plot(data[:,i],color=colors[i],label=Names[cc])
            cc+=1
        else
            plt.plot(data[:,i],color=colors[i])
        end
    end

    """
    #Plot restricted strategies
    for i in 1:n
        plt.plot(data[:,i],color=colors[i],label=string(i+1))
    end
    """

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
