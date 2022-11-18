function [deci_test,predict_label]=test(model,SE_test_vecs,DE_test_vecs,NA_test_vecs)

test_vecs=[SE_test_vecs,DE_test_vecs,NA_test_vecs];
[predict_label,mse,subdeci] = svmpredict(label_test,vec_test,model);
if model.Label(1)==1
    mod2=1;
else 
    mod2=-1;
end
deci_test = subdeci*mod2;
