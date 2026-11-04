rm -f bpp_time_tree.txt
rm -f bppTimeLowEss 


# Gets the ESS values for the bpp analyses
for demo in s1 s2 s3
do 
	for Ne in Ne_i Ne_d
	do
		for dir in time/{t_U,t_B}/$demo/l{40,160}_s{1,8}/theta{0.01,0.0025}/${Ne}/rep{1..50}/bpp/{1,2}
		do
			# Skip exta datasets, bpp wasn't run on them
			if [[ "$demo" == s1 && "$Ne" == Ne_d ]] ; then
				continue
			fi 

			if [ -f $dir/out.FigTree.tre ] ; then	

				# Get the ess values, record to their own file
				# Print error messages to separate file
				echo $dir
				bpp_files/extract_ess.sh $dir/outBpp > $dir/ess.txt  2>> bppTimeLowESS  
				#ls $dir/out.mcmc.txt >> bpp_time_tree.txt
			fi
		done

	done
done

ls time/{t_U,t_B}/{s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/bpp/{1,2}/out.mcmc.txt > lists/bpp_time_trees.txt
ls time/{t_U,t_B}/s1/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_i/rep{1..50}/bpp/{1,2}/out.mcmc.txt >> lists/bpp_time_trees.txt
sed 's/[1,2]\/out.mcmc.txt//g' bpp_time_tree.txt | sort | uniq -c | grep "2 "| awk '{print $2}'  > lists/bpp_time_trees.txt

# Gets the ESS values for the ghost bpp analyses
rm -f bpp_time_tree_ghost.txt
rm -f bppTimeLowEss_ghost
for demo in s3
do 
	for Ne in Ne_i Ne_d
	do
		for dir in time/{t_U,t_B}/$demo/l{40,160}_s{1,8}/theta{0.01,0.0025}/${Ne}/rep{1..50}/bpp/ghost_{1,2}
		do
			# Skip exta datasets, bpp wasn't run on them
			if [[ "$demo" == s1 && "$Ne" == Ne_d ]] ; then
				continue
			fi 

			if [ -f $dir/out.FigTree.tre ] ; then	

				# Get the ess values, record to their own file
				# Print error messages to separate file
				echo $dir
				bpp_files/extract_ess.sh $dir/outBpp > $dir/ess.txt  2>> bppTimeLowESS_ghost
				#ls $dir/out.mcmc.txt >> bpp_time_tree.txt
			fi
		done

	done
done

ls time/{t_U,t_B}/s3/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/bpp/ghost_{1,2}/out.mcmc.txt > lists/bpp_time_trees_ghost.txt
# Checks the Gelman diagnostic 
Rscript bpp_files/checkConvergence_bpp_time.R
