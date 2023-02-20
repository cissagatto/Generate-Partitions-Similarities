rm(list = ls())

cat("\n\n##############################################################")
cat("\n# START JACCARD PARTITIONS                                     #")
cat("\n################################################################\n\n") 

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
# 
###############################################################################
setwd(FolderScripts)
source("libraries.R")

setwd(FolderScripts)
source("utils.R")

setwd(FolderScripts)
source("run.R")



###############################################################################
# R Options Configuration                                                     #
###############################################################################
options(java.parameters = "-Xmx64g")  # JAVA
options(show.error.messages = TRUE)   # ERROR MESSAGES
options(scipen=20)                    # number of places after the comma



###############################################################################
# Reading the "datasets-original.csv" file to get dataset information         #
# for code execution!                                                         #
###############################################################################
setwd(FolderRoot)
datasets <- data.frame(read.csv("datasets-original.csv"))

parameters = list()



###############################################################################
# ARGS COMMAND LINE                                                          #
###############################################################################
cat("\n#####################################")
cat("\n# GET ARGUMENTS FROM COMMAND LINE   #")
cat("\n#####################################\n\n")
args <- commandArgs(TRUE)


###############################################################################
# FIRST ARGUMENT: getting specific dataset information being processed        #
# from csv file                                                               #
###############################################################################

# config_file = "/home/biomal/Generate-Partitions-Similarities/config-files/jaccard/gj-GpositiveGO.csv"


config_file <- args[1]



if(file.exists(config_file)==FALSE){
  cat("\n################################################################")
  cat("#\n Missing Config File! Verify the following path:              #")
  cat("#\n ", config_file, "                                            #")
  cat("#################################################################\n\n")
  break
} else {
  cat("\n########################################")
  cat("\n# Properly loaded configuration file!  #")
  cat("\n########################################\n\n")
}


cat("\n########################################")
cat("\n# Config File                          #\n")
config = data.frame(read.csv(config_file))
print(config)
cat("\n########################################\n\n")

dataset_path = toString(config$Value[1])
dataset_path = str_remove(dataset_path, pattern = " ")
parameters$Dataset.Path = dataset_path

folderResults = toString(config$Value[2])
folderResults = str_remove(folderResults, pattern = " ")
parameters$Folder.Results = folderResults

similarity_path = toString(config$Value[3])
similarity_path = str_remove(similarity_path, pattern = " ")
parameters$Similarity.Path = similarity_path

similarity = toString(config$Value[4])
similarity = str_remove(similarity, pattern = " ")
parameters$Similarity = similarity

dataset_name = toString(config$Value[5])
dataset_name = str_remove(dataset_name, pattern = " ")
parameters$Dataset.Name = dataset_name

number_dataset = as.numeric(config$Value[6])
parameters$Number.Dataset = number_dataset

number_folds = as.numeric(config$Value[7])
parameters$Number.Folds = number_folds

number_cores = as.numeric(config$Value[8])
parameters$Number.Cores = number_cores

ds = datasets[number_dataset,]
parameters$Dataset.Info = ds



###############################################################################
# Creating temporary processing folder                                        #
###############################################################################
if (dir.exists(folderResults) == FALSE) {dir.create(folderResults)}



###############################################################################
# Creating all directories that will be needed for code processing            #
###############################################################################
cat("\n######################")
cat("\n# Get directories    #")
cat("\n######################\n")
diretorios <- directories(dataset_name, folderResults)
print(diretorios)
cat("\n\n")

parameters$Folders = diretorios


###############################################################################
# Copying datasets from ROOT folder on server                                 #
###############################################################################

cat("\n####################################################################")
cat("\n# Checking the dataset tar.gz file                                 #")
cat("\n####################################################################\n\n")
str00 = paste(dataset_path, "/", ds$Name,".tar.gz", sep = "")
str00 = str_remove(str00, pattern = " ")

if(file.exists(str00)==FALSE){
  
  cat("\n######################################################################")
  cat("\n# The tar.gz file for the dataset to be processed does not exist!    #")
  cat("\n# Please pass the path of the tar.gz file in the configuration file! #")
  cat("\n# The path entered was: ", str00, "                                  #")
  cat("\n######################################################################\n\n")
  break
  
} else {
  
  cat("\n####################################################################")
  cat("\n# tar.gz file of the dataset loaded correctly!                     #")
  cat("\n####################################################################\n\n")
  
  # COPIANDO
  str01 = paste("cp ", str00, " ", diretorios$folderDataset, sep = "")
  res = system(str01)
  if (res != 0) {
    cat("\nError: ", str01)
    break
  }
  
  # DESCOMPACTANDO
  str02 = paste("tar xzf ", diretorios$folderDataset, "/", ds$Name,
                ".tar.gz -C ", diretorios$folderDataset, sep = "")
  res = system(str02)
  if (res != 0) {
    cat("\nError: ", str02)
    break
  }
  
  #APAGANDO
  str03 = paste("rm ", diretorios$folderDataset, "/", ds$Name,
                ".tar.gz", sep = "")
  res = system(str03)
  if (res != 0) {
    cat("\nError: ", str03)
    break
  }
  
}



cat("\n####################################################################")
cat("\n# Checking the SIMILARITY tar.gz file                              #")
cat("\n####################################################################\n\n")
str00 = paste(similarity_path, "/", dataset_name, 
              "-", similarity, ".tar.gz", sep = "")
str00 = str_remove(str00, pattern = " ")

if(file.exists(str00)==FALSE){
  
  cat("\n######################################################################")
  cat("\n# The tar.gz file for the dataset to be processed does not exist!    #")
  cat("\n# Please pass the path of the tar.gz file in the configuration file! #")
  cat("\n# The path entered was: ", str00, "                                  #")
  cat("\n######################################################################\n\n")
  break
  
} else {
  
  cat("\n####################################################################")
  cat("\n# tar.gz file of the dataset loaded correctly!                     #")
  cat("\n####################################################################\n\n")
  
  # COPIANDO
  str01 = paste("cp ", str00, " ", diretorios$folderSimat, sep = "")
  res = system(str01)
  if (res != 0) {
    cat("\nError: ", str01)
    break
  }
  
  # DESCOMPACTANDO
  str02 = paste("tar xzf ", diretorios$folderSimat, "/", dataset_name, 
                "-", similarity, ".tar.gz -C ",
                diretorios$folderSimat, sep = "")
  res = system(str02)
  if (res != 0) {
    cat("\nError: ", str02)
    break
  }

  #APAGANDO
  str03 = paste("rm ", diretorios$folderSimat, "/", dataset_name, 
                "-", similarity, ".tar.gz", sep = "")
  res = system(str03)
  if (res != 0) {
    cat("\nError: ", str03)
    break
  }
  
}


cat("\n####################################################################")
cat("\n# Execute Partitions                                       #")
cat("\n####################################################################\n\n")
timeFinal <- system.time(results <- execute(parameters))

print(results)
cat("\n")

print(timeFinal)
cat("\n")

result_set <- t(data.matrix(timeFinal))
setwd(diretorios$folderOutput)
write.csv(result_set, "Runtime-start.csv")


print(system(paste("rm -r ", parameters$Folders$folderDatasets, sep="")))
print(system(paste("rm -r ", parameters$Folders$folderSimat, sep="")))

 
# cat("\n####################################################################")
# cat("\n# Copy to google drive                                      #")
# cat("\n####################################################################\n\n")
# destino = paste("nuvem:Jaccard-Cut/", dataset_name, sep="")
# origem = diretorios$folderReports
# comando = paste("rclone -P copy ", origem, " ", destino, sep="")
# cat("\n", comando, "\n")
# a = print(system(comando))
# a = as.numeric(a)
# if(a != 0) {
#   stop("Erro RCLONE")
#   quit("yes")
# }



cat("\n####################################################################")
cat("\n# Compress folders and files                                       #")
cat("\n####################################################################\n\n")

FolderO = paste(FolderRoot, "/Output", sep="")
if(dir.exists(FolderO)==FALSE){dir.create(FolderO)}

FolderS = paste(FolderO, "/", parameters$Similarity, sep="")
if(dir.exists(FolderS)==FALSE){dir.create(FolderS)}

FolderM = paste(FolderS, "/", results$BestMethod, sep="")
if(dir.exists(FolderM)==FALSE){dir.create(FolderM)}

# tar -czvf name-of-archive.tar.gz /path/to/directory-or-file
str_a <- paste("tar -zcf ", parameters$Folder.Results, 
               "/", dataset_name, "-",  parameters$Similarity, "-", 
               results$BestMethod, "-results.tar.gz ", 
               parameters$Folders$folderOutput, sep = "")
print(system(str_a))

system(paste("rm -r ", parameters$Folders$folderOutput, sep = ""))


cat("\n####################################################################")
cat("\n# Copy to root folder                                              #")
cat("\n####################################################################\n\n")

folder = paste(FolderRoot, "/Dendrogram", sep="")
if(dir.exists(folder)==FALSE){dir.create(folder)}

folderS = paste(folder, "/", parameters$Similarity, sep="")
if(dir.exists(folderS)==FALSE){dir.create(folderS)}

folderM = paste(folderS, "/", results$BestMethod, sep="")
if(dir.exists(folderM)==FALSE){dir.create(folderM)}

str_b <- paste("cp -r ", parameters$Folder.Results, 
               "/", dataset_name, "-",  parameters$Similarity, "-", 
               results$BestMethod, "-results.tar.gz ", folderM, sep = "")
print(system(str_b))


cat("\n####################################################################")
cat("\n# DELETE                                                           #")
cat("\n####################################################################\n\n")
str_c = paste("rm -r ", diretorios$folderResults, sep="")
print(system(str_c))


rm(list = ls())

gc()

cat("\n#########################################################")
cat("\n# END Thanks God!                                       #") 
cat("\n#########################################################")
cat("\n\n\n\n") 

#############################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com              #
# Thank you very much!                                                      #
#############################################################################
