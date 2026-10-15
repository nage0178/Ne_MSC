dir=$1
loci=$2
s=$3
analysis=$4
tree=$5
theta=$6

i=1
# Adds tab after sequence name 
sed -E 's/([0-9])$/\1\t/' $dir/fasta/l${i}.fa > $dir/tmp_${i}
# Removes new line
tr -d '\n' < $dir/tmp_${i} > $dir/tmp2_${i}
# Replaces > with newline and sorts
sed -E 's/>/\n/g' $dir/tmp2_${i} | sort  > $dir/tmp_${i}


for ((i=2; i<=loci;i++))
do
	sed -E 's/([0-9])$/\1\t/' $dir/fasta/l${i}.fa  > $dir/tmp_${i}
	tr -d '\n' < $dir/tmp_${i} > $dir/tmp2_${i}
	sed -E  's/>/\n>/g' $dir/tmp2_${i} | sort | sed -E 's/>n([0-9]*)\t//g' > $dir/tmp_$i 

done

if [[ "$loci" == 40 && "$s" == 1 ]]
then
	echo 5 20000 > $dir/data.phy
	paste -d "" $dir/tmp_{1..40} | tail -n+2  | grep -v n0 >> $dir/data.phy
	cp picl_files/settings_1_$analysis $dir/settings

elif [[ "$loci" == 40 && "$s" == 8 ]]
then
	echo 40 20000 > $dir/data.phy
	paste -d "" $dir/tmp_{1..40} | tail -n+2  | grep -v n0 >> $dir/data.phy
	cp picl_files/settings_8_$analysis $dir/settings

elif [[ "$loci" == 160 && "$s" == 1 ]]
then
	echo 5 80000 > $dir/data.phy
	paste -d "" $dir/tmp_{1..160} | tail -n+2  | grep -v n0 >> $dir/data.phy
	cp picl_files/settings_1_$analysis $dir/settings

elif [[ "$loci" == 160 && "$s" == 8 ]]
then
	echo 40 80000 > $dir/data.phy
	paste -d "" $dir/tmp_{1..160} | tail -n+2  | grep -v n0 >> $dir/data.phy
	cp picl_files/settings_8_$analysis $dir/settings
fi

if [[ "$analysis" == time ]]
then
	if [[ "$tree" == t_B ]]
	then
		cp picl_files/balanced_picl.tre $dir/treefile.tre
	else
		cp picl_files/unbalanced_picl.tre $dir/treefile.tre
	fi

fi

sed -i "s/Theta: 0.01/Theta: $theta/" $dir/settings
sed -i 's/model = 5/model = 1/g' $dir/settings
sed -i 's/200/1/g' $dir/settings

rm -f $dir/tmp*
