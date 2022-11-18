#!/bin/bash
# --env python36

e_size=20
drug_id=172
for((fold_idx=1;fold_idx<=5;fold_idx++));do
	data_path="../cv_data/drug${drug_id}_fold${fold_idx}_train_net.txt"   
	embeddings_prefix="drug${drug_id}_fold${fold_idx}_"
	python src/main_c2.py --data_path $data_path --save_path result/ --save_suffix test --embeddings_prefix $embeddings_prefix -s $e_size -b 256 -lr 0.0025 --index_from_0 True
done
