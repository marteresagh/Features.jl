@testset "Subsample" begin

	@testset "poisson_disk" begin
		points = [0. 1 2 3 4 5 6 7 8 9;
				  0. 0 0 0 0 0 0 0 0 0 ]
		decimate = Features.subsample_poisson_disk(points, 0.01 ; step=0.2)
		@test decimate == points
		decimate = Features.subsample_poisson_disk(points, 1.5 ; step=2.0)
		@test decimate == points[:,[1,3,5,7,9]]
	end

end
