mkdir -p piclOutput
echo SNP/topology/{t_U,t_B}/s1/l{20000,80000}_s8/theta{0.01,0.0025}/Ne_i > lists/dirListPiclSNP_m1_estTopo
echo SNP/topology/{t_U,t_B}/{s2,s3}/l{20000,80000}_s8/theta{0.01,0.0025}/Ne_{i,d} >> lists/dirListPiclSNP_m1_estTopo

for rep in {1..50} 
do
	for i in {1..4}
	do
		picl_files/run_picl_one_thread_est_theta.sh $rep lists/dirListPiclSNP_m1_estTopo $i &>>  piclOutput/SNP_topo_thread${rep} & 
	done

done
wait

