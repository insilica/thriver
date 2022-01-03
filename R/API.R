library(httr)
library(dplyr)

#' Get all of the patient ids for a practice
#'
#' @param practice_id The practice_id to obtain the list
#' @returns graphql_query S3 object
#' @examples get_patient_ids(1)
#' @export
get_patient_ids <- function(practice_id) {
  query <- sprintf("{Practice(id:%s){patients{id}}}",
                      practice_id)
  graphql_query(query)
}

#' Get all of the files associated with a patient
#'
#' @param patient_id the id of the patient to obtain the list for
#' @returns graphql_query S3 object
#' @examples get_patient_file_list(4)
#' @export
get_patient_file_list <- function(patient_id) {
  query <- sprintf("{Patient(id:%s){files{filename,url,uuid}}}",patient_id)
  graphql_query(query)
}

#' Create a new patient. The patient will be associated
#' with the provider corresponding to the Thrive API key
#' in current use
#'
#' @param first_name First Name of patient
#' @param last_name Last Name of patient
#' @param practice_id The id of the practice to create this patient with
#'
#' @returns graphql_query S3 object
#' @examples create_patient("Foo","Bar",1)
#' @export
create_patient <- function(first_name,last_name,practice_id) {
  query <- sprintf("mutation createPatient{createPatient(patient:{firstName:\"%s\",lastName:\"%s\",practiceId:%i}){id}}",
                     first_name,last_name,practice_id)
  graphql_query(query)
}

#' Get all of the patient reports for a practice.
#'
#' @param practice_id The practice id to obtain reports for
#' @return graphql_query S3 object
#' @examples get_patient_reports(1)
#' @export
get_patient_reports <- function(project_id) {
  query <- sprintf("{PracticePatientReports(practiceId:%s) {patientReports {patient {mrn firstName lastName}
dropoutRisk relapseRisk}}}",project_id)
  graphql_query(query)
}


