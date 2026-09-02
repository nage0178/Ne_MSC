dir=$1
loci=$2
s=$3
analysis=$4
tree=$5

# Adds tab after sequence name
sed -E 's/([0-9])$/\1\t/' $dir/combined.fa > $dir/tmp.fa
# Removes new line
tr -d '\n' < $dir/tmp.fa > $dir/tmp2.fa

# Replaces > with newline and sorts
sed -E 's/>/\n/g' $dir/tmp2.fa | tail -n+3  >  $dir/data.phy

if [[ "$loci" == 5000 && "$s" == 1 ]]
then
	sed -i '1i 5 5000' $dir/data.phy 
	cp picl_files/settings_1_$analysis $dir/settings

elif [[ "$loci" == 5000 && "$s" == 8 ]]
then
	sed -i '1i 40 5000' $dir/data.phy 
	cp picl_files/settings_8_$analysis $dir/settings

elif [[ "$loci" == 20000 && "$s" == 1 ]]
then
	sed -i '1i 5 20000' $dir/data.phy 
	cp picl_files/settings_1_$analysis $dir/settings

elif [[ "$loci" == 20000 && "$s" == 8 ]]
then
	sed -i '1i 40 20000' $dir/data.phy 
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
