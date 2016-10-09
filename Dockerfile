FROM ubuntu:14.04

RUN /usr/bin/apt-get update && /usr/bin/apt-get install -y ngircd openssl python3 python3-pip python3.4-venv supervisor
RUN /usr/bin/pip3 install -U setuptools dice
RUN /usr/sbin/service ngircd stop
RUN /bin/mkdir -p /ngircd
RUN /usr/bin/openssl req -newkey rsa:2048 -nodes -keyout /ngircd/irc.legobot.local.key -x509 -days 365 -out /ngircd/irc.legobot.local.crt -subj '/CN=irc.legobot.local'
COPY ngircd.conf /etc/ngircd/ngircd.conf

RUN /usr/sbin/adduser --gecos "" -q --disabled-password --home /legobot legobot
RUN chown -R legobot:legobot /legobot
RUN /usr/bin/pyvenv-3.4 /legobot/venv

COPY docker/supervisord-ngircd.conf /etc/supervisor/conf.d/
COPY docker/supervisord-legobot.conf /etc/supervisor/conf.d/

COPY requirements.txt /legobot/
RUN /bin/bash -c "cd /legobot ; source /legobot/venv/bin/activate ; pip install -r requirements.txt"
COPY docker/docker-legobot.py /legobot/Legobot.py
COPY Legobot /legobot/Legobot/

EXPOSE 6667 6697
WORKDIR /legobot
CMD ["/usr/bin/supervisord", "-n"]
