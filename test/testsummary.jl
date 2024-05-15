@testset "Summary" verbose = true begin
    tol = 0.0001
    
    dmat = hcat(
        [25.0, 21, 19, 22],
        [65.0, 78, 53, 25],
        [7.0, 6, 5, 2],
        [20.0, 24, 33, 31]
    )
    
    weights = [0.25, 0.25, 0.25, 0.25]
    fns = [maximum, maximum, minimum, maximum]


    result1 =
        JMcDM.summary(dmat, weights, fns, [:topsis, :electre, :cocoso, :copras, :moora])
    result2 = JMcDM.summary(dmat, weights, fns, [:grey, :aras, :saw, :wpm, :waspas, :edas])
    result3 = JMcDM.summary(dmat, weights, fns, [:mabac, :mairca, :rov, :marcos, :vikor])

    @test result1 isa Dict
    @test result2 isa Dict
    @test result3 isa Dict

    @test result1 == Dict{Any,Any}(
        (Colon(), :electre) => [" ", " ✅ ", " ", " ✅ "],
        (Colon(), :topsis) => [" ", " ✅ ", " ", " "],
        (Colon(), :copras) => [" ", " ", " ", " ✅ "],
        (Colon(), :cocoso) => [" ", " ✅ ", " ", " "],
        (Colon(), :moora) => [" ", " ✅ ", " ", " "],
    )
    @test result2 == Dict{Any,Any}(
        (Colon(), :aras) => [" ", " ", " ", " ✅ "],
        (Colon(), :saw) => [" ", " ", " ", " ✅ "],
        (Colon(), :wpm) => [" ", " ", " ", " ✅ "],
        (Colon(), :waspas) => [" ", " ", " ", " ✅ "],
        (Colon(), :edas) => [" ", " ", " ", " ✅ "],
        (Colon(), :grey) => [" ", " ", " ", " ✅ "],
    )
    @test result3 == Dict{Any,Any}(
        (Colon(), :mairca) => [" ", " ", " ", " ✅ "],
        (Colon(), :vikor) => [" ", " ✅ ", " ", " "],
        (Colon(), :rov) => [" ", " ", " ", " ✅ "],
        (Colon(), :mabac) => [" ", " ", " ", " ✅ "],
        (Colon(), :marcos) => [" ", " ", " ", " ✅ "],
    )
end
