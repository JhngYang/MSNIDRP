import scipy.io as scio
import numpy as np
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-npy_fname", dest="npy_fname", type=str)
parser.add_argument("-mat_fname", dest="mat_fname", type=str)
parser.add_argument("-mat_name", dest="mat_name", type=str)

args = parser.parse_args()
npy_fname=args.npy_fname
mat_fname=args.mat_fname
mat_name=args.mat_name

mat=np.load(npy_fname)
scio.savemat(mat_fname, {mat_name: mat})