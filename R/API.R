library(httr)
library(dplyr)

#' Get all of the patient ids for a practice
#'
#' @param practice_id The practice_id to obtain the list
#' @returns A list of patients ids
#' @examples get_patient_ids(1)
get_patient_ids <- function(practice_id) {
  query <- sprintf("{Practice(id:%s){patients{id}}}",
                      practice_id)
  graphql_query(query)
}

#' Get all of the files associated with a patient
#'
#' @param patient_id the id of the patient to obtain the list for
#' @returns A list of objects containing the filename, url and uuid of each
#'          file associated with a patient
#' @examples get_patient_file_list(4)
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
#' @practice_id The id of the practice to create this patient with
#'
#' @returns An object with new patient id
#' @examples create_patient("Foo","Bar",1)
create_patient <- function(first_name,last_name,practice_id) {
  query <- sprintf("mutation createPatient{createPatient(patient:{firstName:\"%s\",lastName:\"%s\",practiceId:%i}){id}}",
                     first_name,last_name,practice_id)
  graphql_query(query)
}






