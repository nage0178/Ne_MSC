# Prepare files for baseml
for dir in time/{t_U,t_B}/{s1,s2,s3}/l{40,160}_s1/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}
do
	echo $dir
	cp baseml.ctl $dir
	cd $dir 
	sed -e 's/n1/A/g' -e 's/n2/B/g' -e 's/n3/C/g' -e 's/n4/D/g' -e 's/n5/E/g' data.phy | sed 's/\t/\n/g' > data.fa
	echo 5 1 > baseml.tre
	cat treefile.tre >> baseml.tre
	cd /storage/anna/Ne_MSC
	
done

# Run baseml
for dir in time/{t_U,t_B}/{s1,s2,s3}/l{40,160}_s1/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}
do
	echo $dir
	cd /storage/anna/Ne_MSC/$dir 
	baseml &> outBaseml
	
done

# Check if there were convergence issues, if there were rerun until no issues
for dir in time/{t_U,t_B}/{s1,s2,s3}/l{40,160}_s1/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}
do
	output=$(grep convergence /storage/anna/Ne_MSC/$dir/outBaseml)

	if [[ -n "$output" ]]; then
		cd /storage/anna/Ne_MSC/$dir 

		while [ -n "$(grep convergence outBaseml)" ]; do
			echo $dir
			baseml &> outBaseml
		done	
	fi
	
done

# Get the final tree from baseml
for dir in time/{t_U,t_B}/{s1,s2,s3}/l{40,160}_s1/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}
do
	echo $dir
	tail -n 6  $dir/baseml.txt | head -1  > $dir/outBaseml.tre 
	cat $dir/outBaseml.tre
	
done

ls time/{t_U,t_B}/{s2,s3}/l{40,160}_s1/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/outBaseml.tre > bml_list_tree.txt
ls time/{t_U,t_B}/s1/l{40,160}_s1/theta{0.01,0.0025}/Ne_i/rep{1..50}/outBaseml.tre >> bml_list_tree.txt	

# Get divergence times
Rscript divergence_time.R 
