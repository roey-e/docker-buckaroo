FROM mcr.microsoft.com/dotnet/sdk:3.1-bionic

RUN apt-get update && apt-get install -y --no-install-recommends \
        clang \
        libkrb5-dev \
        libz-dev

RUN wget -c -O /opt/warp-packer https://github.com/dgiagio/warp/releases/download/v0.3.0/linux-x64.warp-packer \
    && chmod +x /opt/warp-packer \
    && ln -s /opt/warp-packer /usr/local/bin/warp-packer

RUN useradd -m buckaroo
USER buckaroo

RUN git clone https://github.com/LoopPerfect/buckaroo.git /tmp/buckaroo --depth 1 \
    && cd /tmp/buckaroo \
    && dotnet publish buckaroo-cli -r linux-x64 \
    && cd - \
    && rm -rf /tmp/buckaroo

RUN dotnet nuget disable source nuget.org
RUN dotnet nuget add source /home/buckaroo/.nuget/packages
