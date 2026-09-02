
for loci in 40 160
do
	for dir in time/{t_U,t_B}/{s1,s2,s3}/l${loci}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}
	do
		echo $dir
	
		for ((i=1;i<=$loci;i++)) ; do cat "$dir/raxml/l$i.raxml.bestTree" ; done > $dir/raxml/all_raxml.tre & 

	done
	wait
done

echo time/{t_U,t_B}/{s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d} > lists/astral_time
echo time/{t_U,t_B}/s1/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_i >> lists/astral_time

for rep in {1..50}
do
	astral_files/run_astral_one_thread.sh $rep lists/astral_time & 

done
wait
