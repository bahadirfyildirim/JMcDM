module CRITIC

export critic, CRITICResult, CriticMethod

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
using ..Utilities



struct CriticMethod <: MCDMMethod end


struct CRITICResult <: MCDMResult
    decisionMatrix::Matrix
    w::Vector
end

function Base.show(io::IO, result::CRITICResult)
    println(io, "Weights: ")
    println(io, result.w)
end

"""
        critic(decisionMat, fns)

Apply CRITIC (Combined Compromise Solution) method for a given matrix and criteria types.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n alternatives and m criteria 
 - `fns::Array{<:Function, 1}`: m-vector of functions to be applied on the columns.

# Description 
critic() applies the CRITIC method to calculate weights using a decision matrix with  
n alterntives subject to m criteria which are supposed to be either maximized or minimized.

# Output 
- `::CRITICResult`: CRITICResult object that holds multiple outputs including weighting and best index.

# Examples
```julia-repl

julia> decmat
3×4 Array{Float64,2}:
 12.9918  0.7264  -1.1009  1.59814
  4.1201  5.8824   3.4483  1.02156
  4.1039  0.0     -0.5076  0.984469

julia> df = makeDecisionMatrix(decmat)

3×4 DataFrame
 Row │ Crt1     Crt2     Crt3     Crt4     
     │ Float64  Float64  Float64  Float64  
─────┼─────────────────────────────────────
   1 │ 12.9918   0.7264  -1.1009  1.59814
   2 │  4.1201   5.8824   3.4483  1.02156
   3 │  4.1039   0.0     -0.5076  0.984469

julia> fns = [maximum, maximum, minimum, maximum];

julia> result = critic(df, fns);

julia> result.w
4-element Array{Float64,1}:
 0.16883905506169491
 0.41844653698732126
 0.24912338769165807
 0.16359102025932576

```
# References

Diakoulaki, D., Mavrotas, G., & Papayannakis, L. (1995). Determining objective weights in multiple criteria problems: The critic method. Computers & Operations Research, 22(7), 763–770. doi:10.1016/0305-0548(94)00059-h 
Akçakanat, Ö., Aksoy, E., Teker, T. (2018). CRITIC ve MDL Temelli EDAS Yöntemi ile TR-61 Bölgesi Bankalarının Performans Değerlendirmesi. Süleyman Demirel Üniversitesi Sosyal Bilimler Enstitüsü Dergisi, 1 (32), 1-24.

"""
function critic(decisionMat::Matrix, fns::Array{F,1})::CRITICResult where {F<:Function}

    row, col = size(decisionMat)
    colMax = colmaxs(decisionMat)
    colMin = colmins(decisionMat)

    A = similar(decisionMat)

    zerotype = eltype(decisionMat[:, 1])

    for i = 1:row
        for j = 1:col
            if fns[j] == maximum
                @inbounds A[i, j] =
                    (decisionMat[i, j] - colMin[j]) / (colMax[j] - colMin[j])
            elseif fns[j] == minimum
                @inbounds A[i, j] =
                    (colMax[j] - decisionMat[i, j]) / (colMax[j] - colMin[j])
            end
        end
    end

    normalizedMat = A

    corMat = one(zerotype) .- cor(normalizedMat)

    scores = zeros(zerotype, col)

    for i = 1:col
        scores[i] = sum(corMat[:, i]) .* std(normalizedMat[:, i])
    end

    w = zeros(zerotype, col)

    for i = 1:col
        w[i] = scores[i] ./ sum(scores)
    end

    result = CRITICResult(decisionMat, w)

    return result
end


"""
        critic(setting)

Apply CRITIC (Combined Compromise Solution) method for a given matrix and criteria types.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 
# Description 
critic() applies the CRITIC method to rank n alterntives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::CRITICResult`: CRITICResult object that holds multiple outputs including weighting and best index.
"""
function critic(setting::MCDMSetting)::CRITICResult
    critic(setting.df, setting.fns)
end



end # end of module CRITIC
