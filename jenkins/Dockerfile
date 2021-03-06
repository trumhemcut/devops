FROM jenkinsci/jenkins:lts

USER root
RUN apt-get update \
      && apt-get install -y sudo curl\
      && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

# getting the docker-cli
# --- Attention: docker.sock needs to be mounted as volume in docker-compose.yml
# see: https://issues.jenkins-ci.org/browse/JENKINS-35025
# see: https://get.docker.com/builds/
# see: https://wiki.jenkins-ci.org/display/JENKINS/CloudBees+Docker+Custom+Build+Environment+Plugin#CloudBeesDockerCustomBuildEnvironmentPlugin-DockerinDocker
RUN curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz && tar -xvzf docker-latest.tgz
RUN mv docker/* /usr/bin/

# INSTALL DOCKER COMPOSE
RUN curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" \ 
    -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# ENABLE JENKINS TO RUN DOCKER (ON MAC)
RUN usermod -a -G staff jenkins
USER jenkins

# installing specific list of plugins. see: https://github.com/jenkinsci/docker#preinstalling-plugins
# COPY plugins.txt /var/jenkins_home/plugins.txt
# RUN /usr/local/bin/plugins.sh /var/jenkins_home/plugins.txt
RUN /usr/local/bin/install-plugins.sh blueocean:1.0.1 gitlab:1.4.5 slack:2.2
# Adding default Jenkins Jobs
# COPY jobs/1-github-seed-job.xml /usr/share/jenkins/ref/jobs/1-github-seed-job/config.xml
# COPY jobs/2-job-dsl-seed-job.xml /usr/share/jenkins/ref/jobs/2-job-dsl-seed-job/config.xml
# COPY jobs/3-conference-app-seed-job.xml /usr/share/jenkins/ref/jobs/3-conference-app-seed-job/config.xml
# COPY jobs/4-selenium2-seed-job.xml /usr/share/jenkins/ref/jobs/4-selenium2-seed-job/config.xml
# COPY jobs/5-docker-admin-seed-job.xml /usr/share/jenkins/ref/jobs/5-docker-admin-seed-job/config.xml
COPY jobs/6-dotnetcore-job.xml /usr/share/jenkins/ref/jobs/dotnetcore/config.xml
############################################
# Configure Jenkins
############################################
# Jenkins settings
COPY config/config.xml /usr/share/jenkins/ref/config.xml

# Jenkins Settings, i.e. Maven, Groovy, ...
COPY config/hudson.tasks.Maven.xml /usr/share/jenkins/ref/hudson.tasks.Maven.xml
COPY config/hudson.plugins.groovy.Groovy.xml /usr/share/jenkins/ref/hudson.plugins.groovy.Groovy.xml
COPY config/maven-global-settings-files.xml /usr/share/jenkins/ref/maven-global-settings-files.xml
COPY config/jenkins.plugins.slack.SlackNotifier.xml /usr/share/jenkins/ref/jenkins.plugins.slack.SlackNotifier.xml
COPY config/com.dabsquared.gitlabjenkins.connection.GitLabConnectionConfig.xml /usr/share/jenkins/ref/com.dabsquared.gitlabjenkins.connection.GitLabConnectionConfig.xml
# SSH Keys & Credentials
COPY config/credentials.xml /usr/share/jenkins/ref/credentials.xml
COPY config/ssh-keys/cd-demo /usr/share/jenkins/ref/.ssh/id_rsa
COPY config/ssh-keys/cd-demo.pub /usr/share/jenkins/ref/.ssh/id_rsa.pub

# tell Jenkins that no banner prompt for pipeline plugins is needed
# see: https://github.com/jenkinsci/docker#preinstalling-plugins
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state


# dotnet
USER root
# Install .NET CLI dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libc6 \
        libcurl3 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu52 \
        liblttng-ust0 \
        libssl1.0.0 \
        libstdc++6 \
        libunwind8 \
        libuuid1 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 1.0.1
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-dev-debian-x64.$DOTNET_SDK_VERSION.tar.gz

RUN mkdir -p /usr/share/dotnet
COPY ./dotnet/dotnet-dev-debian-$DOTNET_SDK_VERSION.tar.gz /usr/share/dotnet/dotnet.tar.gz
RUN tar -zxf /usr/share/dotnet/dotnet.tar.gz -C /usr/share/dotnet \
    && rm /usr/share/dotnet/dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Trigger the population of the local package cache
ENV NUGET_XMLDOC_MODE skip
RUN mkdir warmup \
    && cd warmup \
    && dotnet new \
    && cd .. \
    && rm -rf warmup \
    && rm -rf /tmp/NuGetScratch

# Install nodejs & npm
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get -y install nodejs && npm install -g gulp-cli


USER jenkins