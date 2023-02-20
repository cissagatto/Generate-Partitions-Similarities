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


##################################################################################################
# Runs for all datasets listed in the "datasets.csv" file                                        #
# n_dataset: number of the dataset in the "datasets.csv"                                         #
# number_cores: number of cores to paralell                                                      #
# number_folds: number of folds for cross validation                                             # 
# delete: if you want, or not, to delete all folders and files generated                         #
##################################################################################################
execute <- function(parameters){
  
  retorno = list()
  
  setwd(FolderScripts)
  source("dendrograms.R")
  
  
  if(parameters$Number.Cores == 0){
    
    cat("\n\n##########################################################")
      cat("\n# Zero is a disallowed value for number_cores. Please    #")
      cat("\n# choose a value greater than or equal to 1.             #")
      cat("\n##########################################################\n\n")
    
  } else {
    
    cl <- parallel::makeCluster(parameters$Number.Cores)
    doParallel::registerDoParallel(cl)
    print(cl)
    
    if(number_cores==1){
      cat("\n\n#########################################################")
        cat("\n# Running Sequentially!                                 #")
        cat("\n#########################################################\n\n")
    } else {
      cat("\n\n#################################################################")
        cat("\n# Running in parallel with ", parameters$Number.Cores, " cores! #")
        cat("\n#################################################################\n\n")
    }
  }
  cl = cl
  
  retorno = list()
  
  
  cat("\n\n########################################################")
    cat("\n# RUN: get labels                                      #")
    cat("\n########################################################\n\n")
  arquivo = paste(parameters$Folders$folderNamesLabels, "/" ,
                  parameters$Dataset.Name, "-NamesLabels.csv", sep="")
  namesLabels = data.frame(read.csv(arquivo))
  colnames(namesLabels) = c("id", "labels")
  namesLabels = c(namesLabels$labels)
  parameters$NamesLabels = namesLabels
  
  
  cat("\n\n########################################################")
    cat("\n# RUN: Get the label space                             #")
    cat("\n########################################################\n\n")
  timeLabelSpace = system.time(resLS <- labelSpace(parameters))
  parameters$LabelSpace = resLS

  
  cat("\n\n###########################################")
    cat("\n# RUN: Cut Dendrograms                    #")
    cat("\n###########################################\n\n")
  timeCT = system.time(resCT <- CutreeHClust(parameters))
  
  
  cat("\n\n#####################################################")
    cat("\n# RUN: Best Coeficient                              #")
    cat("\n#####################################################\n\n")
  timeBC = system.time(resCT <- bestCoefficient(parameters))
  
  
  cat("\n\n#########################################################")
    cat("\n# RUN: Partitions Analysis                              #")
    cat("\n#########################################################\n\n")
  timeAP = system.time(resST <- analisaParticoes(parameters))
  
  
  cat("\n\n#######################################################")
    cat("\n# RUN: Best Dendrogram                                #")
    cat("\n#######################################################\n\n")
  timeBD = system.time(resBD <- bestDendrogram(parameters))
  retorno$BestMethod = resBD$BestMethod
  return(retorno)
  
  
  cat("\n\n##########################################################")
  cat("\n# RUN: Runtime                                             #")
  cat("\n###########################################################\n\n")
  timesExecute = rbind(timeCT, timeBC, timeAP, timeBD)
  setwd(diretorios$folderOutput)
  write.csv(timesExecute, paste(parameters$Dataset.Name, 
                                "-RunTime-run.csv", sep=""))
  
  
  cat("\n\n#########################################################")
  cat("\n# RUN: Stop Parallel                                      #")
  cat("\n###########################################################\n\n")
  on.exit(stopCluster(cl))

  cat("\n\n#####################################################")
    cat("\n# RUN: END                                          #") 
    cat("\n#####################################################\n\n")
  
  gc()
}

#############################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com              #
# Thank you very much!                                                      #
#############################################################################
