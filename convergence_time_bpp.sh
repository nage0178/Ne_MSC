for demo in s1 s2 s3
do 
	for Ne in Ne_i Ne_d
	do
		for dir in time/{t_U,t_B}/$demo/l{40,160}_s{1,8}/theta{0.01,0.0025}/${Ne}/{1..50}/bpp/{1,2}
		do
			echo $dir
			# Skip exta datasets, bpp wasn't run on them
			if [[ "$demo" == s1 && "$Ne" == Ne_d ]] ; then
				continue
			fi 

			# Get the ess values, record to their own file
			# Print error messages to separate file
			./extract_ess.sh $dir/outBpp > $dir/ess.txt  2> bppTimeLowESS  
		done

	done
done

ls time/{t_U,t_B}/{s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/bpp/{1,2}/out.mcmc.txt > bpp_time_tree.txt
ls time/{t_U,t_B}/s1/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_i/rep{1..50}/bpp/{1,2}/out.mcmc..txt >> bpp_time_tree.txt

# Checks the Gelman diagnostic 
Rscript checkConvergence_bpp_time.R
