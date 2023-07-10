FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y openssh-server git openjdk-8-jdk gradle awscli

# Configure SSH
RUN mkdir /var/run/sshd && \
    echo 'root:jenkins' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Create Jenkins user
RUN useradd -m -s /bin/bash jenkins && \
    echo 'jenkins:jenkins' | chpasswd

# Expose SSH port
EXPOSE 22

# Start SSH daemon
CMD ["/usr/sbin/sshd", "-D"]