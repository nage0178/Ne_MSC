mkdir -p piclOutput
echo topology/{t_U,t_B}/{s2,s3}/l160_s{1,8}/theta{0.01,0.0025}/Ne_{i,d} > dirListPicl
echo topology/{t_U,t_B}/s1/l160_s{1,8}/theta{0.01,0.0025}/Ne_i >> dirListPicl

for rep in {1..50} 
do
	./run_picl_one_thread.sh $rep dirListPicl  &>  piclOutput/thread${rep} & 

done
wait
