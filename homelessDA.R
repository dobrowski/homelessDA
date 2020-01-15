

#### Load libaries -----

library(tidyverse)
library(here)
library(readxl)
library(googlesheets)


### Import data --------


district.list <-  c("75440", "66068", "66092", "66159")  # Soledad  ,So Mo Co , Monterey Peninsula, Salinas Union

# https://www.cde.ca.gov/ds/sd/sd/filescupc.asp  based on Census Day 

districts <- read_excel(here( "data", "cupc1819-k12.xlsx"), sheet = "LEA-Level CALPADS UPC Data", range = "A3:AA2302" ) %>%
    filter(`District Code` %in% district.list)

schools <- read_excel(here( "data", "cupc1819-k12.xlsx"), sheet = "School-Level CALPADS UPC Data", range = "A3:AA10518") %>%
    filter(`District Code` %in% district.list)

homeless <- districts %>%
    bind_rows(schools) %>%
    select(1:7, starts_with("Charter"), starts_with("Total"), Homeless) 

colnames(homeless) <- c("AcademicYear", "CountyCode", "DistrictCode", "SchoolCode", "CountyName", "DistrictName", "SchoolName", "Charter", "CharterNumber", "CharterFunding", "TotalEnrollment", "Homeless")

homeless <- homeless %>%
    filter(Charter != "Yes") %>%
    select(-starts_with("Chart")) %>%
    mutate(Homeless.perc = Homeless * 100 / TotalEnrollment)


for_gs <- sheets_get("1cAlP2NtU_pr2FSlNU2kukf_jDwifuThMG7xYO2-CoJI")

internal.counts <- read_sheet("1cAlP2NtU_pr2FSlNU2kukf_jDwifuThMG7xYO2-CoJI", range = "A2:W36")

