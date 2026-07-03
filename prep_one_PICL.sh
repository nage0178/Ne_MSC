
dir=$1
loci=$2
s=$3
analysis=$4
tree=$5

i=1
sed -E 's/([0-9])$/\1\t/' $dir/fasta/l${i}.fa > $dir/tmp_${i}
tr -d '\n' < $dir/tmp_${i} > $dir/tmp2_${i}
sed -E 's/>/\n/g' $dir/tmp2_${i} | sort  > $dir/tmp_${i}


for ((i=2; i<=loci;i++))
do
	sed -E 's/([0-9])$/\1\t/' $dir/fasta/l${i}.fa  > $dir/tmp_${i}
	tr -d '\n' < $dir/tmp_${i} > $dir/tmp2_${i}
	sed -E  's/>/\n>/g' $dir/tmp2_${i} | sort | sed -E 's/>n([0-9])\t//g' > $dir/tmp_$i 

done

if [[ "$loci" == 40 && "$s" == 1 ]]
then
	echo 5 20000 > $dir/data.phy
	paste -d "" $dir/tmp_{1..40} | tail -n+2  | grep -v n0 >> $dir/data.phy
	cp settings_1_$analysis $dir/settings

elif [[ "$loci" == 40 && "$s" == 8 ]]
then
	echo 40 20000 > $dir/data.phy
	paste -d "" $dir/tmp_{1..40} | tail -n+2  | grep -v n0 >> $dir/data.phy
	cp settings_8_$analysis $dir/settings

elif [[ "$loci" == 160 && "$s" == 1 ]]
then
	echo 5 80000 > $dir/data.phy
	paste -d "" $dir/tmp_{1..40} | tail -n+2  | grep -v n0 >> $dir/data.phy
	cp settings_1_$analysis $dir/settings

elif [[ "$loci" == 160 && "$s" == 1 ]]
then
	echo 40 80000 > $dir/data.phy
	paste -d "" $dir/tmp_{1..40} | tail -n+2  | grep -v n0 >> $dir/data.phy
	cp settings_8_$analysis $dir/settings
fi

if [[ "$analysis" == time ]]
then
	if [[ "$tree" == t_B ]]
	then
		cp balanced_picl.tre $dir/treefile.tre
	else
		cp unbalanced_picl.tre $dir/treefile.tre
	fi

fi
rm $dir/tmp*
