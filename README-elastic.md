
https://172.17.2.200:5601/
elastic:Zaebuj12345+-
# Elastic

https://www.elastic.co/docs/solutions/security/manage-elastic-defend/endpoints


[GOAD with VMware on Windows — Elastic 8 & Agents](https://medium.com/@m4uz/goad-with-vmware-on-windows-elastic-8-agents-8faeb467ba24)
[GOAD-ELK-Update](https://github.com/m4uz/GOAD-ELK-Update/tree/main)
[Setting Up Elastic 8 with Kibana, Fleet, Endpoint Security, and Windows Log Collection](https://www.youtube.com/watch?v=Ts-ofIVRMo4)

swisskyrepo.github.io/InternalAllTheThings/redteam/evasion/elastic-edr/#setup
https://github.com/peasead/elastic-container


https://172.17.2.200:5601/

 curl -k --request GET \
   --url 'https://127.0.0.1:5601/api/fleet/enrollment_api_keys' \
   -u elastic:Zaebuj12345+- \
   --header 'Content-Type: application/json' \
   --header 'kbn-xsrf: xx'


https://www.elastic.co/docs/reference/fleet/fleet-api-docs#create-agent-policy-api

curl -k --request GET    --url 'https://127.0.0.1:5601/api/fleet/agent_policies'    -u elastic:Zaebuj12345+-    --header 'Content-Type: application/json'    --header 'kbn-xsrf: xx' | jq
