function nodeatrr_vec=CellExpProf_drug(drug_id,dim,Exp_data,GeneRank_data,cells)
    drug_GeneRank=GeneRank_data(1:dim,drug_id);
    nodeatrr_vec=Exp_data(drug_GeneRank,cells+1)';
    