for loci in 40 160
do
	for s in 1 8 
	do
		for theta in 0.01 0.0025
		do

			for analysis in topology time
			do
				for tree in t_U t_B
				do
					for dir in ${analysis}/${tree}/{s1,s2,s3}/l${loci}_s${s}/theta${theta}/Ne_{i,d}/rep{1..50}
					do

						echo $dir

						# Prepare sequence data
						picl_files/prep_one_PICL.sh $dir $loci $s $analysis $tree $theta & 

					done
					wait
				done
			done
		done
	done
done
