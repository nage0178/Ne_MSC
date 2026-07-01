seed=1
for loci in 40 160
do
	for dir in {time,topology}/{t_U,t_B}/{s1,s2,s3}/l${loci}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}
	do
		echo $dir
	
		for ((i=1;i<=loci; i++))
		do
			if [ ! -f $dir/raxml/l${i}.raxml.bestTree  ] 

			then
			
				mkdir -p $dir/raxml
				raxml-ng --model JC --msa $dir/fasta/l${i}.fa --seed $seed --tree rand{10},pars{10} --prefix $dir/raxml/l${i} --outgroup n0 --threads 1  &> $dir/raxml/l${i}_screen2 & 

			fi

			if (( loci % 50 == 0 )) ; 
			then 
				wait 
			fi
		done
		wait
	done
done

