for partDir in $(cat lists/dirListPicl)
do
	for rep in {1..50} 
	do
		dir=$partDir/rep${rep}
		# Take the best tree and add an outgroup
		sed -n '5p' $dir/outtree.tre  | sed 's/^/(O,/' | sed 's/;/);/' > $dir/picl_best.tre & 

	done
	wait
done

for partDir in $(cat lists/dirListPiclTime)
do
	for rep in {1..50} 
	do
		dir=$partDir/rep${rep}
		sed -n '2p' $dir/outtree.tre > $dir/picl_best.tre & 

	done
	wait
done

