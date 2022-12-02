"""
Script used to determine the parameters for which the ODEs will be solved
"""

using DelimitedFiles

R = [2,5,10,15,20,25,30,35,40]
Mu = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]

for i in R
    for j in Mu
        params = Any[i,j]
        #The parameters are saved in cluster_scripts
        open("cluster_scripts/Parameters.txt", "a") do io
            writedlm(io, adjoint(params), " ")
        end
    end
end
