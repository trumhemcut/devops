FROM jetbrains/teamcity-server

COPY ./plugins/* /data/teamcity_server/datadir/plugins/	
COPY ./templates/dotnetcore/* \ 
     /data/teamcity_server/datadir/import/

# COPY SLACK CONFIG
COPY ./config/slack-config.xml /data/teamcity_server/datadir/config/slack/slack-config.xml