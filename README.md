# DevOps for outsourcing companies
You're an outsourcing company and you want to use open source software to save cost. Such as, Gitlab & Slack for colloboration tool & source control, Jenkins for build & deployment tool, Docker as environment provisioning tool...

I've tried to set everything up by using Docker in a single machine. But hopefully you can scale out to a Docker Swarm cluster for production use as well (I haven't tried it yet).

This repo is folked from https://github.com/marcelbirkner/docker-ci-tool-stack

## Usage
### Prerequisites
* Install Docker & docker-compose
* A Linux / Mac will be best suited. I haven't tried on Windows yet

### Provisioning everything up by docker-compose
```
$ git clone https://github.com/trumhemcut/devops.git && cd devops
$ docker-compose up --build
```
It may take sometimes depending on the network connection to pull images & build the containers. If everything is ok, Docker will provision the following containers:
- **nt-openldap**: An open LDAP server with some default credentials for you to use.
- **nt-ldapadmin**: A webserver connects to LDAP to be easily manage the LDAP server such as creating new account, update password, etc...
- **nt-gitlab**: A standalone Gitlab server connected to the LDAP server & ready to use.
- **nt-jenkins**: A pre-configured Jenkins server with some project templates (in C# & NodeJS) so that you can easily inherit & clone for new projects.
- **and more containers will be added ...** 
### 

## Customizations
### LDAP Server
Usually, your company has already setup a LDAP Server for using. But it's still neccessary to get this LDAP Server up & running for testing purpose. Assuming you're working on this activity because you're looking for a new way to build a DevOps flow for your company. In that case I would suggest to keep this LDAP container running to test.

This LDAP container runs on the standard LDAP port 389 & 636. Instead working directly with LDAP Server, the webserver LDAP admin will connect to that LDAP Server and is available for us to manage the LDAP Server.

To double-check the LDAP is working correctly, I've usually used the commands below:
```
$ docker exec -it nt-openldap bash
$ ldapsearch -x -H ldap://nt-openldap -b dc=yourcompany,dc=com -D "cn=admin,ou=admins,dc=yourcompany,dc=com" -w Company@123
$ ldapsearch -x -H ldap://ldap.yourcompany.com -b dc=yourcompany,dc=com -D "cn=admin,ou=admins,dc=yourcompany,dc=com" -w Company@123
```

Preconfigured user list:
`Company@123` is the password for all Users
```
phihuynh, phuongle: Administrators
user1, user2: Read Only
user1: Group1
user1, user2, user3: Group2
```

## Jenkins
https://github.com/jenkinsci/docker
https://github.com/jenkinsci/docker/issues/263
https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/

Bai rat hay de link tu JENKINS qua Gitlab
https://github.com/jenkinsci/gitlab-plugin/wiki/Setup-Example

Bai rat hay de link tu gitlab qua JIRA

Jenkins & Docker volume & sibbling containers
https://stackoverflow.com/questions/42946067/how-to-mount-docker-volume-with-jenkins-docker-container

## Gitlab
https://docs.gitlab.com/omnibus/docker/README.html

## Install Nodejs on Debian
https://github.com/nodesource/distributions