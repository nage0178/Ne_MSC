dir=$1
scenario=$2
Ne=$3
theta=$4
loci=$5
s=$6
tree=$7
analysis=$8

xml=$dir/snap.xml

# Need to change:	sequence data
# 			tree topology
# 			root age prior
# 			theta prior	
# 			Species mappings?


# Choose the files with the right priors 
# for theta and tau
if [[ $theta == "0.01" ]] 
then
	cp snapp_files/example_0.01.xml $xml
else
	cp snapp_files/example_0.0025.xml $xml
fi

# Change the tree topology for balanced tree
if [[ "$tree" == t_B ]] ; 
then
	sed -i 's/newick="((((A,B),C),D),E)"/newick="(((A,B),C),(D,E))"/' $xml
fi 

# Add the sequence data 
((max=5*$s))
for ((i=1;i<=max;i++))
do
	snps=$(grep -w n$i $dir/snps.nex | awk '{print $2}')
	sed1=$(echo taxon=\"n$i\" totalcount=\"4\" value=\"\")
	sed2=$(echo taxon=\"n$i\" totalcount=\"4\" value=\"$snps\")
	sed -i "s/$sed1/$sed2/g" $xml 
done


#~/beast/bin/beauti $xml
#~/beast/bin/treeannotator snap.trees > ann_snp.tree
