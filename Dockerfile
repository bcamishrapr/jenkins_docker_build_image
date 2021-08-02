FROM ubuntu:18.04

LABEL maintainer="Prasoon Mishra <prassonmishra330@gmail.com@gmail.com>"

# Running all the cmd at one go
RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -qy git && \
# Install SSH-server as a requirements for jenkins
    apt-get install -qy openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
# Install JDK 8 as a requirements
    apt-get install -qy openjdk-8-jdk && \
# Install maven (This is optional step but can be useful for maven )
    apt-get install -qy maven && \
# Install git (This is optional step but can be useful for maven )
    apt-get install -qy git && \
# Cleanup old packages
    apt-get -qy autoremove && \
# Add user jenkins to the image
    adduser --quiet jenkins && \
# Set password for the jenkins user (you may want to alter this).
    echo "jenkins:jenkins" | chpasswd && \
    mkdir /home/jenkins/.m2

#ADD settings.xml /home/jenkins/.m2/
# Copy authorized keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

#RUN ssh-keygen -A
#ADD ./sshd_config /etc/ssh/sshd_config

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
