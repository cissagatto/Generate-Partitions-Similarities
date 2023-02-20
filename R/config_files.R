rm(list = ls())


##############################################################################
# Generate Partitions Similarities                                                #
# Copyright (C) 2023                                                         #
#                                                                            #
# This program is free software: you can redistribute it and/or modify it    #
# under the terms of the GNU General Public License as published by the      #
# Free Software Foundation, either version 3 of the License, or (at your     #
# option) any later version. This program is distributed in the hope that    #
# it will be useful, but WITHOUT ANY WARRANTY; without even the implied      #
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the   #
# GNU General Public License for more details.                               #     
#                                                                            #
# Elaine Cecilia Gatto | Prof. Dr. Ricardo Cerri | Prof. Dr. Mauri Ferrandin #
# Federal University of Sao Carlos (UFSCar: https://www2.ufscar.br/) Campus  #
# Sao Carlos Computer Department (DC: https://site.dc.ufscar.br/)            # 
# Program of Post Graduation in Computer Science                             #
# (PPG-CC: http://ppgcc.dc.ufscar.br/) Bioinformatics and Machine Learning   #
# Group (BIOMAL: http://www.biomal.ufscar.br/)                               #
#                                                                            #
##############################################################################


########################################################################
# WORSKSPACE
########################################################################
FolderRoot = "~/Generate-Partitions-Similarities"
FolderScripts = "~/Generate-Partitions-Similarities/R"


###############################################################################
# LOAD LIBRARY/PACKAGE                                                        #
###############################################################################
library(stringr)


###############################################################################
# READING DATASET INFORMATION FROM DATASETS-ORIGINAL.CSV                      #
###############################################################################
setwd(FolderRoot)
datasets = data.frame(read.csv("datasets-original.csv"))
n = nrow(datasets)


###############################################################################
# CREATING FOLDER TO SAVE CONFIG FILES                                        #
###############################################################################
FolderCF = paste(FolderRoot, "/config-files", sep="")
if(dir.exists(FolderCF)==FALSE){dir.create(FolderCF)}


measure.1 = c("jaccard", "rogers")
measure.2 = c("j", "ro")


m = 1
while(m<=length(measure.1)){
  
  FolderMeasure = paste(FolderCF, "/", measure.1[m], sep="")
  if(dir.exists(FolderMeasure)==FALSE){dir.create(FolderMeasure)}
  
  i = 1
  while(i<=n){
    
    # specific dataset
    ds = datasets[i,]
    
    cat("\n\n===========================================")
    cat("\n", measure.1[m])
    cat("\n\t", ds$Name)
    
    
    name = paste("g", measure.2[m], "-", ds$Name, sep="")
    
    # Confi File Name
    file.name = paste(FolderMeasure, "/", name, ".csv", sep="")
    
    # Starts building the configuration file
    output.file <- file(file.name, "wb")
    
    # Config file table header
    write("Config, Value",
          file = output.file, append = TRUE)
    
    # Absolute path to the folder where the dataset's "tar.gz" is stored
    
    write("Dataset_Path, /home/biomal/Datasets",
          file = output.file, append = TRUE)
    
    folder.name = paste("/dev/shm/", name, sep = "")
    
    # Absolute path to the folder where temporary processing will be done.
    # You should use "scratch", "tmp" or "/dev/shm", it will depend on the
    # cluster model where your experiment will be run.
    str.1 = paste("Temporary_Path, ", folder.name, sep="")
    write(str.1,file = output.file, append = TRUE)
    
    str.5 = paste(FolderRoot, "/Similarity-Matrices/",
                  measure.1[m], sep="")
    str.4 = paste("Similarity_Path, ", str.5, sep="")
    write(str.4,file = output.file, append = TRUE)
    
    str.0 = paste("Similarity, ", measure.1[m], sep="")
    write(str.0, file = output.file, append = TRUE)
    
    # dataset name
    str.2 = paste("Dataset_Name, ", ds$Name, sep="")
    write(str.2, file = output.file, append = TRUE)
    
    # Dataset number according to "datasets-original.csv" file
    str.3 = paste("Number_Dataset, ", ds$Id, sep="")
    write(str.3, file = output.file, append = TRUE)
    
    # Number used for X-Fold Cross-Validation
    write("Number_Folds, 10", file = output.file, append = TRUE)
    
    # Number of cores to use for parallel processing
    write("Number_Cores, 1", file = output.file, append = TRUE)
    
    # finish writing to the configuration file
    close(output.file)
    
    # increment
    i = i + 1
    
    # clean
    gc()
  } # FIM DO DATSET
  
  m = m + 1
  gc()
} # FIM DA MEDIDA DE SIMILARIDADE



###############################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                #
# Thank you very much!                                                        #                                #
###############################################################################
