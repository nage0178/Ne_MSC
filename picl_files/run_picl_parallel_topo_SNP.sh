mkdir -p piclOutput
echo SNP/topology/{t_U,t_B}/s1/l{20000,80000}_s{1,8}/theta{0.01,0.0025}/Ne_i > lists/dirListPiclSNP_m1
echo SNP/topology/{t_U,t_B}/{s2,s3}/l{20000,80000}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d} >> lists/dirListPiclSNP_m1

for rep in {1..50} 
do
	picl_files/run_picl_one_thread.sh $rep lists/dirListPiclSNP_m1  &>  piclOutput/SNP_topo_thread${rep} & 

done
wait
