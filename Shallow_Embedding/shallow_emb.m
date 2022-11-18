function shallow_emb(netfile_name,dim,vecfname) 

    densname='train_net_dense.txt';
    cmd1=['./reconstruct -train ',netfile_name,' -output ',densname,' -depth 2 -k-max 1000'];
    cmd2=['./line -train ',densname,' -output ',vecfname,' -binary 0 -size ',num2str(dim),' -order 2 -negative 5 -samples 1000 -threads 40'];

    unix(cmd1);
    unix(cmd2);