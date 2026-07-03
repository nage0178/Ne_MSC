
for loci in 40 160
do
	for i in 1 8
	do
		 for partDir in {topology,time}/{t_U,t_B}/{s1,s2,s3}/l${loci}_s$i/theta{0.01,0.0025}/Ne_{i,d}
		 do
			for rep in {1..50} 
			do
				dir=$partDir/rep${rep}

			
				echo $dir
				cd /storage/anna/Ne_MSC/$dir
				picl &> outPicl & 

			done
			wait
		done
	done
done

