dir=$1
s=$2
loci=$3

mkdir -p $dir/bpp/{1,2}
# Prepare sequence data

rm -f $dir/bpp/seq.txt
for ((i=1; i<=loci; i++))
do 
	((samples=s*5))
	echo $samples 500  >> $dir/bpp/seq.txt
	sed -E 's/([0-9])$/\1\t/' $dir/fasta/l${i}.fa  > $dir/tmp
	tr -d '\n' < $dir/tmp > $dir/tmp2
	sed 's/>/\n\^/g' $dir/tmp2  >> $dir/bpp/seq.txt 

	echo >> $dir/bpp/seq.txt
	echo >> $dir/bpp/seq.txt

done

rm $dir/tmp*
grep -v n0  $dir/bpp/seq.txt > $dir/bpp/seq_noOutgroup.txt
