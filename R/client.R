library(httr)
library(keyring)
library(jsonlite)
library(utils)
base_url = "https://thriveapp.health/api"

#' Set your thrive API key.
#' @export
set_thrive_api_key <- function() {
  keyring::key_set(service = "thrive_api_key",prompt = "Thrive API Key:")
}

#' Get your thrive API key
#' @export
get_thrive_api_key <- function() {
  keyring::key_get(service = "thrive_api_key")
}

#' A check that the API key is set
#' Called in other functions as an initial check
#'
#' @export
#' @examples api_key_check()
api_key_check <- function() {
  if(length(keyring::key_list(service="thrive_api_key")$service) == 0)
   {
    set_thrive_api_key()
   }
}

#' Run a GraphQL Query on the web api
#'
#' @param query A properly formatted GraphQL query
#' @return An S3 graphql_query object
#' @export
graphql_query <- function(query) {
  api_key_check()
  resp <- httr::POST(paste0(base_url,"/graphql"),
                    body = list(query = query), encode="json",
                    httr::add_headers('Authorization'=paste0("Bearer ",get_thrive_api_key())))

  parsed <- jsonlite::fromJSON(httr::content(resp, "text",encoding="UTF-8"), simplifyVector = FALSE)

  if(resp$status_code != 200) {
    stop(httr::content(resp))
  } else if(!is.null(parsed$errors)){
    stop(parsed)
  }

  structure(
    list(
      content = parsed,
      response = resp
    ),
    class = "graphql_query"
  )
}

#'
#' @export
print.graphql_query <- function(x, ...) {
  cat("<graphql_query>\n")
  str(x$content)
  invisible(x)
}

#' Get a patient file from the server and
#' save it locally in getwd().
#'
#' @param url A uri representing the location of the file on the Thrive server
#'            Use `get_patient_file_list` to get the proper url and filename for
#'            files associated with a patient
#' @param filename filename to save data to locally
#' @return A string representing the location of the file locally
#' @examples get_file("http://localhost:3001/files/patient/628/ed2b036a-63ea-4d0a-84b9-ea1cc7109db0/image%20(1).png",
#'                             "image (1).png")
#' @export
get_file <- function(url,filename) {
  api_key_check()
  httr::GET(URLencode(url),
            httr::add_headers('Authorization' = paste0("Bearer ", get_thrive_api_key()))) |>
    httr::content("raw") |>
    writeBin(filename)

  return(paste0(getwd(),"/",filename))
}

#' Upload a file to a patient.
#'
#' @param patient_id patient_id to upload file to
#' @param filename local file to upload
#' @return JSON of the response
#' @examples post_patient-file(599,"new_report.pdf")
#' @export
post_file <- function(patient_id,filename) {
  api_key_check()
  resp <- httr::POST(paste0(base_url,"/files/patient/",patient_id,"/upload"),
                    body = list(file = httr::upload_file(filename)),
                    httr::add_headers('Authorization' = paste0("Bearer ", get_thrive_api_key())),
                    encode="multipart")
  parsed <- jsonlite::fromJSON(httr::content(resp, "text",encoding="UTF-8"), simplifyVector = FALSE)

  if(resp$status_code != 200) {
    stop(httr::content(resp,"text"))
  } else {
    return(parsed)
  }
}

#' Delete a file associated with a patient. Use caution when using this function
#' as it should only be called to correct mistaken uploads
#'
#' @param patent_id patient_id for whom the file is being deleted
#' @param uuid String representing the UUID of the file to delete
#' @return The JSON response
#' @examples delete_patient_file(599,"d4aa531a-89a0-4720-9060-bb32fa6cecec")
#' @export
delete_file <- function(patient_id,uuid) {
  api_key_check()
  resp <- httr::DELETE(paste0(base_url,"/files/patient/",patient_id,"/uuid/",uuid,"/delete"),
               httr::add_headers('Authorization' = paste0("Bearer ", get_thrive_api_key())))

  parsed <- jsonlite::fromJSON(httr::content(resp, "text",encoding="UTF-8"), simplifyVector = FALSE)

  if(resp$status_code != 200) {
    stop(httr::content(resp,"text"))
  } else {
    return(parsed)
  }
}
