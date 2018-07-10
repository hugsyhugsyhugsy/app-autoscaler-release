# export http_proxy=http://guest:123456@yingrtptest.rtp.raleigh.ibm.com:40000
# export https_proxy=http://guest:123456@yingrtptest.rtp.raleigh.ibm.com:40000
# export no_proxy=192.168.50.6
# echo "set ---" 

# cf api https://api.bosh-lite.com --skip-ssl-validation
# cf auth admin admin
# cf target -o system -s dev

# ./api.sh node1 metrics 1 10000 memoryused
# ./api.sh node1 metrics 1 10000 responsetime
# ./api.sh node1 metrics 1 10000 throughput

# res.header("Access-Control-Allow-Origin", "*");
#     res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS');
#     res.header("Access-Control-Allow-Headers", "X-Requested-With");
#     res.header('Access-Control-Allow-Headers', 'Content-Type');

set -x

api=$1
appname=$2
action=$3
page=$4
perpage=$5
metricname=$6
 #"bosh-lite.com"

from=0  #$((($(date +%s)-1800)*1000000000))
#from=1521596468000000000 #Wed Mar 21 01:41:08 UTC 2018 $((($(date +%s)-2*3600)*1000000000))
 to=1999999999999999999 #\ #$(($(date +%s)*1000000000))
#to=1521603668000000000 #Wed Mar 21 03:41:08 UTC 2018 $(($(date +%s)*1000000000))


appid=$(cf app $appname --guid)
token=$(cf oauth-token)

if [[ $action == 'policy' ]]
	then
	curl -w %{http_code} -s -X GET "http://autoscaler.${api}/v1/apps/$appid/policy" -H "Authorization: $token"
	# curl -s -X GET "http://autoscaler.${api}/v1/apps/$appid/policy" -H "Authorization: $token"
elif [[ $action == 'set' ]]
	then
	curl -w %{http_code} -s -X PUT "http://autoscaler.${api}/v1/apps/$appid/policy" -d @policy.json -H "Authorization: $token"
	# curl -s -X PUT "http://autoscaler.${api}/v1/apps/$appid/policy" -d @policy.json -H "Authorization: $token"
elif [[ $action == 'history' ]]
	then
	curl -w %{http_code} -s -X GET "http://autoscaler.${api}/v1/apps/$appid/scaling_histories?start-time=1494989539138350432&end-time=2494989539138350432&page=$3&results-per-page=$4&order=desc" -H "Authorization: $token"
elif [[ $action == 'metrics' ]]
	then
	curl -s -X GET "http://autoscaler.${api}/v1/apps/$appid/metric_histories/${metricname}?start-time=${from}&end-time=${to}&page=${page}&results-per-page=${perpage}&order=desc" -H "Authorization: $token" > throughput
fi

# curl -s -X PUT "http://autoscaler.${api}/v1/apps/8e65d69b-2155-4c94-8657-862e3cb4f19d/policy" -d @policy.json  -H "Authorization: bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImtleS0xIiwidHlwIjoiSldUIn0.eyJqdGkiOiIzOGVhZmU4OTViMTU0NTE3ODJkNzU1NTZjMThhZjQzNiIsInN1YiI6IjY2ZWIzNTkyLTY4NTQtNGZiYy04OTBhLWQwMTA1NTRiOTVmMCIsInNjb3BlIjpbIm9wZW5pZCIsInJvdXRpbmcucm91dGVyX2dyb3Vwcy53cml0ZSIsInNjaW0ucmVhZCIsImNsb3VkX2NvbnRyb2xsZXIuYWRtaW4iLCJ1YWEudXNlciIsInJvdXRpbmcucm91dGVyX2dyb3Vwcy5yZWFkIiwiY2xvdWRfY29udHJvbGxlci5yZWFkIiwicGFzc3dvcmQud3JpdGUiLCJjbG91ZF9jb250cm9sbGVyLndyaXRlIiwibmV0d29yay5hZG1pbiIsImRvcHBsZXIuZmlyZWhvc2UiLCJzY2ltLndyaXRlIl0sImNsaWVudF9pZCI6ImNmIiwiY2lkIjoiY2YiLCJhenAiOiJjZiIsImdyYW50X3R5cGUiOiJwYXNzd29yZCIsInVzZXJfaWQiOiI2NmViMzU5Mi02ODU0LTRmYmMtODkwYS1kMDEwNTU0Yjk1ZjAiLCJvcmlnaW4iOiJ1YWEiLCJ1c2VyX25hbWUiOiJhZG1pbiIsImVtYWlsIjoiYWRtaW4iLCJyZXZfc2lnIjoiOGRjNGI2OGMiLCJpYXQiOjE1MjQwNDExMDIsImV4cCI6MTUyNDA0MTcwMiwiaXNzIjoiaHR0cHM6Ly91YWEuYm9zaC1saXRlLmNvbS9vYXV0aC90b2tlbiIsInppZCI6InVhYSIsImF1ZCI6WyJzY2ltIiwiY2xvdWRfY29udHJvbGxlciIsInBhc3N3b3JkIiwiY2YiLCJ1YWEiLCJvcGVuaWQiLCJkb3BwbGVyIiwicm91dGluZy5yb3V0ZXJfZ3JvdXBzIiwibmV0d29yayJdfQ.Kon1YubJwbto3ysh5l0QuVRklIsVx59l8dRPUyBHPpy9LN8ZMZJP9qggtY0q3z5ljXZ4Vgw2OCP6sthvg-atrV_ItPQ2oYrWX6zYo40SLSrnKgaTvt9Pah6f6NGaWTDNipt3VxYilG8XQEBCwDWBgsdyANi7Boh1_nPfTgJyimWOBcsLpbMrKqEUUloPtcO7cTOfYpA0eToVrB1RoF77NKVLyXOdwDOGFnSqzeebmslMKkMktYFTb3PnwnpYbDcykmNvOsn0QN-BWXMB-PJqJ-8Szjd262X_BYo3yCtheJKgH4sjqbB0QynDNlEDFHmMBziKV28cumHMHr1Yifeorg"

# for line in `./api.sh node1 metrics 1 50 | jq '.resources[].timestamp'`
# do
# date -r ${line:0:10} -u
# done

#memoryused
# Wed Mar 21 02:57:28 UTC 2018
# Wed Mar 21 02:57:13 UTC 2018
# Wed Mar 21 02:56:58 UTC 2018
# Wed Mar 21 02:56:43 UTC 2018

#throughput
# Wed Mar 21 02:57:54 UTC 2018
# Wed Mar 21 02:57:24 UTC 2018
# Wed Mar 21 02:56:54 UTC 2018
# Wed Mar 21 02:56:24 UTC 2018
# Wed Mar 21 02:55:54 UTC 2018


# 1524064539


