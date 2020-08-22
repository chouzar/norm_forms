# Note: You can use any Debian/Ubuntu based image you want. 
#FROM mcr.microsoft.com/vscode/devcontainers/base:0-buster
FROM debian:latest
#FROM elixir:latest

# Options
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="false"
ARG ENABLE_NONROOT_DOCKER="true"
ARG SOURCE_SOCKET=/var/run/docker-host.sock
ARG TARGET_SOCKET=/var/run/docker.sock
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    # Use Docker script from script library to set things up
    && /bin/bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "${SOURCE_SOCKET}" "${TARGET_SOCKET}" "${USERNAME}" \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to the Docker
# socket. The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# locales configuration
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y locales locales-all

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# neovim editor
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && sudo apt-get install -y neovim 

# nodejs
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y nodejs \
    && curl -L https://npmjs.org/install.sh | sh

# postgresql tooling
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y postgresql-client 

# erlang and elixir
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb \
    && sudo dpkg -i erlang-solutions_2.0_all.deb \
    && sudo apt-get update -y \
    && sudo apt-get install -y esl-erlang \
    && sudo apt-get install -y elixir 

# erlang and elixir build tooling
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && mix local.hex --force \
    && mix local.rebar --force 

# phoenix framework dev tooling
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y inotify-tools \
    && mix archive.install hex phx_new --force 

