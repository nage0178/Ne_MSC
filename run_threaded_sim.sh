source venv/bin/activate
mkdir -p SNP/{time,topology}/{t_U,t_B}/{s1,s2,s3}/l{5000,20000,80000}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/{trees,fasta}

file=80000_SNP_seeds
file2=80000_SNP_seq_seeds

length=$(wc -l $file | awk '{print $1}')
threads=50
((perThread=length/threads))

echo $perThread
for ((i=1; i<=length;i=i+perThread)) 
do
	((end=i-1+perThread))
	./one_thread_SNP_sim.sh $i $end $file $file2 &> out_SNPsim/thread_1_$i & 

done
wait 
