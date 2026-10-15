for partDir in $(cat lists/dirListPiclSNP_m1)
do
	for rep in {1..50} 
	do
		dir=$partDir/rep${rep}/picl_model1
		# Take the best tree and add an outgroup
		tail -n 2 $dir/outtree.tre | head -1  | sed 's/^/(O,/' | sed 's/;/);/' > $dir/picl_best.tre & 
		#sed -n '5p' $dir/outtree.tre  | sed 's/^/(O,/' | sed 's/;/);/' > $dir/picl_best.tre & 

	done
	wait
done

for partDir in $(cat lists/dirListPiclTimeSNP)
do
	for rep in {1..50} 
	do
		dir=$partDir/rep${rep}/picl_model1
		sed -n '2p' $dir/outtree.tre > $dir/picl_best.tre & 

	done
	wait
done

