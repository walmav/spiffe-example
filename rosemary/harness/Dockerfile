FROM ruby:2.4

LABEL Description="Certificate Rotation SPIFFE: Harness"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"



# Set the locale
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install basics
RUN apt-get update && apt-get install -y \
    tmux \
    emacs \
    git \
 && rm -rf /var/lib/apt/lists/*

# Map DockerCompose directory for service

# Install Python for docker-compose
# TODO: See if we can mount the binary from the Base OS
RUN apt-get install -y python
RUN apt-get update -y
RUN apt-get install -y python-dev python-distribute python-pip
RUN apt-get install -y curl
RUN curl -sSL https://get.docker.com/ | sh && pip install docker-compose

# Install Gems
RUN gem install tmuxinator
ENV EDITOR "emacs"

# Inject development configuration
COPY rosemary.yml /root/.tmuxinator/rosemary.yml
COPY .tmux.conf  /root/.tmuxinator/.tmux.conf

WORKDIR /home/rosemary

# ENTRYPOINT ["tmuxinator"]
# CMD ["start", "env"]
