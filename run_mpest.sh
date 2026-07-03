seed=1
for loci in 40 160
do
	for dir in topology/{t_U,t_B}/{s1,s2,s3}/l${loci}_s1/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}
	do

		# Need to generate nexus files
		cp nexus_template.txt $dir/mp_trees.nex
		cat $dir/raxml/all_raxml.tre >> $dir/mp_trees.nex
		echo End\; >> $dir/mp_trees.nex
 	
	#	echo $dir

	done
	wait
done

for loci in 40 160
do
	for rep in {1..50} 
	do
	        for dir in topology/{t_U,t_B}/{s1,s2,s3}/l${loci}_s1/theta{0.01,0.0025}/Ne_{i,d}/rep$rep
		do

			#if [ -f $dir/raxml/all_raxml.tre  ] 
			#then
			echo $dir
			# -n # number of runs- idk how many is recommended
			mpest -i $dir/mp_trees.nex -n 10 -s 1 &> $dir/outMpest & 
			#fi

		done
		wait
	done
done

for dir in topology/{t_U,t_B}/{s1,s2,s3}/l{40,160}_s1/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}
do

	grep "tree mpest"  $dir/mp_trees.nex_besttree.tre | sort -n -t "[" -k 3 | tail -n 1 | awk '{print $5}' > $dir/mpest_best.tre
	sed -i -e 's/1:/O:/' -e 's/2:/A:/' -e 's/3:/B:/' -e 's/4:/C:/' -e 's/5:/D:/' -e 's/6:/E:/' $dir/mpest_best.tre


done
