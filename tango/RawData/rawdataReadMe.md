# RawData Directory:

## 1. Introduction and General Notes:
- This directory is a place to keep your raw read files, typically stored in .fq or fq.gz format.
- Currently, any .fq or .fq.gz files in the root of RawData/ will be ingnored from tracking in git. 
- Further, any subdirectories are assumed to contain raw read files and will be ignored from tracking as well. 



## 2. Directory Structure:

- Currently the directory structure that this pipeline will want is subdirectories for each one of your samples.
- This name should match the .fq file names and also be the same as is listed in your metadata file.
- The subdirectories match the typical file structure post data release from a sequencing core.


```
# It might look something like this:

tango/RawData/
├── Sample1_1
│   ├── Sample1_1_1.fq.gz
│   ├── Sample1_1_2.fq.gz
│   └── MD5.txt
├── Sample1_2
│   ├── Sample1_2_1.fq.gz
│   ├── Sample1_2_2.fq.gz
│   └── MD5.txt
├── Sample1_3
│   ├── Sample1_3_1.fq.gz
│   ├── Sample1_3_2.fq.gz
│   └── MD5.txt
├── Sample1_4
│   ├── Sample1_4_1.fq.gz
│   ├── Sample1_4_2.fq.gz
│   └── MD5.txt
└── rawdataReadMe.txt

```
- In the above example, Sample1_1 is the first biological replicate of say treatment or timepoint 1. Following, Sample 1_2 is the second biological replicate for treatment 1, and so on. The _1.fq.gz and _2.fq.gz tags refer to the pair-end nature of the sequencing files, one for F and one for R of each read. 

- This pipeline is designed to work with paired end data, single end data is not guarrenteed to work, user bewares.