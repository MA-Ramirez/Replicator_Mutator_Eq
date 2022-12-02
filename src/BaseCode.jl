"""
Functions used to define the ODEs of the replicator mutator equation
"""

using DrWatson, DynamicalSystems

################################################################################
#                                  Parameters                                  #
################################################################################

#Number of actions
n = 99

################################################################################
#                          Payoff matrix definition                            #
################################################################################

"""
    payoff(x,y,R) → Float64
Defines the payoff scheme of the Travelers Dilemma
Note: I am x, other player is y, for there to be incentive in playing low claims
 If switched, payoff scheme changes
Param: x My claim
Param: y Other player claim
Param: R reward/punishment in the payoff scheme
Return: My payoff
"""
function payoff(x,y,R)
    if x > y
        return min(x, y) - R
    elseif x < y
        return min(x, y) + R
    else
        return min(x,y)
    end
end

"""
    payoff_matrix(R) → Matrix{Float64}
Payoff matrix of Travelers Dilemma
Returns TD payoff matrix for a given reward value
Param: n Number of claims
Param: R reward/punishment in the payoff scheme
Return: Payoff Matrix
"""
function payoff_matrix(R)
    A = zeros((n, n))
    for i in 1:n
        for j in 1:n
            A[i,j] = payoff(i+1,j+1,R)
            #Sum 1 in i and j because strategy space is [2,100]
        end
    end
    return A
end


################################################################################
#                        Mutation matrix definition                            #
################################################################################
"""
    mutation_Matrix(Mu) → Matrix{Float64}
Define mutation matrix
There is equal prob to move to any other state
Param: Mu Mutation prob
Return: Q Mutation matrix
"""
function mutation_matrix(Mu)
    #Mutation matrix
    Q = zeros((n, n))

    for i in 1:n
        for j in 1:n
            if i != j
                Q[i,j] = Mu/(n-1)
            else
                Q[i,j] = 1-Mu
            end
        end
    end
    return Q
end

################################################################################
#                           Dynamic rule definition                            #
################################################################################

##################################################
#                Replicator equation            #
##################################################

@inline @inbounds function replicator_eq!(du, u, p, t)
    """
    replicator_eq!(du, u, p, t)
    Define dynamic rule for n replicator equations
    Param: du Solution (iterative)
    Param: u Variables
    Param: p Parameters
    Param: t Time
    Return: Dyn rule to input in DynamicalSystems methods
    """

    #Input payoff matrix as parameter
    A = p[1]

    #Define vector of variables
    X = []
    for i in 1:n
        push!(X,u[i])
    end

    #Define fitness values
    f = []
    for i in 1:n
        push!(f,(A*X)[i])
    end

    #Average fitness
    Avg = transpose(X)*A*X

    #n replicator equations
    for i in 1:n
        du[i] = X[i]*(f[i]-Avg)
    end

    #Output
    return
end


##################################################
#           Replicator-Mutator equation          #
##################################################

@inline @inbounds function replicator_mutator_eq!(du, u, p, t)
    """
    replicator_mutator_eq!(du, u, p, t)
    Define dynamic rule for n replicator-mutator equations
    Param: du Solution (iterative)
    Param: u Variables
    Param: p Parameters
    Param: t Time
    Return: Dyn rule to input in DynamicalSystems methods
    """

    #Input payoff matrix as parameter
    A = p[1]
    #Input mutation matrix as parameter
    Q = p[2]

    #Define vector of variables
    X = []
    for i in 1:n
        push!(X,u[i])
    end

    #Define fitness values
    f = []
    for i in 1:n
        push!(f,(A*X)[i])
    end

    #Average fitness
    Avg = transpose(X)*A*X

    #n replicator-mutator equations
    for i in 1:n
        sum = 0
        for j in 1:n
            sum += X[j]*f[j]*Q[j,i]
        end
        du[i] = sum - X[i]*Avg
    end

    #Output
    return
end
