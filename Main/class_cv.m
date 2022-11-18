function [decis,labels] = class_cv(labels_cv,vecs_cv,fold_num,c,g)

%%% normalization
all_vec=[];
position_starts=zeros(5,2);
position_ends=zeros(5,2);
indx=1;
for i=1:fold_num
    all_vec=[all_vec;vecs_cv{i,1}];
    test_start=indx;
    test_end=indx+size(vecs_cv{i,1},1)-1;
    all_vec=[all_vec;vecs_cv{i,2}];
    train_start=test_end+1;
    train_end=test_end+size(vecs_cv{i,2},1);
    position_starts(i,1)=test_start;
    position_starts(i,2)=train_start;
    position_ends(i,1)=test_end;
    position_ends(i,2)=train_end;
    indx=train_end+1;
end

all_vec_norm=(all_vec-repmat(min(all_vec,[],1),size(all_vec,1),1))*spdiags(1./(max(all_vec,[],1)-min(all_vec,[],1))',0,size(all_vec,2),size(all_vec,2));


vecs_norm_cv=cell(5,2);
for i=1:fold_num
    vecs_norm_cv{i,1}=all_vec_norm(position_starts(i,1):position_ends(i,1),:);
    vecs_norm_cv{i,2}=all_vec_norm(position_starts(i,2):position_ends(i,2),:);
end

%5 fold cv;  
labels=[];
decis=[];

for i=1:fold_num
    % label for test sets      
    labels_train=labels_cv{i,2};       
    labels_test=labels_cv{i,1};
    labels=[labels;labels_test];          

    % SVM using feature of 1rd proximity from fullnet
    
    vecs_train=vecs_norm_cv{i,2};       
    vecs_test=vecs_norm_cv{i,1}; 


%     cmd=[' -w1 ',num2str(sum(labels_train==0)/sum(labels_train==1)),' -w0 ',num2str(1)];
%
    cmd=[' -w1 ',num2str(sum(labels_train==0)/sum(labels_train==1)),' -w0 ',num2str(1),' -c ',num2str(c),'-g ',num2str(g)];
    model=svmtrain(labels_train,vecs_train,cmd);      
    [predict_label,mse,subdeci] = svmpredict(labels_test,vecs_test,model);
    if model.Label(1)==1
        mod2=1;
    else 
        mod2=-1;
    end
    deci1_test = subdeci*mod2;
    decis=[decis;deci1_test];
end
