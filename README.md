# Generate Hybrid Partitions from Similarity Matrices
This code is part of my PhD project. The aim is build dendrograms from similarity matrices and chose the best one. Then, the best dendrogram is cutted in all possible levels producing the desired Hybrid Partitions.

## How to cite 
@misc{Gatto2023, author = {Gatto, E. C.}, title = {Generate Hybrid Partitions from Similarity Matrices}, year = {2023}, publisher = {GitHub}, journal = {GitHub repository}, howpublished = {\url{https://github.com/cissagatto/Generate-Partitions-Similarities}}}

## Source Code
This code source is composed of the project R to be used in RStudio IDE and also the following scripts R:

1. libraries.R
2. utils.R
3. dendrograms.R
4. run.R
5. start.R
6. config_files.R


## Preparing your experiment

### STEP 1
A file called _datasets-original.csv_ must be in the *root project directory*. This file is used to read information about the datasets and they are used in the code. We have 90 multilabel datasets in this _.csv_ file. If you want to use another dataset, please, add the following information about the dataset in the file:


| Parameter    | Status    | Description                                           |
|------------- |-----------|-------------------------------------------------------|
| Id           | mandatory | Integer number to identify the dataset                |
| Name         | mandatory | Dataset name (please follow the benchmark)            |
| Domain       | optional  | Dataset domain                                        |
| Instances    | mandatory | Total number of dataset instances                     |
| Attributes   | mandatory | Total number of dataset attributes                    |
| Labels       | mandatory | Total number of labels in the label space             |
| Inputs       | mandatory | Total number of dataset input attributes              |
| Cardinality  | optional  | **                                                    |
| Density      | optional  | **                                                    |
| Labelsets    | optional  | **                                                    |
| Single       | optional  | **                                                    |
| Max.freq     | optional  | **                                                    |
| Mean.IR      | optional  | **                                                    | 
| Scumble      | optional  | **                                                    | 
| TCS          | optional  | **                                                    | 
| AttStart     | mandatory | Column number where the attribute space begins * 1    | 
| AttEnd       | mandatory | Column number where the attribute space ends          |
| LabelStart   | mandatory | Column number where the label space begins            |
| LabelEnd     | mandatory | Column number where the label space ends              |
| Distinct     | optional  | ** 2                                                  |
| xn           | mandatory | Value for Dimension X of the Kohonen map              | 
| yn           | mandatory | Value for Dimension Y of the Kohonen map              |
| gridn        | mandatory | X times Y value. Kohonen's map must be square         |
| max.neigbors | mandatory | The maximum number of neighbors is given by LABELS -1 |


1 - Because it is the first column the number is always 1.

2 - [Click here](https://link.springer.com/book/10.1007/978-3-319-41111-8) to get explanation about each property.


### STEP 2
To run this experiment you need the _X-Fold Cross-Validation_ files and they must be compacted in **tar.gz** format. You can download these files, with 10-folds, ready for multilabel dataset by clicking [here](https://www.4shared.com/directory/ypgzwzjq/datasets-cross-validation.html). For a new dataset, in addition to including it in the **datasets-original.csv** file, you must also run this code [here](https://github.com/cissagatto/crossvalidationmultilabel). In the repository in question you will find all the instructions needed to generate the files in the format required for this experiment. The **tar.gz** file can be placed on any directory on your computer or server. The absolute path of the file should be passed as a parameter in the configuration file that will be read by **start.R** script. The dataset folds will be loaded from there.



### STEP 3
You will need the previously similarities matrices generate by the following code

https://github.com/cissagatto/SimilaritiesMultilabel


You must use here the results generated from the *SIMILARITY-MATRICES* directory in that source code. They must be compressed into a *TAR.GZ* file and placed in a directory on your computer. The absolute path of this directory must be passed as a parameter in the configuration file. Please see the example in the _SIMILARITY-MATRICES_ directory in this source code. 

Pay attention to the structure folders and files in TAR.GZ. The structure must be:

- Dataset.Name-Similarity.Name
-- Split-1
-- Split-2
-- .....
-- Split-10

Before running, untar the file and check this.



### STEP 4
You need to have installed all the Java, Python and R packages required to execute this code on your machine or server. This code does not provide any type of automatic package installation!

You can use the [Conda Environment](https://1drv.ms/u/s!Aq6SGcf6js1mw4hbhU9Raqarl8bH8Q?e=IA2aQs) that I created to perform this experiment. Below are the links to download the files. Try to use the command below to extract the environment to your computer:

```
conda env create -file AmbienteTeste.yaml
```

See more information about Conda environments [here](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html) 

You can also run this code using the AppTainer [container](https://1drv.ms/u/s!Aq6SGcf6js1mw4hcVuz_IN8_Bh1oFQ?e=5NuyxX) that I'm using to run this code in a SLURM cluster. Please, check this [tutorial](https://rpubs.com/cissagatto/apptainer-slurm-r) (in portuguese) to see how to do that. 





### STEP 5
To run this code you will need a configuration file saved in *csv* format and with the following information:

| Config          | Value                                                                            | 
|-----------------|----------------------------------------------------------------------------------| 
| Dataset_Path    | Absolute path to the directory where the dataset's tar.gz is stored              |
| Temporary_Path  | Absolute path to the directory where temporary processing will be performed * 1  |
| Similarity_Path | Absolute path to the directory where the similarities matrices are               |
| Similarity      | Must be "jaccard", "rogers" or another similarity measure                        |
| Dataset_Name    | Dataset name according to *dataset-original.csv* file                            |
| Number_Dataset  | Dataset number according to *dataset-original.csv* file                          |
| Number_Folds    | Number of folds used in cross validation                                         |
| Number_Cores    | Number of cores for parallel processing                                          |


1 - Use directorys like */dev/shm*, *tmp* or *scratch* here.


You can save configuration files wherever you want. The absolute path will be passed as a command line argument.



## Software Requirements
This code was develop in RStudio Version 1.4.1106 © 2009-2021 RStudio, PBC "Tiger Daylily" (2389bc24, 2021-02-11) for Ubuntu Bionic Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) QtWebEngine/5.12.8 Chrome/69.0.3497.128 Safari/537.36. The R Language version was: R version 4.1.0 (2021-05-18) -- "Camp Pontanezen" Copyright (C) 2021 The R Foundation for Statistical Computing Platform: x86_64-pc-linux-gnu (64-bit).

## Hardware Requirements
This code may or may not be executed in parallel, however, it is highly recommended that you run it in parallel. The number of cores can be configured via the command line (number_cores). If number_cores = 1 the code will run sequentially. In our experiments, we used 10 cores. For reproducibility, we recommend that you also use ten cores. This code was tested with the birds dataset in the following machine:

*System:*

Host: bionote | Kernel: 5.8.0-53-generic | x86_64 bits: 64 | Desktop: Gnome 3.36.7 | Distro: Ubuntu 20.04.2 LTS (Focal Fossa)

*CPU:*

Topology: 6-Core | model: Intel Core i7-10750H | bits: 64 | type: MT MCP | L2 cache: 12.0 MiB | Speed: 800 MHz | min/max: 800/5000 MHz Core speeds (MHz): | 1: 800 | 2: 800 | 3: 800 | 4: 800 | 5: 800 | 6: 800 | 7: 800 | 8: 800 | 9: 800 | 10: 800 | 11: 800 | 12: 800 |

Then the experiment was executed in a cluster at UFSCar.

## Results
The results stored in the folder _DENDROGRAMS_ and it will be used in the next phase. The result for a dataset must be put in the folder *DENDROGRAMS* in the respective code. Also, must be in "tar.gz" format.

## RUN
To run the code, open the terminal, enter the *~/Generate-Partitions-Similarities/R* folder, and type

```
Rscript start.R [absolute_path_to_config_file]
```

Example:

```
Rscript start.R "~/Generate-Partitions-Similarities/config-files/jaccard/gj-GpositiveGO.csv"
```

## DOWNLOAD RESULTS
[Click here]


## Acknowledgment
This study is financed in part by the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior - Brasil (CAPES) - Finance Code 001

This study is financed in part by the Conselho Nacional de Desenvolvimento Científico e Tecnológico - Brasil (CNPQ) - Process number 200371/2022-3.

## Links

| [Site](https://sites.google.com/view/professor-cissa-gatto) | [Post-Graduate Program in Computer Science](http://ppgcc.dc.ufscar.br/pt-br) | [Computer Department](https://site.dc.ufscar.br/) |  [Biomal](http://www.biomal.ufscar.br/) | [CNPQ](https://www.gov.br/cnpq/pt-br) | [Ku Leuven](https://kulak.kuleuven.be/) | [Embarcados](https://www.embarcados.com.br/author/cissa/) | [Read Prensa](https://prensa.li/@cissa.gatto/) | [Linkedin Company](https://www.linkedin.com/company/27241216) | [Linkedin Profile](https://www.linkedin.com/in/elainececiliagatto/) | [Instagram](https://www.instagram.com/cissagatto) | [Facebook](https://www.facebook.com/cissagatto) | [Twitter](https://twitter.com/cissagatto) | [Twitch](https://www.twitch.tv/cissagatto) | [Youtube](https://www.youtube.com/CissaGatto) |

## Report Error
Please contact me: elainececiliagatto@gmail.com

# Thanks

