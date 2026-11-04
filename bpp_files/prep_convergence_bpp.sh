
for loci in 40 160
do
	for i in 1 8 
	do
		for tree in t_U t_B
		do
			for demo in s1 s2 s3
			do 
				for theta in 0.01 0.0025
				do
					for Ne in Ne_i Ne_d
					do
						for rep in {1..50} 
						do
							dir1=topology/$tree/$demo/l${loci}_s${i}/theta$theta/$Ne/rep${rep}/bpp
							for dir in $dir1/{1,2}
							do
				
								if [[ "$demo" == s1 && "$Ne" == Ne_d ]] ; then
									continue
								fi 
							
								echo $dir
								sed 's/\#[^:]*:/:/g' $dir/out.mcmc.txt | sed 's/\#[^:]*;/;/g' > $dir/mcmc_no_theta.txt & 
							done
							wait
						done
					 done
				
				done

			done
			wait
		done
	done
done

for loci in 40 160
do
	for i in 1 8 
	do
		for tree in t_U t_B
		do
			for demo in s1 s2 s3
			do 
				for theta in 0.01 0.0025
				do

					for Ne in Ne_i Ne_d
					do
						for rep in {1..50} 
						do
							dir=topology/$tree/$demo/l${loci}_s${i}/theta$theta/$Ne/rep${rep}/bpp/
							out=${tree}_${demo}_l${loci}_s${i}_${theta}_${Ne}_${rep}
							if [[ "$demo" == s1 && "$Ne" == Ne_d ]] ; then
								continue
							fi 

							echo $dir
							Rscript bpp_files/topology_convergence.R $dir $dir  & 


						done
						wait
					done
				done
			done
		done
		wait
	done
done
