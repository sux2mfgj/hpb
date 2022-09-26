FROM renskiy/cron

RUN apt-get update && apt-get -y install curl

WORKDIR /etc/hpb

COPY directory.txt .
COPY webhook_url.txt .
COPY notify.sh /etc/cron.daily/
