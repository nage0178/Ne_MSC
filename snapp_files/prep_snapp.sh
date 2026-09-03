#for i in {1..50} 
#do
#	echo $i
#	Rscript snapp_files/prep_snapp.R $i & 
#done
#wait

#for loci in 40 160
#do
#	for theta in 0.01 0.0025
#	do
#		for tree in t_U t_B
#		do
#			for scenario in s1 s2 s3
#			do
#				for Ne in i d
#				do
#					#for dir in time/$tree/${scenario}/l${loci}_s${s}/theta${theta}/Ne_$Ne/rep1
#					for dir in time/$tree/${scenario}/l${loci}_s${s}/theta${theta}/Ne_$Ne/rep{1..50}
#					do
#						if [[ "$scenario" == s1  && "$Ne" == d ]] 
#						then
#							continue
#						
#						fi 
#						snapp_files/prep_xml.sh $dir $scenario $Ne $theta $loci $s $tree  &
#
#					done
#					wait
#				done
#			done
#		done
#	done
#done
#exit

# Number of samples , SNAPP doesn't work with 8
s=1
for loci in 5000 20000 
do
	for theta in 0.01 0.0025
	do
		for tree in t_U t_B
		do
			for scenario in s1 s2 s3
			do
				for Ne in i d
				do
					#for dir in SNP/time/$tree/${scenario}/l${loci}_s${s}/theta${theta}/Ne_$Ne/rep1
					for dir in SNP/time/$tree/${scenario}/l${loci}_s${s}/theta${theta}/Ne_$Ne/rep{1..50}
					do
						if [[ "$scenario" == s1  && "$Ne" == d ]] 
						then
							continue
						
						fi 
						snapp_files/prep_xml.sh $dir $scenario $Ne $theta $loci $s $tree  &

					done
					wait
				done
			done
		done
	done
done
