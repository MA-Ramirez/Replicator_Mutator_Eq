"""
Script used to graph the quantifiers of all the parameters
"""

using DrWatson
@quickactivate "Replicator_Mutator_Eq"

include(srcdir("BaseCode.jl"))

using CSV
using DataFrames
using PyCall
using LaTeXStrings
using DelimitedFiles

@pyimport matplotlib.pyplot as plt
@pyimport matplotlib.cm as cm

################################################################################
#                                      Get data                                #
################################################################################

"""
    get_avg_data() → DataFrame
Returns DataFrame with the averge claim for different R and Mu parameters
"""
function get_avg_data()
    data = CSV.read(datadir("avg_claim.csv"), DataFrame,header=false)
    return data
end

"""
    get_highfreqclaim_data() → DataFrame
Returns DataFrame with the claim with highest frequency for different R and Mu parameters
"""
function get_highfreqclaim_data()
    data = CSV.read(datadir("dominant_claim.csv"), DataFrame,header=false)
    return data
end

"""
    get_avgpayoff_data() → DataFrame
Returns DataFrame with the claim with the average payoff for different R and Mu parameters
"""
function get_avgpayoff_data()
    data = CSV.read(datadir("average_payoff.csv"), DataFrame,header=false)
    return data
end

################################################################################
#                                    Process data                              #
################################################################################

"""
    find_unique_values(array) → Vector{Float64}
Returns unique values of an array in another array
"""
function find_unique_values(array)
    arr = copy(array)
    array_unique_vals = unique!(arr)
    return array_unique_vals
end

################################################################################
#                                  Graph functions                             #
################################################################################

"""
    create_grid_zvalue(r,mu,zval) → Matrix{Float64}
Creates the matrix with the quantifier values that will be graphed in the
contour plot
Param: r Reward/punishment
Param: mu Mutation strength
Param: zval Quantifier value
Return: matrix_zvalue Quantifers values arranged in a matrix with dimensions
defined by the number of r and mu values
"""
function create_grid_zvalue(r,mu,zval)
    size_R = size(r)[1]
    size_Mu = size(mu)[1]

    matrix_zvalue = zeros(size_R,size_Mu)

    cc=1
    for i in 1:size_R
        for j in 1:size_Mu
            matrix_zvalue[i,j]=zval[cc]
            cc+=1
        end
    end
    return matrix_zvalue
end

"""
    graphcontourplot_avg(r,mu,grid_zval) → png file
Average claim
Plot the contour plot
Param: r Reward/punishment
Param: mu Mutation strength
Param: grid_zval Matrix with quantifier values
Return: png file with contour plot
"""
function graphcontourplot_avg(r,mu,grid_zval)
    plt.ylabel("Reward parameter (R)")
    plt.xlabel("Mutation strength ("*L"q"*")")
    plt.contourf(mu,r,grid_zval,levels=n,cmap="inferno")
    plt.clim(2,100)
    plt.colorbar(ticks=[2,10,20,30,40,50,60,70,80,90], label="Average claim")
    plt.savefig(plotsdir("ContourAvg_RepMut.png"))
    plt.clf()
end


"""
    graphcontourplot_high(r,mu,grid_zval) → png file
Claim with highest frequency
Plot the contour plot
Param: r Reward/punishment
Param: mu Mutation strength
Param: grid_zval Matrix with quantifier values
Return: png file with contour plot
"""
function graphcontourplot_high(r,mu,grid_zval)
    plt.ylabel("Reward parameter (R)")
    plt.xlabel("Mutation strength ("*L"q"*")")
    plt.contourf(mu,r,grid_zval,levels=n,cmap="inferno")
    plt.clim(2,100)
    plt.colorbar(ticks=[2,10,20,30,40,50,60,70,80,90], label="Claim with highest frequency")
    plt.savefig(plotsdir("ContourHigh_RepMut.png"))
    plt.clf()
end

"""
    graphcontourplot_pay(r,mu,grid_zval) → png file
Average payoff
Plot the contour plot
Param: r Reward/punishment
Param: mu Mutation strength
Param: grid_zval Matrix with quantifier values
Return: png file with contour plot
"""
function graphcontourplot_pay(r,mu,grid_zval)
    plt.ylabel("Reward parameter (R)")
    plt.xlabel("Mutation strength ("*L"q"*")")
    plt.contourf(mu,r,grid_zval,levels=n,cmap="inferno")
    plt.clim(2,100)
    plt.colorbar(ticks=[2,10,20,30,40,50,60,70,80], label="Average payoff")
    plt.savefig(plotsdir("ContourPay_RepMut.png"))
    plt.clf()
end

################################################################################
#                                  Graph plots                                 #
################################################################################

"""
    run_it(measure) → png file
It runs the graph functions.
It obtains the data and graphs it for an specific measure
Param: measure It specificies the quantifier to be graphed in graphcontourplot
The options are `Average` or `Highest frequency.
Return: png file with contour plot
"""
function run_it(measure)
    if measure == "Average claim"
        Data = get_avg_data()

        #Get unique values of data
        R = sort(find_unique_values(Data[:,1]))
        Mu = find_unique_values(Data[:,2])
        Matrix_zvalue = create_grid_zvalue(R,Mu,Data[:,3])

        graphcontourplot_avg(R,Mu,Matrix_zvalue)

    elseif measure == "Highest frequency claim"
        Data = get_highfreqclaim_data()

        #Get unique values of data
        R = sort(find_unique_values(Data[:,1]))
        Mu = find_unique_values(Data[:,2])
        Matrix_zvalue = create_grid_zvalue(R,Mu,Data[:,3])

        graphcontourplot_high(R,Mu,Matrix_zvalue)

    elseif measure == "Average payoff"
        Data = get_avgpayoff_data()

        #Get unique values of data
        R = sort(find_unique_values(Data[:,1]))
        Mu = find_unique_values(Data[:,2])
        Matrix_zvalue = create_grid_zvalue(R,Mu,Data[:,3])

        graphcontourplot_pay(R,Mu,Matrix_zvalue)
    else
        throw(ArgumentError("The available measures are Average claim, Highest frequency claim or Average payoff."))
    end
end

########################################

#run_it("Average claim")
#run_it("Highest frequency claim")
run_it("Average payoff")
