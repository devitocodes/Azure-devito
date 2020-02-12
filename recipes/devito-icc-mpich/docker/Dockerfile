FROM ubuntu:18.04
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# set up base and ssh keys
COPY ssh_config /root/.ssh/config

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential ca-certificates wget openssh-client openssh-server \
        mpich libmpich-dev \
    && mkdir -p /var/run/sshd \
    && ssh-keygen -A \
    && sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config \
    && sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config \
    && sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config \
    && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config \
    && ssh-keygen -f /root/.ssh/id_rsa -t rsa -N '' \
    && chmod 600 /root/.ssh/config \
    && chmod 700 /root/.ssh \
    && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y cpio libgtk2.0 xorg openbox

COPY /parallel_studio_xe_2020_cluster_edition_online/silent.cfg /tmp/icc-config.cfg
ADD /parallel_studio_xe_2020_cluster_edition_online /tmp/intel
RUN cd /tmp/intel && \
  ./install.sh --silent=/tmp/icc-config.cfg --components intel-mpi-psxe__x86_64 && \
  ./install.sh --silent=/tmp/icc-config.cfg --components intel-icc__x86_64 && \
  ./install.sh --silent=/tmp/icc-config.cfg --components intel-mpi-sdk__x86_64 && \
  ./install.sh --silent=/tmp/icc-config.cfg --components intel-mpi-rt__x86_64 && \
  cd ../../ && \
  rm -rf /tmp/intel && \
  rm /tmp/icc-config.cfg

RUN ls opt/intel/compilers_and_libraries/linux/
RUN source /opt/intel/compilers_and_libraries/linux/bin/compilervars.sh -arch intel64 -platform linux
RUN source /opt/intel/compilers_and_libraries/linux/mpi/intel64/bin/mpivars.sh

# Utils
RUN apt-get install -y htop vim git-core

# Devito
RUN apt-get install -y python3 python3-pip
RUN pip3 install --upgrade pip
RUN git clone https://github.com/devitocodes/devito.git
RUN source /opt/intel/compilers_and_libraries/linux/mpi/intel64/bin/mpivars.sh && cd devito && pip3 install -e .[extras]

# set up sshd on port 23
EXPOSE 23
CMD ["/usr/sbin/sshd", "-D", "-p", "23"]
