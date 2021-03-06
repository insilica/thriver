% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/client.R
\name{get_file}
\alias{get_file}
\title{Get a patient file from the server and
save it locally in getwd().}
\usage{
get_file(url, filename)
}
\arguments{
\item{url}{A uri representing the location of the file on the Thrive server
Use `get_patient_file_list` to get the proper url and filename for
files associated with a patient}

\item{filename}{filename to save data to locally}
}
\value{
A string representing the location of the file locally
}
\description{
Get a patient file from the server and
save it locally in getwd().
}
\examples{
get_file("http://localhost:3001/files/patient/628/ed2b036a-63ea-4d0a-84b9-ea1cc7109db0/image\%20(1).png",
                            "image (1).png")
}
