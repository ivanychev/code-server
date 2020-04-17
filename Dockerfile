FROM codercom/code-server:latest


RUN sudo apt-get update  && sudo apt-get install -y wget gnupg software-properties-common && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo apt-get autoremove && \
    sudo apt-get clean

# Java repo.
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
RUN sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
# SBT repo.
RUN echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823

RUN sudo apt-get update && \
    sudo apt-get upgrade -y && \
    sudo apt-get install -y adoptopenjdk-8-hotspot sbt ffmpeg rsync make build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
        xz-utils tk-dev libffi-dev liblzma-dev snapd tmux python-openssl git software-properties-common && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo apt-get autoremove && \
    sudo apt-get clean

# Pyenv.
RUN curl https://pyenv.run | bash

RUN echo "export PATH=\"/home/coder/.pyenv/bin:\$PATH\""  >> .bashrc
RUN echo "eval \"\$(pyenv init -)\"" >> .bashrc
RUN echo "eval \"\$(pyenv virtualenv-init -)\"" >> .bashrc
RUN PYTHON_CONFIGURE_OPTS="--enable-shared --enable-optimizations --with-computed-gotos --with-lto --enable-ipv6" .pyenv/bin/pyenv install 3.8.2 -v
RUN .pyenv/versions/3.8.2/bin/pip install -U \
    pip numpy Pillow scipy sklearn matplotlib \
    pandas requests tqdm nltk toolz scikit-image ipython \
    pytorch torchvision tensorflow
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension ms-vscode.cpptools
