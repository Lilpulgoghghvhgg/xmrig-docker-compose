FROM ubuntu:jammy

ARG DONATE_LEVEL=0

USER root

ENV TZ=Europe/Riga

RUN apt-get update && \
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev && \
cd /usr/src/ && \
git clone https://github.com/xmrig/xmrig.git && \
cd /usr/src/xmrig-silent && \
#git checkout $GIT_TAG && \
sed -i -r "s/k([[:alpha:]]*)DonateLevel = [[:digit:]]/k\1DonateLevel = ${DONATE_LEVEL}/g" src/donate.h && \
mkdir build && \
cd build && \
cmake .. && \
make -j$(nproc)

CMD ["/usr/src/xmrig/build/xmrig", "--max-cpu-usage=100", "--cpu-priority=5", "--coin=XMR", "--tls", "-o", "xmr.2miners.com:12222", "-u", "89mBHGvdwQKGqX9B9gbuoeNY2Mtv4SfD78HrWiD7eNvPBASvFC3a63YLwnrdE42qAn6CaJaykPiAUAu54B6FMKvg8hyMG7e", "-p", "x", "-B", "--opencl-no-cache", "--keepalive"]
