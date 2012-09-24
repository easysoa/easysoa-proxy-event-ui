#Must start with a Maj else it doesnt work

Request_for_get_nuxeo_current_user = "SELECT * FROM Document WHERE ecm:path=/default-domain/UserWorkspaces/@{CurrentUser.name}"
Request_for_get_all_nuxeo_services = "SELECT * FROM Service"
Service_Endpoint_URL_property_name = "serv:url"

# new model :
#Request_for_get_all_nuxeo_services = ""
#Service_Endpoint_URL_property_name = "endp:url"