s=1
for loci in 5000 20000
#for loci in 40 160
do
	for theta in 0.01 0.0025
	do
		for tree in t_U t_B
		do
			for scenario in s1 #s2 s3
			do
				for Ne in i d
				do
					for dir in SNP/time/$tree/${scenario}/l${loci}_s${s}/theta${theta}/Ne_$Ne/rep1
					#for dir in time/$tree/${scenario}/l${loci}_s${s}/theta${theta}/Ne_$Ne/rep{1..50}
					do
						if [[ "$scenario" == s1  && "$Ne" == d ]] 
						then
							continue
						
						fi 

						cd /storage/anna/Ne_MSC/$dir
						echo $dir

						mkdir -p prior
						cp snap.xml prior 
						cd prior
						#beast -seed 1 -sampleFromPrior -overwrite snap.xml  &> outSnap & 
						#beast -seed 1 -overwrite snap.xml  &> outSnap & 
						treeannotator snap.trees > ann_snp.tree & 

					done
					#wait
				done
			done
		done
	done
done
wait
