mkdir -p SNP/{time,topology}/{t_U,t_B}/{s1,s2,s3}/l{5000,20000}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/{trees,fasta}
#
source venv/bin/activate

seed=1

for infer in time topology
do
	for topology in U B
	do 
		for sim_name in s1 s2 s3 
		do
			
			for loci in 5000 20000 
			do
				for samples in 1 8 
				do
					for theta in 0.01 0.0025
					do 
						for size in i d
						do
							for rep in {1..50}
							do
	

								dir=SNP/$infer/t_$topology/$sim_name/l${loci}_s$samples/theta$theta/Ne_$size/rep$rep
								echo $dir

								python3 coal_sim.py --sim_name $sim_name --topology $topology --infer $infer --loci $loci --samples $samples \
								--theta $theta --Ne_size $size --out_dir $dir/trees --seed $seed & 
	
								((seed=seed+1))
							done
							wait
						done
					done
					wait
				done
	
			done
		done
	done
done


seq_seed=1

for loci in 5000 20000 
do
	for dir in SNP/{time,topology}/{t_U,t_B}/{s1,s2,s3}/l${loci}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep
	do
		for rep in {1..50}
		do

			if [ "$loci" -eq 20000 ] ; then
				skip=$(echo $dir | grep /s1 | grep Ne_d)

				if [ -z "$skip" ]; then
				    ./seq_one_SNP.sh ${dir}${rep} $loci $seq_seed  &>> outSNPAll & 
				fi
			fi
			
			echo ${dir}${rep} 
			((seq_seed=seq_seed+loci))
		done
		wait
	done
done

