FROM exoplatform/ubuntu-jdk7-exo:plf-4.1-rc1
MAINTAINER Eric Taieb Walch <teknologist@gmail.com>

ENV M2_HOME /opt/apache-maven-3.2.3

# Install MongoDB
USER root
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
RUN apt-get -qq update && \
  apt-get -qq -y install mongodb-org && \
  apt-get -qq -y autoremove && \
  apt-get -qq -y autoclean



#Install Maven 3'
RUN mkdir -p ${M2_HOME} && \
curl -L -o /tmp/apache-maven-3.2.3-bin.zip http://wwwftp.ciril.fr/pub/apache/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.zip && \
    unzip -q /tmp/apache-maven-3.2.3-bin.zip -d /opt/ && \
    rm -f /tmp/apache-maven-3.2.3-bin.zip

USER exo

#Setup Maven for eXo Addons build
RUN echo 'export M2_HOME=$M2_HOME' >> /home/${EXO_USER}/.bashrc && \
 mkdir /home/${EXO_USER}/.m2 && \
 echo '<settings><mirrors><mirror><id>exo-central-server</id><name>eXo Central Server</name><url>http://repository.exoplatform.org/public/</url><mirrorOf>central</mirrorOf></mirror></mirrors></settings>' > /home/${EXO_USER}/.m2/settings.xml         && \
 cd /home/${EXO_USER}/.m2 && \
 curl -L -o maven_exo_deps_seed.tgz https://dl.dropboxusercontent.com/u/663951/codenvy-exo/maven_exo_deps_seed.tgz && \
    tar xzf  maven_exo_deps_seed.tgz && \
    rm -f maven_exo_deps_seed.tgz && \
 echo "EXO_JVM_SIZE_MAX=\"1g\"" > ${EXO_APP_DIR}/current/bin/setenv-customize.sh
