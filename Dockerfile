FROM ubuntu:16.04

MAINTAINER Khalid Zubair

RUN echo "Upgrading system & installing necessary dependencies"

RUN apt-get -qq update && apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev git 

RUN echo "Installing python3 and dependencies"

RUN apt-get install -y -qq python3 \
    python3-pip \
    python3-venv \
    direnv \
    > /dev/null


RUN useradd -m python_user 

WORKDIR /home/python_user
USER python_user 

RUN  echo "Installing pyenv via installer" 

RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash > /dev/null

ENV HOME /home/python_user
ENV PYENV_ROOT $HOME/.pyenv 
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \ 
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc && \ 
    echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

RUN echo "Downloading python 3.6.5, 2.7.14 as examples"

RUN pyenv install 3.6.5

RUN pyenv install 2.7.14

RUN echo "Reloading shell"

RUN /bin/bash -c "source ~/.bashrc" 


RUN echo "Running Bash"

CMD ["bash"]
