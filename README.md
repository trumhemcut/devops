# DevOps for outsourcing companies
You're an outsourcing company and you want to use open source software to save cost. Such as, Gitlab & Slack for colloboration tool & source control, Jenkins for build & deployment tool, Docker as environment provisioning tool...

I've tried to set everything up by using Docker in a single machine. But hopefully you can scale out to a Docker Swarm cluster for production use as well (I haven't tried it yet).

This repo is folked from https://github.com/marcelbirkner/docker-ci-tool-stack

## Usage
### Prerequisites
* Install Docker & docker-compose
* A Linux / Mac will be best suited. I haven't tried on Windows yet

### Provisioning everything up by running ```./build.sh```
```
$ git clone https://github.com/trumhemcut/devops.git && cd devops
$ sudo ./build.sh
```
It requires to run with admin user because it will add some hostnames to the /etc/hosts:
* git.yourcompany.com (for Gitlab)
* ldap.yourcompany.com (for LDAP Server)
* jenkins.yourcompany.com (for Jenkins Server)
* hub.yourcompany.com (for Docker Registry Local Hub)

The purpose of this is to simulate the real environment when you're working on the company.

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
# Assume you've run the ./build.sh command
$ docker exec -it nt-openldap bash
$ ldapsearch -x -H ldap://nt-openldap -b dc=yourcompany,dc=com -D "cn=admin,ou=admins,dc=yourcompany,dc=com" -w Company@123
$ ldapsearch -x -H ldap://ldap.yourcompany.com -b dc=yourcompany,dc=com -D "cn=admin,ou=admins,dc=yourcompany,dc=com" -w Company@123
```

Preconfigured user list:
`Company@123` is the password for all Users
```
phihuynh, phuongle: Administrators
thangchung, thiennguyen: Read Only
thiennguyen: Group1
thiennguyen, thangchung, phuongle: Group2
```

### LDAP Web Admin
To login to LDAP Web Admin, access to the url http://ldap.yourcompany.com:8082/, click login. Then fill the ```Login DN``` && ```Password```:

* ```Login DN```: cn=admin,ou=admins,dc=yourcompany,dc=com
* ```Password```: Company@123

From here, you can create new account, change password, create new group, move users to groups, etc...

In case you are confident to config the LDAP Server via LDAP CLI, then you can remove this container in the ```docker-compose.yml```

### Gitlab
The Gitlab server is available at http://git.yourcompany.com. Beware that the ```build.sh``` has added the domain git.yourcompany.com to your hosts file & expose the port 80 from **gitlab** container. At the first time login to the gitlab server, you will be prompted to reset password of **root** account which is administrator. Be aware that Gitlab hasn't been using the default username & password ```root/5iveL!fe``` anymore, so you have to prompt new password for the first time setting up. (See https://gitlab.com/gitlab-org/gitlab-ce/issues/1980)

The **gitlab** server has been also setup to connect to LDAP Server, so you can login to gitlab with the credentials from LDAP server such as:

**Root user:**

Username | Password
--- | ---
root | ```Your reset password```

**Username & password from LDAP:**

Username | Password | Group
--- | --- | ---
phihuynh | Company@123 | admin
phuongle | Company@123 | admin
thiennguyen | Comapny@123 | users
thangchung | Company@123 | users

When you login to Gitlab using LDAP account for the first time, you may need the administrator update your email since I haven't set the email server yet. It's a bit annoying & I'm trying to solve it. To update email, login as administrator (root account) & go to **Admin area**, select **users**, select LDAP account, click **Edit** & then update email & Save.

The LDAP account is now can join to the projects.

### Jenkins
To use Blueocean (new version of Jenkins), you have to login with an account. Otherwise, you can only work with Github project rather than Git project.

Currently if you're using git with Blueoean, you're still not able to use the pipeline editor functionality (currently support Github). See here for more details: https://issues.jenkins-ci.org/browse/JENKINS-43148

Some options has already setup:
* **Plugins**: blueocean, gitlab
* **Software**: dotnet sdk, Docker (ready to integrate with Docker host), nodejs

There're 2 things you can integrate with Gitlab:
* Auto-build when there're pushes to Gitlab: 
    - Go to the Gitlab, choose user profile who has at least Developer right to the repositories. Then choose **Access Tokens**, input the **Name** (eg. Jenkins), chose **Expires at** some date of the year 2020, choose both scopes **api** & **read_user**. Then **Create Personal Access Token**.
    - Go to Jenkins, **Credentials**, **System**, **Global Credentials**, **Add Credentials**, Kind Secret Text, **Secret** is the Personal Access Token (from Gitlab), put an **ID** (eg. Gitlab) then **OK**.
    - Go back Manage Jenkins, **Configure System**, scroll down to Gitlab plugin, input **connection name** (eg. Gitlab), **Gitlab host URL** is http://git.yourcompany.com, **Credentials** is Gitlab (which you've just set above), click **Test Connection** to see it works. Then click **Save**.
    - For the project to setup push event, go to **Configure**, **Build Triggers**, check **Build when a change is pushed to Gitlab**, click **Advanced**, click **Generate**, copy the secret token & Gitlab CI Service URL
    - Go back to Gitlab to the repository where we want to integrate with. Click setting icon, choose **Integrations**, input the **URL** (Gitlab CI Service URL) and **secret token**. Click **Add Web Hook** then click **Test**. You'll see an build action in Jenkins to prove it works.
* Notify Gitlab about the build result:
    - Go back to Jenkins, chooose the project, click configure, at the post build step, click **Publish build status to Gitlab commit**

#### Note about Dockerfile.local
I also created a Dockerfile.local because I have a slow experiemnt when downloading the dotnet SDK package. That's why I have to copy it locally to the image rather than downloading directly. In case you have the same experiment like me, it will be useful. To point to Dockerfile.local, open ```docker-compose.yml```, change from:
```
  jenkins:
    container_name: nt-jenkins
    build: 
      context: ./jenkins
      dockerfile: Dockerfile
```

to:

```
  jenkins:
    container_name: nt-jenkins
    build: 
      context: ./jenkins
      dockerfile: Dockerfile.local
```

#### Note about adding Gitlab Plugin Connection
I created files call ```com.dabsquared.gitlabjenkins.connection.GitLabConnectionConfig.xml``` & ```credentials.xml```, copy them to the Dockerfile in progress of creating the Jenkins image. That means when the Jenkins container is up, it will have the Gitlab connection automatically. But of course, this is a hardcode configuration and the token is generated from the account ```phihuynh/Company@123``` with the command:

```
$ curl http://git.yourcompany.com/api/v3/session/ --data-urlencode 'login=phihuynh' --data-urlencode 'password=Company@123' | jq

{
  "name": "phihuynh",
  "username": "phihuynh",
  "id": 2,
  ...
  "external": false,
  "private_token": "ymX_LJEGMfUW_nd8CJAy"
}

```

### Slack Integration with Jenkins

Jenkins can push notifications to Slack & Slack can do some action by sending commands to Jenkins. The Slack plugin has been installed in Jenkins automatically & it was setup to send to trumhemcut.slack.com, channel #devops. 

To change the configuration to another Slack channel, just go to Slack > **App Directory** > Search for **Incoming Webhooks**> **Add Configuration** > **Add Incoming WebHooks integration**. From there copy the URL & token & paste back to Jenkins Configuration for Slack.

Go back to Jenkins, **Mange Jenkins** > **Configure System** > Scroll down to **Global Slack Notifier Settings** & input **Base URL** is the URL copied from Slack Incoming WebHook, **team subdomain** is the subdomain you created for the slack account, **integration token** is the token you've just copied, channel is the channel you copied from the Slack & click **Test Connection** to see it works.

### TeamCity

Beside Jenkins, TeamCity is very powerful CI Tool. This Jenbrains' product allows you to use for free with the option: up to 20 build configurations, 3 build agents. I think it's enough for small & medium size projects.

To setup Teamcity server up, you just change the variable ```ci_tool=teamcity``` then run the ```su ./build.sh``` to get the environment up. That's it!

After the TeamCity is up, you browse to the website http://teamcity.yourcompany.com:8111 & setup the database, credential of admin for the first time. Then the TeamCity Agent will automatically connect to the TeamCity Server.

The TeamCity Agent has built-in features such as .NET Core support, NodeJS support.

### Reference sources
Some useful links about Jenkins & Gitlabs:
https://github.com/jenkinsci/docker
https://github.com/jenkinsci/docker/issues/263
https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
https://github.com/jenkinsci/gitlab-plugin/wiki/Setup-Example
https://stackoverflow.com/questions/42946067/how-to-mount-docker-volume-with-jenkins-docker-container
https://docs.gitlab.com/omnibus/docker/README.html

