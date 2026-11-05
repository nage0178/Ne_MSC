start=$1
end=$2
file1=$3
file2=$4

for((i=start;i<=end;i++)) 
do
	row=$(sed "${i}q;d" $file1)
	dir=$(echo $row | awk '{print $1}')
	seed=$(echo $row | awk '{print $2}')
	row2=$(sed "${i}q;d" $file2)
	seq_seed=$(echo $row2 | awk '{print $2}')

	infer=$(echo $dir | awk -F / '{print $2}')
	topology=$(echo $dir | awk -F / '{print $3}' | awk -F _ '{print $2}')
	sim_name=$(echo $dir | awk -F / '{print $4}')
	loci=$(echo $dir | awk -F / '{print $5}' | awk -F _ '{print $1}' | awk -F l '{print $2}')
	samples=$(echo $dir | awk -F / '{print $5}'| awk -F s '{print $2}')
	theta=$(echo $dir | awk -F / '{print $6}' | awk -F a '{print $2}')
	size=$(echo $dir | awk -F / '{print $7}' | awk -F _ '{print $2}')
	rep=$(echo $dir | awk -F / '{print $8}')

	skip=$(echo $dir | grep /s1 | grep Ne_d)
	
	if [ -z "$skip" ]; then

		if [ ! -f  $dir/combined.fa ] ; then
			echo python3 coal_sim.py --sim_name $sim_name --topology $topology --infer $infer --loci $loci --samples $samples \
			--theta $theta --Ne_size $size --out_dir $dir/trees --seed $seed 
			python3 coal_sim.py --sim_name $sim_name --topology $topology --infer $infer --loci $loci --samples $samples \
			--theta $theta --Ne_size $size --out_dir $dir/trees --seed $seed 
	
			echo simulating seqs
			./seq_one_SNP.sh ${dir} $loci $seq_seed  &> out_SNPsim/outSNPAll_$seq_seed
		fi
	fi
done

