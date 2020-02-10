# RStudio Server Docker Image
FROM rocker/geospatial:3.6.1
MAINTAINER Troy James Palanca <mail@tjpalanca.com>

# Linux Dependencies
RUN apt-get update && apt-get -y install \
	gdebi-core \
	apt-utils \
	curl \
	nano \
	software-properties-common \
	zsh \
	gnupg \
	apt-transport-https

# Install Docker (to be able to communicate with Docker host)
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
	apt-key fingerprint 0EBFCD88 && \
	add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/debian \
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

# Install favorite R packages
RUN install2.r \
	packrat \
	here \
	reticulate

# Install Git LFS
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
	apt-get update && apt-get install -y git-lfs

# Install Anaconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH=/opt/conda/bin:$PATH
RUN conda update -n base -c defaults conda

# RStudio Server Preview 1.3
RUN apt-get update && apt-get install gdebi-core
RUN wget https://s3.amazonaws.com/rstudio-ide-build/server/debian9/x86_64/rstudio-server-1.3.776-amd64.deb -O rstudio.deb 
RUN gdebi --non-interactive rstudio.deb && rm -rf rstudio.deb

# Rprofile.site
COPY Rprofile.site /usr/local/lib/R/etc/Rprofile.site
