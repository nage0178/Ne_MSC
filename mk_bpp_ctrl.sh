for loci in 40 160
do
	for s in 1 8 
	do
		for theta in 0.01 0.0025
		do

			for dir in {topology,time}/{t_U,t_B}/{s1,s2,s3}/l${loci}_s${s}/theta${theta}/Ne_{i,d}/rep{1..50}
			do

				echo $dir

				# Prepare sequence data
				./mk_seq_bpp.sh $dir $s $loci & 


			done
			wait
		done
	done
done

for loci in 40 160
do
	for s in 1 8 
	do
		for theta in 0.01 0.0025
		do
			for tree in t_U t_B
			do
				for scenario in s1 s2 s3
				do
					for Ne in i d
					do
						for analysis in time topology
						do

							for dir in ${analysis}/$tree/${scenario}/l${loci}_s${s}/theta${theta}/Ne_$Ne/rep{1..50}
							do
								./bpp_one_ctrl.sh $dir $scenario $Ne $theta $loci $s $tree $analysis & 

							done
							wait
						done
					done
				done
			done
		done
	done
done

wait
