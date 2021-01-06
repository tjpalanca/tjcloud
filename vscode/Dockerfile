FROM codercom/code-server:3.8.0
MAINTAINER TJ Palanca <mail@tjpalanca.com>

# Linux Dependencies
RUN sudo apt-get update && sudo apt-get -y install \
	gdebi-core \
	apt-utils \
	curl \
	nano \
	software-properties-common \
	zsh \
	gnupg \
	apt-transport-https \
    libsodium-dev \
    nodejs \
    npm \
    make

# Install Docker (to be able to communicate with Docker host)
RUN sudo curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
	apt-key fingerprint 0EBFCD88 && \
	sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && \
	sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
RUN sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" \
	-o /usr/local/bin/docker-compose && \
    sudo chmod +x /usr/local/bin/docker-compose

# Install kubectl
RUN sudo apt-get update && sudo apt-get install -y apt-transport-https && \
	sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list && \
	sudo apt-get update && sudo apt-get install -y kubectl

# Install Cloud 66 Toolbelt
RUN sudo curl -sSL https://s3.amazonaws.com/downloads.cloud66.com/cx_installation/cx_install.sh | sudo bash

# Install Git LFS
RUN sudo curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
	sudo apt-get update && sudo apt-get install -y git-lfs

# Install Anaconda
RUN sudo wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    sudo /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    sudo rm ~/miniconda.sh
ENV PATH=/opt/conda/bin:$PATH
RUN conda update -n base -c defaults conda

# Install Google Chrome (Headless Browsing)
RUN sudo wget \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    sudo apt install -y ./google-chrome-stable_current_amd64.deb && \
    sudo rm ./google-chrome-stable_current_amd64.deb

ENTRYPOINT ["dumb-init", "code-server", "--host", "0.0.0.0", "--auth", "none", "--disable-telemetry"]
