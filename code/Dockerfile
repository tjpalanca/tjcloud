# RStudio Server Docker Image
FROM rocker/geospatial:4
LABEL maintainer="Troy James Palanca <code@tjpalanca.com>"

# Rocker Scripts
RUN /rocker_scripts/install_python.sh && \
	/rocker_scripts/install_pyenv.sh && \
	/rocker_scripts/install_julia.sh

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
	software-properties-common \
	curl \
	gnupg-agent \
	ca-certificates \
	nano \
	zsh \
	gnupg \
	apt-transport-https \
	libsodium-dev \
	nodejs \
	make \
	wget \
	libssh-dev \
	nginx \
	xclip \
	xvfb \
	libpoppler-cpp-dev

# Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
	sudo apt-key fingerprint 0EBFCD88 && \
	sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable" && \
	apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io && \
	usermod -aG docker rstudio && usermod -aG rstudio-server rstudio

# Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" \
	-o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Kubernetes
RUN apt-get update && apt-get install -y apt-transport-https && \
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
	apt-get update && apt-get install -y kubectl

# Cloud 66 Toolbelt
RUN curl -sSL https://s3.amazonaws.com/downloads.cloud66.com/cx_installation/cx_install.sh | bash

# Git Large File Storage
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
	apt-get update && apt-get install -y git-lfs

# Apache JMeter
RUN wget \
    https://tjpalanca.sgp1.digitaloceanspaces.com/bin/apache-jmeter-5.4.1.tgz \
    -O jmeter.tgz && \
    tar xzvf jmeter.tgz && \
    rm jmeter.tgz && \
    mv apache-jmeter-5.4.1 /usr/local/lib/apache-jmeter-5.4.1
ENV PATH $PATH:/usr/local/lib/apache-jmeter-5.4.1/bin

# RStudio Server
RUN sudo apt-get remove -y rstudio-server && \
	wget https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-2021.09.1-372-amd64.deb \
    -O rstudio-server.deb && \
    gdebi --non-interactive rstudio-server.deb && \
    rm -rf rstudio-server.deb

# VS Code Server
RUN curl -fOL https://github.com/cdr/code-server/releases/download/v3.12.0/code-server_3.12.0_amd64.deb && \
	dpkg -i code-server_3.12.0_amd64.deb && \
	rm code-server_3.12.0_amd64.deb
RUN pip install -U radian jupyter
COPY services.d/vscode /etc/services.d/vscode/

# Networking Components and Tweaks
COPY cont-init.d/userconf /etc/cont-init.d/userconf
COPY services.d/cleanup /etc/services.d/cleanup
ENV DISPLAY :1
COPY services.d/display /etc/services.d/display
COPY services.d/nginx /etc/services.d/nginx

# Expose Ports
EXPOSE 8888 5050 3838 8789
