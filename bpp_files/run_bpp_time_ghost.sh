mkdir -p bppTimeOutput
echo time/{t_U,t_B}/s3/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d} > lists/dirListGhost

for rep in {1..50} 
do
	bpp_files/run_bpp_one_thread_ghost.sh $rep lists/dirListGhost out.FigTree.tre &>  bppTimeOutput/threadGhost${rep} & 


done
wait
