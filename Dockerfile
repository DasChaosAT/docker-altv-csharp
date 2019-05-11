FROM mcr.microsoft.com/dotnet/core/runtime:2.2
LABEL maintainer="DasChaos <Twitter: @DasChaosAT>"

RUN apt-get update && \
    apt-get install -y wget jq

RUN wget --no-cache -O altv-server https://alt-cdn.s3.nl-ams.scw.cloud/server/master/x64_linux/altv-server && \
    wget --no-cache -O libnode.so.64  https://alt-cdn.s3.nl-ams.scw.cloud/alt-node/libnode.so.64 && \
    wget --no-cache -O vehmodels.bin https://alt-cdn.s3.nl-ams.scw.cloud/server/master/x64_win32/data/vehmodels.bin && \
    wget --no-cache -O vehmods.bin https://alt-cdn.s3.nl-ams.scw.cloud/server/master/x64_win32/data/vehmods.bin && \
    wget --no-cache -O libnode-module.so https://alt-cdn.s3.nl-ams.scw.cloud/alt-node/x64_linux/libnode-module.so && \
    mkdir /altv && \
    mkdir /altv/data && \
    mkdir /altv/modules && \
    mv altv-server /altv/ && \
    mv libnode.so.64 /altv/ && \
    mv vehmodels.bin /altv/data && \
    mv vehmods.bin /altv/data && \
    mv libnode-module.so /altv/modules

ADD download_module.sh /download_module.sh

RUN sh download_module.sh && \
    mv libcsharp-module.so /altv/modules/ && \
    rm download_module.sh

RUN apt-get purge -y wget jq && \
    apt-get clean

RUN mkdir /altv-persistend && \
    mkdir /altv-persistend/config && \
    mkdir /altv-persistend/resources && \
    mkdir /altv-persistend/logs && \
    rm -rf /altv/resources && \
    rm /altv/server.cfg && \
    rm /altv/start.sh && \
    ln -s /altv-persistend/config /altv/config && \
    ln -s /altv-persistend/resources /altv/resources && \
    ln -s /altv-persistend/logs /altv/logs

EXPOSE 7788
VOLUME /altv-persistend/

ADD start_server.sh /altv/start_server.sh
RUN chmod +x /altv/start_server.sh
RUN chmod +x /altv/altv-server

USER 0

ENTRYPOINT ["/altv/start_server.sh"]
CMD ["sh"]

