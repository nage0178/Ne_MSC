for demo in s1 s2 s3
do 
	for Ne in Ne_i Ne_d
	do
		for dir in time/{t_U,t_B}/$demo/l{40,160}_s{1,8}/theta{0.01,0.0025}/${Ne}/rep{1..50}/bpp/{1,2}
		do
			echo $dir
			# Skip exta datasets, bpp wasn't run on them
			if [[ "$demo" == s1 && "$Ne" == Ne_d ]] ; then
				continue
			fi 

			# Get the ess values, record to their own file
			# Print error messages to separate file
			./extract_summary_bpp_time.sh $dir/outBpp > $dir/time_sum.txt 
		done

	done
done

