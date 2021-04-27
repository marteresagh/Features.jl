@testset "Density" begin

	@testset "relative_density_points" begin
		k = 3
		V = [1. 2. 1. 2. 4. 5. 4. 5.;
			1. 1. 2. 2. 4. 4. 5. 5.]
		current_inds = collect(1:size(V,2))
		PC = Common.PointCloud(V)
		density,AVGRelDensity = Features.relative_density_points(PC, current_inds, k)
		@test density ≈ [0.8786796564403575, 0.8786796564403575, 0.8786796564403575, 0.8786796564403575, 0.8786796564403575, 0.8786796564403575, 0.8786796564403575, 0.8786796564403575]
		@test AVGRelDensity ≈ [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]

		k = 4
		V = [0.504265  0.960838  0.510291  0.12767   0.513024  0.163572  0.321616  0.218421  0.769508   0.0393077;
 			0.327851  0.582116  0.965744  0.63266   0.547962  0.779063  0.433883  0.726959  0.0755752  0.763799;
 			0.42326   0.961364  0.848957  0.582004  0.738998  0.169038  0.450948  0.788794  0.335797   0.728604]
		current_inds = collect(1:size(V,2))
		PC = Common.PointCloud(V)
		density,AVGRelDensity = Features.relative_density_points(PC, current_inds, k)
		@test density ≈ [2.6950800964583066, 1.5212383231419966, 2.090378801720729, 3.355470101863262, 2.6279484739899175, 1.899518987114734, 2.9778126266156755, 3.4263978955163528, 1.6255647077937918, 2.7696669847556015]
		@test AVGRelDensity ≈ [1.0182797965702712, 0.5613526389360449, 0.6865246163356675, 1.1372715060534249, 0.843998060813555, 0.6440122690838282, 0.9840026669967751, 1.2639495205682614, 0.6620042953021076, 0.8943331973690027]
	end

	@testset "outliers" begin
		k = 3
		V = [1. 2. 1. 2. 4. 5. 4. 5. 1. 5.;
			1. 1. 2. 2. 4. 4. 5. 5. 5. 1.]
		current_inds = collect(1:size(V,2))
		PC = Common.PointCloud(V)

		outliers = Features.outliers(PC, current_inds, k)
		@test outliers == [9,10]

		k = 5
		V = [0.504265  0.960838  0.510291  0.12767   0.513024  0.163572  0.321616  0.218421  0.769508  2.;
 			0.327851  0.582116  0.965744  0.63266   0.547962  0.779063  0.433883  0.726959  0.0755752 2.;
 			0.42326   0.961364  0.848957  0.582004  0.738998  0.169038  0.450948  0.788794  0.335797   2.]
		current_inds = collect(1:size(V,2))
		PC = Common.PointCloud(V)

		outliers = Features.outliers(PC, current_inds, k)
		@test outliers == [10]
	end

	@testset "estimate_threshold" begin
		k = 3
		V = [1. 2. 1. 2. 4. 5. 4. 5.;
			1. 1. 2. 2. 4. 4. 5. 5.]
		PC = Common.PointCloud(V)
		thr = Features.estimate_threshold(PC, k)
		@test thr == 1.1380711874576983

		k = 5
		V = [0.504265  0.960838  0.510291  0.12767   0.513024  0.163572  0.321616  0.218421  0.769508  2.;
 			0.327851  0.582116  0.965744  0.63266   0.547962  0.779063  0.433883  0.726959  0.0755752 2.;
 			0.42326   0.961364  0.848957  0.582004  0.738998  0.169038  0.450948  0.788794  0.335797   2.]
		PC = Common.PointCloud(V)
		thr = Features.estimate_threshold(PC, k)
		@test thr ≈ 1.2855448677166095
	end

end
