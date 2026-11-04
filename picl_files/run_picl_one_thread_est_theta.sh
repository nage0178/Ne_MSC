rep=$1
dirList=$2
p_rep=$3

for dir in $(cat ${dirList})
do
		if [[ -n "$p_rep" ]] 
		then
			analysisDir=/storage/anna/Ne_MSC/$dir/rep${rep}/PICL_est_theta/$p_rep
		else
			analysisDir=/storage/anna/Ne_MSC/$dir/rep${rep}/PICL_est_theta/
		fi 
		echo $analysisDir
		cd $analysisDir

		if [ ! -f "outtree.tre" ] ; then
			picl &> outPicl
		fi
done
