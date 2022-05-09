function subsample(pointcloud::Common.PointCloud, radius::Float64)
	if pointcloud.dimension == 3
		decimated = subsample3D()
	elseif pointcloud.dimension == 2
		decimated = subsample2D(pointcloud.coordinates, radius)
	end
	return PointCloud(pointcloud.coordinates[:,decimated], pointcloud.rgbs[:,decimated])
end

function subsample(pointcloud::Common.Points, radius::Float64)
	dim = size(pointcloud,1)
	if dim == 3
		decimated = subsample3D()
	elseif dim == 2
		decimated = subsample2D(pointcloud, radius)
	end
	return pointcloud[:,decimated]
end

function subsample2D(points, radius)
    aabb = Common.AABB(points)
    width = aabb.x_max - aabb.x_min
    heigth = aabb.y_max - aabb.y_min
    #cell side length
    a = radius / sqrt(2)
    nx = map(Int ∘ trunc, width / a) + 1
    ny = map(Int ∘ trunc, heigth / a) + 1
    coords_list = [(ix, iy) for ix = 1:nx for iy = 1:ny]
    cells = Dict{Tuple{Int64,Int64},Union{Nothing,Vector{Float64}}}(
        coords => nothing for coords in coords_list
    )

    samples = []
    for i = 1:size(points, 2)

        pt = points[:, i]
        if point_valid(pt, radius, a, cells, nx, ny, aabb)
            push!(samples, i)
            cells[get_cell_coords(pt, a, aabb)] = pt
        end
    end

    return samples
end


"""
Get the coordinates of the cell that pt = (x,y) falls in.
"""
function get_cell_coords(pt, a, aabb)
    return map(Int ∘ trunc, (pt[1] - aabb.x_min) / a) + 1, map(Int ∘ trunc, ( pt[2] - aabb.y_min) / a) + 1
end
"""
Return the indexes of points in cells neighbouring cell at coords.
        For the cell at coords = (x,y), return the indexes of points in the
        cells with neighbouring coordinates illustrated below: ie those cells
        that could contain points closer than r.

                                     ooo
                                    ooooo
                                    ooXoo
                                    ooooo
                                     ooo

"""
function get_neighbours(coords, cells, nx, ny)
    dxdy = [
        (-1, -2),
        (0, -2),
        (1, -2),
        (-2, -1),
        (-1, -1),
        (0, -1),
        (1, -1),
        (2, -1),
        (-2, 0),
        (-1, 0),
        (1, 0),
        (2, 0),
        (-2, 1),
        (-1, 1),
        (0, 1),
        (1, 1),
        (2, 1),
        (-1, 2),
        (0, 2),
        (1, 2),
        (0, 0),
    ]
    neighbours = []
    for (dx, dy) in dxdy
        neighbour_coords = coords[1] + dx, coords[2] + dy
        if !(1 <= neighbour_coords[1] <= nx && 1 <= neighbour_coords[2] <= ny)
            # We're off the grid: no neighbours here.
            continue
        end
        neighbour_cell = cells[neighbour_coords]
        if !isnothing(neighbour_cell)
            # This cell is occupied: store the index of the contained point
            push!(neighbours, neighbour_coords)
        end
    end
    return neighbours
end

"""
Is pt a valid point to emit as a sample?

    It must be no closer than r from any other point: check the cells in
    its immediate neighbourhood.

"""
function point_valid(pt, r, a, cells, nx, ny, aabb)
    cell_coords = get_cell_coords(pt, a, aabb)
    for idx in get_neighbours(cell_coords, cells, nx, ny)
        nearby_pt = cells[idx]
        # Squared distance between candidate point, pt, and this nearby_pt.
        distance2 = (nearby_pt[1] - pt[1])^2 + (nearby_pt[2] - pt[2])^2
        if distance2 < r^2
            # The points are too close, so pt is not a candidate.
            return false
        end
    end
    # All points tested: if we're here, pt is valid
    return true
end


function subsample3D()
	print("3D decimation")
end
