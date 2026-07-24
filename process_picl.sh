for loci in 40 160
do
	for i in 1 8
	do
		 for partDir in topology/{t_U,t_B}/{s1,s2,s3}/l${loci}_s$i/theta{0.01,0.0025}/Ne_{i,d}
		 do
			for rep in {1..50} 
			do
				dir=$partDir/rep${rep}
				# Take the best tree and add an outgroup
				sed -n '5p' $dir/outtree.tre  | sed 's/^/(O,/' | sed 's/;/);/' > $dir/picl_best.tre & 

			done
			wait
		done
	done
done

