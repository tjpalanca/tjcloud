FROM jupyter/all-spark-notebook:4cdbc9cdb7d1
MAINTAINER TJ Palanca <mail@tjpalanca.com>

# Switch to root and install dependencies
USER root

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
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
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

# Copy hooks
COPY start_notebook.sh /usr/local/bin/start-notebook.d/start_notebook.sh
COPY before_notebook.sh /usr/local/bin/before-notebook.d/before_notebook.sh

# Install Oh My ZSH
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

# Custom command
CMD [ \
    "/usr/local/bin/start.sh", \
    "jupyter", "lab", \
    "--ip='0.0.0.0'", \
    "--NotebookApp.token=''", \
    "--NotebookApp.password=''", \
    "--allow-root" \
]
