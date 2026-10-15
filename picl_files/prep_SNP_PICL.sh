for loci in 20000 80000 
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


						# Prepare sequence data
						if [ -f SNP/$dir/combined.fa ] ; then
							echo SNP/$dir
							picl_files/prep_one_SNP.sh SNP/$dir $loci $s $analysis $tree $theta  & 
						fi

					done
					wait
				done
			done
		done
	done
done
wait
