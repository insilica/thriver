# thriver <img src="man/figures/logo.png" align="right" height = 150/>

The aim of **thriver** is to make interacting with the Thrive API easy for R users

# Installation

### Prerequisites

**thriver** is currently hosted in a private repo. You must generate a 
GitHub Personal Access Token (PAT) for access.

Navigate to
https://github.com/settings/tokens

Create a PAT

<img src="man/figures/new_personal_access_token.png" height=300/>

Set the PAT key with rstudioapi::askForPassword()
```r
github_pat <<- rstudioapi::askForPassword()
```

### Install

```r
devtools::install_github("insilica/thriver",auth_token=github_pat)
```

# Usage

You will need to request an API key to access the Thrive API. 

### Handling files

You will need the patient id and be a provider in their practice
Obtain a report for a patient by listing their files

```r
thriver::get_patient_file_list(893)
<graphql_query>
#> List of 1
#> $ data:List of 1
#>  ..$ Patient:List of 1
#>  .. ..$ files:List of 1
#>  .. .. ..$ :List of 3
#>  .. .. .. ..$ filename: chr "TCGA.PRAD.mutect.deca36be-bf05-441a-b2e4-394228f23fbe.DR-10.0.somatic.case_id.75a7afb5-66d5-47e3-8a8a-3e3a1e749a96.maf"
#>  .. .. .. ..$ url     : chr "/files/patient/893/12f7193b-e81e-4eef-8fdb-c683d21de3ce"
#>  .. .. .. ..$ uuid    : chr "12f7193b-e81e-4eef-8fdb-c683d21de3ce"
```  

Obtain the report
```r
thriver::get_file("12f7193b-e81e-4eef-8fdb-c683d21de3ce","TCGA.PRAD.mutect.deca36be-bf05-441a-b2e4-394228f23fbe.DR-10.0.somatic.case_id.75a7afb5-66d5-47e3-8a8a-3e3a1e749a96.maf")
#> [1] "/Users/james/Insilica/thrive-R/TCGA.PRAD.mutect.deca36be-bf05-441a-b2e4-394228f23fbe.DR-10.0.somatic.case_id.75a7afb5-66d5-47e3-8a8a-3e3a1e749a96.maf"
```

Upload a new report for the patient
```r
thriver::post_file(893,"~/Gene_Report.pdf")
#> $success
#> [1] TRUE
```

Report should be present
```r
thriver::get_patient_file_list(893)
#> <graphql_query>
#> List of 1
#> $ data:List of 1
#>  ..$ Patient:List of 1
#>  .. ..$ files:List of 2
#>  .. .. ..$ :List of 3
#>  .. .. .. ..$ filename: chr "TCGA.PRAD.mutect.deca36be-bf05-441a-b2e4-394228f23fbe.DR-10.0.somatic.case_id.75a7afb5-66d5-47e3-8a8a-3e3a1e749a96.maf"
#>  .. .. .. ..$ url     : chr "/files/patient/893/12f7193b-e81e-4eef-8fdb-c683d21de3ce"
#>  .. .. .. ..$ uuid    : chr "12f7193b-e81e-4eef-8fdb-c683d21de3ce"
#>  .. .. ..$ :List of 3
#>  .. .. .. ..$ filename: chr "Gene_Report.pdf"
#>  .. .. .. ..$ url     : chr "/files/patient/893/bfd58c83-6449-4e12-bf03-ce45fbc067a1"
#>  .. .. .. ..$ uuid    : chr "bfd58c83-6449-4e12-bf03-ce45fbc067a1"
```

That report was incorrect, delete it!
```r
thriver::delete_file(893,"bfd58c83-6449-4e12-bf03-ce45fbc067a1")
#> $success
#> [1] TRUE
```

Chaos averted, order restored
```r
thriver::get_patient_file_list(893)
#> <graphql_query>
#> List of 1
#> $ data:List of 1
#>  ..$ Patient:List of 1
#>  .. ..$ files:List of 1
#>  .. .. ..$ :List of 3
#>  .. .. .. ..$ filename: chr "TCGA.PRAD.mutect.deca36be-bf05-441a-b2e4-394228f23fbe.DR-10.0.somatic.case_id.75a7afb5-66d5-47e3-8a8a-3e3a1e749a96.maf"
#>  .. .. .. ..$ url     : chr "/files/patient/893/12f7193b-e81e-4eef-8fdb-c683d21de3ce"
#>  .. .. .. ..$ uuid    : chr "12f7193b-e81e-4eef-8fdb-c683d21de3ce"
```








