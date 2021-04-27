module Features
    using Geometry
    import Geometry.Points, Geometry.Cells
    using Search
    using DataStructures
    using Statistics

    include("Features/density.jl")
    include("Features/normals.jl")
    include("Features/subsample.jl")

    export Statistics
end # module
