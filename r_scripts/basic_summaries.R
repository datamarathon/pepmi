#!/usr/bin/Rscript

################################################################################
### Basic demographics
##
## Created on: 2014-09-05
## Author: Kazuki Yoshida
################################################################################


### Prepare environment
################################################################################

## Configure parallelization
library(doMC)           # Parallel backend to foreach (used in plyr)
registerDoMC()          # Turn on multicore processing
options(cores = 4)
options(mc.cores = 4)

## Load packages
library(reshape2)
library(magrittr)
library(tableone)
library(dplyr)
library(ggplot2)
library(survival)

## Configure sink()
if (sink.number() != 0) {sink()}
..scriptFileName.. <- gsub("^--file=", "", Filter(function(x) {grepl("^--file=", x)}, commandArgs()))
if (length(..scriptFileName..) == 1) {
    sink(file = paste0(..scriptFileName.., ".txt"), split = TRUE)
}
options(width = 500)


### Load data
################################################################################

## Load data
ltDf <- list(
    icustay_detail     = read.csv("~/mimic2/_merged_files/ICUSTAY_DETAIL.txt"),
    d_patients         = read.csv("~/mimic2/_merged_files/D_PATIENTS.txt"),
    comorbidity_scores = read.csv("~/mimic2/_merged_files/COMORBIDITY_SCORES.txt"),
    demographic_detail = read.csv("~/mimic2/_merged_files/DEMOGRAPHIC_DETAIL.txt"),
    drgevents          = read.csv("~/mimic2/_merged_files/DRGEVENTS.txt")
)

icustay_detail <-
    Reduce(f = function(a,b) {
        ## left  join
        merge(x = a, y = b, all.x = TRUE,  all.y = FALSE)
    },
           ## list
           ltDf)
##
cat("### Overall summary \n")
summary(icustay_detail)

summary(icustay_detail$ICUSTAY_ADMIT_AGE)


## Export ICUSTAY_ID age > 60
write.csv(data.frame(ICUSTAY_ID = icustay_detail[icustay_detail$ICUSTAY_ADMIT_AGE > 60, "ICUSTAY_ID"]),
          file = "~/mimic2/_filtered_files/ICUSTAY_ID_Age_gr_60.txt", row.names = FALSE)


### Add asthma/COPD/dementia
################################################################################

## Create additional comorbidities
ltDfComo <- list(
    asthma    = read.csv("~/mimic2/_sql_results/icd9_asthma.csv"),
    copd      = read.csv("~/mimic2/_sql_results/icd9_copd.csv"),
    dementia  = read.csv("~/mimic2/_sql_results/icd9_dementia.csv"),
    fracture  = read.csv("~/mimic2/_sql_results/icd9_fracture.csv"),
    trauma    = read.csv("~/mimic2/_sql_results/icd9_trauma.csv"),
    decubitus = read.csv("~/mimic2/_sql_results/icd9_decubitus.csv")
)

namesVars <- toupper(names(ltDfComo))

ltDfComo <- lapply(names(ltDfComo), function(name) {
    ## Discard description
    ltDfComo[[name]] <- ltDfComo[[name]][,1:3]
    ##
    ltDfComo[[name]][,3] <- 1
    ##
    names(ltDfComo[[name]])[3] <- toupper(name)
    ##
    unique(ltDfComo[[name]])
})


##
dfComo <-
    Reduce(f = function(a,b) {
        ## outer  join
        merge(x = a, y = b, all.x = TRUE,  all.y = TRUE)
    },
           ## list
           ltDfComo
           )

dfComo[is.na(dfComo)] <- 0


## Merge
icustay_detail <- merge(x = icustay_detail,
                        y = dfComo,
                        all.x = TRUE,  all.y = FALSE # left  join
                        )

## Fill in zero
icustay_detail[,namesVars] <-
    lapply(icustay_detail[,namesVars],
           function(VEC) {

               VEC[is.na(VEC)] <- 0
               VEC
           })



### Tatyana files
################################################################################

## Define a function to remove duplication based on 1st column
RemoveDuplicate1 <- function(DF) {

    DF[!duplicated(DF[1]), ]
}

## Define a function to get file names from a folder
GetFileNamesWoExt <- function(directory) {
    Filter(f = function(elt) {grepl(".csv$", elt)}, x = dir(directory)) %>%
        gsub(pattern = ".csv", replacement = "")
}


## Define a function to sequentially load
LoadFiles <- function(dir_t, vars_t, keep) {
    sapply(vars_t, function(var) {

    paste0(dir_t, var, ".csv") %>%
        read.csv(header = FALSE, nrow = -1) %>%
        RemoveDuplicate1 %>%
        `[`(keep)

}, simplify = FALSE)
}

## Name columns with a variable name
NameCols <- function(ltDf) {

    ltDf <- lapply(names(ltDf), function(name) {
        ## 
        names(ltDf[[name]]) <- c("ICUSTAY_ID",name)
        ltDf[[name]]
    })
    ltDf
}

## Outer merge
OuterMergeLstOfDf <- function(lst) {
    Reduce(f = function(a,b) {
        ## outer  join
        merge(x = a, y = b, all.x = TRUE,  all.y = TRUE)
    },
           ## list
           lst
           )
}


dir_t <- "~/mimic2/_sql_results/tatyana/"
vars_t <- GetFileNamesWoExt(dir_t)


## Keep only ID and value
ltVar_t <- LoadFiles(dir_t, vars_t, c(1,3)) %>% NameCols

## Merge
dfVar_t <- OuterMergeLstOfDf(ltVar_t)


### Sebastian files
################################################################################

dir_s <- "~/mimic2/_sql_results/sebastian/"
vars_s <- GetFileNamesWoExt(dir_s)


## Keep only ID and value
ltVar_s <- LoadFiles(dir_s, vars_s, c(1,4)) %>% NameCols

## Merge
dfVar_s <- OuterMergeLstOfDf(ltVar_s)



### Combine Tatyana and Sebastian files
################################################################################

dfVar <- OuterMergeLstOfDf(list(dfVar_t,dfVar_s))

dfVar[is.na(dfVar)] <- 0



### Merge all together
################################################################################

## Merge
icustay_detail <- merge(x = icustay_detail,
                        y = dfVar,
                        all.x = TRUE,  all.y = FALSE # left  join
                        )

## Fill in zero
icustay_detail[,namesVars] <-
    lapply(icustay_detail[,namesVars],
           function(VEC) {

               VEC[is.na(VEC)] <- 0
               VEC
           })


###

### Export data as CSV
################################################################################
write.csv(x = icustay_detail, file = "./icustay_detail.csv", na = "")



### Basic Statistics
################################################################################
cat("### What ICU unit \n")
summary(icustay_detail$ICUSTAY_FIRST_CAREUNIT)

cat("### Age distribution in each ICU \n")
by(icustay_detail$ICUSTAY_ADMIT_AGE,
   icustay_detail$ICUSTAY_FIRST_CAREUNIT,
   summary)

## DOD: Date of death for the patient. Null if still alive as of March 2009.
## DIED before 3/2009
cat("### death status \n EXPIRE_FLG is death before 3/2009 \n HOSPITAL_EXPIRE_FLG is in-hospital")
xtabs( ~ EXPIRE_FLG + (DOD == "") + HOSPITAL_EXPIRE_FLG, data = icustay_detail)
cat("###  \n")
xtabs( ~ EXPIRE_FLG + HOSPITAL_EXPIRE_FLG, data = icustay_detail)

## Length of stay
cat("### ICU length of stay in hours \n")
with(icustay_detail,
     by(ICUSTAY_LOS/60,
        list(ICUSTAY_FIRST_CAREUNIT),
        summary))

## Demographics
cat("### Table 1 \n")

vars1 <-
    c("HOSPITAL_EXPIRE_FLG" , "GENDER", "EXPIRE_FLG", "SUBJECT_ICUSTAY_TOTAL_NUM", "SUBJECT_ICUSTAY_SEQ", "HOSPITAL_TOTAL_NUM", "HOSPITAL_SEQ", "HOSPITAL_FIRST_FLG", "HOSPITAL_LAST_FLG", "HOSPITAL_LOS", "ICUSTAY_TOTAL_NUM", "ICUSTAY_SEQ", "ICUSTAY_FIRST_FLG", "ICUSTAY_LAST_FLG", "ICUSTAY_ADMIT_AGE", "ICUSTAY_AGE_GROUP", "ICUSTAY_LOS", "ICUSTAY_EXPIRE_FLG", "ICUSTAY_FIRST_CAREUNIT", "ICUSTAY_LAST_CAREUNIT", "ICUSTAY_FIRST_SERVICE", "ICUSTAY_LAST_SERVICE", "HEIGHT", "WEIGHT_FIRST", "WEIGHT_MIN", "WEIGHT_MAX", "SAPSI_FIRST", "SAPSI_MIN", "SAPSI_MAX", "SOFA_FIRST", "SOFA_MIN", "SOFA_MAX", "MATCHED_WAVEFORMS_NUM", "SEX", "CATEGORY", "CONGESTIVE_HEART_FAILURE", "CARDIAC_ARRHYTHMIAS", "VALVULAR_DISEASE", "PULMONARY_CIRCULATION", "PERIPHERAL_VASCULAR", "HYPERTENSION", "PARALYSIS", "OTHER_NEUROLOGICAL", "CHRONIC_PULMONARY", "DIABETES_UNCOMPLICATED", "DIABETES_COMPLICATED", "HYPOTHYROIDISM")

vars2 <- c("RENAL_FAILURE", "LIVER_DISEASE", "PEPTIC_ULCER", "AIDS", "LYMPHOMA", "METASTATIC_CANCER", "SOLID_TUMOR", "RHEUMATOID_ARTHRITIS", "COAGULOPATHY", "OBESITY", "WEIGHT_LOSS", "FLUID_ELECTROLYTE", "BLOOD_LOSS_ANEMIA", "DEFICIENCY_ANEMIAS", "ALCOHOL_ABUSE", "DRUG_ABUSE", "PSYCHOSES", "DEPRESSION", "MARITAL_STATUS_ITEMID", "MARITAL_STATUS_DESCR", "ETHNICITY_ITEMID", "ETHNICITY_DESCR", "OVERALL_PAYOR_GROUP_ITEMID", "OVERALL_PAYOR_GROUP_DESCR", "RELIGION_ITEMID", "RELIGION_DESCR", "ADMISSION_TYPE_ITEMID", "ADMISSION_TYPE_DESCR", "ADMISSION_SOURCE_ITEMID", "ADMISSION_SOURCE_DESCR")

vars <- c(vars1,vars2)

## Make comorbidities factors
comob <- c("CONGESTIVE_HEART_FAILURE", "CARDIAC_ARRHYTHMIAS", "VALVULAR_DISEASE", "PULMONARY_CIRCULATION", "PERIPHERAL_VASCULAR", "HYPERTENSION", "PARALYSIS", "OTHER_NEUROLOGICAL", "CHRONIC_PULMONARY", "DIABETES_UNCOMPLICATED", "DIABETES_COMPLICATED", "HYPOTHYROIDISM", "RENAL_FAILURE", "LIVER_DISEASE", "PEPTIC_ULCER", "AIDS", "LYMPHOMA", "METASTATIC_CANCER", "SOLID_TUMOR", "RHEUMATOID_ARTHRITIS", "COAGULOPATHY", "OBESITY", "WEIGHT_LOSS", "FLUID_ELECTROLYTE", "BLOOD_LOSS_ANEMIA", "DEFICIENCY_ANEMIAS", "ALCOHOL_ABUSE", "DRUG_ABUSE", "PSYCHOSES", "DEPRESSION")

icustay_detail[comob] <- lapply(icustay_detail[comob], factor)

##
cat("###  \n")
cat("### Table 1 \n")
tab1 <- CreateTableOne(vars = vars, strata = "ICUSTAY_FIRST_CAREUNIT", data = icustay_detail)
print(tab1)



### Plotting
################################################################################

cat("###  \n")
cat("### Plotting \n")

pdf(file = "basic_summaries.pdf", width = 7, height = 7, family = "sans")

ggplot(data = icustay_detail,
       mapping = aes(x = ICUSTAY_ADMIT_AGE)) +
           layer(geom = "density") +
           facet_wrap( ~ ICUSTAY_FIRST_CAREUNIT, scales = "free") +
           labs(title = "Age distribution by ICU type") +
           theme_bw() +
           theme(legend.key = element_blank())

ggplot(data = icustay_detail,
       mapping = aes(x = ICUSTAY_ADMIT_AGE, y = ICUSTAY_LOS/60/24)) +
           layer(geom = "point") +
           facet_wrap( ~ ICUSTAY_FIRST_CAREUNIT) +
           labs(title = "stay length in days by age in each ICU units") +
           theme_bw() +
           theme(legend.key = element_blank())

ggplot(data = icustay_detail,
       mapping = aes(x = HOSPITAL_LOS/60/24, y = ICUSTAY_LOS/60/24)) +
           layer(geom = "point") +
           facet_wrap( ~ ICUSTAY_FIRST_CAREUNIT) +
           labs(title = "stay length in days by ICU units") +
           theme_bw() +
           theme(legend.key = element_blank())

ggplot(data = icustay_detail,
       mapping = aes(x = HOSPITAL_EXPIRE_FLG, y = ICUSTAY_ADMIT_AGE)) +
           layer(geom = "boxplot") +
           layer(geom = "point") +
           facet_wrap( ~ ICUSTAY_FIRST_CAREUNIT) +
           labs(title = "age by death in each ICU units") +
           theme_bw() +
           theme(legend.key = element_blank())

dev.off()


################################################################################
## Stop sinking to a file if active
if (sink.number() != 0) {sink()}
