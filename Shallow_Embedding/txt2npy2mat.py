import scipy.io as scio
import numpy as np
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-txt_fname", dest="txt_fname", type=str)
parser.add_argument("-npy_fname", dest="npy_fname", type=str)
parser.add_argument("-mat_fname", dest="mat_fname", type=str)
parser.add_argument("-mat_name", dest="mat_name", type=str)

args = parser.parse_args()
txt_fname=args.txt_fname
npy_fname=args.npy_fname
mat_fname=args.mat_fname
mat_name=args.mat_name

embeddings=np.loadtxt(txt_fname,skiprows=1)
ind_sorted=np.argsort(embeddings[:,0]); 
embedding_sorted=embeddings[ind_sorted,1:]; # sort embedding vectors based on nodes index
embedding_sorted=embedding_sorted.astype(np.float32) # save storage space
np.save(npy_fname,embedding_sorted)
scio.savemat(mat_fname, {mat_name: embedding_sorted})