using Common
using Features
using FileManager
using Visualization

function larModelProduct(modelOne, modelTwo)
    (V, cells1) = modelOne
    (W, cells2) = modelTwo

    vertices = DataStructures.OrderedDict()
    k = 1
    for j = 1:size(V, 2)
        v = V[:, j]
        for i = 1:size(W, 2)
            w = W[:, i]
            id = [v; w]
            if haskey(vertices, id) == false
                vertices[id] = k
                k = k + 1
            end
        end
    end

    cells = []
    for c1 in cells1
        for c2 in cells2
            cell = []
            for vc in c1
                for wc in c2
                    push!(cell, vertices[[V[:, vc]; W[:, wc]]])
                end
            end
            push!(cells, cell)
        end
    end


    vertexmodel = []
    for v in keys(vertices)
        push!(vertexmodel, v)
    end
    verts = hcat(vertexmodel...)
    cells = [[v for v in cell] for cell in cells]
    return (verts, cells)
end


function draw_grid(nx, ny, a, aabb)
    geom_0 = hcat([[x] for x = aabb.x_min:a:aabb.x_max]...)
    topol_0 = [[i, i + 1] for i = 1:nx-1]
    geom_1 = hcat([[x] for x = aabb.y_min:a:aabb.y_max]...)
    topol_1 = [[i, i + 1] for i = 1:ny-1]
    model_0 = (geom_0, topol_0)
    model_1 = (geom_1, topol_1)
    V, FV = larModelProduct(model_0, model_1)
    return V,
    convert(
        Array{Array{Int64,1},1},
        collect(Set(Common.CAT(map(Common.FV2EV, FV)))),
    )
end

source = raw"D:\pointclouds\SEZIONI\sezione_stanza.las"
pc = FileManager.source2pc(source)
radius = 0.005
points = pc.coordinates[1:2, :]
samples = Features.subsample(points, radius)
# #
# aabb = Common.AABB(points)
# width = aabb.x_max - aabb.x_min
# heigth = aabb.y_max - aabb.y_min
# #cell side length
# a = radius / sqrt(2)
# nx = map(Int ∘ trunc, width / a) + 1
# ny = map(Int ∘ trunc, heigth / a) + 1
# V,EV = draw_grid(nx,ny,a,aabb)

Visualization.VIEW([
    # Visualization.GLGrid(V,EV),
    # Visualization.points(points),
    Visualization.points(samples[:,:]; color = Visualization.COLORS[2])
])
