mkdir -p piclOutput
echo SNP/time/{t_U,t_B}/s1/l{5000,20000}_s{1,8}/theta{0.01,0.0025}/Ne_i > lists/dirListPiclTimeSNP
echo SNP/time/{t_U,t_B}/{s2,s3}/l{5000,20000}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d} >> lists/dirListPiclTimeSNP
sed 's/ /\n/g' lists/dirListPiclTimeSNP > lists/dirListTimeSNP

for rep in {1..50} 
do
	picl_files/run_picl_one_thread.sh $rep lists/dirListPiclTimeSNP  &>  piclOutput/SNPtimeThread${rep} & 

done
wait
