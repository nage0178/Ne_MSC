mkdir -p bppTopologyOutput
echo topology/{t_U,t_B}/{s2,s3}/l{40,160}_s1/theta{0.01,0.0025}/Ne_{i,d} > lists/dirListTopo
echo topology/{t_U,t_B}/s1/l{40,160}_s1/theta{0.01,0.0025}/Ne_i >> lists/dirListTopo
echo topology/{t_U,t_B}/{s2,s3}/l{40,160}_s8/theta{0.01,0.0025}/Ne_{i,d} >> lists/dirListTopo
echo topology/{t_U,t_B}/s1/l{40,160}_s8/theta{0.01,0.0025}/Ne_i >> lists/dirListTopo

for rep in {1..50} 
do
	./run_bpp_one_thread.sh $rep lists/dirListTopo out.mcmc.txt &>  bppTopologyOutput/thread${rep} & 


done
wait
