for loci in 20000 80000 
do
	for s in 1 8 
	do
		for theta in 0.01 0.0025
		do

			for analysis in topology
			do
				for tree in t_U t_B
				do
					for dir in ${analysis}/${tree}/{s1,s2,s3}/l${loci}_s${s}/theta${theta}/Ne_{i,d}/rep{1..50}
					do


						echo SNP/$dir
						./picl_files/find_best_likelihood.sh SNP/$dir/picl_model1 & 

					done
					wait
				done
			done
		done
	done
done
wait

for loci in 20000 80000 
do
	for s in  8 
	do
		for theta in 0.01 0.0025
		do

			for analysis in topology
			do
				for tree in t_U t_B
				do
					for dir in ${analysis}/${tree}/{s1,s2,s3}/l${loci}_s${s}/theta${theta}/Ne_{i,d}/rep{1..50}
					do


						echo SNP/$dir
						./picl_files/find_best_likelihood.sh SNP/$dir/PICL_est_theta & 

					done
					wait
				done
			done
		done
	done
done
wait
