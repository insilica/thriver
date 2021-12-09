library(httr)
library(dplyr)

base_url = "https://thriveapp.health/api"

#' Set your thrive API key.
#'
#' @examples
#' set_thrive_api_key()
set_thrive_api_key <- function() {
  thrive_api_key <<- rstudioapi::askForPassword()
}

#' A check that the API key is set
#' Called in other functions as an initial check
#'
#' @examples
#' api_key_check()
api_key_check <- function() {
  if(!exists("thrive_api_key")) {
    set_thrive_api_key()
  }
}

#' Run a GraphQL Query on the web api
#'
#' @param query A properly formatted GraphQL query
#' @return A R object representing the JSON response
graphql_query <- function(query) {
  api_key_check()
  req <- httr::POST(paste0(base_url,"/graphql"),
                    body = list(query = query), encode="json",
                    httr::add_headers('Authorization'=paste0("Bearer ",thrive_api_key)))

  res <- httr::content(req,as = "parsed", encoding = "UTF-8")

  if(req$status_code != 200) {
    stop(content(req))
  } else if(!is.null(res$errors)){
    stop(res$errors[[1]]$message)
  } else{
    return(res$data)
  }
}

#' Get a patient file from the server and
#' save it locally in getwd().
#'
#' @param url A url representing the location of the file on the Thrive server
#'            Use `get_patient_file_list` to get the proper url and filename for
#'            files associated with a patient
#' @param filename filename to save data to locally
#' @examples get_patient_file("/files/patient/599/d4aa531a-89a0-4720-9060-bb32fa6cecec","report.pdf")
get_patient_file <- function(url,filename) {
  api_key_check()
  httr::GET(paste0(base_url,url),
            httr::add_headers('Authorization' = paste0("Bearer ", thrive_api_key))) %>%
    content("raw") %>%
    writeBin(filename)

  return(paste0(getwd(),"/",filename))
}

#' Upload a file to a patient.
#'
#' @param patient_id patient_id to upload file to
#' @param filename local file to upload
#' @examples post_patient-file(599,"new_report.pdf")
post_patient_file <- function(patient_id,filename) {
  api_key_check()
  req <- httr::POST(paste0(base_url,"/files/patient/",patient_id,"/upload"),
             body = list(file = upload_file(filename)),
             httr::add_headers('Authorization' = paste0("Bearer ", thrive_api_key)),
             encode="multipart")

  if(req$status_code != 200) {
    stop(content(req,"text"))
  } else {
    return(content(req,as="parsed",encoding = "UTF-8"))
  }
}

#' Delete a file associated with a patient. Use caution when using this function
#' as it should only be called to correct mistaken uploads
#'
#' @param patent_id patient_id for whom the file is being deleted
#' @param uuid String representing the UUID of the file to delete
#' @examples delete_patient_file(599,"d4aa531a-89a0-4720-9060-bb32fa6cecec")
delete_patient_file <- function(patient_id,uuid) {
  api_key_check()
  req <- httr::DELETE(paste0(base_url,"/files/patient/",patient_id,"/uuid/",uuid,"/delete"),
               httr::add_headers('Authorization' = paste0("Bearer ", thrive_api_key)))

  if(req$status_code != 200) {
    stop(content(req,"text"))
  } else {
    return(content(req,as="parsed",encoding = "UTF-8"))
  }
}

