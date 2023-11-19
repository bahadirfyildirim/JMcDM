"""
        mcdm(df, w, fns, method)

    Perform selected method for a given decision matrix, weight vector, and function list.

# Arguments:
 - `df::Matrix`: n × m matrix of decision matrix in type of Matrix. 
 - `weights::Array{Float64, 1}`: m-vector of weights for criteria.
 - `fs::Array{Function, 1}`: m-vector of functions that are either maximize or minimize for each single criterion.
 - `method::MCDMMethod`: Preferred MCDMMethod.
 
# Description 
The method is one of the subtypes of MCDMMethod type. See examples.

# Output 
- `::MCDMResult`: An object derived from subtypes of MCDMResult type.

# Examples

```julia-repl

julia> subtypes(MCDMMethod)
23-element Vector{Any}:
 ArasMethod
 CocosoMethod
 CodasMethod
 CoprasMethod
 CriticMethod
 EdasMethod
 ElectreMethod
 GreyMethod
 LMAWMethod
 LOPCOWMethod
 MabacMethod
 MaircaMethod
 MarcosMethod
 MERECMethod
 MooraMethod
 MoosraMethod
 OCRAMethod
 PIVMethod
 PrometheeMethod
 PSIMethod
 ROVMethod
 SawMethod
 TopsisMethod
 VikorMethod
 WaspasMethod
 WPMMethod


julia> # mcdm() for Topsis:
julia> # mcdm(df, w, fns, TopsisMethod())

julia> # mcdm() for Saw:
julia> # mcdm(df, w, fns, SawMethod())

julia> # mcdm() with optional parameters:
julia> # mcdm(df, w, fns, GreyMethod(0.6))
```

"""
function mcdm(
    df::Matrix,
    w::Array{Float64,1},
    fns::Array{F,1},
    method::T1,
)::MCDMResult where {T1<:MCDMMethod,F<:Function}

    if method isa TopsisMethod
        topsis(df, w, fns)
    elseif method isa MoosraMethod
        moosra(df, w, fns)
    elseif method isa ElectreMethod
        electre(df, w, fns)
    elseif method isa ArasMethod
        aras(df, w, fns)
    elseif method isa CocosoMethod
        cocoso(df, w, fns, lambda=method.lambda)
    elseif method isa CodasMethod
        codas(df, w, fns, tau=method.tau)
    elseif method isa CoprasMethod
        copras(df, w, fns)
    elseif method isa ROVMethod
        rov(df, w, fns)
    elseif method isa EdasMethod
        edas(df, w, fns)
    elseif method isa GreyMethod
        grey(df, w, fns, zeta=method.zeta)
    elseif method isa MabacMethod
        mabac(df, w, fns)
    elseif method isa MaircaMethod
        mairca(df, w, fns)
    elseif method isa MooraMethod
        moora(df, w, fns)
    elseif method isa PrometheeMethod
        promethee(df, w, fns, method.pref, method.qs, method.ps)
    elseif method isa SawMethod
        saw(df, w, fns)
    elseif method isa VikorMethod
        vikor(df, w, fns, v=method.v)
    elseif method isa WaspasMethod
        waspas(df, w, fns, lambda=method.lambda)
    elseif method isa WPMMethod
        wpm(df, w, fns)
    elseif method isa MarcosMethod
        marcos(df, w, fns)
    elseif method isa PSIMethod
        # psi method does not use weights
        psi(df, fns)
    elseif method isa MERECMethod
        merec(df, fns)
    elseif method isa LOPCOWMethod
        lopcow(df, fns)
    elseif method isa OCRAMethod
        ocra(df, w, fns)
    elseif method isa LMAWMethod
        lmaw(df, w, fns)
    elseif method isa PIVMethod
        piv(df, w, fns)
    else
        error("Method is not defined")
    end
end



"""
    mcdm(setting, method = TopsisMethod())

    Perform selected method for a given decision matrix, weight vector, and function list.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object that holds the decision matrix, weight vector, and functions.
 - `method::MCDMMethod`: Preferred MCDMMethod. The default is TopsisMethod().
 
# Description 
The method is one of the subtypes of MCDMMethod type. See examples.

# Output 
- `::MCDMResult`: An object derived from subtypes of MCDMResult type.

# Examples

```julia-repl
julia> # mcdm() for Topsis:
julia> # mcdm(setting, TopsisMethod())

julia> # mcdm() for Saw:
julia> # mcdm(setting, SawMethod())

julia> # mcdm() with optional parameters:
julia> # mcdm(setting, GreyMethod(0.6))
```

"""
function mcdm(setting::MCDMSetting, method::T1=TopsisMethod())::MCDMResult where {T1<:MCDMMethod}

    mcdm(setting.df, setting.weights, setting.fns, method)
end
