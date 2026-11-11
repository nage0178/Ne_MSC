dir=$1
file=$dir/outBpp

start=$(grep -n  '(A)'  $file | awk -F : '{print $1}')
end=$(grep -n  '(B)'  $file | awk -F : '{print $1}')

((start=start+1))
((end=end-2))
echo $start $end

sed -n "${start},${end}p" $file > $dir/tree_prob.txt
