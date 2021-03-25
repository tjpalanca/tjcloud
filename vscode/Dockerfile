FROM codercom/code-server:3.9.1
LABEL maintainer="TJ Palanca <mail@tjpalanca.com>"

# Root user
USER root

# Linux Dependencies
RUN apt-get update && apt-get -y install \
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
	npm \
	make \
	wget

# Install Docker (to be able to communicate with Docker host)
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - && \
	sudo apt-key fingerprint 0EBFCD88 && \
	sudo add-apt-repository \
   	"deb [arch=amd64] https://download.docker.com/linux/debian \
   	$(lsb_release -cs) \
   	stable" && \
	apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

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

# Install Anaconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
	/bin/bash ~/miniconda.sh -b -p /opt/conda && \
	rm ~/miniconda.sh
ENV PATH=/opt/conda/bin:$PATH
RUN conda update -n base -c defaults conda

# Install Google Chrome (Headless Browsing)
RUN wget \
	https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
	sudo apt install -y ./google-chrome-stable_current_amd64.deb && \
	rm ./google-chrome-stable_current_amd64.deb

# Install R
RUN apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' && \
	sudo add-apt-repository \
   	"deb http://cloud.r-project.org/bin/linux/debian buster-cran40/" && \
	apt-get update && \
	apt-get install -y -t buster-cran40 r-base r-base-dev && \
	apt-get install libopenblas-base

# Install Julia
RUN cd /usr/bin && \
	wget https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.0-linux-x86_64.tar.gz && \
	tar zxvf julia-1.6.0-linux-x86_64.tar.gz && \
	mv julia-1.6.0 julia
ENV PATH="$PATH:/usr/bin/julia/bin"

# Back to user
USER 1000
