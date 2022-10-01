# TBIM
This repository shows the implementation of the Trained Born Iterative Method (TBIM) in the reference below applied for electromagnetic imaging.

The repositry includes two folders:
  1) Matlab: Matlab folder to generate the training, validation, and testing set. 
  2) Python: To traine the TBIM model using Pytorch 1.8.1 cuda. It also consist the pre-trained model used in the reference below. 


# Matlab
The following files are created under the Matlab folder:
  1) ProblemConfiguration.m : Run this file to generate the problem configuration that includes receiver-tranmitter locations, invistigation domain discritized grid, cylinderical permittivity profiles that are used to train the model. The file will return "ProblemConfiguration.mat" used in scattered field computation.  
  2) MoM_forward_solver_TM_v2.m : After running (1), run this file that will compute the 2D EM forward model for each example. The fu 
