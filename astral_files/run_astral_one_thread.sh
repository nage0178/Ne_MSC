rep=$1
dirList=$2

seed=1
for partDir in $(cat ${dirList})
do
		dir=/storage/anna/Ne_MSC/$partDir/rep${rep}
		echo $dir

		balanced=$(echo $dir | grep t_B)
		if [[ -z "$balanced" ]] ; then 
			tree=astral_files/unbalanced.tre

		else
			tree=astral_files/balanced.tre
		fi 

		samples=$(echo $dir | grep _s8)
		if [ -z "$samples" ] ; then 
			map=1

		else
			map=8
		fi 

		if [ ! -s "$dir/astral.tre" ] ; then
			astral4 -R -o $dir/astral.tre -i $dir/raxml/all_raxml.tre --seed $seed --root O -a astral_files/astral_map_${map}.txt -c $tree &> $dir/outAstral 
		fi

done
wait

