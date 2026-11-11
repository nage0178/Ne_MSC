rep=$1
dirList=$2
fileCheck=$3
for dir in $(cat ${dirList})
do
	for mcmc in 1 2
	do
		analysisDir=/storage/anna/Ne_MSC/$dir/rep${rep}/bpp/ghost_${mcmc}
		echo $analysisDir
		cd $analysisDir

		if [ ! -f $fileCheck ] ; then
			bpp --cfile bpp.ctl &> outBpp 
		fi
	done
done
