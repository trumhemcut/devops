export HOST_IP=$(ifconfig en0 | grep inet | grep -v inet6 | cut -d ' ' -f2)
echo $HOST_IP git.yourcompany.com | sudo tee -a /private/etc/hosts
echo $HOST_IP ldap.yourcompany.com | sudo tee -a /private/etc/hosts
docker-compose up