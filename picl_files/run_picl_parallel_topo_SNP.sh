mkdir -p piclOutput
echo SNP/topology/{t_U,t_B}/{s2,s3}/l{5000,20000}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d} > lists/dirListPiclSNP
echo SNP/topology/{t_U,t_B}/s1/l{5000,20000}_s{1,8}/theta{0.01,0.0025}/Ne_i >> lists/dirListPiclSNP

for rep in {1..50} 
do
	picl_files/run_picl_one_thread.sh $rep lists/dirListPiclSNP  &>  piclOutput/SNP_topo_thread${rep} & 

done
wait
