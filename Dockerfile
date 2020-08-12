FROM centos:7.8.2003

RUN yum -y update
RUN yum -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm
RUN yum -y install git
RUN yum -y install sudo rsync net-tools nfs-utils python3-pip.noarch file gawk make wget tar bzip2 gzip python unzip perl patch diffutils diffstat git cpp gcc gcc-c++ glibc-devel texinfo chrpath socat perl-Data-Dumper perl-Text-ParseWords perl-Thread-Queue python34-pip xz which SDL-devel xtermsudo pip3 install GitPython jinja2

RUN sudo git clone -b v1.10.0 https://gerrit.googlesource.com/git-repo /tmp/git-repo
RUN sudo cp /tmp/git-repo/repo /usr/bin/repo
RUN sudo chmod 755 /usr/bin/repo


# Create a non-root user that will perform the actual build
RUN id build 2>/dev/null || useradd --uid 1000 --create-home build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

# Disable Host Key verification.
RUN mkdir -p /home/build/.ssh
RUN printf "Host *\n\tStrictHostKeyChecking no\n" > /home/build/.ssh/config
RUN chown -R build:build /home/build/.ssh

# overwrite this with 'CMD []' in a dependent Dockerfile
USER build
ENV USER build
WORKDIR /home/build

CMD ["/bin/bash"]
