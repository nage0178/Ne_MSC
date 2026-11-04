ls topology/{t_U,t_B}/{s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/astral.tre  > lists/list_tree.txt
ls topology/{t_U,t_B}/s1/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_i/rep{1..50}/astral.tre  >> lists/list_tree.txt
ls topology/{t_U,t_B}/{s1,s2,s3}/l{40,160}_s1/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/mpest_best.tre >> lists/list_tree.txt

ls SNP/topology/{t_U,t_B}/{s2,s3}/l{80000,20000}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/picl_model1/picl_bestLike.tre >> lists/list_tree.txt
ls SNP/topology/{t_U,t_B}/s1/l{80000,20000}_s{1,8}/theta{0.01,0.0025}/Ne_i/rep{1..50}/picl_model1/picl_bestLike.tre >> lists/list_tree.txt
#ls topology/{t_U,t_B}/{s1,s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/picl_best.tre >> lists/list_tree.txt

ls SNP/topology/{t_U,t_B}/{s2,s3}/l{80000,20000}_s8/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/PICL_est_theta/picl_bestLike.tre >> lists/list_tree.txt
ls SNP/topology/{t_U,t_B}/s1/l{80000,20000}_s8/theta{0.01,0.0025}/Ne_i/rep{1..50}/PICL_est_theta/picl_bestLike.tre >> lists/list_tree.txt

ls topology/{t_U,t_B}/{s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50}/bpp/1/MAP.txt >> lists/list_tree.txt
ls topology/{t_U,t_B}/s1/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_i/rep{1..50}/bpp/1/MAP.txt >> lists/list_tree.txt


echo time/{t_U,t_B}/{s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}/rep{1..50} > time_tree.txt
echo time/{t_U,t_B}/s1/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_i/rep{1..50} >> time_tree.txt
sed -i 's/ /\n/g' time_tree.txt


echo time/{t_U,t_B}/{s2,s3}/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_{i,d}  > lists/astral_bl
echo time/{t_U,t_B}/s1/l{40,160}_s{1,8}/theta{0.01,0.0025}/Ne_i  >> lists/astral_bl
sed -i 's/ /\n/g' lists/astral_bl

