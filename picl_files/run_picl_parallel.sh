mkdir -p piclOutput
echo topology/{t_U,t_B}/{s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d} > lists/dirListPicl
echo topology/{t_U,t_B}/s1/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_i >> lists/dirListPicl

for rep in {1..50} 
do
	picl_files/run_picl_one_thread.sh $rep lists/dirListPicl  &>  piclOutput/thread${rep} & 

done
wait
