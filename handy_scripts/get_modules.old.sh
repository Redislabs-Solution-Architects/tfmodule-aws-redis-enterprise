export REDIS_SERVER='40.88.133.113'
curl -v -k -L -u admin@redis.com:redis123 -H "accept:application/json"  https://${REDIS_SERVER}:9443/v1/modules
