mkdir -p {time,topology}/{t_U,t_B}/{s1,s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/{trees,fasta}

#source venv/bin/activate

seed=1

for infer in time topology
do
	for topology in U B
	do 
		for sim_name in s1 s2 s3 
		do
			
			for loci in 40 160 
			do
				for samples in 1 8 
				do
					for theta in 0.01 0.0025
					do 
						for size in i d
						do
							for rep in {1..50}
							do
	
								dir=$infer/t_$topology/$sim_name/l${loci}_s$samples/theta$theta/Ne_$size/rep$rep
								python3 coal_sim.py --sim_name $sim_name --topology $topology --infer $infer --loci $loci --samples $samples \
								--theta $theta --Ne_size $size --out_dir $dir/trees --seed $seed & 
	
								((seed=seed+1))
							done
						done
					done
					wait
				done
	
			done
			echo $dir
		done
	done
done


seq_seed=1
for loci in 40 160
do
	for dir in {time,topology}/{t_U,t_B}/{s1,s2,s3,s4}/l${loci}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}
	do
	
		for ((i=1;i<=loci; i++))
		do
			if [ -f $dir/trees/l${i}.tre ] 
			then
				seq-gen -mHKY -s0.00000001 -z $seq_seed < $dir/trees/l${i}.tre > $dir/fasta/l${i}.fa  & 
			fi
			((seq_seed=seq_seed+1))
		done
		wait
	done
done

