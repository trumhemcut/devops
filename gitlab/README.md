## Config LDAP
https://docs.gitlab.com/ce/administration/auth/ldap.html
nano /etc/gitlab/gitlab.rb

## Check LDAP server is working
$ ldapsearch -x -H ldap://192.168.1.107 -b dc=appdynamics,dc=com -D "cn=admin,ou=admins,dc=appdynamics,dc=com" -w Harveynash@123
$ ldapsearch -H ldap://192.168.1.107:389 -D "cn=admin,ou=admins,dc=appdynamics,dc=com" -y Harveynash@123  -b "dc=appdynamics,dc=com" sAMAccountName
## Reconfigure & Restart Gitlab
https://docs.gitlab.com/ee/administration/restart_gitlab.html
$ gitlab-ctl reconfigure
$ gitlab-ctl restart

## Install ldapsearch util
apt-get install ldap-utils

## Install NodeJS to fix command rake
cd ~
curl -sL https://deb.nodesource.com/setup_7.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get install nodejs


## See logs of gitlab
gitlab-ctl tail