
dir=$1
scenario=$2
Ne=$3
theta=$4
loci=$5
s=$6
tree=$7
analysis=$8

if [[ "$scenario" == s1  && "$Ne" == d ]] 
then
	continue

fi 

# Copy control file with the correct theta/tau priors
if [[ $analysis == "time" ]] 
then
	if [[ $theta == "0.01" ]] 
	then
		cp bpp_files/A00_theta_01.bpp.ctl $dir/bpp/1/bpp.ctl
	
	else 
		cp bpp_files/A00_theta_0025.bpp.ctl $dir/bpp/1/bpp.ctl
	
	fi
else
	if [[ $theta == "0.01" ]] 
	then
		cp bpp_files/A01_theta_01.bpp.ctl $dir/bpp/1/bpp.ctl
	
	else 
		cp bpp_files/A01_theta_0025.bpp.ctl $dir/bpp/1/bpp.ctl
	
	fi
fi

# Change number of loci
if [[ "$loci" == "160" ]] ; 
then
	
	sed -i 's/nloci = 40/nloci = 160/' $dir/bpp/1/bpp.ctl
fi

# Change number of samples
if [[ "$s" == "8" ]] ; 
then
	
	sed -i 's/1  1  1  1  1/8  8  8  8  8/' $dir/bpp/1/bpp.ctl
	sed -i 's/1_imap.txt/8_imap.txt/' $dir/bpp/1/bpp.ctl
	cp bpp_files/8_imap.txt $dir/bpp/
else

	cp bpp_files/1_imap.txt $dir/bpp/
fi 

# Change tree topology
if [[ "$tree" == t_B ]] ; 
then
	sed -i 's/((((A, B), C), D), E)/(((A, B), C), (D, E))/' $dir/bpp/1/bpp.ctl
fi 

# Different seeds for two runs
sed 's/seed = 1/seed = 2/' $dir/bpp/1/bpp.ctl > $dir/bpp/2/bpp.ctl

