mkdir -p piclOutput
echo SNP/time/{t_U,t_B}/s1/l{80000,20000}_s8/theta{0.01,0.0025}/Ne_i > lists/dirListPiclTimeSNP_estTheta
echo SNP/time/{t_U,t_B}/{s2,s3}/l{80000,20000}_s8/theta{0.01,0.0025}/Ne_{i,d} >> lists/dirListPiclTimeSNP_estTheta
sed 's/ /\n/g' lists/dirListPiclTimeSNP_estTheta > lists/dirListTimeSNP_estTheta

for rep in {1..50} 
do
	picl_files/run_picl_one_thread_est_theta.sh $rep lists/dirListPiclTimeSNP_estTheta  &>  piclOutput/SNPtimeThread${rep} & 

done
wait

