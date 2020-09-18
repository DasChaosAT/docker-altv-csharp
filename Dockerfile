FROM mcr.microsoft.com/dotnet/core/runtime:3.1
LABEL maintainer="DasChaos(Thomas Marangoni) <Twitter: @DasChaosAT>"

ARG BRANCH=release

ENV PORT 7788
ENV UID 0

RUN apt-get update && \
    apt-get install -y wget libc-bin libatomic1

RUN mkdir /altv && \
    mkdir /altv/data && \
    mkdir /altv/resources-data && \
    mkdir -p /altv/modules/js-module && \
    # Download server
    wget -q --no-cache -O /altv/altv-server https://cdn.altv.mp/server/${BRANCH}/x64_linux/altv-server && \
    wget -q --no-cache -O /altv/data/vehmodels.bin https://cdn.altv.mp/server/${BRANCH}/x64_linux/data/vehmodels.bin && \
    wget -q --no-cache -O /altv/data/vehmods.bin https://cdn.altv.mp/server/${BRANCH}/x64_linux/data/vehmods.bin && \
    # Download js-module
    wget -q --no-cache -O /altv/modules/js-module/libjs-module.so https://cdn.altv.mp/js-module/${BRANCH}/x64_linux/modules/js-module/libjs-module.so && \
    wget -q --no-cache -O /altv/modules/js-module/libnode.so.72 https://cdn.altv.mp/js-module/${BRANCH}/x64_linux/modules/js-module/libnode.so.72
    # Download csharp-module
    wget -q --no-cache -O /altv/modules/libcsharp-module.so https://cdn.altv.mp/coreclr-module/${BRANCH}/x64_linux/modules/libcsharp-module.so && \
    wget -q --no-cache -O /altv/AltV.Net.Host.dll https://cdn.altv.mp/coreclr-module/${BRANCH}/x64_linux/AltV.Net.Host.dll && \
    wget -q --no-cache -O /altv/AltV.Net.Host.runtimeconfig.json https://cdn.altv.mp/coreclr-module/${BRANCH}/x64_linux/AltV.Net.Host.runtimeconfig.json

RUN apt-get purge -y wget && \
    apt-get clean

RUN mkdir /altv-persistend && \
    mkdir /altv-persistend/config && \
    mkdir /altv-persistend/resources && \
    mkdir /altv-persistend/logs && \
    mkdir /altv-persistend/resources-data && \
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
CMD ["bash"]
