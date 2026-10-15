rep=$1
dirList=$2
fileCheck=$3
for dir in $(cat ${dirList})
do
		analysisDir=/storage/anna/Ne_MSC/$dir/rep${rep}/picl_model1/
		echo $analysisDir
		cd $analysisDir

		if [ ! -f "outtree.tre" ] ; then
			picl &> outPicl
		fi
done
