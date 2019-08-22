FROM mcr.microsoft.com/dotnet/core/runtime:3.0
LABEL maintainer="DasChaos <Twitter: @DasChaosAT>"

ENV PORT 7788
ENV UID 0

RUN apt-get update && \
    apt-get install -y wget libc-bin

RUN wget --no-cache -O altv-server https://cdn.altv.mp/server/stable/x64_linux/altv-server && \
    wget --no-cache -O vehmodels.bin https://cdn.altv.mp/server/stable/x64_linux/data/vehmodels.bin&& \
    wget --no-cache -O vehmods.bin https://cdn.altv.mp/server/stable/x64_linux/data/vehmods.bin && \
    wget --no-cache -O libnode-module.so https://cdn.altv.mp/node-module/stable/x64_linux/modules/libnode-module.so && \
    wget --no-cache -O libnode.so.72 https://cdn.altv.mp/node-module/stable/x64_linux/libnode.so.72 && \
    wget --no-cache -O libcsharp-module.so https://cdn.altv.mp/coreclr-module/stable/x64_linux/modules/libcsharp-module.so && \
    wget --no-cache -O AltV.Net.Host.dll https://cdn.altv.mp/coreclr-module/stable/x64_linux/AltV.Net.Host.dll && \
    wget --no-cache -O AltV.Net.Host.runtimeconfig.json https://cdn.altv.mp/coreclr-module/stable/x64_linux/AltV.Net.Host.runtimeconfig.json && \
    mkdir /altv && \
    mkdir /altv/data && \
    mkdir /altv/modules && \
    mkdir /altv/resources-data && \
    mv altv-server /altv/ && \
    mv libnode.so.72 /altv/ && \
    mv AltV.Net.Host.dll /altv/ && \
    mv AltV.Net.Host.runtimeconfig.json /altv/ && \
    mv vehmodels.bin /altv/data && \
    mv vehmods.bin /altv/data && \
    mv libnode-module.so /altv/modules && \
    mv libcsharp-module.so /altv/modules

RUN apt-get purge -y wget && \
    apt-get clean

RUN mkdir /altv-persistend && \
    mkdir /altv-persistend/config && \
    mkdir /altv-persistend/resources && \
    mkdir /altv-persistend/resources-data && \
    mkdir /altv-persistend/logs && \
    ln -s /altv-persistend/config /altv/config && \
    ln -s /altv-persistend/resources /altv/resources && \
    ln -s /altv-persistend/resources-data /altv/resources-data && \
    ln -s /altv-persistend/logs /altv/logs

EXPOSE ${PORT}/tcp
EXPOSE ${PORT}/udp

VOLUME /altv-persistend/

ADD start_server.sh /altv/start_server.sh
RUN chmod +x /altv/start_server.sh
RUN chmod +x /altv/altv-server

USER ${UID}

ENTRYPOINT ["/altv/start_server.sh"]
CMD ["sh"]

