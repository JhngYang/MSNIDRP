library(FSelector)
GDSC_EXP<-read.csv('cell_Exp_v1.csv')
exp_data_ori<-as.matrix(GDSC_EXP)
rm(GDSC_EXP)
na_logi<-is.na(exp_data_ori[1,])

print(nrow(exp_data)) #1001
print(ncol(exp_data)) #17737

Genes<-read.csv('cell_Exp_v1_Genes.csv')
Genes<-t(as.matrix(Genes))
Cells<-read.csv('cell_Exp_v1_Cells.csv')
Cells<-as.matrix(Cells)

label_lists<-read.csv('cell_drug_respadj_fselector.csv',header = FALSE)
label_mat<-as.matrix(label_lists[-(1:2),-1])  # cut the first and second row, and the first column 
label_mat=apply(label_mat,2,as.numeric)
print(nrow(label_mat)) #1001
print(ncol(label_mat)) #265
rm(label_lists)




# source("discretization_trail.R")
# exp_data_2 <- discretization_trail(exp_data,save_rate = 0.8)
# exp_data_dis <- exp_data_2$mat_dis
# index_save <- exp_data_2$index_s
# exp_data_tmp <- exp_data_dis[,index_save]
# Genes_2<-as.matrix(Genes[,index_save])
# rownames(exp_data_tmp) <- Cells[!logi]
# colnames(exp_data_tmp) <- Genes_2
# weight_genes <- linear.correlation(label~.,data.frame(exp_data_tmp))
# label_tmp <- as.matrix(label[tmp])

gene_num=16600 #16655
case_num=ncol(label_mat)
# case_num=3
weight_genes_mat = matrix(0,gene_num,case_num)
for (i in (1:case_num )) {
  label_ori=as.matrix(label_mat[,i])
  screen_logi<-is.na(label_ori)
  logi <- na_logi|screen_logi
  label <- as.matrix(label_ori[!logi])
  colnames(label) <- c("label")
  rownames(label)<-Cells[!logi]
  gc()
  # exp_data<- t(as.matrix(exp_datra_ori[,!logi]))
  # rownames(exp_data) <- Cells[!logi]
  # colnames(exp_data) <- Genes
  
  weight_genes <- linear.correlation(label~.,data.frame(t(as.matrix(exp_data_ori[,!logi]))[,1:gene_num])) # 16655 
  weight_genes_mat[,i]<-as.matrix(weight_genes)
  gc()
}

write.csv(weight_genes_mat,'weight_genes_4drugs.csv')
