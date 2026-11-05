dir=$1
loci=$2
seq_seed=$3
if [ ! -s "$dir/combined.fa" ] ; then
	for ((i=1;i<=loci; i++))
	do
		if [ -f $dir/trees/l${i}.tre ] 
		then
			seq-gen -mHKY -l 1 -s0.00000001 -z $seq_seed < $dir/trees/l${i}.tre > $dir/fasta/l${i}.fa  
		fi
		((seq_seed=seq_seed+1))
	
		# Sorts the sequence file by name
		paste - - < $dir/fasta/l${i}.fa | sort -V -k1,1 | tr "\t" "\n" > $dir/fasta/l${i}_sort.fa & 
		if (( i % 50 == 0 ))
		then
			wait
		fi


	
	done
fi 
wait

if [ ! -s $dir/combined.fa   ] ; then
	> $dir/combined.fa
	
	# Process in blocks of 500 files
	for i in $(seq 1 500 $loci); do
	    end=$((i + 499))
	    eval paste  $dir/fasta/l{$i..$end}_sort.fa   > "$dir/fasta/part_${i}.txt"
	done
	
	# Combine the parts
	eval paste  $dir/fasta/part_*.txt | sed 's/\t//g' | sed -E 's/(.)>.*/\1/g'  > $dir/combined.fa
fi

rm -rf $dir/fasta/
rm -rf $dir/trees/
