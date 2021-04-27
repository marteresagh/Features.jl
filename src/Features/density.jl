"""
	relative_density_points(PC::PointCloud, current_inds::Array{Int64,1}, k::Int64)

Compute density and relative density of points in PointCloud.
"""
function relative_density_points(V::Points, current_inds::Array{Int64,1}, k::Int64)::Tuple{Array{Float64,1},Array{Float64,1}}
	points = V[:,current_inds]
	npoints = length(current_inds)

	kdtree = NearestNeighbors.KDTree(points)

	idxs = Array{Array{Int64,1},1}(undef,npoints)
	dists = Array{Array{Float64,1},1}(undef,npoints)
	for i in 1:npoints
		idx, dist = NearestNeighbors.knn(kdtree, points[:,i], k, true, t -> t == i)
		idxs[i] = idx
		dists[i] = dist
	end

	density = [k/sum(dists[i]) for i in 1:npoints]

	AVGRelDensity = [density[i]/(sum(density[idxs[i]])/k) for i in 1:npoints]

	return density,AVGRelDensity
end

function relative_density_points(PC::PointCloud, current_inds::Array{Int64,1}, k::Int64)
	V = PC.coordinates
	return relative_density_points(V, current_inds, k)
end

"""
	outliers(PC::PointCloud, current_inds::Array{Int64,1}, k::Int64)

Return outliers defined by low relative density.
"""
function outliers(PC::PointCloud, current_inds::Array{Int64,1}, k::Int64)::Array{Int64,1}
	density,AVGRelDensity = relative_density_points(PC, current_inds, k)
	mu = Statistics.mean(AVGRelDensity)
	rho = Statistics.std(AVGRelDensity)
	outliers = [AVGRelDensity[i]<mu-rho for i in 1:length(current_inds) ]
	return current_inds[outliers]
end

"""
	estimate_threshold(PC::PointCloud, k::Int64)
"""
function estimate_threshold(PC::PointCloud, k::Int64)
	points = PC.coordinates
	return estimate_threshold(points, k)
end


function estimate_threshold(points::Points, k::Int64)
	density, _ = relative_density_points(points, collect(1:size(points,2)), k)
	dist = map(x->1/x,density)
	mu = Statistics.mean(dist)
	rho = Statistics.std(dist)
	threshold = mu + rho
	return threshold
end

"""
	point_cloud_distance(source, target)

Computes for each point in the source point cloud the distance to the closest point in the target point cloud.
"""
function cloud2cloud_distances(source::PointCloud, target::PointCloud)
	S = source.coordinates
	T = target.coordinates
	return cloud2cloud_distances(S,T)
end

function cloud2cloud_distances(source::Points, target::Points)
	kdtree = KDTree(target)
	idxs, dists = NearestNeighbors.nn(kdtree, source)
	return idxs,dists
end
