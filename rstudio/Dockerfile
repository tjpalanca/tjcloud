# RStudio Server Docker Image
FROM rocker/geospatial:4.1.1
MAINTAINER Troy James Palanca <mail@tjpalanca.com>

# Linux Dependencies
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
RUN apt-get update && \
	apt-get install -y \
	curl \
	dumb-init \
	zsh \
	htop \
	locales \
	man \
	nano \
	git \
	procps \
	openssh-client \
	sudo \
	vim.tiny \
	lsb-release \
	gdebi-core \
	apt-utils \
	curl \
	gnupg-agent \
	ca-certificates \
	nano \
	software-properties-common \
	zsh \
	gnupg \
	apt-transport-https \
	libsodium-dev \
	nodejs \
	make \
	wget \
	xvfb \
	libssh-dev \
	nginx \
	libpoppler-cpp-dev \
	libnode-dev 

# Install Docker (to be able to communicate with Docker host)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
	sudo apt-key fingerprint 0EBFCD88 && \
	sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable" && \
	apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io && \
	usermod -aG docker rstudio && usermod -aG rstudio-server rstudio

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" \
	-o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install kubectl
RUN apt-get update && apt-get install -y apt-transport-https && \
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
	apt-get update && apt-get install -y kubectl

# Install Cloud 66 Toolbelt
RUN curl -sSL https://s3.amazonaws.com/downloads.cloud66.com/cx_installation/cx_install.sh | bash

# Install Git LFS
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
	apt-get update && apt-get install -y git-lfs

# Install Google Chrome (Headless Browsing)
RUN wget \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install -y ./google-chrome-stable_current_amd64.deb && \
    rm ./google-chrome-stable_current_amd64.deb

# Install Apache JMeter (Load Testing)
RUN wget \
    https://tjpalanca.sgp1.digitaloceanspaces.com/bin/apache-jmeter-5.4.1.tgz \
    -O jmeter.tgz && \
    tar xzvf jmeter.tgz && \
    rm jmeter.tgz && \
    mv apache-jmeter-5.4.1 /usr/local/lib/apache-jmeter-5.4.1
ENV PATH $PATH:/usr/local/lib/apache-jmeter-5.4.1/bin

# RStudio Preview
# RUN apt-get remove -yq rstudio-server
# RUN wget https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-1.4.1725-amd64.deb \
#     -O rstudio-server.deb && \
#     gdebi --non-interactive rstudio-server.deb && \
#     rm -rf rstudio-server.deb

# Custom userconf
COPY userconf.sh /etc/cont-init.d/userconf

# Copy entrypoint
COPY entrypoint.sh /usr/bin/entrypoint.sh

# Expose ports
EXPOSE 8080
ENTRYPOINT ["bin/sh"]
CMD ["-c", "set -ex && Xvfb :99 & export DISPLAY=:99 && /usr/bin/entrypoint.sh"]
