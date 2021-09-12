FROM phusion/baseimage:bionic-1.0.0

# Use baseimage-docker's init system:
CMD ["/sbin/my_init"]

# Install dependencies:
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    sudo \
    wget \
    git \
    make \
    busybox \
    build-essential \
    nodejs \
    npm \
    ffmpeg \
    python \
 && mkdir -p /home/stuff

RUN apt-get install xbase-clients -y
RUN apt-get install xfce4 xfce4-terminal -y
RUN wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
RUN dpkg -i chrome*
RUN apt-get install -f
RUN DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0AX4XfWj5o-RjPyf_6l-eTPvWjEu9QMAUc5faOXjG9LK1Y_X5DYDSH_oSnjoLRpxO3AOcLw" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)
# Set work dir:
WORKDIR /home

# Copy files:
COPY startbot.sh /home
COPY config.sh /home
COPY /stuff /home/stuff

# Run config.sh and clean up APT:
RUN sh /home/config.sh \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install the bot:
RUN git clone https://github.com/botgram/shell-bot.git \
 && cd shell-bot \
 && npm install

RUN echo "Uploaded files:" && ls /home/stuff/

# Run bot script:
CMD bash /home/startbot.sh
