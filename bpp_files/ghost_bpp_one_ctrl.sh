dir=$1
Ne=$2
theta=$3
loci=$4
s=$5
tree=$6

mkdir -p $dir/bpp/ghost_1
mkdir -p $dir/bpp/ghost_2
ctl=$dir/bpp/ghost_1/bpp.ctl

# Copy control file with the correct theta/tau priors
if [[ $theta == "0.01" ]] 
then
	cp bpp_files/ghost_sam${s}_A00_theta_01.bpp.ctl $ctl

else 
	cp bpp_files/ghost_sam${s}_A00_theta_0025.bpp.ctl $ctl

fi

# Change number of loci
if [[ "$loci" == "160" ]] ; 
then
	
	sed -i 's/nloci = 40/nloci = 160/' $ctl
fi

# Change number of samples
if [[ "$s" == "8" ]] ; 
then
	
	sed -i 's/1_imap.txt/8_imap.txt/' $ctl
	# These files should already be there
	#cp bpp_files/8_imap.txt $dir/bpp/
#else

	#cp bpp_files/1_imap.txt $dir/bpp/
fi 

# Change tree topology
if [[ "$tree" == t_B ]] ; 
then
	if [[ "$s" == "8" ]] ; 
	then

		sed -i 's/((((((((A,A1),A2), B), C), D),D1),D2), E)/(((((A,A1),A2), B), C), (((D, E),D1),D2))/' $ctl
	else
		sed -i 's/((((((A, B), C), D),D1),D2), E)/(((A,B), C), (((D, E),D1),D2))/' $ctl
	fi
fi 

# Different seeds for two runs
sed 's/seed = 1/seed = 2/' $ctl > $dir/bpp/ghost_2/bpp.ctl

