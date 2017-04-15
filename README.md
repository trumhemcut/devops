# DevOps for outsourcing companies
You're an outsourcing company and you want to use open source software to save cost. Such as, Gitlab & Slack for colloboration tool & source control, Jenkins for build & deployment tool, Docker as environment provisioning tool...

I've tried to setup everything up by using Docker in a single machine. But you can scale out to a Docker Swarm cluster as well (I haven't tried it yet).

This repo is folked from https://github.com/marcelbirkner/docker-ci-tool-stack

## Usage
### Prerequisites
* Install Docker & docker-compose
* A Linux / Mac will be best suited. I haven't tried on Windows yet

### Provisioning everything up by docker-compose
```
$ docker-compose up --build
```
After you run the above command, Docker will provision following containers:
- **nt-openldap**: An open LDAP server with some default credentials for you to use.
- **nt-ldapadmin**: A webserver connects to LDAP to be easily manage the LDAP server such as creating new account, update password, etc...
- **nt-gitlab**: A standalone Gitlab server connected to the LDAP server & ready to use.
- **nt-jenkins**: A pre-configured Jenkins server with some project templates (in C# & NodeJS) so that you can easily inherit & clone for new projects.
- **and more containers will be added ...** 
### 

## Customizations
### LDAP Server
[TBD]
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