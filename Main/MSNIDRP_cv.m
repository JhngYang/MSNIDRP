SE_dim=80;
DE_dim=24;
NA_dim=20;
fold_num=5;

netData_dir='../DCR_net/';
cv_data_dir='../cv_data/';
load([cv_data_dir,'drug_cell_resp_cvs_idx.mat']);
load([netData_dir,'DCGnet.mat']);

% drug index
drug_id=8; %example


%%%shallow embedding
cd ../Shallow_Embedding/;
mkdir dim80;
prefix=['drug',num2str(drug_id),'_'];

drug_cv_data=drug_cell_resp_cvs_idx{drug_id+1};
ShallowEmb_cv(fold_num,SE_dim,drug_cv_data,DCGnet,prefix);
for fold_id=1: fold_num
	txt_fname=['dim',num2str(SE_dim),'/drug',num2str(drug_id),'_fold',num2str(fold_id),'_embeddings.txt'] ;    
	npy_fname=['dim',num2str(SE_dim),'/drug',num2str(drug_id),'_fold',num2str(fold_id),'_embeddings.npy'] ;
	mat_fname=['dim',num2str(SE_dim),'/drug',num2str(drug_id),'_fold',num2str(fold_id),'_embeddings.mat'];
	mat_name=['drug',num2str(drug_id),'_fold',num2str(fold_id),'_embeddings'];   
    cmd=['python txt2npy2mat.py -txt_fname ',txt_fname,' -npy_fname ',npy_fname,' -mat_fname ',mat_fname,' -mat_name ',mat_name];
    unix(cmd)
end


%%% deep embeddding
cd ../Deep_Embedding;
for fold_id=1: fold_num
	data_path=['../cv_data/drug',num2str(drug_id),'_fold',num2str(fold_id),'_train_net.txt' ] ;
	embeddings_prefix=['drug',num2str(drug_id),'_fold',num2str(fold_id),'_'];
	cmd1=['python main_c2.py --data_path ',data_path,' --save_path result/ --save_suffix test --embeddings_prefix ',embeddings_prefix,' -s ',num2str(DE_dim),' -b 256 -lr 0.0025 --index_from_0 True'];
	unix(cmd1);
	npy_fname=['result/test_',num2str(DE_dim),'_0.0_0.5/drug',num2str(drug_id),'_fold',num2str(fold_id),'_embeddings.npy'] ;
	mat_fname=['result/test_',num2str(DE_dim),'_0.0_0.5/drug',num2str(drug_id),'_fold',num2str(fold_id),'_embeddings.mat'];
	mat_name=['drug',num2str(drug_id),'_fold',num2str(fold_id),'_embeddings'];
	cmd2=['python npy2mat.py -npy_fname ',npy_fname,' -mat_fname ',mat_fname,' -mat_name ',mat_name];
	unix(cmd2)   % convert .npy to matlab to .mat
end

%%% node attibute
cd ../Main;
EXP_dir='../Node_Attr/';
EXP_data=importdata([netData_dir,'cell_Exp_v2.mat']);
EXP_GeneRank=importdata([EXP_dir,'Selected1000_Genes_idx.mat']);

%%%  5 fold cv procedure
SE_dir=['../Shallow_Embedding/dim',num2str(SE_dim),'/'];
DE_dir=['../Deep_Embedding/result/test_',num2str(DE_dim),'_0.0_0.5/'];



deci=[];
vecs_cv=cell(5,2);
labels_cv=cell(5,2);
for fold_id=1: fold_num
    drug_respairs_train_fname=[cv_data_dir,'drug',num2str(drug_id),'_cell_resp_pairs_fold',num2str(fold_id),'_train_idx.txt'];
    drug_respairs_test_fname=[cv_data_dir,'drug',num2str(drug_id),'_cell_resp_pairs_fold',num2str(fold_id),'_test_idx.txt'];      
    drug_train_respairs=load(drug_respairs_train_fname);   
    train_cells=drug_train_respairs(:,1);
    drug_test_respairs=load(drug_respairs_test_fname);
    test_cells=drug_test_respairs(:,1);
    drug_GeneRank=EXP_GeneRank(1:NA_dim,drug_id+1); % as node index starts with 0
    
    SE_vecs_fname=[SE_dir,'drug',num2str(drug_id),'_fold',num2str(fold_id),'_embeddings.mat'];
    SE_vecs=importdata(SE_vecs_fname);        
    DE_vecs_fname=[DE_dir,'drug',num2str(drug_id),'_fold',num2str(fold_id),'_embeddings.mat'];
    DE_vecs=importdata(DE_vecs_fname);
    SE_vecs=double(SE_vecs);
    DE_vecs=double(DE_vecs);
    
    SE_train_vecs=SE_vecs(train_cells+1,:); % as node index starts with 0
    SE_test_vecs=SE_vecs(test_cells+1,:);
    DE_train_vecs=DE_vecs(train_cells+1,:);
    DE_test_vecs=DE_vecs(test_cells+1,:);
    NA_train_vecs=EXP_data(drug_GeneRank,train_cells+1)';
    NA_test_vecs=EXP_data(drug_GeneRank,test_cells+1)';
    
     train_labels=drug_train_respairs(:,3);
     test_labels=drug_test_respairs(:,3);     
     train_vecs=[SE_train_vecs,DE_train_vecs,NA_train_vecs];
     test_vecs=[SE_test_vecs,DE_test_vecs,NA_test_vecs];
     
    vecs_cv{fold_id,1}= test_vecs;
    vecs_cv{fold_id,2}=train_vecs;
    labels_cv{fold_id,1}=test_labels;
    labels_cv{fold_id,2}=train_labels;
end

c=1;
g=1/(SE_dim+DE_dim+NA_dim);
[decis,labels] = class_cv(labels_cv,vecs_cv,fold_num,c,g);    
  

%%% performance evaluation
colour='m';
[auc,sn,sp] = roc_curve(decis,labels,colour);
    