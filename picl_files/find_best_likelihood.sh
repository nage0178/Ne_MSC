startDir=$1
best_likelihood=""
best_dir=""

for dir in $startDir/{1..4}/ ; do

    file="${dir}outPicl"

    if [[ -f "$file" ]]; then
        likelihood=$(awk '/The composite likelihood of the best tree found by the algorithm is/ {print $NF}' "$file")
#	echo $file $likelihood

        if [[ -n "$likelihood" ]]; then
            if [[ -z "$best_likelihood" ]] || \
               awk -v a="$likelihood" -v b="$best_likelihood" 'BEGIN {exit !(a > b)}'; then
                best_likelihood="$likelihood"
                best_dir="${dir%/}"
            fi
        fi
    fi
done

#echo "Best directory: $best_dir"
#echo "Highest likelihood: $best_likelihood"
if  [[ -f ${best_dir}/outtree.tre ]] ; then

	tail -n 2 ${best_dir}/outtree.tre | head -1  | sed 's/^/(O,/' | sed 's/;/);/' > $best_dir/../picl_bestLike.tre &

fi
