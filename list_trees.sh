ls topology/{t_U,t_B}/{s1,s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/astral.tre  > lists/list_tree.txt
ls topology/{t_U,t_B}/{s1,s2,s3}/l{40,160}_s1/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/mpest_best.tre >> lists/list_tree.txt
ls topology/{t_U,t_B}/{s1,s2,s3}/l{40,160}_s1/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/picl_best.tre >> lists/list_tree.txt

ls topology/{t_U,t_B}/{s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/bpp/1/MAP.txt >> lists/list_tree.txt
ls topology/{t_U,t_B}/s1/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_i/rep{1..50}/bpp/1/MAP.txt >> lists/list_tree.txt


echo time/{t_U,t_B}/{s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50} > time_tree.txt
echo time/{t_U,t_B}/s1/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_i/rep{1..50} >> time_tree.txt
sed -i 's/ /\n/g' time_tree.txt
