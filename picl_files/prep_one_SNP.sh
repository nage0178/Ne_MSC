orgDir=$1
loci=$2
s=$3
analysis=$4
tree=$5
theta=$6

if [[ "$analysis" == time ]]
then
	mkdir -p  $orgDir/picl_model1
	dir=$orgDir/picl_model1
else

	rm -rf $orgDir/picl_model1/{1..4}
	mkdir -p  $orgDir/picl_model1/1
	dir=$orgDir/picl_model1/1
fi

# Adds tab after sequence name
sed -E 's/([0-9])$/\1\t/' $orgDir/combined.fa > $dir/tmp.fa
# Removes new line
tr -d '\n' < $dir/tmp.fa > $dir/tmp2.fa

# Replaces > with newline and sorts
sed -E 's/>/\n/g' $dir/tmp2.fa | tail -n+3  >  $dir/data.phy

if [[ "$loci" == 5000 && "$s" == 1 ]]
then
	sed -i '1i 5 5000' $dir/data.phy 
	cp picl_files/m1_settings_1_$analysis $dir/settings

elif [[ "$loci" == 5000 && "$s" == 8 ]]
then
	sed -i '1i 40 5000' $dir/data.phy 
	cp picl_files/m1_settings_8_$analysis $dir/settings

elif [[ "$loci" == 20000 && "$s" == 1 ]]
then
	sed -i '1i 5 20000' $dir/data.phy 
	cp picl_files/m1_settings_1_$analysis $dir/settings

elif [[ "$loci" == 20000 && "$s" == 8 ]]
then
	sed -i '1i 40 20000' $dir/data.phy 
	cp picl_files/m1_settings_8_$analysis $dir/settings

elif [[ "$loci" == 80000 && "$s" == 1 ]]
then
	sed -i '1i 5 80000' $dir/data.phy 
	cp picl_files/m1_settings_1_$analysis $dir/settings

elif [[ "$loci" == 80000 && "$s" == 8 ]]
then
	sed -i '1i 40 80000' $dir/data.phy 
	cp picl_files/m1_settings_8_$analysis $dir/settings
fi

if [[ "$theta" == 0.0025 ]]
then
	sed -i "s/Theta: 0.01/Theta: 0.0025/" $dir/settings
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


rm $dir/tmp.fa
rm $dir/tmp2.fa

if [[ "$analysis" == topology ]]
then
	for i in {2..4}
	do
		cp -r $dir $orgDir/picl_model1/$i
		wait
		sed -i "s/Seed1: 1/Seed1: $i/g" $orgDir/picl_model1/$i/settings
		sed -i "s/Seed2: 2/Seed2: 2$i/g" $orgDir/picl_model1/$i/settings
	
	done
fi
