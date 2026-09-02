for loci in 40 160
do
	for i in 1 8 
	do
		for rep in {1..50} 
		do
			for dir in topology/{t_U,t_B}/{s1,s2,s3}/l${loci}_s$i/theta{0.01,0.0025}/Ne_{i,d}/rep${rep}/bpp/{1,2}
			do

				noRun=$(echo $dir | grep /s1/ | grep Ne_d)
				if [[ ! -z "$noRun" ]]; then
					continue
				fi

				echo $dir
				cd $dir
				tail -n1 out.txt | sed 's/^/(O,/g' | sed 's/;/);/g' > MAP.txt 
				awk -F = '{print $2}' MAP.txt | sed 's/\]//g'  | sed 's/ //g' > PP_MAP.txt
				cd ../../../../../../../../../

			done
			wait
		done
	done
done

