FROM ubuntu:18.04

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











# Utils
RUN apt-get install -y htop vim git-core

# Devito
RUN apt-get install -y python3 python3-pip
RUN pip3 install --upgrade pip
RUN git clone -b azure-make https://github.com/devitocodes/devito.git
RUN cd devito && pip3 install -e .[extras]

# set up sshd on port 23
EXPOSE 23
CMD ["/usr/sbin/sshd", "-D", "-p", "23"]