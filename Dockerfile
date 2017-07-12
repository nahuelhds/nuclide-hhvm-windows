FROM debian:jessie

# Arguments with default values
ARG p=nuclide
ARG v=0.236.0

COPY rootf /usr/local/bin

# Configure Node.js repository
RUN node_setup_7.x

# System packages required
RUN install_packages nodejs openssh-server gcc make automake autoconf git python-dev libpython-dev

# Install HHVM
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 \
	&& echo deb http://dl.hhvm.com/debian jessie main | tee /etc/apt/sources.list.d/hhvm.list \
	&& apt-get update \
	&& apt-get -y install hhvm

# Install Watchman
RUN git clone https://github.com/facebook/watchman.git \
	&& cd watchman \
	&& git checkout v4.7.0 \
	&& ./autogen.sh \
	&& ./configure \
	&& make && make install

# Configure SSH server
RUN echo 'root:${p}' | chpasswd \
    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
	  && mkdir /var/run/sshd

# Install Nuclide Remote Server
RUN npm install -g nuclide@${v}

VOLUME ["/projects"]

EXPOSE 22 9090

# Start ssh service
CMD ["/usr/sbin/sshd", "-D"]
