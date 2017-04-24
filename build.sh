export HOST_IP=$(ifconfig en0 | grep inet | grep -v inet6 | cut -d ' ' -f2)

HOST_NAMES[0]="git.yourcompany.com"
HOST_NAMES[1]="ldap.yourcompany.com"
HOST_NAMES[2]="jenkins.yourcompany.com"
HOST_NAMES[3]="hub.yourcompany.com"
HOST_NAMES[4]="teamcity.yourcompany.com"

ci_tool='teamcity'

for HOST_NAME in ${HOST_NAMES[@]}
do
    if grep $HOST_NAME /etc/hosts
    then
        # echo 'HOST_NAME EXISTS: ' $HOST_NAME
        sed -i '' "/$HOST_NAME/ s/.*/$HOST_IP $HOST_NAME/g" /private/etc/hosts
    else
        # echo 'HOST_NAME DOESN'' EXIST: ' $HOST_NAME
        echo $HOST_IP $HOST_NAME >> /private/etc/hosts
    fi
done

docker-compose -f docker-compose.yml -f docker-compose.${ci_tool}.yml up