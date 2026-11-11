

for loci in 40 160
do
	for s in 1 8 
	do
		for theta in 0.01 0.0025
		do

			for demo in s1 s2 s3  
			do
				for Ne in Ne_i Ne_d
				do
					for dir in topology/{t_U,t_B}/${demo}/l${loci}_s${s}/theta${theta}/$Ne/rep{1..50}/bpp/1
					do

						if [[ "$demo" == s1 && "$Ne" == Ne_d ]] ; then
							continue
						fi 
						echo $dir
						./bpp_files/cov_one.sh $dir  & 
					done
				done
				wait 
			done
		done
	done
done

ls topology/{t_U,t_B}/*/l*_s*/theta*/*/rep{1..50}/bpp/1/tree_prob.txt > lists/cov_bpp.txt
