# Setup Docker base worker nodes
#!/bin/bash

# Setup Docker file
#mkdir -p Docker
mkdir -p .ssh
ssh-keygen -f .ssh/id_rsa -t rsa -N ''
cp -r .ssh/id_rsa.pub .ssh/authorized_keys
cat <<EOF>> Dockerfile
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:admin' | chpasswd
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
RUN rm -rf /root/.ssh
COPY .ssh /root/.ssh
ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
EOF
docker build -t ssh_worker .
echo "####################################################################################"
echo "Please SPIN Containers using ssh_worker image....."
echo " docker run -dit -p 2222:22 --name test ssh_worker "
echo "####################################################################################"
