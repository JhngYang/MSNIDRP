function model=train(SE_train_vecs,DE_train_vecs,NA_train_vecs, train_labels)

train_vecs=[SE_train_vecs,DE_train_vecs,NA_train_vecs];
cmd=[' -w1 ',num2str(sum(train_labels==0)/sum(train_labels==1)),' -w0 ',num2str(1),' -c ',num2str(c),'-g ',num2str(g)];
model=svmtrain(train_labels,train_vecs,cmd);