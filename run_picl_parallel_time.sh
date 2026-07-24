mkdir -p piclOutput
echo time/{t_U,t_B}/{s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d} > dirListPiclTime
echo time/{t_U,t_B}/s1/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_i >> dirListPiclTime

for rep in {1..50} 
do
	./run_picl_one_thread.sh $rep dirListPiclTime  &>  piclOutput/timeThread${rep} & 

done
wait
