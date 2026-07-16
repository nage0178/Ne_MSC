rep=$1
for dir in $(cat dirList)
do
	for mcmc in 1 2
	do
		analysisDir=/storage/anna/Ne_MSC/$dir/rep${rep}/bpp/${mcmc}
		echo $analysisDir
		cd $analysisDir
		bpp --cfile bpp.ctl &> outBpp 
	done
done
