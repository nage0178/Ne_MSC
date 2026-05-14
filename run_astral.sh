
seed=1
for loci in 40 160
do
	for dir in {time,topology}/{t_U,t_B}/{s1,s2,s3}/l${loci}_s{1,8}/theta{0.01,0.0025}/rep{1..5}
	do
		if [ -f $dir/raxml/l1.raxml.bestTree ] ; then
	
			for ((i=1;i<=$loci;i++)) ; do cat "$dir/raxml/l$i.raxml.bestTree"; done > $dir/raxml/all_raxml.tre
		fi

	done
done

for loci in 40 160
do
	for i in 1 8
	do
		for dir in {time,topology}/{t_U,t_B}/{s1,s2,s3}/l${loci}_s$i/theta{0.01,0.0025}/rep{1..5}
		do
		
			echo $dir
			if [ -f $dir/raxml/all_raxml.tre  ] 
			then
				astral4 -R -o $dir/astral.tre -i $dir/raxml/all_raxml.tre --seed $seed --root O -a astral_map_${i}.txt
			fi


		done
	done
done

