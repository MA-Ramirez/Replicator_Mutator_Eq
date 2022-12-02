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
Returns DataFrame with the mean data of the quantifier specified by `measure`
"""
function get_avg_data()
    data = CSV.read(datadir("avg_claim.csv"), DataFrame,header=false)
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
    graphcontourplot(r,mu,grid_zval) → png file
Plot the contour plot
Param: r Reward/punishment
Param: mu Mutation strength
Param: grid_zval Matrix with quantifier values
Return: png file with contour plot
"""
function graphcontourplot(r,mu,grid_zval)
    plt.ylabel("Reward parameter (R)")
    plt.xlabel("Mutation strength ("*L"q"*")")
    plt.contourf(mu,r,grid_zval,levels=n,cmap="inferno")
    plt.colorbar(ticks=[2,10,20,30,40,50,60,70,80,90], label="Average claim")
    #plt.colorbar(label="Average claim")
    plt.savefig(plotsdir("ContourAvg_RepMut_full.png"))
    plt.clf()
end

################################################################################
#                                  Graph plots                                 #
################################################################################
Data = get_avg_data()

#Get unique values of data run
R = sort(find_unique_values(Data[:,1]))
Mu = find_unique_values(Data[:,2])

Matrix_zvalue = create_grid_zvalue(R,Mu,Data[:,3])

graphcontourplot(R,Mu,Matrix_zvalue)
