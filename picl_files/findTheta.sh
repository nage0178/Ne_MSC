sites=$1
dir=$2
analysis=$3

source picl_files/venv/bin/activate

python3 picl_files/makeVCF.py $dir/combined.fa $dir/seq.vcf
bcftools view -s n1n2,n3n4,n5n6,n7n8         -O v -o $dir/A.vcf $dir/seq.vcf
bcftools view -s n9n10,n11n12,n13n14,n15n16  -O v -o $dir/B.vcf $dir/seq.vcf
bcftools view -s n17n18,n19n20,n21n22,n23n24 -O v -o $dir/C.vcf $dir/seq.vcf
bcftools view -s n25n26,n27n28,n29n30,n31n32 -O v -o $dir/D.vcf $dir/seq.vcf
bcftools view -s n33n34,n35n36,n37n38,n39n40 -O v -o $dir/E.vcf $dir/seq.vcf

rm -f $dir/theta_species
for species in A B C D E
do
	~/vcftools/src/cpp/vcftools --window-pi $sites --vcf $dir/${species}.vcf --out $dir/out
	tail -n 1 $dir/out.windowed.pi |awk '{print $6}' >> $dir/theta_species
done

avg_theta=$(awk '{sum+=$1} END {if (NR>0) print sum/NR}' $dir/theta_species)


mkdir $dir/PICL_est_theta
if [[ "$analysis" == topology ]]
then
	mkdir -p $dir/PICL_est_theta/{1..4}
	for i in {1..4}
	do
		cp  $dir/picl_model1/data.phy $dir/PICL_est_theta/$i
	        sed "s/Theta: .*/Theta: $avg_theta/g" $dir/picl_model1/$i/settings > $dir/PICL_est_theta/$i/settings
	
	done
else
	cp $dir/picl_model1/data.phy $dir/PICL_est_theta/
	cp $dir/picl_model1/treefile.tre $dir/PICL_est_theta/
	sed "s/Theta: .*/Theta: $avg_theta/g" $dir/picl_model1/settings > $dir/PICL_est_theta/settings
fi

