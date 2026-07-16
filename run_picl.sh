
for loci in 40 160
do
	for i in 1 8
	do
		for demo in s1 s2 s3
		do
			for Ne in Ne_d Ne_i
			do

		 		for partDir in topology/{t_U,t_B}/${demo}/l${loci}_s$i/theta{0.01,0.0025}/$Ne
		 		do
					for rep in {1..50} 
					do
						dir=$partDir/rep${rep}

						echo $dir
						# Skip extra datasets
						if [[ "$demo" == s1 && "$Ne" == Ne_d ]] ; then
							continue
						fi 
					
						# Run picl for all dataset
						cd /storage/anna/Ne_MSC/$dir
						if [ ! -f "outtree.tre" ] ; then
							picl &> outPicl & 
						fi

					done
					wait
				done
			done
		done
	done
done

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

