FROM centos:7.6.1810
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN yum install -y gcc gcc-c++ make vim htop

# ICC
COPY conf_mpi_test.cfg /tmp/icc-config.cfg
ADD ./parallel_studio_xe_2020_cluster_edition_online /tmp/intel


RUN cd /tmp/intel && \
  ./install.sh --silent=/tmp/icc-config.cfg && \
  cd ../../ && \
  rm -rf /tmp/intel && \
  rm /tmp/icc-config.cfg

ENV MANPATH=/usr/share/man:/usr/local/man
ENV LD_LIBRARY_PATH=/usr/lib:/usr/lib64

RUN ls /opt/intelicc/
RUN mkdir /opt/intelicc/compilers_and_libraries_2020.0.166/linux/licenses/
COPY x.lic /opt/intelicc/compilers_and_libraries_2020.0.166/linux/licenses/
# set up workdir
ENV COMPILERVARS_ARCHITECTURE='intel64'
ENV COMPILERVARS_PLATFORM='linux'
ENV ICC='source /opt/intelicc/bin/iccvars.sh'
ENV MPIICC='source /opt/intelicc/bin/compilervars.sh'
ENV CC=icc

RUN yum clean all
RUN rm -rf /opt/intelicc/advisor_2020.0.0.604394
RUN rm -rf /opt/intelicc/vtune_profiler_2020.0.0.605129
RUN rm -rf /opt/intelicc/inspector_2020.0.0.603904

# set up base
COPY ssh_config /root/.ssh/config
RUN yum install -y ca-certificates wget openssh-server openssh-clients net-tools \
        numactl-devel gtk2 atk cairo tcsh libnl3 tcl libmnl tk \
        htop vim git-core which pciutils lsof ethtool gcc-gfortran

# set up ssh keys
RUN mkdir -p /var/run/sshd \
    && ssh-keygen -A \
    && sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config \
    && sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config \
    && sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config \
    && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config \
    && ssh-keygen -f /root/.ssh/id_rsa -t rsa -N '' \
    && chmod 600 /root/.ssh/config \
    && chmod 700 /root/.ssh \
    && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# nompi vars
ADD varsnompi.sh /opt/intelicc/bin/varsnompi.sh
ENV ICC='source /opt/intelicc/bin/varsnompi.sh'


##### MPI install
# mlnx (IB required)
ADD ./mlnx /tmp/mpi/mlnx
RUN $ICC\
    && F77=ifort FC=ifort CC=icc CXX=icpc /tmp/mpi/mlnx/mlnxofedinstall --user-space-only --without-fw-update --all --force \
    && rm -rf /tmp/mpi/mlnx

#  HPC-X (IB required)
ADD ./hpcx /opt/hpcx
ENV HPCX_HOME=/opt/hpcx

RUN yum install -y systemd-devel libgudev1-devel libgudev1 zlib-devel zlib \
                   libxml2 libxml2-devel binutils binutils-devel libpsm2-devel libpsm2 
# OpenMPi from HPC-x

# download and install MPICH
RUN tar xfp ${HPCX_HOME}/sources/openmpi-gitclone.tar.gz
RUN cd openmpi-gitclone \
    && $ICC \
    && source $HPCX_HOME/hpcx-init.sh && hpcx_load \
    && CC=icc CXX=icpc F77=ifort FC=ifort ./configure \
                   --with-ucx=$HPCX_HOME/ucx \
                   --with-hcoll=/$HPCX_HOME/hcoll \
                   --prefix=${HPCX_HOME}/ompi-icc \
                   --with-platform=optimized \
                   --enable-mca-no-build=btl-uct \
                   --with-device=ch4:ucx 2>&1 | tee config-icc-output.log \
    && make -j32 all 2>&1 | tee build_icc.log \
    && make -j24 install 2>&1 | tee install_icc.log \
    && cd .. \
    && rm -rf openmpi-gitclone

ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

# Devito
RUN yum install -y python3 python3-pip python3-devel python3-libs
RUN pip3 install --upgrade pip
RUN git clone https://github.com/devitocodes/devito.git
# RUN cd devito && $ICC && pip3 install --force-reinstall --no-cache-dir --upgrade -e .
RUN cd devito && CC=gcc && pip3 install --force-reinstall --no-cache-dir --upgrade -e .
RUN cd devito && $MPIICC && pip3 install mpi4py
RUN $MPIICC && DEVITO_ARCH=intel python3 devito/examples/seismic/acoustic/acoustic_example.py

#
# Install storage queue
RUN pip3 install azure-storage-blob h5py segyio
RUN pip3 install azure-storage

# Add application
# ADD ./tti /app/tti
# COPY setup-ompi.sh /opt/setup-ompi.sh

# set up sshd on port 23
EXPOSE 23
CMD ["/usr/sbin/sshd", "-D", "-p", "23"]