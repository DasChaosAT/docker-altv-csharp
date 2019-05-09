FROM mcr.microsoft.com/dotnet/core/runtime:2.2
LABEL maintainer="DasChaos <Twitter: @DasChaosAT>"

RUN apt-get update && \
    apt-get install -y wget unzip jq

RUN wget --no-cache https://alt-cdn.s3.nl-ams.scw.cloud/server/master/x64_linux/server.zip && \
    mkdir /altv && \
    unzip -d altv server.zip && \
    rm server.zip && \
    chmod +x /altv/altv-server

ADD download_module.sh /download_module.sh

RUN mkdir -p /altv/modules/ && \
    chmod +x download_module.sh && \
    /download_module.sh && \
    mv libcsharp-module.so /altv/modules/ && \
    rm download_module.sh

RUN apt-get purge -y wget unzip jq && \
    apt-get clean

RUN mkdir /altv-persistend && \
    mkdir /altv-persistend/config && \
    mkdir /altv-persistend/ressources && \
    mkdir /altv-persistend/logs && \
    ln -s /altv-persistend/config /altv/config && \
    ln -s /altv-persistend/ressources /altv/ressources && \
    ln -s /altv-persistend/logs /altv/logs

EXPOSE 7788
VOLUME /altv-persistend/

ADD start_server.sh /altv/start_server.sh
RUN chmod +x /altv/start_server.sh

USER 0

ENTRYPOINT ["/altv/start_server.sh"]
CMD ["sh"]

