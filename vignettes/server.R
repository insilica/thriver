#* listen for events relevant to your application
#* @post /thrive/webhook
#* @serializer unboxedJSON
function(req){
  json <- (req$body)
  print(paste0(Sys.time(),": The patient id is: ", json$patientId))
  print(paste0(Sys.time(),": The event-type is: ", json$eventType))
  # ... your code here
}
