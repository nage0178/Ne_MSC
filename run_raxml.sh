seed=1
for loci in 40 160
do
	for dir in {time,topology}/{t_U,t_B}/{s1,s2,s3}/l${loci}_s{1,8}/theta{0.01,0.0025}/rep{1..20}
	do
	
		for ((i=1;i<=loci; i++))
		do
			if [ -f $dir/fasta/l${i}.fa ] 
			then
			
				mkdir -p $dir/raxml
				raxml-ng --model JC  --msa $dir/fasta/l${i}.fa --seed $seed --tree rand{10},pars{10} --redo --prefix $dir/raxml/l${i} --outgroup n0

			fi
			#((seed=seed+1))
		done
	done
done

