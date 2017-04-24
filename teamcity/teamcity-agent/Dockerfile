FROM jetbrains/teamcity-agent
RUN mkdir /src
RUN mkdir /artifacts
WORKDIR /src
VOLUME ["/src", "/artifacts", "/root/.nuget"]

# INSTALL NODEJS
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get -y install nodejs && npm install -g gulp-cli


# INSTALL DOTNET
RUN sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
RUN apt-get update
RUN apt-get install -y dotnet-dev-1.0.1

# INSTALL DOCKER COMPOSE
RUN curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" \ 
    -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose