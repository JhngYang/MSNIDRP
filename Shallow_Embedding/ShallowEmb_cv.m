% if reported error:  error while loading shared libraries: libgsl.so.0: cannot open shared object file: No such file or directory
% LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
% export LD_LIBRARY_PATH



function ShallowEmb_cv(fold_num,dim,cv_data,net,prefix)
%%% when we perform shawllow embedding on one drug, the prefix
%%% is set as 'drugname_'

    for fold_id=1:fold_num
        test_pairs=cv_data{fold_id,1};
        [lia1,~]=ismember(net(:,2),test_pairs(:,2));   % lia1&lia2 indicates the response pairs which are contained in the test data
        [lia2,~]=ismember(net(:,1),test_pairs(:,1));  
        train_net=net(~(lia1&lia2),:);
        train_net_inverse=[train_net(:,2),train_net(:,1)];
        train_net_dual=[train_net;train_net_inverse];
        train_net_dual=[train_net_dual,ones(length(train_net_dual),1)];    

        netfile_name='train_net.txt';
        fid=fopen(netfile_name,'w'); 
        [m,n]=size(train_net_dual);
        for i=1:1:m
            for j=1:1:n
                if j==n
                    fprintf(fid,'%d\n',train_net_dual(i,j));
                else
                    fprintf(fid,'%d\t',train_net_dual(i,j));
                end
            end
        end
        fclose(fid);
        vecfname=['dim',num2str(dim),'/',prefix,'fold',num2str(fold_id),'_embeddings.txt'];
        shallow_emb(netfile_name,dim,vecfname) 
     end



