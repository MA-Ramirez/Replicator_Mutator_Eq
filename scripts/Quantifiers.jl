"""
Script used to run the quantifiers on a given dataset.
Each quantifier is saved on a different file.
"""

using DrWatson
@quickactivate "Replicator_Mutator_Eq"

include(srcdir("BaseCode.jl"))

using DynamicalSystems
using DelimitedFiles
using CSV
using DataFrames

################################################################################
#                                      Get data                                #
################################################################################

#Reward
R = ARGS[1]

#Check correct input of parameters
num_arguments = size(ARGS)[1]
if num_arguments == 1

    #For the replicator equation mu=0
    Mu = "0"

    #Dictionary of parameters
    params = @strdict R

    #From arguments define the name of the file to read
    NAMEFILE = "R="*R*".csv"
elseif num_arguments == 2
    #Mutation strength
    Mu = ARGS[2]

    #Dictionary of parameters
    params = @strdict R Mu

    #From arguments define the name of the file to read
    NAMEFILE = "Mu="*Mu*"_R="*R*".csv"
else
    throw(ArgumentError("There should be 1 or 2 command line arguments, but there are "*string(num_arguments)))
end


"""
    getdata() → Matrix{Float64}
Imports data from file and returns it as a matrix
"""
function getdata()
    data = CSV.read(datadir(NAMEFILE), DataFrame,header=false)
    return data
end

################################################################################
#                               Quantifiers functions                          #
################################################################################

"""
    average_claim(data) → csv file
Calculates the frequency weighted average claim of the population
The calculation is done in the last time step, when the population has stabilised
Param: data Solution trajectories of the system
Return: csv file with info [R, Mu, average claim]
"""
function average_claim(data)
    sum = 0
    for i in 1:n
        freq = data[end,i]
        claim_val = i+1
        to_sum = freq*claim_val
        sum += to_sum
    end

    r = parse(Int64,R)
    mu = parse(Float64,Mu)
    ans = [r mu sum]
    open(datadir("avg_claim.csv"), "a") do io
        writedlm(io, ans, ",")
    end
end

"""
Obtains which strategy dominates in the population
Param: data Solution trajectories of the system
Return: csv file with info [R, Mu, dominant strategy]
"""
function dominant_claim(data)
    max = 0
    dominant = 0
    for i in 1:n
        temp = last(data[:,i])
        if temp > max
            max = temp
            #+1 given that lower bound of interval is 2
            dominant = i+1
        end
    end

    r = parse(Int64,R)
    mu = parse(Float64,Mu)
    ans = [r mu dominant]
    open("Data/dominant.csv", "a") do io
        writedlm(io, ans)
    end
end

################################################################################
#                   Apply quantifiers to data and save results                 #
################################################################################

Data = getdata()
average_claim(Data)
dominant_claim(Data)
