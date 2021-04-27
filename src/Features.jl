module Features
    using Common
    import Common.Points, Common.Cells
    using Search
    using DataStructures
    using Statistics

    include("Features/density.jl")
    include("Features/normals.jl")
    include("Features/subsample.jl")

    export Statistics, Common
end # module
